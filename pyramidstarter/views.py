import json
import os
import pprint
import shutil
import smtplib
import traceback
import urllib.request
import uuid
import _thread as thread
from itertools import product
from warnings import warn

import markdown
from pyramid.response import FileResponse
from pyramid.view import view_config, notfound_view_config

import pyramidstarter.calculations as calc
from pyramidstarter.epistasis import Epistatic

# import csv

# PLACE = "server"
# PLACE = "localhost"
PATH = 'pyramidstarter/'

# debugprint=lambda x: None
debugprint = print

# formerly I set these variables each reboot using the route set. Now it is an external file.
GMAIL_USER = '??????@gmail.com'
GMAIL_PWD = '*******'
GMAIL_SET = False
if os.path.isfile('email_details.json'):
    globals().update(**json.load(open('email_details.json')))  # Dangerous... but I am lazy

print('reporting from views.py')

STATUS = 'construction'

FRAME = 'templates/frame.pt'
try:
    urllib.request.urlopen('http://python.org/')
except OSError:
    warn('The server is running in OFFLINE mode as it cannot connect to the web.')
    FRAME = 'templates/frame_local.pt'  # offline!


def basedict(**kwargs):
    return {'project': 'Pyramidstarter',
            'main': '',
            'welcome': '',
            'm_home': 'not-active',
            'm_deep': 'not-active',
            'm_about': 'not-active',
            'm_QQC': 'not-active',
            'm_landscape': 'not-active'}


def talk_to_user():
    outer = '''<div class="row" id="warning"><div class="col-md-8 col-md-offset-2">{note}</div></div>'''
    if STATUS == 'normal':
        return '<!-- all nominal -->'
    elif STATUS == 'beta':
        return outer.format(
            note='<div class="bs-callout bs-callout-info"><h4>Info</h4>This is still in beta. This version may be unstable.</div>')
    elif STATUS == 'construction':
        return outer.format(
            note='<div class="bs-callout bs-callout-warning"><h4>Warning</h4>Matteo is actively working with the server. It may go down at any time.</div>')
    elif STATUS == 'red':
        return outer.format(
            note='<div class="bs-callout bs-callout-danger"><h4>Danger</h4>Somebody pressed the forbidden link.</div>')
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


def save_file(fileball, ext='ab1'):
    input_file = fileball.file  # <class '_io.BufferedRandom'>
    new_filename = '{0}.{1}'.format(uuid.uuid4(), ext)
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


# raise Exception('JS variables differ from modules')

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


@view_config(route_name='ajax_land', renderer='json')
def lander(request):
    try:
        scores = []
        seqs = []  # checking!
        headers = []
        ways = []
        AAlphabet = 'A C D E F G H I K L M N P Q R S T V W Y'.split()
        if 'demo' in request.POST:  # JSON
            for file in ['unreact', 'intermediate', 'whole']:
                s, q = calc.pmut_renumber(
                    open('pyramidstarter/static/dog-{f}_scores.txt'.format(f=file), 'r').readlines())
                scores.append(s)
                seqs.append(q)
            headers = ['Substrate', 'Transition', 'Product']
            ways = ['-', '+', '+']
        else:  # FormData
            AAlphabet = request.POST['AAlphabet']
            if isinstance(AAlphabet, str):
                AAlphabet = AAlphabet.split()
            # print('N files...',int(request.POST['number_of_files']))
            for fi in range(int(request.POST['number_of_files'])):
                # print(fi,request.POST['file_'+str(fi)])
                file = request.POST['file_' + str(fi)].file
                data = []
                while 1:
                    line = file.readline()
                    if not line: break
                    data.append(line)
                s, q = calc.pmut_renumber(data)
                scores.append(s)
                seqs.append(q)
                ways.append(request.POST['way_' + str(fi)])
                headers.append(
                    str(request.POST['file_' + str(fi)].filename))  # hcange in future based on user submission
        # print(headers)
        table = '<div class="table-responsive"><table class="table table-striped"><thead class="thead-dark">{thead}</thead><tbody>{tbody}</tbody></table></div>'
        td = '<td>{}</td>'
        th = '<th>{}</th>'
        tr = '<tr>{}</tr>'
        # print(scores)
        made_table = table.format(
            thead=tr.format(''.join([th.format(x) for x in ['Residue ID', 'From residue', 'To residue'] + headers])),
            tbody=''.join(
                [tr.format(''.join(
                    [td.format(str(x)) for x in [round(i / 20 + 1),
                                                 seqs[0][round(i / 20) + 1],
                                                 AAlphabet[i % 20],
                                                 *[scores[j][round(i / 20) + 1][AAlphabet[i % 20]] for j in
                                                   range(len(scores))]
                                                 ]
                     ]))
                    for i in range(20 * len(scores[0]) - 20)]))

        def sc_norm(n):
            if n > 20:
                return 20
            elif n < -20:
                return -20
            else:
                return n

        # make basic heatplot data
        hxlabel = [seqs[0][i] + str(i) for i in range(1, len(seqs[0]) + 1)]
        hylabel = list(reversed(AAlphabet))
        hdata = [[[sc_norm(sc[resi][resn]) for resi in range(1, len(sc) + 1)] for resn in hylabel] for sc in scores]

        # make substraction
        pos = [i for i, w in enumerate(ways) if w == '+']
        neg = [i for i, w in enumerate(ways) if w == '-']
        if pos and neg:
            for pair in product(pos, neg):
                p = scores[pair[0]]
                n = scores[pair[1]]
                hdata.append(
                    [[sc_norm(p[resi][resn] - n[resi][resn]) for resi in range(1, len(p) + 1)] for resn in hylabel])
                headers.append(headers[pair[0]] + '&nbsp;&ndash;&nbsp;' + headers[pair[1]])

        opt = '<li class="fake-link" data-n={i} data-name={name}><span id="land_{plot}_option_{name}">{name}</span></li>'
        opt_seq = '<li role="separator" class="divider"></li>'
        html = open(os.path.join(PATH, 'templates', 'landscape_results.pt')).read() \
            .format(table=made_table,
                    heat_opt='\n'.join([opt.format(name=x, i=i, plot='heat') for i, x in enumerate(headers)]),
                    distro_opt='\n'.join([opt.format(name=x, i=i, plot='distro') for i, x in enumerate(headers)])
                    )
        return {'html': html, 'data': hdata, 'heat_data_ylabel': hylabel, 'heat_data_xlabel': hxlabel}
    except Exception as err:
        print('error', err)
        print(traceback.format_exc())
        return {'html': '<div class="alert alert-danger" role="alert">Error — server side:<br/>{e}</div>'.format(
            e=str(err))}


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
        # print(GMAIL_USER, GMAIL_PWD, str(e))
        return json.dumps({'msg': str(e)})


