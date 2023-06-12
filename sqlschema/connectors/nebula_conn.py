from typing import List, Tuple

from nebula3.gclient.net import ConnectionPool
from nebula3.Config import Config


class NebulaConnector(object):

    def __init__(self, host_port_list: List[Tuple[str, int]], username, password, **kwargs):
        self.conn_pool = ConnectionPool()
        self.config = Config()
        self.username = username
        self.password = password

        self.conn_pool.init(host_port_list, self.config)
        self._default_session = None

    def get_session(self):
        return self.conn_pool.get_session(self.username, self.password)

    @property
    def default_session(self):
        if self._default_session is None:
            self._default_session = self.get_session()
        return self._default_session

    def execute(self, *args, **kwargs):
        return self.default_session.execute(*args, **kwargs)


if __name__ == '__main__':
    config = Config()
    config.max_connection_pool_size = 10
    connection_pool = ConnectionPool()
    connection_pool.init([('127.0.0.1', 9669)], config)

    conn = NebulaConnector([('127.0.0.1', 9669)], 'root', 'nebula')
