from pyramid.config import Configurator


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """

    config_logging()
    config = Configurator(settings=settings)
    config.include('pyramid_chameleon')
    config.add_static_view('static', 'static', cache_max_age=3600)
    config.add_route('home', '/')
    config.add_route('deepscan', '/deepscan')
    config.add_route('admin','/admin')
    config.add_route('about', '/about')
    config.add_route('log','/log')
    config.add_route('ajax_test', '/ajax_test')
    config.add_route('ajax_deepscan', '/ajax_deepscan')
    config.scan()
    return config.make_wsgi_app()

def config_logging():
    import logging.config

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

    return





