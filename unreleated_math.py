#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Written for python 3, not tested under 2.
"""

"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""
__license__ = "Cite me!"
__version__ = "1.0"

#what is the probability that an mutation is coding?

import itertools
from Bio.Seq import Seq


def mutations_everywhere():
    silent=0
    nonsilent=0
    nonsense=0
    bases=['A','T','G','C']
    for codon in itertools.combinations_with_replacement('ATGC', 3):
        aa=Seq(''.join(codon)).translate()
        for a in bases:
            for b in bases:
                for c in bases:
                    if codon != (a, b, c):
                        new=Seq(''.join([a, b, c])).translate()
                        if aa == new:
                            silent+=1
                        elif new =='*':
                            nonsense+=1
                        else:
                            nonsilent+=1
    total=silent+nonsense+nonsilent
    print('Silent: ',silent,silent/total)
    print('Non-Silent: ',nonsilent,nonsilent/total)
    print('Nonsense: ',nonsense,nonsense/total)

silent=0
nonsilent=0
nonsense=0
bases=['A','T','G','C']
for codon in itertools.combinations_with_replacement('ATGC', 3):
    aa=Seq(''.join(codon)).translate()
    for a in bases:
        for i in range(3):
            newcodon=[codon[0],codon[1],codon[2]] #you cannot mutate a tuple!
            newcodon[i]=a
            if codon != newcodon:
                new=Seq(''.join(newcodon)).translate()
                if aa == new:
                    silent+=1
                elif new =='*':
                    nonsense+=1
                else:
                    nonsilent+=1
total=silent+nonsense+nonsilent
print('Silent: ',silent,silent/total)
print('Non-Silent: ',nonsilent,nonsilent/total)
print('Nonsense: ',nonsense,nonsense/total)