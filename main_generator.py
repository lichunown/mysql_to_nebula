import os
from typing import List

from sql_parse import CreateSqlList
from generators import FlinkGenerator, NebulaGenerator
from utils.format import Format

from utils.util import clean_name
from dataclasses import dataclass


@dataclass
class NodeInfo:
    table_name: str
    tag_field_name: str
    nebula_tag_name: str


@dataclass
class EdgeInfo:
    table_name: str
    node1_field_name: str
    node2_field_name: str
    nebula_edge_name: str


class MainGenerator(object):

    @classmethod
    def load_mysql_sqls(cls, path):
        sqls = ''.join(open(path, 'r', encoding='utf8').readlines())
        return cls(sqls)

    def __init__(self, sqls, tag_data_type=None):
        self.create_sql_list = CreateSqlList(sqls)

        self.flink_mysql_meta_info = {}
        self.flink_nebula_meta_info = {}

        self.nodes: List[NodeInfo] = []
        self.edges: List[EdgeInfo] = []

        self.tag_data_type = tag_data_type

    def update_flink_mysql_meta_info(self, dict_data: dict):
        self.flink_mysql_meta_info.update(dict_data)
        return self

    def update_flink_nebula_meta_info(self, dict_data: dict):
        self.flink_nebula_meta_info.update(dict_data)
        return self

    def define_tag(self, table_name, tag_field_name,
                   nebula_tag_name):
        assert table_name in self.create_sql_list, f'table `{table_name}` not in sqls.'
        create_sql = self.create_sql_list[table_name]
        assert clean_name(tag_field_name) in create_sql.field_names, \
            f'field `{tag_field_name}` not in table `{create_sql.name}`.'

        self.nodes.append(NodeInfo(table_name, tag_field_name,
                                   nebula_tag_name))
        return self

    def define_edge(self, table_name, node1_field_name, node2_field_name,
                    nebula_edge_name):
        assert table_name in self.create_sql_list, f'table `{table_name}` not in sqls.'
        create_sql = self.create_sql_list[table_name]
        assert clean_name(node1_field_name) in create_sql.field_names, \
            f'field `{node1_field_name}` not in table `{create_sql.name}`.'
        assert clean_name(node2_field_name) in create_sql.field_names, \
            f'field `{node2_field_name}` not in table `{create_sql.name}`.'

        self.edges.append(EdgeInfo(table_name, node1_field_name,
                                   node2_field_name, nebula_edge_name))
        return self

    def create_nebula_sql(self):
        res = []
        for node in self.nodes:
            table_sql = self.create_sql_list[node.table_name]
            generator = NebulaGenerator(table_sql)
            res.append(generator.create_tag(node.nebula_tag_name, node.tag_field_name))

        for edge in self.edges:
            table_sql = self.create_sql_list[edge.table_name]
            generator = NebulaGenerator(table_sql)
            res.append(generator.create_edge(edge.nebula_edge_name,
                                             edge.node1_field_name, edge.node2_field_name))

        return Format(res)

    def create_flink_sql(self):
        if self.tag_data_type is None:
            raise ValueError('请先定义tag_data_type：nebula空间下索引类型。')

        res = []

        for node in self.nodes:
            table_sql = self.create_sql_list[node.table_name]
            generator = FlinkGenerator(table_sql)

            res.append(generator.with_item(self.flink_mysql_meta_info)
                       .mysql_virtual(node.table_name + '_mysql'))

            res.append(generator.with_item(self.flink_nebula_meta_info)
                       .nebula_tag_virtual(node.table_name + '_nebula',
                                           node.nebula_tag_name,
                                           self.tag_data_type))

            sql = f"INSERT INTO {node.table_name + '_nebula'} " \
                  f"SELECT {node.tag_field_name},{','.join(table_sql.field_names)} " \
                  f"FROM {node.table_name + '_mysql'}; \n"
            res.append(sql)

        for edge in self.edges:
            table_sql = self.create_sql_list[edge.table_name]
            generator = FlinkGenerator(table_sql)

            res.append(generator.with_item(self.flink_mysql_meta_info)
                       .mysql_virtual(edge.table_name + '_mysql'))

            res.append(generator.with_item(self.flink_nebula_meta_info)
                       .nebula_edge_virtual(edge.table_name + '_nebula',
                                            edge.nebula_edge_name,
                                            self.tag_data_type))

            sql = f"INSERT INTO {edge.table_name + '_nebula'} " \
                  f"SELECT {edge.node1_field_name},{edge.node2_field_name},0,{','.join(table_sql.field_names)} " \
                  f"FROM {node.table_name + '_mysql'}; \n"
            res.append(sql)

        return Format(res)


if __name__ == '__main__':
    main_generator = MainGenerator.load_mysql_sqls('examples/mysql_schema.sql')
    main_generator.tag_data_type = 'VARCHAR(64)'

    main_generator.update_flink_mysql_meta_info({
        'connector': 'mysql-cdc',
        'hostname': '172.16.1.7',
        'port': '3306',
        'username': 'flink',
        'password': '1234567890',
        'database-name': 'koala',
    }).update_flink_nebula_meta_info({
        'connector': 'nebula',
        'meta-address': '127.0.0.1:9559',
        'graph-address': '127.0.0.1:9669',
        'username': 'root',
        'password': 'nebula',
        'graph-space': 'jmt',
    })\
        .define_tag('t_user_info', 'user_id', 'user')\
        .define_tag('t_region', 'region_id', 'region')\
        .define_edge('t_user_region', 'user_id', 'region_id',
                     'user_region_relation')\
        .define_edge('t_region', 'region_id', 'parent_region_id',
                     'region_region_relation')\
        .define_edge('t_user_relation', 'user_id', 'related_user_id',
                     'user_user_relation')

    main_generator.create_nebula_sql().save('./examples/_genetated_nebula.sql')
    main_generator.create_flink_sql().save('./examples/_genetated_flink.sql')




