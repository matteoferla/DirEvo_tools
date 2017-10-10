print("You have looked in the code junk yard. Go away!")
exit()
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






    #####


    @view_config(route_name='ajax_facs', renderer='json')
    def facser(request):  # temp here. DELETE SOON.
        data = {}
        input_file = request.POST['file'].file  # <class '_io.BufferedRandom'>
        new_filename = '{0}.ab1'.format(uuid.uuid4())
        data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename}
        file_path = os.path.join(PATH, 'tmp', new_filename)
        temp_file_path = file_path + '~'
        input_file.seek(0)
        with open(temp_file_path, 'wb') as output_file:
            shutil.copyfileobj(input_file, output_file)
        os.rename(temp_file_path, file_path)
        meta, fcs = fcsparser.parse(file_path)
        reply = fcs.to_csv()
        return {'csv': str(reply)}
        # except Exception as err:
        #    log_passing(request, json.dumps(data), status='fail ({e})'.format(e=err))
        #    return {
        #        'message': json.dumps({'data': '',
        #                               'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
        #                                   err)})}

