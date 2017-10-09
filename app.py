import os

from pyramid.paster import get_app
from pyramid.paster import get_appsettings

import pprint

pprinter = pprint.PrettyPrinter().pprint

if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    ip = '0.0.0.0'
    port = 8000
    if os.path.isdir("/opt/app-root/src/pyramidstarter/"):
        config = os.path.join(here, 'production.ini')
    else:
        config = os.path.join(here, 'production.ini')

    print('Binding to {ip}:{port}'.format(ip=ip, port=port))
    app = get_app(config, 'main')  # find 'main' method in __init__.py.  That is our wsgi app
    settings = get_appsettings(config,
                               'main')  # don't really need this but is an example on how to get settings from the '.ini' files

    # Waitress
    from waitress import serve

    print("Starting Waitress.")
    serve(app, host=ip, port=port, threads=50)