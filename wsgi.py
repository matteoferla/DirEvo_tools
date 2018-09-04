#!/usr/bin/env python3
import os
import sys
from pyramid.paster import get_app

here = os.path.dirname(os.path.abspath(__file__))
if os.path.join(os.getcwd(), 'wsgi.py') != __file__:  # generic weird location fixer...
        if os.path.split(__file__)[0]: # no idea why it would fail...
            os.chdir(os.path.split(__file__)[0])
pyramid_working_folder = os.path.basename(here).lower()
sys.path.insert(0, os.path.join(here, pyramid_working_folder))
config = os.path.join(here, 'production.ini')
application = get_app(config, 'main')