from pyramid.view import view_config, notfound_view_config
from pyramid.response import Response
import pyramidstarter.mutant_wrapper as wrap
import json, os, uuid, shutil
import fcsparser
import smtplib


if 'OPENSHIFT_APP_NAME' in os.environ or 'OPENSHIFT_BUILD_NAME' in os.environ: #openshift 2 and 3 savvy!
    PLACE = "server"
    PATH = "/opt/app-root/src/pyramidstarter/"
else:
    PLACE = "localhost"
    PATH = "pyramidstarter/"
print(PLACE)


def basedict():
    return {'project': 'Pyramidstarter',
            'main': '',
            'welcome': '',
            'm_home': 'not-active',
            'm_deep': 'not-active',
            'm_about': 'not-active',
            'm_QQC': 'not-active'}


############### LOG! #####################
import logging

'''
import logging, io

log = logging.getLogger(__name__)
f = io.StringIO('This is the StringIO stream of the Log', '\n')
handler = logging.StreamHandler(f)
handler.setFormatter(logging.Formatter('%(asctime)s\t%(levelname)s\t%(message)s'))
log.addHandler(handler)
'''


def log_passing(req, extra='—', status='—'):
    if "HTTP_X_FORWARDED_FOR" in req.environ:
        # Virtual host
        ip = req.environ["HTTP_X_FORWARDED_FOR"]
    elif "HTTP_HOST" in req.environ:
        # Non-virtualhost
        ip = req.environ["REMOTE_ADDR"]
    else:
        ip = '0.0.0.0'
    logging.getLogger('pyramidstarter').info(ip + '\t' + req.upath_info + '\t' + extra + '\t' + status)


@view_config(route_name='log', renderer='templates/final_log.pt')
def hello_there(request):
    log_passing(request)
    '''to find what city the users are from...
    http://ip-api.com/json/195.166.143.137
    {"as":"AS6871 PlusNet","city":"Sheffield","country":"United Kingdom","countryCode":"GB","isp":"PlusNet Technologies Ltd","lat":53.3844,"lon":-1.47298,"org":"Hyper platform dial pool","query":"195.166.143.137","region":"ENG","regionName":"England","status":"success","timezone":"Europe/London","zip":""}
    '''
    response = basedict()
    log = logging.getLogger('pyramidstarter').handlers[0].stream.getvalue()
    response[
        'main'] = '<br/><table class="table table-condensed"><thead><tr><th>Time</th><th>Code</th><th>Address</th><th>Task</th><th>AJAX JSON</th><th>Status</th></tr></thead><tbody><tr>' + '</tr><tr>'.join(
        ['<td>' + '</td><td>'.join(line.split('\t')) + '</td>' for line in log.split('\n')]) + '</tr></tbody></table>'
    return response

############### Main views #####################
@view_config(route_name='about', renderer='templates/final_about.pt')
@view_config(route_name='deepscan', renderer='templates/final_deepscan.pt')
@view_config(route_name='home', renderer='templates/final_main.pt')
@view_config(route_name='QQC', renderer='templates/final_QQC.pt')
@view_config(route_name='pedel', renderer='templates/final_pedel.pt')
@view_config(route_name='driver', renderer='templates/final_driver.pt')
@view_config(route_name='glue', renderer='templates/final_glue.pt')
@view_config(route_name='mutanalyst', renderer='templates/final_mutanalyst.pt')
@view_config(route_name='misc', renderer='templates/final_misc.pt')
@view_config(route_name='mutantcaller', renderer='templates/final_mutantcaller.pt')
@view_config(route_name='mutantprimers', renderer='templates/final_mutantprimers.pt')
# @view_config(route_name='facs2excel', renderer='templates/final_facs2excel.pt') #I am leaving this? It is harmless untill I get pandas going.
def my_view(request):
    # from pprint import PrettyPrinter
    # PrettyPrinter().pprint(request.__dict__)
    log_passing(request)
    #print(request.matched_route.name)
    return {'project': 'Pyramidstarter'}


############### Ajacean views #####################

@view_config(route_name='ajax_mutantprimers', renderer='json')
@view_config(route_name='ajax_deepscan', renderer='json')
def deepscanner(request):
    try:
        reply = wrap.DS(request.json_body)
        filename = os.path.join(PATH,'tmp', '{0}.json'.format(uuid.uuid4()))
        open(filename, 'w').write(reply)
        request.session['DS'] = filename
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except Exception as err:
        log_passing(request, str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}


