#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Written for python 3, not tested under 2.
"""
There are two version of this script. Or possibly a single smarter one in the future.
This one is a mod of that for variant call files from `samtools` not CLC genomics to make it CLC compatible.
Usage
python3 table_maker.py BS1183_reannotated.gbk BS1131_1\ \(paired\)\ mapping\ \(Variants\).txt BS1131.csv

There is a bug! Reverse compliment promoters are considered.
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""
__license__ = "Cite me!"
__version__ = "1.4"

#debugprint=print
debugprint=lambda *x: 0

#print('THIS IS THE VERSION FOR VCF FILES FOR BOTH CLC OR SAM')

from pprint import PrettyPrinter
import argparse

import csv, os, re
from Bio import SeqIO
from Bio.Seq import MutableSeq, Seq
from warnings import warn

upstream_cutoff = 100
qual_cutoff = 100  # 228
#marker='gene' #gene is gene symbol
marker='protein_id'



def tabulator(ref, strain, outname, subset=None, mode='CLC'):
    notes=[]
    debugprint('Parsing genome... ')
    genome = {chromo.name:chromo for chromo in SeqIO.parse(ref, 'genbank')}
    geneball = {chromo: [gene for gene in genome[chromo].features if gene.type not in ('source','Contig')] for chromo in genome}
    debugprint('Starting outfile {0}... '.format(outname))
    out = csv.DictWriter(open(outname, 'w'),
                         fieldnames=['Chromosome', 'Position', 'Category', 'Symbol', 'Product', 'Effect', 'Mutation',
                                     'Type', 'Quality'])
    out.writeheader()
    ''' DISABLED UNTIL FIXED.
    geneball = genome.features[1:]
    if subset:
        print('ONLY SUBSET OF GENES SHOWN IN FINAL TABLE!')
        geneball = [gene for gene in genome.features[1:] if
                    'gene' in gene.qualifiers and gene.qualifiers['gene'][0] in subset]
             '''
    file = open(strain)
    if mode=='SAM':
        modedex = {'QUAL': 'QUAL', 'CHROM': '#CHROM','POS':'POS','INFO':'INFO','ALT':'ALT'}
        modedeli = '\t'
        while next(file)[0:22] != '##bcftools_callCommand':
            pass
    elif mode=='CLC':
        modedex = {'QUAL': 'Average quality', 'CHROM': 'Type','POS':'Reference Position','INFO':'Type','ALT':'Allele'}  # no Chrom!!
        modedeli = ','
    else:
        raise KeyError('Not a valid mode, CLC or SAM only')
    count = 0
    debugprint(mode)
    debugprint(modedex)
    debugprint(list(csv.DictReader(file, delimiter=modedeli)))
    debugprint('Going through list...')
    # The headers differ in CLC:
    # "Reference Position","Type","Length","Reference","Allele","Linkage","Zygosity","Count","Coverage","Frequency","Forward/reverse balance","Average quality","Overlapping annotations","Coding region change","Amino acid change"

    for line in csv.DictReader(file, delimiter=modedeli):
        try:
            if float(line[modedex['QUAL']]) >= qual_cutoff: #QUAL
                #chr_name='.'.join(list(line['#CHROM'].split())[:-1])
                chr_name =line[modedex['CHROM']]
                pastgene = genome[chr_name].features[0]
                pastproduct = ''
                pastsymbol = ''
                pastlocus=''
                for gene in geneball[chr_name]:
                    if gene.type == 'gene':
                        if 'locus_tag' in gene.qualifiers:
                            locus=gene.qualifiers['locus_tag'][0]
                        else:
                            locus='N/A'
                        continue
                    pos = int(line[modedex['POS']])
                    data = {'Chromosome': line[modedex['CHROM']], 'Position': pos, 'Type': line[modedex['INFO']], 'Quality': line[modedex['QUAL']]}
                    if 'product' in gene.qualifiers:
                        product = gene.qualifiers['product'][0]
                    else:
                        product = 'Unstated!'
                    if marker in pastgene.qualifiers:
                        symbol = pastgene.qualifiers[marker][0]

                    elif 'protein_id' in pastgene.qualifiers:
                        symbol = pastgene.qualifiers['protein_id'][0]
                    else:
                        symbol = ''

                    if gene.location.start < pos - 1 < gene.location.end:
                        gs = gene.extract(genome[chr_name]).seq
                        if gene.location.strand > 0:
                            loc = pos - 1 - gene.location.start
                            target = line[modedex['ALT']]
                        else:
                            loc = gene.location.end - pos
                            target = str(Seq(line[modedex['ALT']]).reverse_complement())
                        if line['INFO'][0:2] == 'DP':
                            mut = gs.tomutable()
                            mut[loc] = target
                            from_aa = gs.translate()[int(loc / 3)]
                            to_aa = mut.toseq().translate()[int(loc / 3)]
                            if from_aa == to_aa:
                                effect = 'Synonymous'
                                break  # skip synonymous
                            elif to_aa == '*':
                                effect = 'NonSense'
                            else:
                                effect = 'NonSynonymous'
                            count += 1
                            if count % 200 == 0:
                                debugprint('Still working through the list... ({0} done so far)'.format(count))
                            mutation = from_aa + str(int(loc / 3) + 1) + to_aa
                            out.writerow({**data,
                                **{'Product': product,
                                   'Symbol': symbol,
                                   'Effect': effect, 'Mutation': mutation, 'Category': 'CODING'}})
                            break
                        else:
                            out.writerow({**data,
                                **{'Product': product,
                                   'Symbol': symbol,
                                   'Effect': 'Indel', 'Mutation': 'N/A', 'Category': 'CODING'}})
                            break
                    elif gene.location.start > pos - 1:  # not got to the gene yet but the previous gene was earlier, i.e. gene.location.end < pos
                        if gene.location.start < pos + upstream_cutoff and gene.location.strand > 0:  # great than changed. This was inverted.
                            if marker in gene.qualifiers:
                                symbol = gene.qualifiers[marker][0]

                            elif 'protein_id' in gene.qualifiers:
                                symbol = gene.qualifiers['protein_id'][0]
                            else:
                                symbol = ''
                            out.writerow({**data,
                                          **{'Category': 'PROMOTER', 'Symbol': symbol,
                                             'Product': product}})
                        elif pastgene.location.end + upstream_cutoff > pos and pastgene.location.strand < 0:

                            out.writerow({**data,
                                          **{'Category': 'PROMOTER', 'Symbol': pastsymbol,
                                             'Product': pastproduct}})
                        elif not subset:
                            out.writerow({**data,
                                          **{'Category': 'INTERGENIC', 'Symbol': pastsymbol,
                                             'Product': pastproduct}})
                        break
                    pastgene = gene
                    pastproduct = product
                    pastsymbol = symbol
        except KeyError as e:
            notes.append('KEY ERROR! {e}'.format(e=e))
        except Exception as error:
            warn('Bugger! An error happened! This one: '+str(error)+'\n The line was this: '+'\t'.join(line))
        notes.append('There are {0} protein mutations!'.format(count))
    genome = {chromo.name: chromo for chromo in SeqIO.parse(ref, 'genbank')}
    #notes.append('Elements in genbank:  '+', '.join(*genome.keys()))
    file = open(strain)
    if mode=='SAM':
        while next(file)[0:22] != '##bcftools_callCommand':
            pass
    #notes.append('Elements in cvf:  '+', '.join(*{line[modedex['CHROM']] for line in csv.DictReader(file, delimiter=modedeli)}))
    #return '#'+'\n#'.join(notes)+'\n'
    return ''


if __name__ == "__main__":  # and 1==0 taken away the impossible identity to make it work normal.
    parser = argparse.ArgumentParser()
    parser.add_argument("reference", help="the reference genbank input file, e.g. BS1183 annotated.gbk")
    parser.add_argument("mutant", help="the tab-delimited mutant input file, e.g. st_1_mutations.txt")
    parser.add_argument("outfile", help="the csv outfile to be made")
    parser.add_argument('--sam', help='Run the parser for SAMTools output, not CLC')
    args = parser.parse_args()
    if args.sam:
        mode='SAM'
    else:
        mode = 'CLC'
    print(tabulator(args.reference, args.mutant, args.outfile, mode))
