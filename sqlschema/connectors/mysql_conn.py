from sqlschema.connectors.base import Connector
import mysql.connector as conn

import dataclasses


@dataclasses.dataclass
class TableColumnOriginType:
    TABLE_CATALOG: str
    TABLE_SCHEMA: str
    TABLE_NAME: str
    COLUMN_NAME: str
    ORDINAL_POSITION: int
    COLUMN_DEFAULT: str
    IS_NULLABLE: str
    DATA_TYPE: str
    CHARACTER_MAXIMUM_LENGTH: int
    CHARACTER_OCTET_LENGTH: int
    NUMERIC_PRECISION: int
    NUMERIC_SCALE: int
    DATETIME_PRECISION: int
    CHARACTER_SET_NAME: str
    COLLATION_NAME: str
    COLUMN_TYPE: str
    COLUMN_KEY: str
    EXTRA: str
    PRIVILEGES: str
    COLUMN_COMMENT: str
    GENERATION_EXPRESSION: str


@dataclasses.dataclass
class TableIndexOriginType:
    Table: str
    Non_unique: int
    Key_name: str
    Seq_in_index: int
    Column_name: str
    Collation: str
    Cardinality: int
    Sub_part: int
    Packed: str
    Null: str
    Index_type: str
    Comment: str
    Index_comment: str


class MysqlConnector(Connector):

    def _connect(self, host, port, username, password, **kwargs):
        return conn.connect(host=host, port=port, username=username,
                            password=password, **kwargs)

    def use(self, database_name):
        self._database_name = database_name
        self.cursor.execute(f'use {database_name};')
        return self

    def show_tables(self):
        self.cursor.execute('show tables;')
        return [i for item in self.cursor.fetchall() for i in item]

    def table_info(self, table_name):
        TABLE_SCHEMA_WHERE = ''
        if self._database_name is not None:
            TABLE_SCHEMA_WHERE = f'and TABLE_SCHEMA="{self._database_name}"'
        self.cursor.execute('select * from INFORMATION_SCHEMA.COLUMNS '
                            f'where TABLE_NAME="{table_name}" {TABLE_SCHEMA_WHERE};')
        data = self.cursor.fetchall()
        return [TableColumnOriginType(*item) for item in data]

    def index_info(self, table_name):
        self.cursor.execute(f'show index from {table_name};')
        data = self.cursor.fetchall()
        return [TableIndexOriginType(*item) for item in data]

    def table(self, table_name):
        from sqlschema.fields.tablelike.table import TableInfo
        return TableInfo.from_sql_connect(table_name,
                                          self.table_info(table_name),
                                          self.index_info(table_name))


if __name__ == '__main__':
    conn = MysqlConnector(
        host="localhost",
        port=3306,
        username='flink',
        password='1234567890',
    )
    data = conn.use('koala').table_info('t_region')
    data2 = conn.use('koala').index_info('t_region')

    table = conn.use('koala').table('t_region')
    table.set_tag('region', 'region_id', 'remain_all') \
        .set_edge('parent', 'region_id', 'parent_region_id',
                  'remain_all',
                  edge_indexes={'id': ['region_id']})
    table.to_xml('tmp.xml')

    # mydb = conn.connect(
    #     host="localhost",
    #     port=3306,
    #     username='flink',
    #     password='1234567890',
    # )
    # cursor = mydb.cursor()
    # cursor.execute('use koala;')
    #
    # cursor.execute('show tables;')
    # data = cursor.fetchall()
    # cursor.execute('describe t_region;')
    # data = cursor.fetchall()
    #
    # cursor.execute('select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME="t_region";')
    # data = cursor.fetchall()