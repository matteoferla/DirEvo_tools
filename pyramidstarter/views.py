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
import psutil

import markdown
from pyramid.response import FileResponse
from pyramid.view import view_config, notfound_view_config

import pyramidstarter.calculations as calc
from pyramidstarter.epistasis import Epistatic

# import csv

# PLACE = "server"
# PLACE = "localhost"
PATH = 'pyramidstarter/'

# debugprint=lambda *x: None
debugprint = print

# formerly I set these variables each reboot using the route set. Now it is an external file.
GMAIL_USER = '??????@gmail.com'
GMAIL_PWD = '*******'
GMAIL_SET = False
if os.path.isfile('email_details.json'):
    globals().update(**json.load(open('email_details.json')))  # Dangerous... but I am lazy

print('reporting from views.py')

STATUS = 'upgradetemp'
FRAME = 'templates/frame.mako'

try:
    urllib.request.urlopen('http://python.org/')
except OSError:
    warn('The server is running in OFFLINE mode as it cannot connect to the web.')
    FRAME = 'templates/frame_local.mako'  # offline!
    raise Exception('OFFLINE TESTING NOT SUPPORTED ANYMORE')

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
        html = open(os.path.join(PATH, 'templates', 'landscape_results.mako')).read() \
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

def sanitize(inputstr): #from https://gist.github.com/dustyfresh/10d4e260499612c055f91f824ebd8a64
    sanitized = inputstr
    badstrings = [
        ';',
        '$',
        '&&',
        '../',
        '<',
        '>',
        '%3C',
        '%3E',
        '\'',
        '--',
        '1,2',
        '\x00',
        '`',
        '(',
        ')',
        'file://',
        'input://'
    ]
    for badstr in badstrings:
        if badstr in sanitized:
            sanitized = sanitized.replace(badstr, '')
    return sanitized


@view_config(route_name='ajax_email', renderer='json')
def send_email(request):
    global GMAIL_PWD, GMAIL_USER
    reply = request.json_body
    subject = 'Comment from ' + sanitize(reply['name'])
    ip, where = get_ip(request)
    body = sanitize(reply['message']+'\n'+ip+' '+where)
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

class Fields():
    # I think I need some methods... so better do this than a default dictionary
    terms={
        'load':('Mutational load','Average number of mutations per variant in the library. This can be per gene or per kb.'),
        'spectrum': ('Mutational spectrum','The distribution of mutation types (e.g. A to C)'),
        'bias': ('Mutational bias','Various metrics to assess the divergence from the ideal situation where a nucleotide position has equiprobably change of mutating into any of the other three.'),
        'rate':('Replicational mutational rate','The average number of <i>de novo</i> mutations per kb that happen during one PCR duplication cycle'),
        'transversion':('Transversions','This is a mutation where a purine (adenine, guanine),  becomes a pyrimidine (thymine/uracil, cytosine) or <i>vice versa</i>.'),
        'transition':('Transitions','This is a mutation where the class of nucleobase (purine or pyrimidine) is unchanged.'),
        'doubling':('Doubling number','Number of duplications during PCR, which differs from PCR cycle number'),
        'missense':('Missense mutation','A mutation that results in an amino acid change. These are good mutations for directed evolution.'),
        'nonsense':('Nonsense mutation','A mutation that results in a premature stop. These are bad mutations for directed evolution.'),
        'synonymous':('Synonymous mutation','A mutation that alters the codon into another that codes the same amino acid. one third of changes in a equiprobable scenario are synonymous.')
    }

    def term_helper(self, term, inner=None):
        if inner:
            return '<abbr data-toggle="tooltip" title="{t}">{i}</abbr>'.format(i=inner,t=self.terms[term][0]+': '+self.terms[term][1])
        else:
            return '<abbr data-toggle="tooltip" title="{t}">{i}</abbr>'.format(i=term, t=self.terms[term][0] + ': ' + self.terms[term][1])

    def __init__(self, **kwargs):
        #deal with status.
        self.status = STATUS
        if 'status' in kwargs:
            self.status = kwargs['status']
        if STATUS == 'normal' or STATUS == 'none' or not STATUS:
            self.status = None
        elif STATUS == 'beta':
            self.status_class='info'
            self.status_msg='This is still in beta. This version may be unstable.'
        elif STATUS == 'construction':
            self.status_class = 'warning'
            self.status_msg = 'Matteo is actively working with the server. It may go down at any time.'
        elif STATUS == 'red':
            self.status_class = 'danger'
            self.status_msg = 'Somebody pressed the forbidden link.'
        elif STATUS == 'upgradetemp':
            self.status_class = 'warning'
            self.status_msg = '<i class="fas fa-bat fa-spin"></i> Matteo just upgraded both Bootstrap and Font Awesome, and did a major change to the Mako templating so bugginess is a given.'

        else: #'custom' there will be status_msg and class in kwargs
            self.status_class='danger'
            self.status_msg=STATUS
        #write args
        for k in kwargs:
            setattr(self,k,kwargs[k])

    def __setattr__(self, key, value):
        self.__dict__[key] = value

    def __getattr__(self, item):
        if item in self.__dict__:
            return self.__dict__[item]
        else:
            return ''


@view_config(route_name='home', renderer=FRAME)
def home_callable(request):
    try:
        log_passing(request)
        return {'page': Fields(request=request, m_home='active', body='main.mako', code='main.js')}
    except Exception as err:
        debugprint(traceback.format_exc())
        return {'page': Fields(request=request, m_home='active', error=traceback.format_exc())}

@view_config(route_name='upcoming', renderer=FRAME)
def upcoming_callable(request):
    log_passing(request)
    return {'page': Fields(request=request, m_upcoming='active', body='upcoming.mako', md=markdown.markdown(open('readme.md').read()))}

