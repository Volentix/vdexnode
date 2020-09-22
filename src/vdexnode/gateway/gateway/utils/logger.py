import os
import sys
import logging


def get_logger(name, level='DEBUG', logpath=None, logfile=os.path.basename(sys.argv[0])):
    level = getattr(logging, level.upper())
    logger = logging.getLogger(name)
    logger.propagate = False
    logger.setLevel(level)
    stdout_handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter(
            '%(asctime)s - %(name)s -%(filename)s[line:%(lineno)d] - %(levelname)s - %(message)s'
        )
    stdout_handler.setFormatter(formatter)
    logger.addHandler(stdout_handler)
    if logpath:
        logfile = os.path.basename(logfile)
        log_path = os.path.join(logpath, logfile + '.log')
        file_handler = logging.FileHandler(log_path)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
    return logger
