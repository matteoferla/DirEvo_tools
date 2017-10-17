from pyramid.view import view_config, notfound_view_config
from pyramid.response import Response
import pyramidstarter.mutant_wrapper as wrap
import json, os, uuid, shutil
# import fcsparser
import smtplib
import markdown
import pprint
pprinter = pprint.PrettyPrinter().pprint


PATH = "/opt/app-root/src/pyramidstarter/"
PLACE = "server"
if not os.path.isdir(PATH):
    PATH = "pyramidstarter/"
    PLACE = "localhost"
GMAIL_USER = 'squidonius.tango@gmail.com'
GMAIL_PWD = '*******'
GMAIL_SET = False

def basedict():
    return {'project': 'Pyramidstarter',
            'main': '',
            'welcome': '',
            'm_home': 'not-active',
            'm_deep': 'not-active',
            'm_about': 'not-active',
            'm_QQC': 'not-active'}


############### Ajacean views #####################

@view_config(route_name='ajax_mutantprimers', renderer='json')
@view_config(route_name='ajax_deepscan', renderer='json')
def deepscanner(request):
    try:
        reply = wrap.DS(request.json_body)
        filename = os.path.join(PATH, 'tmp', '{0}.json'.format(uuid.uuid4()))
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

def save_file(fileball):
    input_file = fileball.file  # <class '_io.BufferedRandom'>
    new_filename='{0}.ab1'.format(uuid.uuid4())
    file_path=os.path.join(PATH, 'tmp', new_filename)
    temp_file_path = file_path + '~'
    input_file.seek(0)
    with open(temp_file_path, 'wb') as output_file:
        shutil.copyfileobj(input_file, output_file)
    os.rename(temp_file_path, file_path)
    return (new_filename,file_path)

@view_config(route_name='ajax_QQC', renderer='json')
def QQCer(request):
    data = {}
    try:
        if request.POST['file'] == 'demo':
            data = {'tainted_filename': 'N/A', 'stored_filename': '22c_demo.ab1',
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH, 'static',
                                     '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
        else:
            (new_filename, file_path) = save_file(request.POST['file'])
            data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
        reply = wrap.QQC(file_path=file_path, **data)
        log_passing(request, json.dumps(data))
        return {'message': str(reply)}
    except Exception as err:
        log_passing(request, json.dumps(data), status='fail ({e})'.format(e=err))
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       err)})}

@view_config(route_name='ajax_MC', renderer='json')
def MCer(request):
    data = {}
    try:
        if request.POST['file'] == 'demo':
            raise NotImplementedError
            data = {'tainted_filename': 'N/A', 'stored_filename': '22c_demo.ab1',
                    'location': request.POST['location'], 'scheme': request.POST['scheme']}
            file_path = os.path.join(PATH, 'static',
                                     '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
        else:
            (new_filename,file_path) = save_file(request.POST['file'])
            data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                    'sequence': request.POST['sequence']}
        reply = wrap.MC(file_path=file_path, **data)
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


@view_config(route_name='ajax_email', renderer='json')
def send_email(request):
    global GMAIL_PWD, GMAIL_USER
    reply = request.json_body
    subject = 'Comment from ' + reply['message']
    body = reply['name']
    recipient = 'matteo.ferla@gmail.com'
    addressee = recipient if type(recipient) is list else [recipient]
    # Prepare actual message
    message = """From: %s\nTo: %s\nSubject: %s\n\n%s
    """ % (GMAIL_USER, ", ".join(addressee), subject, body)
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.ehlo()
        server.starttls()
        server.login(GMAIL_USER, GMAIL_PWD)
        server.sendmail(GMAIL_USER, addressee, message)
        server.close()
        return json.dumps({'msg': 'successfully sent the mail'})
    except Exception as e:
        print(GMAIL_USER,GMAIL_PWD,str(e))
        return json.dumps({'msg': str(e)})


############### Main views #####################
barnames = 'm_home m_mutantcaller m_pedel m_driver m_deepscan m_mutantprimers m_glue m_QQC m_mutanalyst m_about m_misc'.split()


