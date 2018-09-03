#!/usr/bin/env python3
# -*- coding: utf-8 -*-
__description__ = \
    """
So editing html is hard. This should make it better...
NB. Written for python 3, not tested under 2.
"""
__author__ = "Matteo Ferla. [Github](https://github.com/matteoferla)"
__email__ = "matteo.ferla@gmail.com"
__date__ = ""
__license__ = "Cite me!"
__version__ = "1.0"

import os


def parse_inwards(infile, outfile):
    for file in os.listdir('pyramidstarter/templates'):
        if file.find('.pt'):
            text=open(file).read()


if __name__ == "__main__":
    pass