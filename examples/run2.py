from sqlschema.connectors import MysqlConnector, NebulaConnector
from sqlschema.fields.tablelike.table import TableList


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

# type 1
graphs = table.to_graph()
codes = graphs.code_new_space('jmt3', modify_mode='DROP_IF_EXIST')
codes += graphs.code_create_graph(with_backslash=False, modify_mode='ADD_IF_NOT_EXIST')
codes.save_to('./tmp.sql')

nebula_conn = NebulaConnector([('127.0.0.1', 9669)], 'root', 'nebula')
session = nebula_conn.get_session()
codes.execute_on_nebula(session)

# type 2

session = NebulaConnector([('127.0.0.1', 9669)], 'root', 'nebula').get_session()
session.execute('use jmt3;')
t_region = conn.use('koala').table('t_region')
t_region.set_tag('region', 'region_id', 'remain_all') \
     .set_edge('parent', 'region_id', 'parent_region_id',
               'remain_all',
               edge_indexes={'id': ['region_id']})
tables = TableList([t_region])
tables.to_graphs()\
      .code_create_graph(with_backslash=False, modify_mode='ADD_IF_NOT_EXIST')\
      .execute_on_nebula(session)
