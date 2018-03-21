import json
import os
import pprint
import shutil
import smtplib
import traceback
import uuid

import urllib.request

import markdown
import pyramidstarter.calculations as calc
from pyramid.view import view_config, notfound_view_config
from warnings import warn

pprinter = pprint.PrettyPrinter().pprint

PATH = "/opt/app-root/src/pyramidstarter/"
PLACE = "server"
if not os.path.isdir(PATH):
    PATH = "pyramidstarter/"
    PLACE = "localhost"
GMAIL_USER = 'squidonius.tango@gmail.com'
GMAIL_PWD = '*******'
GMAIL_SET = False
STATUS = 'construction'

FRAME='templates/frame.pt'
try:
    import urllib.request
    urllib.request.urlopen('http://python.org/')
except OSError:
    warn('The server is running in OFFLINE mode as it cannot connect to the web.')
    FRAME='templates/frame_local.pt' #offline!


def basedict(**kwargs):
    return {'project': 'Pyramidstarter',
            'main': '',
            'welcome': '',
            'm_home': 'not-active',
            'm_deep': 'not-active',
            'm_about': 'not-active',
            'm_QQC': 'not-active'}

def talk_to_user():
    outer='''<div class="row" id="warning"><div class="col-md-8 col-md-offset-2">{note}</div></div>'''
    if STATUS == 'normal':
        return '<!-- all nominal -->'
    elif STATUS == 'construction':
        return outer.format(note='<div class="bs-callout bs-callout-warning"><h4>Warning</h4>Matteo is playing with the server. This version may be unstable.</div>')
    else:
        return '<!-- no warnings -->'


############### Ajacean views #####################

@view_config(route_name='ajax_mutantprimers', renderer='json')
@view_config(route_name='ajax_deepscan', renderer='json')
def deepscanner(request):
    try:
        reply = calc.DS(request.json_body)
        filename = os.path.join(PATH, 'tmp', '{0}.json'.format(uuid.uuid4()))
        open(filename, 'w').write(reply)
        request.session['DS'] = filename
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except Exception as err:
        warn(err)
        log_passing(request, str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       traceback.format_exc())})}


@view_config(route_name='deepscan_IDT96')
def IDT96(request):
    return calc.IDT(request, 96)


@view_config(route_name='deepscan_IDT384')
def IDT384(request):
    return calc.IDT(request, 384)


def save_file(fileball):
    input_file = fileball.file  # <class '_io.BufferedRandom'>
    new_filename = '{0}.ab1'.format(uuid.uuid4())
    file_path = os.path.join(PATH, 'tmp', new_filename)
    temp_file_path = file_path + '~'
    input_file.seek(0)
    with open(temp_file_path, 'wb') as output_file:
        shutil.copyfileobj(input_file, output_file)
    os.rename(temp_file_path, file_path)
    return (new_filename, file_path)


### file ajacean views
def file_ajacean(request, fun):
    data = {}
    try:
        (reply, data) = fun(request)
        log_passing(request, json.dumps(data))
        return {'message': str(reply)}
    except Exception as err:

        log_passing(request, json.dumps(data), status='fail ({e})'.format(e=err))
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       traceback.format_exc())})}


def QQC_inner(request):
    if request.POST['file'] == 'demo':
        data = {'tainted_filename': 'N/A', 'stored_filename': '22c_demo.ab1',
                'location': request.POST['location'], 'scheme': request.POST['scheme']}
        file_path = os.path.join(PATH, 'static',
                                 '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
    else:
        (new_filename, file_path) = save_file(request.POST['file'])
        data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                'location': request.POST['location'], 'scheme': request.POST['scheme']}
    return calc.QQC(file_path=file_path, **data), data


def MC_inner(request):
    if request.POST['file'] == 'demo':
        data = {'tainted_filename': 'N/A', 'stored_filename': 'demo_MC.ab1'}
        file_path = os.path.join(PATH, 'static',
                                 'demo_MC.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
    else:
        (new_filename, file_path) = save_file(request.POST['file'])
        data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename}
    data['sequence'] = request.POST['sequence']
    data['sigma'] = int(request.POST['sigma'])
    data['reverse'] = request.POST['reverse']
    return calc.MC(file_path=file_path, **data), data


@view_config(route_name='ajax_QQC', renderer='json')
def QQC_outer(request):
    return file_ajacean(request, QQC_inner)


@view_config(route_name='ajax_MC', renderer='json')
def MC_outer(request):
    return file_ajacean(request, MC_inner)


### standard ajacean views (dataType: JSON requests)
def std_ajacean(request, fun):
    try:
        reply = fun(request.json_body)
        log_passing(request, str(request.json_body))
        return {'message': str(reply)}
    except Exception as err:
        print(str(err))
        log_passing(request, extra=str(request.json_body), status='fail')
        return {
            'message': json.dumps({'data': '',
                                   'html': '<div class="alert alert-danger" role="alert"><span class="pycorpse"></span> Error.<br/>{0}</div><br/>'.format(
                                       traceback.format_exc())})}

@view_config(route_name='ajax_silico', renderer='json')
def silicator(request):
    return std_ajacean(request, calc.silico)

@view_config(route_name='ajax_pedel', renderer='json')
def pedeller(request):
    return std_ajacean(request, calc.pedel)

#raise Exception('JS variables differ from modules')

@view_config(route_name='ajax_pedelAA', renderer='json')
def aminopedeller(request):
    return std_ajacean(request, calc.pedelAA)

