class Connector(object):
    def __init__(self, *args, **kwargs):
        self.args = args
        self.kwargs = kwargs

        self.conn = None
        self._cursor = None

        self.connect()

    def connect(self):
        self.conn = self._connect(*self.args, **self.kwargs)
        self._cursor = None

    @property
    def cursor(self):
        if self._cursor is None:
            self._cursor = self.conn.cursor()
        return self._cursor

    def _connect(self, *args, **kwargs):
        raise NotImplementedError

    def desc(self, table_name):
        raise NotImplementedError
