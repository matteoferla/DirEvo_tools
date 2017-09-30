#!/usr/bin/env python
import os
import sys
from pyramid.paster import get_app


here = os.path.dirname(os.path.abspath(__file__))
pyramid_working_folder = os.path.basename(here).lower()
sys.path.insert(0, os.path.join(here, pyramid_working_folder))
config = os.path.join(here, 'production.ini')
application = get_app(config, 'main')