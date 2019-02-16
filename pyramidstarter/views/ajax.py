############### Ajacean views #####################

import json
import os
import shutil
import smtplib
import traceback
import uuid
from itertools import product
from warnings import warn
from pyramid.view import view_config

import pyramidstarter.calculations as calc

from . import Settings, log_passing, debugprint, get_ip, Fields

######


@view_config(route_name='ajax_mutantprimers', renderer='json')
@view_config(route_name='ajax_deepscan', renderer='json')
def deepscanner(request):
    try:
        reply = calc.DS(request.json_body)
        filename = os.path.join(Settings.path, 'tmp', '{0}.json'.format(uuid.uuid4()))
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
    file_path = os.path.join(Settings.path, 'tmp', new_filename)
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
        file_path = os.path.join(Settings.path, 'static',
                                 '22c_demo.ab1')  # variable comes from loop. PyCharm is wrong is its warning.
    else:
        (new_filename, file_path) = save_file(request.POST['file'])
        data = {'tainted_filename': request.POST['file'].filename, 'stored_filename': new_filename,
                'location': request.POST['location'], 'scheme': request.POST['scheme']}
    return calc.QQC(file_path=file_path, **data), data


def MC_inner(request):
    if request.POST['file'] == 'demo':
        data = {'tainted_filename': 'N/A', 'stored_filename': 'demo_MC.ab1'}
        file_path = os.path.join(Settings.path, 'static',
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
        html = open(os.path.join(Settings.path, 'templates', 'landscape_results.mako')).read() \
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
    reply = request.json_body
    subject = 'Pedel2 comment from ' + sanitize(reply['name'])
    ip, where = get_ip(request)
    body = sanitize(reply['message'] + '\n' + '*'*10 + ip + ' ' + where)
    recipient = 'matteo.ferla@gmail.com'
    os.system('echo -m "{m}" | mail -s "{s}" {r}'.format(m=body, s=subject, r=recipient))

@view_config(route_name='ajax_test', renderer='json')
def ajacean_test(request):
    return {'message': '<div class="alert alert-success" role="alert">I got this back.</div>'}