def set_navbar_state(name):  # this is uttterly unneccessary now. Old code.
    ddex = {i: '' for i in barnames}
    if name in barnames:
        ddex[name] = 'active'
    return ddex


@view_config(route_name='home', renderer='templates/frame.pt')
def home_callable(request):
    log_passing(request)
    return {'main': open(os.path.join(PATH, 'templates', 'main.pt')).read(),
            'codon_modal': open(os.path.join(PATH, 'templates', 'codon_modal.pt')).read(),
            'code': open(os.path.join(PATH, 'templates', 'main.js')).read(),
            'welcome': open(os.path.join(PATH, 'templates', 'welcome.pt')).read(), **set_navbar_state('m_home')}


@view_config(route_name='upcoming', renderer='templates/frame.pt')
def upcoming_callable(request):
    log_passing(request)
    if PLACE == "server":
        md = markdown.markdown(open(os.path.join('/'.join(PATH.split('/')[0:-1], 'README.md')), 'r').read())
    else:
        md = markdown.markdown(open('README.md').read())
        return {'main': md, 'codon_modal': '', 'code': '', 'welcome': '', **set_navbar_state('m_upcoming')}

@view_config(route_name='admin', renderer='templates/frame.pt')
def admin_callable(request):
    return {'main': open(os.path.join(PATH, 'templates', 'admin.pt')).read(),'code': open(os.path.join(PATH, 'templates', 'admin.js')).read()}

@view_config(route_name='set', renderer='json')
def set_callable(request):
    global GMAIL_SET, GMAIL_PWD
    if not GMAIL_SET:
        GMAIL_PWD=request.params['pwd']
        GMAIL_SET = True
        print('Password for gmail set')
        return 'Sucess'
    else:
        return 'Password already set.'

@view_config(route_name='main', renderer='templates/frame.pt')
def main_callable(request):
    log_passing(request)
    page = request.matchdict['page']
    return {'main': open(os.path.join(PATH, 'templates', page + '.pt')).read(),
            'codon_modal': open(os.path.join(PATH, 'templates', 'codon_modal.pt')).read(),
            'code': open(os.path.join(PATH, 'templates', page + '.js')).read(), 'welcome': '',
            **set_navbar_state('m_' + page)}


# request.params['key']


@notfound_view_config(renderer='templates/frame.pt')
def notfound_callable(request):
    request.response.status = 404
    log_passing(request)
    return {'main': open(os.path.join(PATH, 'templates', '404.pt')).read().format(address=request),
            'codon_modal': '',
            'code': ' ', 'welcome': '', **set_navbar_state('m_404')}


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


@view_config(route_name='log', renderer='templates/frame.pt')
def hello_there(request):
    log_passing(request)
    '''to find what city the users are from...
    http://ip-api.com/json/195.166.143.137
    {"as":"AS6871 PlusNet","city":"Sheffield","country":"United Kingdom","countryCode":"GB","isp":"PlusNet Technologies Ltd","lat":53.3844,"lon":-1.47298,"org":"Hyper platform dial pool","query":"195.166.143.137","region":"ENG","regionName":"England","status":"success","timezone":"Europe/London","zip":""}
    '''
    log = logging.getLogger('pyramidstarter').handlers[0].stream.getvalue()
    log_response = '<br/><table class="table table-condensed"><thead><tr><th>Time</th><th>Code</th><th>Address</th><th>Task</th><th>AJAX JSON</th><th>Status</th></tr></thead>' + \
                   '<tbody><tr>' + '</tr><tr>'.join(
        ['<td>' + '</td><td>'.join(line.split('\t')) + '</td>' for line in log.split('\n')]) + \
                   '</tr></tbody></table>'
    return {'main': log_response,
            'codon_modal': '',
            'code': ' ', **set_navbar_state('m_log', False)}


'''
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
    '''


############### Other #####################


@view_config(route_name='ajax_test', renderer='json')
def ajaxian(request):
    return {'message': '<div class="alert alert-success" role="alert">I got this back.</div>'}
