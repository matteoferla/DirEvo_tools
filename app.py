import os, pprint

from pyramid.paster import get_app
from pyramid.paster import get_appsettings




if __name__ == '__main__':
    here = os.path.dirname(os.path.abspath(__file__))
    if 'OPENSHIFT_APP_NAME' in os.environ:                                          #are we on OPENSHIFT 2?
        ip = os.environ['OPENSHIFT_PYTHON_IP']
        port = int(os.environ['OPENSHIFT_PYTHON_PORT'])
        config = os.path.join(here, 'production.ini')
    elif 'OPENSHIFT_BUILD_NAME' in os.environ:                                          #are we on OPENSHIFT 3?
        ip = '0.0.0.0' #other options that dont work are os.environ['HOME_SERVICE_HOST'] '127.0.0.1' os.environ['KUBERNETES_PORT_53_TCP_ADDR']
        #
        port = 8080
        config = os.path.join(here, 'production.ini')
    else:
        ip = '0.0.0.0'                                                              #localhost
        port = 6543
        config = os.path.join(here, 'development.ini')

    print('Binding to '+ip)
    app = get_app(config, 'main')                                                   #find 'main' method in __init__.py.  That is our wsgi app
    settings = get_appsettings(config, 'main')                                      #don't really need this but is an example on how to get settings from the '.ini' files

# Waitress (remember to include the waitress server in "install_requires" in the setup.py)
    from waitress import serve
    print("Starting Waitress.")
    serve(app, host=ip, port=port, threads=50)

# Cherrypy server (remember to include the cherrypy server in "install_requires" in the setup.py)
#     from cherrypy import wsgiserver
#     print("Starting Cherrypy Server on http://{0}:{1}".format(ip, port))
#     server = wsgiserver.CherryPyWSGIServer((ip, port), app, server_name='Server')
#     server.start()


#Simple Server
    # from wsgiref.simple_server import make_server
    # print("Starting Simple Server on http://{0}:{1}".format(ip, port))
    # server = make_server(ip, port, app)
    # server.serve_forever()

#Running 'production.ini' method manually.  I find this method the least compatible with Openshift since you can't
#easily start/stop/restart your app with the 'rhc' commands. Maybe somebody can suggest a better way :)

# #Don't forget to set the Host IP in 'production.ini'.  Use 8080 for the port for Openshift
# You will need to use the 'pre_build' action hook(pkill python) so it stops the existing running instance of the server on OS
# You also will have to set up another custom action hook so rhc app-restart, stop works.
# See Openshifts Origin User's Guide  ( I have not tried this yet)

#Method #1
    # print('Running pserve production.ini')
    # os.system("pserve production.ini &")

#Method #2
    #import subprocess
    #subprocess.Popen(['pserve', 'production.ini &'])