@view_config(route_name='ajax_codonAA', renderer='json')
def aminocodonist(request):
    return std_ajacean(request, calc.codonAA)

@view_config(route_name='ajax_glue', renderer='json')
def gluer(request):
    return std_ajacean(request, calc.glue)

@view_config(route_name='ajax_glueIT', renderer='json')
def gluerIT(request):
    return std_ajacean(request, calc.glueit)

@view_config(route_name='ajax_probably', renderer='json')
def probablier(request):
    return std_ajacean(request, calc.probably)


@view_config(route_name='ajax_codon', renderer='json')
def codonist(request):
    return std_ajacean(request, calc.codon)


@view_config(route_name='ajax_driver', renderer='json')
def driverist(request):
    return std_ajacean(request, calc.driver)


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
        print(GMAIL_USER, GMAIL_PWD, str(e))
        return json.dumps({'msg': str(e)})


@view_config(route_name='ajax_test', renderer='json')
def ajacean_test(request):
    return {'message': '<div class="alert alert-success" role="alert">I got this back.</div>'}


############### Main views #####################
barnames = 'm_home m_mutantcaller m_pedel m_driver m_deepscan m_mutantprimers m_glue m_QQC m_mutanalyst m_about m_misc m_silico m_probably'.split()


def ready_fields(thisbar, main=None, code_file=None, codon_flag=False, welcome_flag=False):
    ddex = {i: '' for i in barnames}
    if thisbar in barnames:
        ddex[thisbar] = 'active'
    ddex['headsup']=talk_to_user()
    if os.path.isfile(os.path.join(PATH, 'templates', main)): #it is a file name
        ddex['main'] = open(os.path.join(PATH, 'templates', main)).read()
    elif main: #it is a str itself.
        ddex['main'] = main
    else:
        ddex['main'] ='&nbsp;'
    ddex['codon_modal'] = open(os.path.join(PATH, 'templates', 'codon_modal.pt')).read() if codon_flag else '&nbsp;'
    ddex['welcome'] = open(os.path.join(PATH, 'templates', 'welcome.pt')).read() if welcome_flag else '&nbsp;'
    ddex['code'] = open(os.path.join(PATH, 'templates', code_file)).read() if code_file else '&nbsp;'
    return ddex


@view_config(route_name='home', renderer=FRAME)
def home_callable(request):
    log_passing(request)
    return ready_fields('m_home', 'main.pt', 'main.js', welcome_flag=False) #I was sick of the welcome flag.


@view_config(route_name='upcoming', renderer=FRAME)
def upcoming_callable(request):
    log_passing(request)
    if PLACE == "server":
        md = markdown.markdown(open(os.path.join(*PATH.split('/')[0:-1], 'README.md'), 'r').read())
    else:
        md = markdown.markdown(open('README.md').read())
        return ready_fields('m_upcoming', md, 'main.js')


@view_config(route_name='admin', renderer=FRAME)
def admin_callable(request):
    return ready_fields('m_admin', 'admin.pt', 'admin.js')


@view_config(route_name='set', renderer='json')
def set_callable(request):
    """
    For now the only setting changeable is /set?pwd=****
    :param request:
    :return:
    """
    global GMAIL_SET, GMAIL_PWD
    if not GMAIL_SET:
        GMAIL_PWD = request.params['pwd']
        GMAIL_SET = True
        print('Password for gmail set')
        return 'Sucess'
    else:
        return 'Password already set.'


@view_config(route_name='main', renderer=FRAME)
def main_callable(request):
    log_passing(request)
    page = request.matchdict['page']
    return ready_fields('m_'+page, page + '.pt', page + '.js',codon_flag=True)


@notfound_view_config(renderer=FRAME)
def notfound_callable(request):
    request.response.status = 404
    if request.method == 'POST':
        log_passing(request,extra=str(request.POST), status='404')
    else:
        log_passing(request, extra=str(request.GET), status='404')
    return ready_fields('m_404', open(os.path.join(PATH, 'templates', '404.pt')).read().format(address=request))

@view_config(route_name='log', renderer=FRAME)
def lumberjack(request):
    log_passing(request)
    '''to find what city the users are from...
    http://ip-api.com/json/xxx.xxx.xxx.xxx
    '''
    log = logging.getLogger('pyramidstarter').handlers[0].stream.getvalue()
    log_response = '<br/><table class="table table-condensed"><thead><tr><th>Time</th><th>Code</th><th>Address</th><th>Task</th><th>AJAX JSON</th><th>Status</th></tr></thead>' + \
                   '<tbody><tr>' + '</tr><tr>'.join(
        ['<td>' + '</td><td>'.join(line.split('\t')) + '</td>' for line in log.split('\n')]) + \
                   '</tr></tbody></table>'
    return ready_fields('m_log', log_response,None)

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

############### Other #####################
@view_config(route_name='status', renderer='string')
def pinger(request):
    return 'OK'


########### TEMPORARILY HERE #######
@view_config(route_name='carlos', renderer='templates/Carlos.pt')
def carlos(request): # serving static basically.
    return dict()

from pyramidstarter import VCF_mapper
@view_config(route_name='carlos_submit', renderer='json')
def carlos_submit(request):
    open('temp.gb','wb').write(request.POST['genbank'].value)
    open('vcf.csv', 'wb').write(request.POST['vcf'].value)
    notes=VCF_mapper.tabulator('temp.gb', 'vcf.csv', 'out.csv')
    return notes+open('out.csv','r').read().replace('\n','<br/>')