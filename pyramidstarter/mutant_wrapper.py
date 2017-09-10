#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Written for python 3, not tested under 2.
"""
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""

N = "\n"
T = "\t"
# N = "<br/>

from pyramidstarter.deep_mut_scanning import deep_mutation_scan
from pyramidstarter.QQC import Trace, scheme_maker, codon_to_AA
import re, json, openpyxl
from Bio.Seq import Seq
from pyramid.response import FileResponse
from pyramidstarter import bike
from collections import defaultdict


class SeqEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Seq):
            return str(obj)
        else:
            return json.JSONEncoder.default(self, obj)

def DS(req):
    ###seq.
    # for some reason I abided by the keep python variables pythonic and the JS variables JavaScribal
    req['sequence'] = re.sub('\>.*\n', '', req['sequence']).upper()  # kill fasta header
    req['sequence'] = re.sub('\W', '', req['sequence'])  # kill spaces and stuff
    #### check if user has given numeric or seq position
    if not re.search('\d', req['startBase']):
        req['startBase'] = re.sub('\W', '', req['startBase']).upper()
        if req['sequence'].find(req['startBase']) != -1:
            req['startBase'] = req['sequence'].find(req['startBase']) + 1
        else:
            pass
        if not re.search('\d', req['stopBase']):
            req['stopBase'] = re.sub('\W', '', req['stopBase']).upper()
            if req['sequence'].find(req['stopBase']) != -1:
                req['stopBase'] = req['sequence'].find(req['stopBase']) + 1 + len(req['stopBase'])
            else:
                pass
    #### parse rest
    pyreq = {
             'region': req['sequence'],
             'primer_range': [int(x) for x in req['primerRange'].split(',')],
             'section': slice(int(req['startBase']), int(req['stopBase'])),
             'Tm_bonus': float(req['TMBonus'])}
    if req['task'] == 'MP':
        pyreq['mutation'] = req['mutationList']
        pyreq['task'] = 'MP'
    elif req['task'] == 'DS':
        pyreq['mutation']=req['mutationCodon']
        pyreq['task']='DS'
    else:
        print(req)
        raise ValueError('Unrecognised: MP or DS mode?')
    if req['targetTemp']:
        pyreq['target_temp'] = float(req['targetTemp'])
    if req['GCclamp']:
        pyreq['GC_bonus'] = float(req['GCclamp'])
    cleanpyreq = {k: pyreq[k] for k in pyreq if pyreq[k]}
    cleanpyreq['staggered'] = req['method']
    data = deep_mutation_scan(**cleanpyreq)
    #####send to fxn
    fields = 'base AA codon fw_primer rv_primer len_homology fw_len_anneal rv_len_anneal fw_len_primer rv_len_primer homology_start homology_stop homology_Tm fw_anneal_Tm rv_anneal_Tm'.split()
    table = "<h3>Results</h3><table class='table-striped'>\n<thead><tr><th class='th-rotated'><div><span>" + "</span><div></th><th class='th-rotated'><div><span>".join(
        fields).replace('_', ' ') + "</span><div></th></tr></thead><tbody>\n"
    for row in data:
        for pref in ('fw', 'rv'):
            seq = row[pref + '_primer']
            n = 10
            row[pref + '_primer'] = ' '.join([str(seq[i:i + n]) for i in range(0, len(seq), n)])
        table += "<tr><td>" + "&nbsp;&nbsp;</td><td>".join([str(row[f]) for f in fields]) + "&nbsp;&nbsp;</td></tr>\n"
    table += "</tbody></table>"
    return json.dumps({'data': data, 'html': table}, cls=SeqEncoder)


def QQC(file_path, stored_filename, tainted_filename, location, scheme='NNK'):
    chroma = Trace.from_filename(file_path)
    Q = chroma.QQC(location, scheme)
    index = chroma.find_peak(location)
    span = round(len(chroma.A) / len(chroma.peak_index))
    window = (len(location) + 5) * span
    doubleindex = chroma.peak_index[index]
    raw = {
        base:
            [getattr(chroma, base)[doubleindex + i] for i in range(window)]
        for base in 'ATGC'}
    html = '''<div class="col-lg-12">&nbsp;<div id='QQC_raw_plot'></div></div><br/>
         <div class="col-lg-12">&nbsp;<p>Q<sub>pool</sub> = {q:.2f}</p></div><br/>
         <div class="col-lg-12">&nbsp;<div id='QQC_pie'></div></div><br/>
         <div class="col-lg-12">&nbsp;<div id='QQC_bar'></div></div><br/>
         '''.format(q=Q.Qpool)
    return json.dumps({'data': {'raw': raw, 'nt': Q.codon_peak_freq, 'AAemp': Q.empirical_AA_probabilities,
                                'AAscheme': Q.scheme_AA_probabilities, 'Qpool': Q.Qpool}, 'html': html})

def glue(jsonreq):
    #{'prob_complete': '0.95', 'completeness': '0.95', 'library_size': '3000000', 'nvariants': '1000000', 'mode': 'prob_complete'}
    for id in ['prob_complete','completeness','library_size']:
        if jsonreq['mode'] == id:
            glue_out=bike.glue(jsonreq['nvariants'], **{id: jsonreq[id]})
            if float(jsonreq['nvariants']) <10:
                hreply='<div class="alert alert-info" role="alert"><i class ="fa fa-exclamation-triangle" aria-hidden="true" > </ i > <span>Number of variants very small. Poisson statistics may be compromised.</span></div>'
            else:
                hreply='<div></div>'
            return json.dumps({'data': glue_out,'html':hreply})

def pedel(jsonreq):
    pedel_out = bike.pedel(library_size=jsonreq['size'], sequence_length=jsonreq['len'],
                           mean_number_of_mutations_per_sequence=jsonreq['mutload'])
    stats = bike.pedel_stats(library_size=jsonreq['size'], sequence_length=jsonreq['len'],
                             mean_number_of_mutations_per_sequence=jsonreq[
                                 'mutload'])
    # print(pedel_out)
    return json.dumps({'data': stats, 'html': '<div>Expected number of distinct sequences in library: {0}</div>'.format(
        pedel_out['expected_number_of_distinct_sequences_in_library'])})


def platecounter(size):
    if size == 96:
        letters = 'ABCDEFGH'
        m = 12
    elif size == 384:
        letters = 'ABCDEFGHIJKLMNOP'
        m = 24
    else:
        raise Exception('only 96 or 384 supported')
    for i in range(1, m + 1):
        for l in letters:
            yield l + str(i)


def IDT(request, size):
    data = json.load(open(request.session['DS']))['data']
    wb = openpyxl.Workbook()
    platenumb = 1
    wf = wb.active
    wf.title = 'forward_{}'.format(platenumb)
    wr = wb.create_sheet('reverse_{}'.format(platenumb))
    wf['A1'] = 'Well Position'
    wf['B1'] = 'Name'
    wf['C1'] = 'Sequence'
    wr['A1'] = 'Well Position'
    wr['B1'] = 'Name'
    wr['C1'] = 'Sequence'
    '''{'fw_primer': 'AGGGCTCGAG CnnkGTGAGC AAGGGCG', 'fw_anneal_Tm': 55.7, 'fw_len_primer': 27,
     'rv_primer': 'TTGCTCACmn nGCTCGAGCC CTGG', 'rv_anneal_Tm': 57.4, 'homology_stop': 116, 'len_homology': 22,
     'rv_len_anneal': 13, 'rv_len_primer': 24, 'base': 105, 'AA': 'M1', 'homology_Tm': 60.5, 'homology_start': 94,
     'fw_len_anneal': 16, 'codon': 'ATG'}'''
    platewells = platecounter(size)
    r = 1
    for entry in data:
        r = r + 1
        try:
            well = next(platewells)
        except StopIteration:
            platenumb += 1
            wf = wb.create_sheet('forward_{}'.format(platenumb))
            wr = wb.create_sheet('reverse_{}'.format(platenumb))
            wf['A1'] = 'Well Position'
            wf['B1'] = 'Name'
            wf['C1'] = 'Sequence'
            wr['A1'] = 'Well Position'
            wr['B1'] = 'Name'
            wr['C1'] = 'Sequence'
            r = 2
            platewells = platecounter(size)
            well = next(platewells)
        wf.cell(row=r, column=1, value=well)
        wf.cell(row=r, column=2, value=entry['AA'])
        wf.cell(row=r, column=3, value=entry['fw_primer'].replace(' ', ''))
        wr.cell(row=r, column=1, value=well)
        wr.cell(row=r, column=2, value=entry['AA'])
        wr.cell(row=r, column=3, value=entry['rv_primer'].replace(' ', ''))
    request.session['DS_IDT'] = request.session['DS'].replace('.json', '.xlsx')
    wb.save(request.session['DS_IDT'])
    response = FileResponse(
        request.session['DS_IDT'],
        request=request,
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    return response

def codon(request):
    ##parts are stolen from the QCC class. This basically just give the empirical results.
    #convert str request which should have codons to AA.
    scheme=scheme_maker(request)
    #a LIST of n primers each being a list of 3 positions each with a dictionary of the probability of each base.
    schemeprobball = []
    for primer in scheme:
        schemeprobball.append(codon_to_AA(primer[1]))
    AA = {
        aa: sum([scheme[pi][0] * schemeprobball[pi][aa] for pi in range(len(schemeprobball))]) for aa in
        schemeprobball[0].keys()}
    return json.dumps({'data': AA, 'html': ''})

if __name__ == "__main__":
    pass
