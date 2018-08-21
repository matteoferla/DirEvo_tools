from pyramid.config import Configurator
from pyramid.session import SignedCookieSessionFactory


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.include('pyramid_chameleon')
    config.add_static_view('static', 'static', cache_max_age=3600)
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
                  'ajax_land']:
        config.add_route(route, '/' + route)
        # deepscan mutanalyst misc about QQC pedel driver glue mutantcaller mutantprimers no longer here
    config.add_route('main', '/main/{page}')
    config.set_session_factory(SignedCookieSessionFactory('methionine'))
    config.scan()
    config_logging()
    #### TEMP
    config.add_route('carlos', '/Carlos')
    config.add_route('carlos_submit', '/Carlos_submit')
    config.add_route('epistasis', '/epistasis')
    config.add_route('ajax_epistasis', '/ajax_epistasis')
    config.add_route('download_epistasis', '/download_epistasis')
    config.add_route('create_epistasis', '/create_epistasis')
    ####
    return config.make_wsgi_app()


def config_logging():
    import logging, io
    ##### original crap #######
    log_ini = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "simple": {
                "format": "%(asctime)s [%(levelname)-8s] %(name)s: %(message)s",
                "datefmt": "%Y-%m-%d %H:%M:%S"
            }
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "level": "DEBUG",
                "formatter": "simple",  # key name of our formatter
                "stream": None
            }
        },
        "loggers": {
            "": {
                "handlers": ["console"],  # ["console", "mail", "standard_file", "rotating_file", etc]
                "level": "DEBUG",
                "propagate": True
            }
        }
    }

    logging.config.dictConfig(log_ini)  # configure log

    ###### mine #######
    logging.captureWarnings(True)

    log = logging.getLogger(__name__)
    f = io.StringIO('This is the StringIO stream of the Log', '\n')
    handler = logging.StreamHandler(f)
    handler.setFormatter(logging.Formatter('%(asctime)s\t%(levelname)s\t%(message)s'))
    log.addHandler(handler)

    return
