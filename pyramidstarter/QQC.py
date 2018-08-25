#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Written for python 3, not tested under 2.
"""
QQC in Python. Under construction. See the Matlab files!
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = "25/10/2016"

N = "\n"
T = "\t"
# N = "<br/>
import re
from collections import defaultdict
from pprint import PrettyPrinter
from warnings import warn

import numpy as np
from Bio import SeqIO
from Bio import pairwise2
from Bio.Seq import Seq
from scipy.optimize import minimize

pprint = PrettyPrinter().pprint


class Trace:
    """
    A class designed to better handle sequence traces as the documentation is shocking for the SeqIO/AbiIO.
    http://biopython.org/DIST/docs/api/Bio.SeqIO.AbiIO-module.html
    """
    bases = ('A', 'T', 'G', 'C')

    def __init__(self, record=None, **kwargs):
        if record:
            for ni, N in enumerate(record.annotations['abif_raw']['FWO_1'].upper()):
                setattr(self, N, record.annotations['abif_raw']['DATA{0}'.format(9 + ni)])
            self.peak_index = record.annotations['abif_raw']['PLOC1']
            self.peak_id = record.annotations['abif_raw']['PBAS1']
        else:
            for k in ['A', 'T', 'G', 'C', 'peak_id', 'peak_index']:
                setattr(self, k, kwargs[k])
        self.span = len(self.A) / len(self.peak_index)  # float
        self.halfspan = round(len(self.A) / (2 * len(self.peak_index)))  # int
        self.alignment = None

    @classmethod
    def from_filename(cls, file):
        """
        Class method to return a Trace instance, but from a filename.
        >>> data=Trace.from_filename('sample.ab1')
        :param file: a file name
        :return: Trace instance
        """
        handle = open(file, 'rb')
        record = SeqIO.read(handle, "abi")
        return cls(record)

    def __getitem__(self, key):
        if isinstance(key, slice):
            peak_values = {
                k: getattr(self, k)[
                   self.peak_index[key.start] - self.halfspan:self.peak_index[key.stop] + self.halfspan]
                for k in self.bases}
            fluoro_values = {k: getattr(self, k)[key] for k in ['peak_id', 'peak_index']}
            return Trace(**{**peak_values, 'peak_index': [n - self.peak_index[key.start] + self.halfspan for n in
                                                          self.peak_index[key]], 'peak_id': self.peak_id[key]})
        elif isinstance(key, int):
            raise NotImplementedError
        else:
            raise TypeError

    def size_test(self):
        for k in ['A', 'T', 'G', 'C', 'peak_id', 'peak_index']:
            print(k, len(getattr(self, k)))

    def find_peak(self, target_seq, strict=True):
        """
        Find the index of the first base of a given sequence in the trace.
        :param target_seq: a string of bases.
        :param strict: boolean, dies if multiple hits.
        :return: the index of peak_id or peak_index of the first base.
        """
        ## sanitise
        target_seq = re.sub('[^ATGC]', '', target_seq.upper())
        targetdex = re.findall(target_seq, self.peak_id)
        if not targetdex:
            raise ValueError('target_seq not found!')
        elif len(targetdex) > 1:
            if strict:
                raise ValueError('Ambiguous sequence given!')
            else:
                warn('Ambiguous sequence given!')
        return self.peak_id.find(target_seq)

    def find_peak_after(self, target_seq, strict=True):
        """
        Same as find_peak, but give the index of the base after the given sequence.
        :param target_seq: a string of bases.
        :param strict: boolean, dies if multiple hits.
        :return: the index of peak_id or peak_index of the next (last+1) base along
        """
        target_seq = re.sub('[^ATGC]', '', target_seq.upper())
        return self.find_peak(target_seq, strict) + len(target_seq)

    def get_intensities(self, index, wobble=0.20):
        """
        Get intensities at given peak index.
        :param index: a peak index
        :param wobble: window to look in (default .2)
        :return: dictionary
        """
        span = round(len(self.A) / len(self.peak_index))
        doubleindex = self.peak_index[index]
        return {
            base: max(
                [getattr(self, base)[doubleindex + i] for i in range(-round(span * wobble), round(span * wobble))])
            for base in self.bases}

    def reverse(self):
        """
        Is the trace from a reverse primer?
        :return: a new trace
        """
        return Trace(peak_index=[len(self.T) - x for x in self.peak_index[::-1]],
                     peak_id=str(Seq(self.peak_id).reverse_complement()),
                     A=self.T[::-1],
                     T=self.A[::-1],
                     G=self.C[::-1],
                     C=self.G[::-1])

    def QQC(self, location, *args, **kwargs):
        """
        Intended main entry point to the QQC class.
        :param location: peak number. Note that this is not residue or base number as there is no way of telling
        what is the right frame and start position. Accepts a string of bases preceeding (add NNK or whatever as scheme not at end.)
        :param args: stuff to pass to QQC(). E.g. scheme='NNK'
        :param kwargs: stuff to pass to QQC()
        :return: a QQC object.
        """
        if isinstance(location, str):
            location = self.find_peak_after(location)
            ## go..
        return QQC(
            [self.get_intensities(location), self.get_intensities(location + 1), self.get_intensities(location + 2)],
            *args, **kwargs)

    def align(self, sequence, *args, **kwargs):
        """
        While QQC does a partial match, MC has to do a full alignment.
        :param sequence:
        :param args:
        :param kwargs:
        :return:
        """
        # sanitise
        ref_seq = re.sub('[^ATGC]', '', sequence.upper())
        # play around... >>> pairwise2.align.localxs(''.join([random.choice('A T G C'.split()) for i in range(100)]), ''.join([random.choice('A T G C'.split()) for i in range(60)]),-5,-.2)
        match = pairwise2.align.globalxs(self.peak_id, ref_seq, -5, -.2, one_alignment_only=True)[0]
        if not match:
            raise ValueError('target_seq not found!')
        # case 1. The read is longer than the CDS
        if match[1][0] == '-':
            # front trim
            for i in range(len(match[1])):
                if match[1][i] != '-':
                    break
            else:
                raise ValueError('Seq does not match')
            # back trim
            for j in range(len(match[1]) - 1, -1, -1):
                if match[1][j] != '-':
                    break
            else:
                raise ValueError('Seq does not match')
            trim = self[i:j]
            setattr(trim, 'alignment', (match[0][i:j], match[1][i:j]))
        # case 2. The read is shorter...
        else:
            raise NotImplementedError('case 2. The read is shorter than the CDS at the front.')
        return trim

    def other_bases(self, base):
        other_bases = set(self.bases)
        if isinstance(base,str) and base in self.bases:
            other_bases.remove(base)
        elif isinstance(base,int) and self.peak_id[base] in self.bases:
            other_bases.remove(self.peak_id[base])
        return other_bases

    def noise_analysis(self, sigma=5):
        # get intensity of main peaks and of minor peak sums
        main_peaks = []
        minor_peaks = []
        for i in range(len(self.peak_index)):
            ii = self.peak_index[i]
            if self.peak_id[i] in self.bases:
                id=self.peak_id[i]
            else: # Degenerate...
                k={b: getattr(self, b)[ii] for b in self.bases}
                id=sorted(k, key=lambda x: k[x], reverse = True)[0]
            main_peaks.append(getattr(self, id)[ii])
            minor_peaks.append(sum([getattr(self, b)[ii] for b in self.other_bases(id)]))
        mainPeaks = np.array(main_peaks)  # why do I always call np varibles C++ style? oh well.
        minorPeaks = np.array(minor_peaks)
        SNR = np.divide(mainPeaks, minorPeaks)
        snrMedian = np.median(SNR)
        snrThresh = np.std(minorPeaks) * sigma + np.median(minorPeaks)
        # find outliers.
        outliers=np.nonzero(minorPeaks > snrThresh)[0]  #why tuple?
        outball=[]
        print(outliers)
        if outliers.size:
            for i in np.nditer(outliers):
                tally={b: getattr(self,b)[self.peak_index[i]] for b in self.bases}
                st=sum(tally.values())
                prop={b: tally[b]/st for b in self.bases}
                outball.append((int(i),prop))
        return {'snr': snrMedian, 'main_peaks': main_peaks, 'minor_peaks': minor_peaks, 'outliers':outball}


def scheme_maker(scheme):
    """
    FORMERLY A STATIC METHOD.
    converts a name of a scheme to a probability set.
    The input is a string (e.g. NNK). Except some are complicated.
    So it accepts one or more codons separated by a space and optionally prefixed with a interger number.
    >>> scheme_maker('12NDT 6VHA 1TGG 1ATG')
    :param scheme: str of codon proportion.
    :return: a LIST of n primers each being a list of 3 positions each with a dictionary of the probability of each base.
    """
    # check first if reserved word.
    scheme = scheme.upper().replace('-trick'.upper(), '')
    if scheme == 'Tang'.upper() or scheme.lower() == '20c':
        scheme = '12NDT 6VHA 1TGG 1ATG'
    elif scheme.lower() == '19c':
        scheme = ''
    elif scheme.lower() == '21c':
        scheme = ''
    elif scheme == 'Kille'.upper() or scheme.lower() == '22c':
        # dx.doi.org / 10.1038 / srep10654
        scheme = '1NDT 9VHG 1TGG'
    else:
        pass  # there seems no need to store a boolean?
    # Biopython can handle this somewhere but tyhis is easier.
    degeneracy = {'N': 'ATGC',
                  'A': 'A',
                  'T': 'T',
                  'G': 'G',
                  'C': 'C',
                  'W': 'AT',
                  'S': 'GC',
                  'K': 'GT',
                  'M': 'AC',
                  'R': 'AG',
                  'Y': 'TC',
                  'B': 'TGC',
                  'V': 'AGC',
                  'H': 'ATC',
                  'D': 'ATG'}
    # split for analysis
    schemelist = scheme.split()
    proportions = []
    codons = []
    for m in schemelist:
        (prop, codon) = re.match('(\d{0,2})(\w{3})', m).groups()
        if prop:
            proportions.append(int(prop))
        else:
            proportions.append(1)
        codons.append(codon)
    # pars
    freq = [p / sum(proportions) for p in proportions]
    codonmix = []
    for codon in codons:
        pred = []
        for i in range(3):
            basedex = {}
            for b in 'ATGC':
                if b in degeneracy[codon[i]]:
                    basedex[b] = 1 / len(degeneracy[codon[i]])
                else:
                    basedex[b] = 0
            pred.append(basedex)
        codonmix.append(pred)
    return list(zip(freq, codonmix))


def codon_to_AA(codonball):
    codprob = [codonball[0][x] * codonball[1][y] * codonball[2][z]
               for x in 'ATGC' for y in 'ATGC' for z in 'ATGC']
    codnames = [x + y + z for x in 'ATGC' for y in 'ATGC' for z in 'ATGC']
    # translate codnames to AA.
    AAprob = defaultdict(int)
    for i in range(64):
        AAprob[str(Seq(codnames[i]).translate())] += codprob[i]
    return AAprob


class QQC:
    """
    This class is meant to be called via:
    >>> Trace(seqRecord).QQC(str_of_preceding_bases, str_of_scheme)
    But can be called directly...
    The normal initialisation relies on as an input a special construct that is the key format of this class and is a list of 3 positions each with a dictionary of the probability of each base. This may be made better in the future.
    There is also a reverse
    >>> QQC.from_trace(filename,str_of_preceding_bases, str_of_scheme)
    The default scheme is NNK, but complex inputs are possible: see `scheme_maker()`
    """

    def _targetfun(self, offness):
        """I cannae shove this in __init__ as it needs a few variables from self.
        There is a weirdness in that the vector gets linearised.
        objfunc = @(offness) sum(abs(reshape(abs(offness(:,:,1) .* ppro(1) .* con(:,:,1)) + abs(offness(:,:,2) .* ppro(2) .* con(:,:,2)) + abs(offness(:,:,3) .* ppro(3) .* con(:,:,3)) - codon, 12,1)));
        """
        off = offness.reshape(len(self.scheme_mix), 3, 4)
        return sum([abs(sum([abs(
            off[p, i, bi] * self.scheme_mix[p][0] *
            self.scheme_mix[p][1][i]['ATGC'[bi]])
                             for p in range(len(self.scheme_mix))]) - self.codon_peak_freq[i]['ATGC'[bi]]) for i in
                    range(3) for bi in range(4)])

    def __init__(self, peak_int, scheme='NNK', normalise_hack=False):
        """
        The QQC object has various attributes:
        * scheme: str of scheme name
        * scheme_mix: a list of size 2 tuple with a first value the fraction that the primer accounts for and the second a size 3 list of ('A','T','G','C')-keyed dicts
        * Qpool: float of the calculated Qpool
        * codon_peak_freq: a size 3 list of ('A','T','G','C')-keyed dicts of the empirical values
        * codon_peak_freq_split: the deconvoluted version (a list of size 3 lists of ('A','T','G','C')-keyed dicts, unlike sheme_mix the outer list does not have a size 2 tuple as the proportion is for the scheme_mix)
        * scheme_AA_probabilities: AminoAcid-keyed dict of predicted pobabilities
        * empirical_AA_probabilities: AminoAcid-keyed dict of empirical pobabilities
        """

        self.peak_int = peak_int
        self.scheme = scheme
        self.scheme_mix = scheme_maker(scheme)
        self.scheme_pred = [
            {b: sum([self.scheme_mix[p][0] * self.scheme_mix[p][1][i][b] for p in range(len(self.scheme_mix))]) for b in
             'ATGC'} for i in range(3)]
        # make peakfreqs a fraction of one
        self.codon_peak_freq = [{b: p[b] / sum(p.values()) for b in 'ATGC'} for p in peak_int]
        # calculate deviation per position
        deviation = [
            sum([self.scheme_pred[i][b] - abs(self.scheme_pred[i][b] - self.codon_peak_freq[i][b]) for b in 'ATGC'])
            for i in range(3)]
        # calculate the weights
        weight_total = sum([self.scheme_pred[i][b] > 0 for b in 'ATGC' for i in range(3)])
        weights = [sum([self.scheme_pred[i][b] > 0 for b in 'ATGC']) / weight_total for i in range(3)]
        # weighted sum of deviations
        wsum = sum([deviation[i] * weights[i] for i in range(3)])
        # calculated the worse case scenario, an undiverse codon
        undiverse = [{'A': 1, 'T': 0, 'G': 0, 'C': 0}, {'A': 1, 'T': 0, 'G': 0, 'C': 0},
                     {'A': 1, 'T': 0, 'G': 0, 'C': 0}]
        worse = [sum([self.scheme_pred[i][b] - abs(self.scheme_pred[i][b] - undiverse[i][b]) for b in 'ATGC']) for i in
                 range(3)]
        wmin = sum([worse[i] * weights[i] for i in range(3)])
        # calculate Qpool
        self.Qpool = (wsum + abs(wmin)) / (1 + abs(wmin))
        # calculate AA...
        schemeprobball = []
        for primer in self.scheme_mix:
            schemeprobball.append(codon_to_AA(primer[1]))
        self.scheme_AA_probabilities = {
            aa: sum([self.scheme_mix[pi][0] * schemeprobball[pi][aa] for pi in range(len(schemeprobball))]) for aa in
            schemeprobball[0].keys()}
        if len(self.scheme_mix) == 1:  # i.e. the easy case...
            # triadic product (horizontal vector x vertical vector x stacked vector
            # codprob = bsxfun( @ mtimes, codon(1,:)'*codon(2,:), reshape(codon(3,:),1,1,4));
            self.codon_peak_freq_split = [self.codon_peak_freq]
            self.empirical_AA_probabilities = codon_to_AA(self.codon_peak_freq)
        else:  # deconvolute!
            prinumb = len(self.scheme_mix)
            offness_zero = np.array([[[0.25 for b in 'ATGC'] for i in range(3)] for p in
                                     range(prinumb)])  # ones(3,4,numel(ppro))
            res = minimize(self._targetfun, offness_zero)
            r = res.x.reshape(prinumb, 3, 4)
            self.codon_peak_freq_split = [
                [{'ATGC'[bi]: abs(r[p, i, bi] * self.scheme_mix[p][1][i]['ATGC'[bi]]) for bi in range(4)} for i in
                 range(3)]
                for p in range(prinumb)]
            if normalise_hack:
                s = sum([self.codon_peak_freq_split[p][i][b] for b in 'ATGC' for i in range(3) for p in
                         range(len(self.scheme_mix))]) / (3 * prinumb)
                self.codon_peak_freq_split = [
                    [{b: self.codon_peak_freq_split[p][i][b] / s for b in 'ATGC'} for i in range(3)] for p in
                    range(prinumb)]
            codonprobball = []
            for primer in self.codon_peak_freq_split:
                codonprobball.append(codon_to_AA(primer))
            self.empirical_AA_probabilities = {
                aa: sum([self.scheme_mix[pi][0] * codonprobball[pi][aa] for pi in range(len(codonprobball))]) for aa in
                codonprobball[0].keys()}

    @staticmethod
    def from_trace(trace, location, *args, **kwargs):
        """
        An alternate route. QQC instance comes from Trace(...).QQC()
        :param trace: Trace instance
        :param location: location of first peak of three
        :return: QQC instance
        """
        if not isinstance(trace, Trace):
            trace = Trace(trace)
        return trace.QQC(location, *args, **kwargs)


def QQC_test():
    file = "example data/ACE-AA-088-02-60Â°C-BM3-A82_NDT-VHG-TGG-T7Hi-T7minus1.ab1"
    x = Trace.from_filename(file)
    q = x.QQC('CGT GAT TTT', '22c')
    # q = x.QQC('CGT GAT TTT', 'NNK') # works
    print('Bases ', sum([p[i][b] for p in q.codon_peak_freq_split for i in range(3) for b in 'ATGC']) / (
        3 * len(q.codon_peak_freq_split)))
    print('AA ', sum(q.empirical_AA_probabilities.values()))


def MC_test():
    seq = 'GTGGAACAGGATGTGGTGTTTAGCAAAGTGAATGTGGCTGGCGAGGAAATTGCGGGAGCGAAAATTCAGTTGAAAGACGCGCAGGGCCAGGTGGTGCATAGCTGGACCAGCAAAGCGGGCCAAAGCGAAACCGTGAAGCTGAAAGCCGGCACCTATACCTTTCATGAGGCGAGCGCACCGACCGGCTATCTGGCGGTGACCGATATTACCTTTGAAGTGGATGTGCAGGGCAAAGTTACAGTGAAAGATgcgaatGGCAATGGTGTGAAAGCGGAG'
    x = Trace.from_filename('pyramidstarter/static/demo_MC.ab1').reverse().align(seq)
    pprint(x.alignment)
    ref = Seq(x.alignment[1].replace('-', '')).translate()
    query = Seq(x.alignment[0].replace('-', '')).translate()
    for resi in range(len(ref)):
        if ref[resi] != query[resi]:
            print('{0}{1}{2}'.format(ref[resi], resi + 1, query[resi]))
    print('#' * 20)
    x.size_test()
    print('SNR', x.noise_analysis(sigma=2)['snr'])


if __name__ == "__main__":
    MC_test()
