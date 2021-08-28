import logging


class CustomHandler(logging.StreamHandler):
    """Custom handler for logging algorithm."""

    def format(self, record):
        """Format the record with specific format."""
        fmt = '[testing-docker|%(levelname)s|%(asctime)s]: %(message)s'
        return logging.Formatter(fmt, datefmt='%Y-%m-%d %H:%M:%S').format(record)


# allocate logger object
logger = logging.getLogger(__name__)
logger.setLevel(1)
logger.addHandler(CustomHandler())
