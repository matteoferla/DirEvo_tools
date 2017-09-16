from pyramid.config import Configurator
from pyramid.session import SignedCookieSessionFactory


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(settings=settings)
    config.include('pyramid_chameleon')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    for route in 'deepscan mutanalyst misc admin about log QQC pedel driver glue mutantcaller ajax_test ajax_deepscan deepscan_IDT96 deepscan_IDT384 ajax_QQC ajax_pedel ajax_glue ajax_mutantcaller facs2excel ajax_facs ajax_codon personal original_mutanalyst mutantprimers ajax_mutantprimers ajax_email'.split():
        config.add_route(route,'/'+route)
    config.set_session_factory(SignedCookieSessionFactory('methionine'))
    config.scan()
    config_logging()
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