
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

            PLACE = "venv"
            print("This appears to be a VENV... but not OPENSHIFT?")
else:
    pprinter(dict(os.environ))

    config = os.path.join(here, 'development.ini')