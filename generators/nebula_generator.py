from utils.util import clean_name
from sql_parse import CreateSql


def _create_field_column_sql(column):
    if column.is_not_null:
        return f'{column.name} {column.ftype.nebula} NOT NULL COMMENT {column.comment()}'
    else:
        return f'{column.name} {column.ftype.nebula} DEFAULT {column.default} COMMENT {column.comment()}'


def _create_index_column_sql(dtype, column, edge_name):
    index_names = ', '.join(column.index_fields)
    t_tag_name = '_'.join([clean_name(item) for item in column.index_fields])
    return f'CREATE {dtype} INDEX IF NOT EXISTS {clean_name(edge_name)}_{t_tag_name} ON {edge_name}({index_names});'


class NebulaGenerator(object):
    def __init__(self, mysql_creator: CreateSql):
        self.mysql_creator = mysql_creator

    def create_edge(self, edge_name, node1_field, node2_field):
        assert node1_field in [clean_name(item.name) for item in self.mysql_creator.columns]
        assert node2_field in [clean_name(item.name) for item in self.mysql_creator.columns]

        field_res, index_res = [], []
        for column in self.mysql_creator.columns:
            if column.type == 'FieldColumn':
                field_res.append(_create_field_column_sql(column))
            elif column.type == 'IndexColumn':
                index_res.append(_create_index_column_sql('EDGE', column, edge_name))
        field_res = ', \\ \n'.join(field_res)
        index_res = '\n'.join(index_res)

        return f"CREATE EDGE IF NOT EXISTS {edge_name}({field_res}) \\ \n" \
               f"COMMENT={self.mysql_creator.comment()}; \n" + index_res

    def create_tag(self, tag_name, node_field):
        assert node_field in [clean_name(item.name) for item in self.mysql_creator.columns if item.type == 'FieldColumn']

        field_res, index_res = [], []
        for column in self.mysql_creator.columns:
            if column.type == 'FieldColumn':
                field_res.append(_create_field_column_sql(column))
            elif column.type == 'IndexColumn':
                if column.is_primary_key:
                    # mysql中原始的id字段不添加
                    continue
                index_res.append(_create_index_column_sql('TAG', column, tag_name))
        field_res = ', \\ \n'.join(field_res)
        index_res = '\n'.join(index_res)

        return f"CREATE TAG IF NOT EXISTS {tag_name}({field_res}) \\ \n" \
               f"COMMENT={self.mysql_creator.comment()}; \n" + index_res


if __name__ == '__main__':
    sqls = ''.join(open('../examples/mysql_schema.sql', 'r', encoding='utf8').readlines())
    from sql_parse import CreateSqlList
    create_sql_list = CreateSqlList(sqls)
    nebula_generator = NebulaGenerator(create_sql_list[0])

    print(nebula_generator.create_tag('xx', 'user_id'))
    # print(nebula_generator.create_edge('xx', 'user_id'))

