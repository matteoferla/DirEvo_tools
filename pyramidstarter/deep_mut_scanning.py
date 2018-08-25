#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Written for python 3, not tested under 2.
"""
Deep mutational scan primer design for Carlos Acevedo-Rocha based on this paper: http://nar.oxfordjournals.org/content/43/2/e12.long
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""
__version__ = "1.0.8"

N = "\n"
T = "\t"
# N = "<br/>
from Bio.Seq import Seq
from Bio.Alphabet import generic_dna
from Bio.SeqUtils import MeltingTemp as mt
import math
from warnings import warn
import random, re
from pyramidstarter.mutagenesis import Mutation


def parse_AAmutation(mutation, sequence, offset=0,check=True):
    """
    Coverts a AA mutation to codon
    :param mutation: AA mutation, eg. A23K or A23[NNK]
    :param sequence: the sequence
    :param offset: the start codon is n (from zero)
    :param check: bol whether to check if the original codon matches the mutated-from AA.
    :return:
    """
    sequence=str(sequence) #for now..
    AA_choice='QWERTYIPASDFGHKLCVNM*X'
    rex=re.match('(\w)(\d+)(.*)',mutation)
    if not rex:
        raise ValueError('{0} is not a valid mutation, unlike say A23K'.format(mutation))
    (start_AA,num,target)=rex.groups()
    num=int(num)
    assert start_AA in AA_choice, ValueError('{0} is not an amino acid letter'.format(start_AA))
    pos = (num - 1) * 3 + offset
    if check:
        if isinstance(sequence,Seq):
            actual_AA = str(sequence[pos:pos + 3].translate())
        else:
            actual_AA=str(Seq(sequence[pos:pos+3]).translate())
        assert actual_AA == start_AA, ValueError('In {mutation}, Pos {pos}-{pos2} ({seq}) encodes a {actual} not a {start}. Neighbourhood: {neigh}'.format(pos=pos, pos2=pos+3, seq=str(Seq(sequence[pos:pos+3])), actual=actual_AA, start=start_AA, mutation=mutation,neigh=str(Seq(sequence[pos-9:pos+12]))))
    if target in AA_choice and target != 'X': #AA target
        ori_codon=str(Seq(sequence[pos:pos+3]))
        #temp solution. Not using the Mutation class itself
        return (pos,Mutation.codon_codex[ori_codon][target])
    elif target.find('[') != -1: # nucleotide target A23[NNK]
        return (pos,re.search('\[(\w{3})\]', target).groups()[0])
        # assert if real codon?
    else:
        raise ValueError('{0} is an unrecognised target'.format(target))

def deep_mutation_scan(region, section, target_temp=55, overlap_len=22, primer_range=(None, 60), mutation='NNK',
                       GC_bonus=1, Tm_bonus=2.8, staggered=True, count_from_one=True, task='DS'):
    """
    Designs primers for quikchange for deep mutation scanning.
    Based on the overlap principle of http://nar.oxfordjournals.org/content/43/2/e12.long
    In terms of calculating the melting temperature module is used.
    For now the calculations are based on everything after the NNK. The problem is the missing thermodynamics for the various mismatches.
    :param region: the sequence of a region including neighbouring parts and not only the seq of interest.
    :param section: the range of bases to make primers for as a list/tuple of two items or a slice
    :param target_temp: the temp threshold. Remember that Phusion HF buffer is secret, but they say the Tm is +3. For salt correction see below
    :param overlap_len: the length of the overlap of the two primers. ignored if stagged = False
    :param primer_range: the min and max len of the primer.
    :param mutation: str of the desired mutatated codon
    :param GC_bonus: 5' GC clamp. This number is added to the Tm when checking if is greater than the set threshold target_temp.
    :param Tm_bonus: Temp increase due to salt. Distilled water (+0). To match the IDT oligoanalyser with 50 mM Na (+2.8&deg;C). Taq buffer (+4.9&deg;C), Phusion buffer (+11.6&deg;C), Q5 buffer (+13.3&deg;C)
    :param staggered: Boolean. If true (default) staggered primers will be designed. If not, Agilent-QC primers with full overlap will be designed.
    :param count_from_one: Boolean or int. If true (default) the first amino acid mutated will be the first one, else whatever number it was in the sequence.
    :param mode: DS the normal way deepscan. MP make primers based on mutation list.
    :return: a list of dictionaries with the following keys: base codon primer len_homology len_anneal len_primer homology_start homology_stop homology_Tm anneal_Tm

    Regarding salts. check out mt.salt_correction at http://biopython.org/DIST/docs/api/Bio.SeqUtils.MeltingTemp-module.html#salt_correction
    if needed.
    """
    #
    # sanity
    if isinstance(region, Seq):
        pass
    elif isinstance(region, str):
        region = Seq(region, generic_dna)
    else:
        raise TypeError('Sequence is neither string or Seq.')
    region = region.ungap(' ')  # spaces!
    if isinstance(section, slice):
        pass
    else:  # try if it is an iterable.
        section = slice(*section)
    gene = region[section]
    #if len(gene) % 3 != 0:
    #    warn('The length of the region is not a multiple of three: ' + str(len(region)))
    # max size
    if not staggered and primer_range[0]:  # in case someone gives a rather odd input.
        overlap_len = primer_range[0]
    if not primer_range[0] or primer_range[0] < overlap_len:
        primer_range = (overlap_len, primer_range[1])
    # iterate across codons.
    geneball = []
    if count_from_one is True:
        offset = int(section.start/3 -1)
    elif isinstance(count_from_one,int):
        offset=count_from_one
    else:
        offset=0
    mutagenplan=[] #list of tuple of two: nt position, codon
    if task =='DS':
        for x in range(section.start, section.stop, 3):
            mutagenplan.append((x,mutation)) #mutation is the same for all and is a codon
    elif task == 'MP':
        for AA_mut in mutation.replace("\n"," ").split(): # in MP mode mutation is a list A45K
            mutagenplan.append(parse_AAmutation(AA_mut, region,section.start))
    else:
        raise NotImplementedError
    for (x,mutcodon) in mutagenplan:
        start = x - int(overlap_len / 2)
        stop = x + overlap_len - int(overlap_len / 2)
        codon = {'codon': region[x:x + 3],
                 'AA': str(region[x:x + 3].translate()) + str(int(x/3)-offset),
                 'base': x,
                 'homology_start': start,
                 'homology_stop': stop,
                 'len_homology': overlap_len,
                 'homology_Tm': round(mt.Tm_NN(region[start:stop]), 1)
                 }
        # iterate to find best fw primer.
        for dir in ('fw', 'rv'):
            for i in range(primer_range[0] - int(overlap_len / 2) - 3, primer_range[1] - int(overlap_len / 2) - 3):
                # the length of the annealing part of the primer is i+3 (the end of the mutated codon)
                # so the region prior to the mutation does not count: -int(overlap_len/2)-3

                # This cannot be done:
                # mut=region[start:x]+Seq('NNK')+region[x+3:x+i]
                # ori=region[start:x+i]
                # t= mt.Tm_NN(mut, c_seq=ori.complement())
                # ValueError: no thermodynamic data for neighbors 'GG/TA' available

                # this seems to pick the weakest
                # mut = region[start:x] + Seq('NNK') + region[x + 3:x + i]
                # t = mt.Tm_NN(mut)

                # so ignoring forepart
                if dir == 'fw':
                    mut = region[x + 3:x + i]
                elif dir == 'rv':
                    mut = region[x - i:x].reverse_complement()
                else:
                    raise Exception

                t = mt.Tm_NN(mut) + float(Tm_bonus)

                # check if the tms are good...
                if mut[-1].upper() in ['C', 'G'] and t > target_temp - GC_bonus:
                    break
                elif t > target_temp:
                    break
            else:
                warn('Target temperature not met. {0}C > {1}C'.format(target_temp, t))
            if dir == 'fw':
                if staggered:
                    codon[dir + '_primer'] = region[start:x].upper() + mutcodon.lower() + mut.upper()
                else:
                    # placeholder
                    codon[dir + '_primer'] = mut.upper()
            else:  # dir == 'rv'
                if staggered:
                    codon[dir + '_primer'] = region[x + 3:stop].reverse_complement().upper() + Seq(
                        mutcodon).reverse_complement().lower() + mut.upper()
                else:
                    codon[dir + '_primer'] = mut.upper()
            codon[dir + '_len_primer'] = len(codon[dir + '_primer'])
            codon[dir + '_anneal_Tm'] = round(t, 1)
            codon[dir + '_len_anneal'] = i
        if not staggered:
            codon['fw_primer'] = codon['rv_primer'].reverse_complement().upper() + mutcodon.lower() + codon['fw_primer']
            codon['rv_primer'] = codon['fw_primer'].reverse_complement()
        geneball.append(codon)
    return geneball


def randomer(n):
    """
    Generate random DNA (not a randomer (NNNNN) which is a mix of random DNA)
    :param n: length
    :return: string
    """
    alphabet = ['A', 'T', 'G', 'C']
    return ''.join([random.choice(alphabet) for x in range(n)])


def test():
    """Diagnostic!"""
    print('Testing deep_mutation_scan...')
    n = 30
    m = 21
    query = randomer(n).lower() + randomer(m).upper() + randomer(n).lower()
    print('sequence:', query)
    import csv
    f=open('out.csv', 'w', newline='')
    w = csv.DictWriter(f,
                       fieldnames='base AA codon fw_primer rv_primer len_homology fw_len_anneal rv_len_anneal fw_len_primer rv_len_primer homology_start homology_stop homology_Tm fw_anneal_Tm rv_anneal_Tm'.split())
    w.writeheader()
    w.writerows(deep_mutation_scan(query, (n, n + m)))
    f.close()
    print(open('out.csv').read())
    ##
    print('Testing parse_AAmutation...')
    print('Y2K',parse_AAmutation('Y2K', 'ATGTATGGT', 0,True)[1])


def cmdline():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("infile", help="the fasta file with the sequence")
    parser.add_argument("outfile", help="the csv file to save the data into")
    parser.add_argument("section_start", type=int, help="the start of the mutagenised region")
    parser.add_argument("section_end", type=int, help="the end of the mutagenised region")
    # parser.add_argument("-T", "--target_temp", type=int, nargs = 1, dest = "target_temp", help="Target temperature")
    args = parser.parse_args()
    seq = ''.join(open(args.infile).read().split('\n')[1:])  # crude fasta reading...
    deep_mutation_scan(seq, (args.section_start, args.section_stop))


if __name__ == "__main__":
    #cmdline()
    test()