@view_config(route_name='admin', renderer=FRAME, http_cache=0)
def admin_callable(request):
    # get machine usage data...
    pid = psutil.Process(os.getpid())
    data=dict(pid_cpu=pid.cpu_times().user,
                    tot_cpu=' '.join([str(x) + '%' for x in psutil.cpu_percent(percpu=True)]),
                    cpu=psutil.cpu_times(),
                    pid_mem=pid.memory_info()[0] / 2. ** 20,
                    virt=psutil.virtual_memory(),
                    swap=psutil.swap_memory())
    status='This area is not for users. Sorry.'
    if 'admin' in request.session and request.session['admin']:
        admin=True
    else:
        admin=False
    if 'password' in request.POST:
        if request.POST['password'] == 'norleucine':
            print('Granted')
            request.session['admin'] = True
            admin=True
            status = 'The password is right. How did you get this message?'
        else:
            print('wrong...{}'.format(request.POST['password']))
            status='禁 Warning: Password wrong!'
    if admin:
        return {'page': Fields(request=request, m_admin='active', body='admin.mako', code='admin.js', data=data)}
    else:
        return {'page': Fields(request=request, m_admin='active', body='forbidden.mako', code='forbidden.js', status='custom', status_msg=status, status_class='info')}

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
    if 'admin' in request.session and request.session['admin']:
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
        elif 'reset' in request.params:
            os.system('sudo sh update.sh;')
            return 'Resetting...'
        else:
            return 'Unknown command'
    else:
        return 'You need to be admin'



@view_config(route_name='main', renderer=FRAME)
def main_callable(request):
    try:
        debugprint('main called...')
        log_passing(request)
        page = request.matchdict['page']
        debugprint('for page ' + page)
        if os.path.isfile(os.path.join(PATH,'templates',page+'.mako')):
            if os.path.isfile(os.path.join(PATH,'templates',page+'.js')):
                code = page + '.js'
            else:
                code = ''
            return {'page': Fields(request=request, body=page+'.mako', code=code, codon_flag=True, **{'m_'+page: 'active'})}
        else:
            return {'page': Fields(request=request, m_404='active', status=True, status_msg='404 Error! File not found!', status_class='danger', error=page)}
    except Exception as err:
        debugprint(traceback.format_exc())
        return {'page': Fields(request=request, error=traceback.format_exc(),**{'m_'+page: 'active'})}


@notfound_view_config(renderer=FRAME)
def notfound_callable(request):
    request.response.status = 404
    if request.method == 'POST':
        details = str(request.POST)
    else:
        details=str(request.GET)
    log_passing(request, extra=details, status='404')
    return {'page': Fields(request=request, m_404='active', status=True, status_msg='404 Error! File not found!', status_class='danger',error=details)}


@view_config(route_name='log', renderer=FRAME)
def lumberjack(request):

    log_passing(request)
    if 'admin' in request.session and request.session['admin']:
        log = logging.getLogger('pyramidstarter').handlers[0].stream.getvalue()
        return {'page': Fields(request=request, m_log='active', body='log.mako', log=log)}
    else:
        return {'page': Fields(request=request, m_admin='active', body='forbidden.mako', code='forbidden.js', status='custom', status_msg='The log is admin only. Sorry', status_class='info')}


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

if os.path.isfile('addressbook.csv'):
    addressbook = {line.split(',')[0]: line.split(',')[1].replace('\n', '') for line in
                   open('addressbook.csv', 'r').readlines() if line.find(',') != -1}
    print(addressbook)
else:
    addressbook = {}


def whois(ip):
    if ip in addressbook:
        debugprint('seen before')
        return addressbook[ip]
    else:
        try:
            debugprint('retriving...')
            #id = {'city': 'nowhere', 'countryCode': 'neverland'}
            ip=ip.split()[-1] # just in case.
            try:
                id = json.load(urllib.request.urlopen('http://ip-api.com/json/{}'.format(ip)))
            except TypeError: #python not 3.6!
                id = json.loads(urllib.request.urlopen('http://ip-api.com/json/{}'.format(ip)).read().decode('utf-8'))
            if id['status'] == 'success':
                where = '{city} ({countryCode})'.format(**id)
            elif 'message' in id:
                where = id['message']
            else:
                raise Exception
            open('addressbook.csv', 'a').write('{ip},{where},\n'.format(ip=ip, where=where.replace(',', ' ')))
        except Exception as err:
            where = 'Error'
            debugprint(traceback.format_exc())
        return where

def log_passing(req, extra='—', status='—'):
    thread.start_new_thread(log_passing_para, (req, extra, status))

def get_ip(req):
    # pprinter(req.environ)
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
    return ip,where

def log_passing_para(req, extra, status):
    try:
        ip,where=get_ip(req)
        logging.getLogger('pyramidstarter').info(
            ip + '\t' + where + '\t' + req.upath_info + '\t' + extra + '\t' + status)
    except Exception as err:
        debugprint('MAJOR LOGGING ERROR: {}'.format(str(err)))
        debugprint(traceback.format_exc())


############### Other #####################
@view_config(route_name='status', renderer='string')
def pinger(request):
    return 'OK'

@view_config(route_name='robots')
def robots(request):
    txt = os.path.join("pyramidstarter", "static", "robots.txt")
    return FileResponse(txt, request=request)

@view_config(route_name="favicon")
def favicon_view(request):
    icon = os.path.join("pyramidstarter", "static", "favicon.ico")
    return FileResponse(icon, request=request)


########### TEMPORARILY HERE #######
@view_config(route_name='carlos', renderer='templates/Carlos.mako')
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


@view_config(route_name='epistasis', renderer='templates/epistasis.mako')
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
