import os
import psutil
import markdown
import logging
import traceback
from pyramid.view import view_config, notfound_view_config
from pyramidstarter.SynBio_press import Press

from . import Settings, log_passing, debugprint, Fields

############### Main views #####################


@view_config(route_name='home', renderer=Settings.frame)
def home_callable(request):
    try:
        log_passing(request)
        return {'page': Fields(request=request, m_home='active', body='main.mako', code='main.js')}
    except Exception as err:
        debugprint(traceback.format_exc())
        return {'page': Fields(request=request, m_home='active', error=traceback.format_exc())}

@view_config(route_name='upcoming', renderer=Settings.frame)
def upcoming_callable(request):
    log_passing(request)
    return {'page': Fields(request=request, m_upcoming='active', body='upcoming.mako', md=markdown.markdown(open('todo.md').read()))}

@view_config(route_name='admin', renderer=Settings.frame, http_cache=0)
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
            if not Settings.gmail_set:
                Settings.gmail_pwd = request.params['pwd']
                Settings.gmail_set = True
                print('Password for gmail set')
                return 'Sucess'
            else:
                return 'Password already set.'
        elif 'status' in request.params:
            Settings.status = request.params['status']
            debugprint(Settings.status)
            return 'Sucess'
        elif 'reset' in request.params:
            os.system('sudo sh update.sh;')
            return 'Resetting...'
        elif 'clear' in request.params:
            os.remove(os.path.join(Settings.path,'tmp','*'))
        else:
            return 'Unknown command'
    else:
        return 'You need to be admin'



@view_config(route_name='main', renderer=Settings.frame)
def main_callable(request):
    try:
        debugprint('main called...')
        log_passing(request)
        page = request.matchdict['page']
        pager = Fields(request=request, codon_flag=True, **{'m_'+page: 'active'})
        debugprint('for page ' + page)

        if os.path.isfile(os.path.join(Settings.path,'templates',page+'.mako')):
            pager.body = page+'.mako'
            if os.path.isfile(os.path.join(Settings.path,'templates',page+'.js')):
                pager.code = page + '.js'
            pager.requirements=['plotly']
            if os.path.isfile(os.path.join(Settings.path,'templates',page+'_tour.js')):
                pager.tour=page+'_tour.js'
                pager.requirements.append('tour')
            if os.path.isfile(os.path.join(Settings.path,'templates',page+'_overview.mako')):
                pager.overview=page+'_overview.mako'
            if os.path.isfile(os.path.join(Settings.path,'templates',page+'_next.mako')):
                pager.avanti=page+'_next.mako'
            if 'admin' in request.session:
                pager.admin = True
            if page in ('QQC','planner'):
                pager.requirements.append('math')
            if page == 'press':
                pager.garbage=Press(os.path.join(Settings.path,'abstracts.json')).generate(200,5000)
            return {'page': pager}
        else:
            return {'page': Fields(request=request, m_404='active', status=True, status_msg='404 Error! File not found!', status_class='danger', error=page)}
    except Exception as err:
        debugprint(traceback.format_exc())
        return {'page': Fields(request=request, error=traceback.format_exc(),**{'m_'+page: 'active'})}


@notfound_view_config(renderer=Settings.frame)
def notfound_callable(request):
    request.response.status = 404
    if request.method == 'POST':
        details = str(request.POST)
    else:
        details=str(request.GET)
    log_passing(request, extra=details, status='404')
    return {'page': Fields(request=request, m_404='active', status=True, status_msg='404 Error! File not found!', status_class='danger',error=details)}


@view_config(route_name='log', renderer=Settings.frame)
def lumberjack(request):

    log_passing(request)
    if 'admin' in request.session and request.session['admin']:
        log = logging.getLogger('pyramidstarter').handlers[0].stream.getvalue()
        return {'page': Fields(request=request, m_log='active', body='log.mako', log=log)}
    else:
        return {'page': Fields(request=request, m_admin='active', body='forbidden.mako', code='forbidden.js', status='custom', status_msg='The log is admin only. Sorry', status_class='info')}

