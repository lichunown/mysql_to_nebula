from sqlschema.utils.util import clean_name
from sqlschema.ssparse.sql_parse import CreateSql


def _create_field_column_sql(column):
    if column.is_not_null:
        return f'\t{column.name} {column.ftype.flink} NOT NULL COMMENT {column.comment()}'
    else:
        return f'\t{column.name} {column.ftype.flink} NULL COMMENT {column.comment()}'


class FlinkGenerator(object):
    def __init__(self, mysql_creator: CreateSql):
        self.mysql_creator = mysql_creator
        self._with_context = {}

    def with_item(self, dict_res):
        self._with_context = dict_res
        return self

    def mysql_virtual(self, create_table_name):
        field_res = []
        for column in self.mysql_creator.columns:
            if column.type == 'FieldColumn':
                field_res.append(_create_field_column_sql(column))
            if column.type == 'PrimaryKeyColumn':
                field_res.append(f'\tPRIMARY KEY ({column.name}) NOT ENFORCED')
        field_res = ', \n'.join(field_res)

        with_context = self._with_context.copy()
        with_context.update({'table-name': clean_name(self.mysql_creator.name)})
        with_context = ', \n'.join([f"\t'{key}' = '{value}'" for key, value in with_context.items()])

        return f"CREATE TABLE IF NOT EXISTS {create_table_name}( \n{field_res} \n ) WITH ( \n{with_context} \n ); \n"  # noqa

    def nebula_edge_virtual(self, create_table_name, conn_label_name, tag_data_type='VARCHAR(64)'):

        field_res = []
        field_res.append(f'\t`sid` {tag_data_type}')
        field_res.append(f'\t`did` {tag_data_type}')
        field_res.append(f'\t`rid` BIGINT')

        for column in self.mysql_creator.columns:
            if column.type == 'FieldColumn':
                field_res.append(_create_field_column_sql(column))

        field_res = ', \n'.join(field_res)
        with_context = self._with_context.copy()
        with_context.update({'data-type': 'edge',
                             'src-id-index': '0',
                             'dst-id-index': '1',
                             'rank-id-index': '2',
                             'label-name': clean_name(conn_label_name)})

        with_context = ', \n'.join([f"\t'{key}' = '{value}'" for key, value in with_context.items()])

        return f"CREATE TABLE IF NOT EXISTS {create_table_name}( \n{field_res} \n ) WITH ( \n{with_context} \n ); \n"  # noqa

    def nebula_tag_virtual(self, create_table_name, conn_label_name, tag_data_type='VARCHAR(64)'):

        field_res = []
        field_res.append(f'\t`tag_id` {tag_data_type}')

        for column in self.mysql_creator.columns:
            if column.type == 'FieldColumn':
                field_res.append(_create_field_column_sql(column))

        field_res = ', \n'.join(field_res)
        with_context = self._with_context.copy()
        with_context.update({'data-type': 'vertex',
                             'label-name': clean_name(conn_label_name)})

        with_context = ', \n'.join([f"\t'{key}' = '{value}'" for key, value in with_context.items()])

        return f"CREATE TABLE IF NOT EXISTS {create_table_name}( \n{field_res} \n ) WITH ( \n{with_context} \n ); \n"  # noqa


if __name__ == '__main__':
    sqls = ''.join(open('../../examples/mysql_schema.sql', 'r', encoding='utf8').readlines())
    from sqlschema.ssparse.sql_parse import CreateSqlList
    create_sql_list = CreateSqlList(sqls)
    flink_generator = FlinkGenerator(create_sql_list[0])

    res = flink_generator.with_item({
        'connector': 'mysql-cdc',
        'hostname': '172.16.1.7',
        'port': '3306',
        'username': 'flink',
        'password': '1234567890',
        'database-name': 'koala',
    }).nebula_edge_virtual('t_user_info_nebula', 'user')


    # print(nebula_generator.create_edge('xx', 'user_id'))

