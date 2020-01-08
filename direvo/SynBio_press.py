#!/usr/bin/env python3
# -*- coding: utf-8 -*-
__description__ = \
    """
This small script generates Markov chain random text (called Lorem Ipsum, dissociated press, technobabble etc.).
See the readme of the GitHub or the docstrings of the methods.
Do note that the Entrez email address needs to be filled to be able to use the static method `fetch_abstracts`. 

NB. Written for python 3, not tested under 2.
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""
__license__ = "Cite me!"
__version__ = "1.0"


import sys, argparse, re, random, json
from collections import defaultdict, Counter
from Bio import Entrez

if sys.version_info[0] < 3:
    raise NotImplementedError("Oi, $%£$#head! This is a python3 script.\n")

############ Please edit accordingly #########
Entrez.email = "****@gmail.com"
##############################################

class Press:
    """
    Instantiation loads the data from the trained json file, while the bound method `.generate()` generates the text.
    """
    def __init__(self, trained='abstracts.json', data=None):
        if data:
            self._pdex = data
        else:
            with open(trained, 'r') as w:
                self._pdex = json.load(w)

    def generate(self, minimum=100, maximum=1000):
        """
        Generates the text and returns it.
        :param minimum: smallest number of words (it can get to a dead end.)
        :param maximum: the hard limit to number of words.
        :return: string
        """
        dlist = list(self._pdex.keys())
        story = [random.choices(dlist, weights=[float(sum(self._pdex[d].values())) for d in dlist])[0].capitalize()]
        for i in range(maximum):
            last = story[-1]
            if last in self._pdex:
                story.append(random.choices(list(self._pdex[last].keys()), weights=[float(i) for i in self._pdex[last].values()])[0])
            else:
                break
        if len(story) > minimum:
            return ' '.join(story).replace(' STOP', '.\n').replace('\n ','\n')
        else:
            return self.generate(minimum, maximum)

    @classmethod
    def make_trainer(cls, raw='abstracts.txt', trained='abstracts.json'):
        """
        Converts the file from the static method `.fetch_abstract(term)`, which fetched the abstracts, into a json.
        :param raw: the text file input
        :param trained: the json file output
        :return: a Press instance
        """
        text = open(raw).read()
        # d=re.findall('(\w+)',text)
        d = re.sub('[^\w\.]', ' ', text).replace('. ', ' STOP ').split()
        pdex = defaultdict(Counter)
        for i in range(1, len(d)):
            pdex[d[i - 1]].update([d[i]])
        with open(trained, 'w') as w:
            json.dump(pdex, w)
        self = cls(data=pdex)
        return self

    @staticmethod
    def fetch_abstracts(term):
        handle = Entrez.esearch(db="pubmed", term=term, retmax=10000)
        with open('abstracts.txt', 'w') as w:
            for id in Entrez.read(handle)["IdList"]:
                print(id)
                try:
                    w.write(Entrez.read(Entrez.efetch(db="pubmed", id=id, rettype="abstract"))['PubmedArticle'][0]['MedlineCitation']['Article']['Abstract'][
                                'AbstractText'][0])
                except Exception:
                    print(Exception)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__description__)
    parser.add_argument("-a","--abstract", help="the text file with the abstracts to train the Markov chain on")
    parser.add_argument("-m","--min", help="the minimum number of words",type=int, default=100)
    parser.add_argument("-M","--max", help="the minimum number of words",type=int, default=1000)
    parser.add_argument('--version', action='version', version=__version__)
    args = parser.parse_args()
    if args.abstract:
        story = Press.make_trainer(args.abstract).generate(args.min,args.max)
    else:
        story = Press().generate(args.min,args.max)
    print(story)