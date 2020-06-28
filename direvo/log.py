import logging, io

def config_logging():
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