@view_config(route_name='ajax_test', renderer='json')
def ajacean_test(request):
    return {'message': '<div class="alert alert-success" role="alert">I got this back.</div>'}


############### Main views #####################
barnames = 'm_home m_mutantcaller m_pedel m_driver m_deepscan m_mutantprimers m_glue m_QQC m_mutanalyst m_about m_misc m_silico m_probably m_landscape'.split()


def ready_fields(thisbar, main=None, code_file=None, codon_flag=False, welcome_flag=False):
    ddex = {i: '' for i in barnames}
    if thisbar in barnames:
        ddex[thisbar] = 'active'
    ddex['headsup'] = talk_to_user()
    if os.path.isfile(os.path.join(PATH, 'templates', main)):  # it is a file name
        ddex['main'] = open(os.path.join(PATH, 'templates', main)).read()
    elif main:  # it is a str itself.
        ddex['main'] = main
    else:
        ddex['main'] = '&nbsp;'
    ddex['codon_modal'] = open(os.path.join(PATH, 'templates', 'codon_modal.pt')).read() if codon_flag else '&nbsp;'
    ddex['welcome'] = open(os.path.join(PATH, 'templates', 'welcome.pt')).read() if welcome_flag else '&nbsp;'
    ddex['code'] = open(os.path.join(PATH, 'templates', code_file)).read() if code_file else '&nbsp;'
    return ddex


@view_config(route_name='home', renderer=FRAME)
def home_callable(request):
    try:
        log_passing(request)
        return ready_fields('m_home', 'main.pt', 'main.js', welcome_flag=False)  # I was sick of the welcome flag.
    except Exception:
        return 'SOMETHING IS WRONG.'


@view_config(route_name='upcoming', renderer=FRAME)
def upcoming_callable(request):
    log_passing(request)
    md = markdown.markdown(open('readme.md').read())
    wrap = '<div class="row" id="§upcoming"><div class="col-lg-8  col-lg-offset-2"><div class="panel panel-default"><div class="panel-heading"><h1 class="panel-title">Upcoming</h1></div><div class="panel-body">{}</div></div></div></div>'
    return ready_fields('m_upcoming', wrap.format(md), 'main.js')


@view_config(route_name='admin', renderer=FRAME)
def admin_callable(request):
    return ready_fields('m_admin', 'admin.pt', 'admin.js')


@view_config(route_name='update', renderer='string')
def update_callable(request):
    if 'GitHub - Hookshot' in request.environ['HTTP_USER_AGENT']:
        os.system('sh update.sh')
        return 'OK'
    else:
        return 'Not Github webhook'