@view_config(route_name='deepscan_IDT96')
def IDT96(request):
    return wrap.IDT(request, 96)


@view_config(route_name='deepscan_IDT384')
def IDT384(request):
    return wrap.IDT(request, 384)


@view_config(route_name='ajax_QQC', renderer='json')
def QQCer(request):
    data = {}
    try:
        if request.POST['file'] == 'demo':
            data = {'tainted_filename': 'N/A', 'stored_filename': '22c_demo.ab1',
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH,'static', '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
        else:
            input_file = request.POST['file'].file  # <class '_io.BufferedRandom'>
            new_filename = '{0}.ab1'.format(uuid.uuid4())
            data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH,'tmp', new_filename)
            temp_file_path = file_path + '~'
            input_file.seek(0)
            with open(temp_file_path, 'wb') as output_file:
                shutil.copyfileobj(input_file, output_file)
            os.rename(temp_file_path, file_path)
        reply = wrap.QQC(file_path=file_path, **data)
        log_passing(request, json.dumps(data))
        return {'message': str(reply)}
    except Exception as err:
        log_passing(request, json.dumps(data), status='fail ({e})'.format(e=err))
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}


@view_config(route_name='ajax_mutantcaller', renderer='json')
def mutantcaller(request):
    data = {}
    raise NotImplementedError
    try:
        if request.POST['file'] == 'demo':
            data = {'tainted_filename': 'N/A', 'stored_filename': '22c_demo.ab1',
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH,'static', '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
        else:
            input_file = request.POST['file'].file  # <class '_io.BufferedRandom'>
            new_filename = '{0}.ab1'.format(uuid.uuid4())
            data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH, 'tmp',new_filename)
            temp_file_path = file_path + '~'
            input_file.seek(0)
            with open(temp_file_path, 'wb') as output_file:
                shutil.copyfileobj(input_file, output_file)
            os.rename(temp_file_path, file_path)
        reply = wrap.QQC(file_path=file_path, **data)
        log_passing(request, json.dumps(data))
        return {'message': str(reply)}
    except Exception as err:
        log_passing(request, json.dumps(data), status='fail ({e})'.format(e=err))
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}


@view_config(route_name='ajax_pedel', renderer='json')
def pedeller(request):
    try:
        reply = wrap.pedel(request.json_body)
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except TypeError as err:
        print(str(err))
        log_passing(request, extra=str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}


@view_config(route_name='ajax_glue', renderer='json')
def gluer(request):  # copy paste of pedeller
    try:
        reply = wrap.glue(request.json_body)
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except TypeError as err:
        print('ERROR in glue: ', str(err))
        log_passing(request, extra=str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}


@view_config(route_name='ajax_facs', renderer='json')
def facser(request):  # temp here. DELETE SOON.
    data = {}
    input_file = request.POST['file'].file  # <class '_io.BufferedRandom'>
    new_filename = '{0}.ab1'.format(uuid.uuid4())
    data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename}
    file_path = os.path.join(PATH, 'tmp',new_filename)
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


@view_config(route_name='ajax_codon', renderer='json')
def codonist(request):  # copy paste of pedeller
    try:
        reply = wrap.codon(request.json_body)
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except TypeError as err:
        print('ERROR in codon: ', str(err))
        log_passing(request, extra=str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}

@view_config(route_name='ajax_email',renderer='json')
def send_email():
    subject=''
    body=''
    gmail_user = 'squidonius.tango@gmail.com'
    gmail_pwd = ''
    FROM = 'squidonius.tango@gmail.com'
    recipient = 'matteo.ferla@gmail.com'
    TO = recipient if type(recipient) is list else [recipient]
    SUBJECT = subject
    TEXT = body

    # Prepare actual message
    message = """From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (FROM, ", ".join(TO), SUBJECT, TEXT)
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.ehlo()
        server.starttls()
        server.login(gmail_user, gmail_pwd)
        server.sendmail(FROM, TO, message)
        server.close()
        return json.dumps({'msg': 'successfully sent the mail'})
    except Exception as e:
        return json.dumps({'msg': str(e)})



############### Other #####################

@view_config(route_name='admin')
def hello_world(request):
    log_passing(request)
    return Response('Hello world!')


@view_config(route_name='ajax_test', renderer='json')
def ajaxian(request):
    return {'message': '<div class="alert alert-success" role="alert">I got this back.</div>'}


@notfound_view_config(renderer='templates/final_404.pt')
def notfound(request):
    request.response.status = 404
    log_passing(request)
    return {'project': 'Pyramidstarter'}
