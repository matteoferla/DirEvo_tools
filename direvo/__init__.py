from pyramid.config import Configurator
from pyramid.session import SignedCookieSessionFactory
from .log import config_logging


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.include('pyramid_mako')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_static_view('robots.txt', 'robots.txt')
    config.add_route('home', '/')
    for route in ['admin',
                  'set',
                  'upcoming',
                  'update',
                  'log',
                  'status',
                  'ajax_test',
                  'ajax_deepscan',
                  'deepscan_IDT96',
                  'deepscan_IDT384',
                  'landscape',
                  'ajax_QQC',
                  'ajax_pedel',
                  'ajax_glue',
                  'ajax_glueIT',
                  'ajax_MC',
                  'ajax_facs',
                  'ajax_codon',
                  'ajax_codonAA',
                  'ajax_silico',
                  'ajax_mutantprimers',
                  'ajax_email',
                  'ajax_pedelAA',
                  'ajax_driver',
                  'ajax_probably',
                  'ajax_land',
                  'glossary']:
        config.add_route(route, '/' + route)
        # deepscan mutanalyst misc about QQC pedel driver glue mutantcaller mutantprimers no longer here
    config.add_route('params', '/params')
    config.add_route('ajax_params', '/params/{mode}')
    config.add_route('main', '/main/{page}')
    config.add_route('favicon', '/favicon.ico')
    config.add_route('robots', '/robots.txt')
    config.set_session_factory(SignedCookieSessionFactory('methionine'))
    config.scan()
    config_logging()
    return config.make_wsgi_app()