@view_config(route_name='set', renderer='json')
def set_callable(request):
    """
    For now the only setting changeable is /set?pwd=**** and /set?status=construction
    :param request:
    :return:
    """

    if 'pwd' in request.params:
        global GMAIL_SET, GMAIL_PWD
        if not GMAIL_SET:
            GMAIL_PWD = request.params['pwd']
            GMAIL_SET = True
            print('Password for gmail set')
            return 'Sucess'
        else:
            return 'Password already set.'
    elif 'status' in request.params:
        global STATUS
        STATUS = request.params['status']
        debugprint(STATUS)
        return 'Sucess'


@view_config(route_name='main', renderer=FRAME)
def main_callable(request):
    try:
        debugprint('main called...')
        log_passing(request)
        page = request.matchdict['page']
        debugprint('for page ' + page)
        return ready_fields('m_' + page, page + '.pt', page + '.js', codon_flag=True)
    except Exception as err:
        debugprint('error', err)
        debugprint(traceback.format_exc())
        return {'html': 'ERROR'}


@notfound_view_config(renderer=FRAME)
def notfound_callable(request):
    request.response.status = 404
    if request.method == 'POST':
        log_passing(request, extra=str(request.POST), status='404')
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
    log_response = '<div class="alert alert-success" role="alert"><a href="static/bash_log.txt">download terminal log</a></div>' + \
                   '<br/><table class="table table-condensed"><thead><tr><th>Time</th><th>Code</th><th>IP Address</th><th>Physical address</th><th>Task</th><th>AJAX JSON</th><th>Status</th></tr></thead>' + \
                   '<tbody><tr>' + '</tr><tr>'.join(
        ['<td>' + '</td><td>'.join(line.split('\t')) + '</td>' for line in log.split('\n')]) + \
                   '</tr></tbody></table>'
    return ready_fields('m_log', log_response, None)


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

addressbook = {line.split(',')[0]: line.split(',')[1].replace('\n', '') for line in
               open('addressbook.csv', 'r').readlines() if line.find(',') != -1}
print(addressbook)


def whois(ip):
    if ip in addressbook:
        debugprint('seen before')
        return addressbook[ip]
    else:
        try:
            debugprint('retriving...')
            #id = {'city': 'nowhere', 'countryCode': 'neverland'}
            ip=ip.split()[-1] # just in case.
            id=json.load(urllib.request.urlopen('http://ip-api.com/json/{}'.format(ip))) #.read().decode('utf-8')
            where = '{city} ({countryCode})'.format(**id)
            open('addressbook.csv', 'a').write('{ip},{where},\n'.format(ip=ip, where=where.replace(',', ' ')))
        except Exception:
            where = 'Error'
        return where

def log_passing(req, extra='—', status='—'):
    thread.start_new_thread(log_passing_para, (req, extra, status))

def log_passing_para(req, extra, status):
    try:
        #pprinter(req.environ)
        if "HTTP_X_FORWARDED_FOR" in req.environ:
            # Virtual host
            ip = req.environ["HTTP_X_FORWARDED_FOR"]
        elif "HTTP_HOST" in req.environ:
            # Non-virtualhost
            ip = req.environ["REMOTE_ADDR"]  # 192.168.0.99 the pi apache
        else:
            ip = '0.0.0.0'
        # print(ip)
        debugprint('ip is ' + ip)
        where = whois(ip)
        logging.getLogger('pyramidstarter').info(
            ip + '\t' + where + '\t' + req.upath_info + '\t' + extra + '\t' + status)
    except Exception as err:
        debugprint('MAJOR LOGGING ERROR: {}'.format(str(err)))
        debugprint(traceback.format_exc())


############### Other #####################
@view_config(route_name='status', renderer='string')
def pinger(request):
    return 'OK'


########### TEMPORARILY HERE #######
@view_config(route_name='carlos', renderer='templates/Carlos.pt')
def carlos(request):  # serving static basically.
    return dict()


from pyramidstarter import VCF_mapper


@view_config(route_name='carlos_submit')
def carlos_submit(request):
    open('temp.gb', 'wb').write(request.POST['genbank'].value)
    open('vcf.csv', 'wb').write(request.POST['vcf'].value)
    notes = VCF_mapper.tabulator('temp.gb', 'vcf.csv', 'out.csv')
    response = FileResponse(
        'out.csv',
        request=request,
        content_type='text/csv'
    )
    return response


@view_config(route_name='epistasis', renderer='templates/epistasis.pt')
def epi(request):  # serving static basically.
    return {'code': open(os.path.join(PATH, 'templates', 'epistasis.js')).read()}


