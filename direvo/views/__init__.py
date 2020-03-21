from warnings import warn
import os, json
import urllib.request
import _thread as thread
import logging
import traceback

# debugprint=lambda *x: None
debugprint = print


#### Crash if offline.
try:
    urllib.request.urlopen('http://python.org/')
except OSError:
    warn('The server is running in OFFLINE mode as it cannot connect to the web.')
    FRAME = 'templates/frame_local.mako'  # offline!
    raise Exception('OFFLINE TESTING NOT SUPPORTED ANYMORE')


########## Settings

from ..utility import Fields, Settings

tmp = os.path.join(Settings.path, 'tmp')
if not os.path.exists(tmp):
    os.mkdir(tmp)


############### LOG! #####################

'''
import logging, io

log = logging.getLogger(__name__)
f = io.StringIO('This is the StringIO stream of the Log', '\n')
handler = logging.StreamHandler(f)
handler.setFormatter(logging.Formatter('%(asctime)s\t%(levelname)s\t%(message)s'))
log.addHandler(handler)
'''

if os.path.isfile('addressbook.csv'): # this really really ought to be a DB
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
        logging.getLogger('direvo').info(
            ip + '\t' + where + '\t' + req.upath_info + '\t' + extra + '\t' + status)
    except Exception as err:
        debugprint('MAJOR LOGGING ERROR: {}'.format(str(err)))
        debugprint(traceback.format_exc())
