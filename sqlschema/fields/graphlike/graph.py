import dataclasses
import warnings
from typing import List, Union

from sqlschema.fields.graphlike.edge import EdgeType
from sqlschema.fields.graphlike.enums import ModifyType
from sqlschema.fields.graphlike.tag import Tag
from sqlschema.fields.graphlike.field import Field
from sqlschema.fields.graphlike.index import Index

from sqlschema.fields.tablelike.table import TableInfo
from sqlschema.utils.codes import Codes


@dataclasses.dataclass
class Graph:
    tags: List[Tag]
    edge_types: List[EdgeType]

    @classmethod
    def from_table_info(cls, table: TableInfo):
        tags, edge_types = [], []
        for edge_info in table.edge_infos:
            edge_types.append(EdgeType.from_table_edge_info(edge_info))
        for tag_field in table.tags:
            assert len(tag_field.graph_belong_to) == 1
            name = tag_field.graph_belong_to[0]
            attrs = table.get_attr_fields_by_tag_id_name(tag_field.name)
            attrs = [Field.from_table_field(item) for item in attrs]
            indexes = table.get_index_by_tag_id_name(tag_field.name)
            indexes = [Index.from_table_index(item) for item in indexes]
            tags.append(Tag(name=name,
                            id_field=Field.from_table_field(tag_field),
                            attrs_field=attrs,
                            indexes=indexes)
                        )
        return cls(tags, edge_types)

    def code_create_graph(self, include_id_field=True,
                          modify_mode: ModifyType = None,
                          with_backslash=True,
                          with_indexes=True):
        res = []
        res.extend([item.code_create_tag(include_id_field, modify_mode, with_backslash, with_indexes)
                    for item in self.tags])
        res.extend([item.code_create_edge(include_id_field, modify_mode, with_backslash, with_indexes)
                    for item in self.edge_types])
        return Codes('\n\n\n'.join(res))

    def code_new_space(self, space_name, vid_type=None,
                       partition_num=10, replica_factor=1, modify_mode: ModifyType = None):
        modify_mode = ModifyType(modify_mode)
        if vid_type is None:
            field_types = [tag.id_field.type for tag in self.tags]
            field_type_sets = set([_type.__class__.__name__ for _type in field_types])
            if len(field_type_sets) > 1:
                raise AssertionError(f'the defined tags has more than 1 type: {field_type_sets}')

            vid_type = field_types[0].data_type
            if field_types[0].CHARACTER_MAXIMUM_LENGTH is not None:
                max_length = max([item.CHARACTER_MAXIMUM_LENGTH for item in field_types
                                  if item.CHARACTER_MAXIMUM_LENGTH is not None])
                vid_type = vid_type + f'({max_length})'

        IF_EXISTS = 'IF NOT EXISTS' if modify_mode == modify_mode.ADD_IF_NOT_EXIST else ''

        res = f'CREATE SPACE {IF_EXISTS} {space_name} (vid_type={vid_type},' \
              f'partition_num={partition_num},replica_factor={replica_factor});'

        if modify_mode == ModifyType.DROP_IF_EXIST:
            res = f'DROP SPACE IF EXISTS {space_name};\n{res}'

        res = f'{res}\nuse {space_name};'
        return Codes(res)

    def code_drop(self):
        tag_drop = [tag.code_drop() for tag in self.tags]
        edge_drop = [edge.code_drop() for edge in self.edge_types]
        return Codes(''.join(tag_drop + edge_drop))


@dataclasses.dataclass
class GraphList:
    graphs: List[Graph]

    def extend(self, graphs: Union[List[Graph], "GraphList"]):
        if isinstance(graphs, GraphList):
            graphs = graphs.graphs
        self.graphs.extend(graphs)
        return self

    def __iadd__(self, other):
        return self.extend(other)

    def __add__(self, other):
        if isinstance(other, GraphList):
            other = other.graphs
        return GraphList(self.graphs.copy() + other)

    def _code_apply(self, func_name, *args, **kwargs):
        codes = [getattr(g, func_name)(*args, **kwargs) for g in self.graphs]
        codes = '\n\n\n'.join(codes)
        return Codes(codes)

    def code_new_space(self, space_name, vid_type=None,
                       partition_num=10, replica_factor=1, modify_mode: ModifyType = None):
        pass
        #TODO

    def code_create_graph(self, include_id_field=True,
                          modify_mode: ModifyType = None,
                          with_backslash=True,
                          with_indexes=True):
        return self._code_apply('code_create_graph', include_id_field, modify_mode, with_backslash, with_indexes)

    def code_drop(self):
        return self._code_apply('code_drop')


