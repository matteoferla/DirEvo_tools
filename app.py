import os

from pyramid.paster import get_app
from pyramid.paster import get_appsettings

import pprint

pprinter = pprint.PrettyPrinter().pprint

if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    ip = '0.0.0.0'
    port = 8080
    if os.path.isdir("/opt/app-root/src/pyramidstarter/"):  # openshift specific relic
        os.chdir("/opt/app-root/src/")
    elif os.path.join(os.getcwd(), 'app.py') != __file__:  # generic weird location fixer...
        if os.path.split(__file__)[0]: # no idea why it would fail...
            os.chdir(os.path.split(__file__)[0])
    config = os.path.join(here, 'development.ini')
    #config = os.path.join(here, 'production.ini')

    print('Binding to {ip}:{port}'.format(ip=ip, port=port))
    app = get_app(config, 'main')  # find 'main' method in __init__.py.  That is our wsgi app
    settings = get_appsettings(config,
                               'main')  # don't really need this but is an example on how to get settings from the '.ini' files

    # did I change the C++ scripts? Let's recompile anyway!
    # No. run the update.sh script instead.
    # os.system('bash '+os.path.join(here,'pyramidstarter/bikeshed/compile.sh'))
    # print('C++ compiled')

    # Waitress
    from waitress import serve

    print("Starting Waitress.")
    print("working directory: ",os.getcwd())
    serve(app, host=ip, port=port, threads=50)
