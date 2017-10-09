import os

from pyramid.paster import get_app
from pyramid.paster import get_appsettings

import pprint

pprinter = pprint.PrettyPrinter().pprint

if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    global PLACE
    global PATH
    if 'OPENSHIFT_APP_NAME' in os.environ:  # are we on OPENSHIFT 2?
        ip = os.environ['OPENSHIFT_PYTHON_IP']
        port = int(os.environ['OPENSHIFT_PYTHON_PORT'])
        config = os.path.join(here, 'production.ini')
        PLACE = "server"
        PATH = "/opt/app-root/src/pyramidstarter/"
    elif 'OPENSHIFT_BUILD_NAME' in os.environ or 'HOSTNAME' in os.environ:  # are we on OPENSHIFT 3 or in docker?
        ip = '0.0.0.0'
        port = 8000
        config = os.path.join(here, 'production.ini')
        PLACE = "localhost"
        PATH = "pyramidstarter/"
        if not os.path.isdir(PATH):
            if not os.path.isdir(PATH):
                print("I have no idea where I am.")
                print("pwd ", os.getcwd())
                pprinter(dict(os.environ))
                raise FileExistsError
            else:
                PATH = "/opt/app-root/src/pyramidstarter/"
                PLACE = "venv"
                print("This appears to be a VENV... but not OPENSHIFT?")
    else:
        pprinter(dict(os.environ))
        ip = '0.0.0.0'  # localhost
        port = 8000
        config = os.path.join(here, 'development.ini')

    print('Binding to {ip}:{port}'.format(ip=ip, port=port))
    app = get_app(config, 'main')  # find 'main' method in __init__.py.  That is our wsgi app
    settings = get_appsettings(config,
                               'main')  # don't really need this but is an example on how to get settings from the '.ini' files

    # Waitress
    from waitress import serve

    print("Starting Waitress.")
    serve(app, host=ip, port=port, threads=50)