@view_config(route_name='ajax_epistasis', renderer='json')
def epier(request):
    try:
        if 'file' not in request.POST:  # JSON
            data = epier_table(request.json_body)
        else:  # FormData
            data = epier_file(request)
        filename = os.path.join(PATH, 'tmp', '{0}.{1}'.format(uuid.uuid4(), '.xlsx'))
        data.save(filename)
        request.session['epistasis'] = filename
        suppinfo = ["Combinations", "Experimental average", "Experimental standard deviation", "Theoretical average",
                    "Theoretical standard deviation", "Exp.avg - Theor.avg", "Epistasis type"]
        raw = {'theoretical': {'data': data.all_of_it.tolist(), 'columns': data.mutations_list + suppinfo,
                               'rows': data.comb_index},
               'empirical': {'data': data.foundment_values.tolist(),
                             'columns': data.mutations_list + ["Average", "Standard deviation"],
                             'rows': data.mutant_list}}

        table = '<div class="table-responsive"><table class="table table-striped"><thead class="thead-dark">{thead}</thead><tbody>{tbody}</tbody></table></div>'
        td = '<td>{}</td>'
        th = '<th>{}</th>'
        tr = '<tr>{}</tr>'
        theo = table.format(thead=tr.format(''.join([th.format(x) for x in [''] + data.mutations_list + suppinfo])),
                            tbody=''.join([tr.format(th.format(data.comb_index[i] + ''.join(
                                [td.format(x) if isinstance(x, str) or isinstance(x, tuple) else td.format(round(x, 1))
                                 for
                                 x in data.all_of_it[i]]))) for i in range(len(data.comb_index))]))
        emp = table.format(thead=tr.format(
            ''.join([th.format(x) for x in [''] + data.mutations_list + ["Average", "Standard deviation"]])),
            tbody=''.join([tr.format(th.format(data.mutant_list[i] + ''.join(
                [td.format(x) if isinstance(x, str) or isinstance(x, tuple) else td.format(round(x, 1)) for x
                 in data.foundment_values[i]]))) for i in range(len(data.mutant_list))]))
        tabs = '<ul class="nav nav-tabs" id="myTab" role="tablist"><li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#{set}-table" role="tab">Table</a></li><li class="nav-item"><a class="nav-link" data-toggle="tab" href="#{set}-graph" role="tab">Graph</a></li></ul><br/>'
        tabcont = '<div class="tab-content"><div class="tab-pane fade show active" id="{set}-table" role="tabpanel">{table}</div><div class="tab-pane fade" id="{set}-graph" role="tabpanel">{graph}</div></div>'
        graph = '<div id="{0}-graph-plot"><p>{1}</p><button type="button" class="btn btn-success" id="{0}-down"><i class="fa fa-download" style="margin-left:20px;"></i>Download</button></div>'
        html = '{down}<br/><h3>Theoretical</h3>{theonav}{theotab}<h3>Empirical</h3>{empnav}{emptab}'.format(
            down='<a class="btn btn-primary" href="/download_epistasis" download="epistasis_results.xlsx">Download</a>',
            theotab=tabcont.format(set='theo', table=theo, graph=graph.format('theo',
                                                                              'Plot of the combinations of mutations. Note that the circles can be dragged, which is useful when the lines criss-cross under a circle.')),
            theonav=tabs.format(set='theo'),
            emptab=tabcont.format(set='emp', table=emp, graph=graph.format('emp',
                                                                           'Graph of the powerset of combinations mutants with circle width correlated to intensity.')),
            empnav=tabs.format(set='emp')
        )

        return {'html': html, 'raw': raw}
    except Exception as err:
        print('*' * 10 + ' ERROR ' + '*' * 10)
        print('error', err)
        print(traceback.format_exc())
        print('*' * 10 + ' ERROR ' + '*' * 10)
        return {'html': 'ERROR: ' + str(err)}


def epier_table(jsonreq):
    return Epistatic(**jsonreq).calculate()


def epier_file(request):
    (new_filename, file_path) = save_file(request.POST['file'], 'xlsx')
    return Epistatic.from_file(request.POST['your_study'], file_path).calculate()


@view_config(route_name='download_epistasis')
def down_epi(request):
    file = request.session['epistasis']
    response = FileResponse(
        file,
        request=request,
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    return response


@view_config(route_name='create_epistasis')
def create_epi(request):
    file = os.path.join(PATH, 'tmp', '{0}.{1}'.format(uuid.uuid4(), '.xlsx'))
    Epistatic.create_input_scheme(your_study='C', mutation_number=request.params['mutation_number'],
                                  replicate_number=request.params['replicate_number'], outfile=file)
    response = FileResponse(
        file,
        request=request,
        content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    )
    return response
