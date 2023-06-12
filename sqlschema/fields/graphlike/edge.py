import dataclasses
from typing import List

from sqlschema.fields.graphlike.enums import ModifyType
from sqlschema.fields.graphlike.field import Field
from sqlschema.fields.graphlike.index import Index

from sqlschema.fields.tablelike.edgeinfo import EdgeInfo
from sqlschema.utils.codes import Codes


@dataclasses.dataclass
class EdgeType:
    name: str
    src_field: Field
    dst_field: Field
    attrs_field: List[Field]
    indexes: List[Index]

    @classmethod
    def from_table_edge_info(cls, table_edge_info: EdgeInfo):
        return cls(
            name=table_edge_info.edge_type,
            src_field=Field.from_table_field(table_edge_info.src),
            dst_field=Field.from_table_field(table_edge_info.dst),
            attrs_field=[Field.from_table_field(item) for item in table_edge_info.edge_attrs],
            indexes=[Index.from_table_edge_index(item) for item in table_edge_info.edge_indexes]
        )

    def code_create_edge(self, include_id_field=True,
                         modify_mode: ModifyType = None,
                         with_backslash=True,
                         with_indexes=True):

        """
        :param with_indexes:
        :param include_id_field:
        :param with_backslash:
        :param modify_mode: `ADD_IF_NOT_EXIST` or `DROP_IF_EXIST` or None
        :return:
        """
        modify_mode = ModifyType(modify_mode)
        fields = self.attrs_field.copy()
        if include_id_field:
            fields = [self.src_field, self.dst_field] + fields

        context_codes = ',\n\t'.join([item.code_desc() for item in fields])

        IF_EXISTS = 'IF NOT EXISTS' if modify_mode == modify_mode.ADD_IF_NOT_EXIST else ''
        res = f'CREATE EDGE {IF_EXISTS} {self.name} ({context_codes});'
        if with_backslash:
            res = res.replace('\n', '\\\n')

        if modify_mode == modify_mode.DROP_IF_EXIST:
            res = f'{self.code_drop()}\n{res}'

        if with_indexes:
            code_indexes = '\n'.join([index.code_create(self.name) for index in self.indexes])
            res = f'{res}\n\n{code_indexes}\n'
        return Codes(res)

    def code_drop(self):
        indexes_drop = [index.code_drop() for index in self.indexes]
        indexes_drop = ''.join(indexes_drop)

        tag_drop = f'DROP EDGE IF EXISTS `{self.name}`;\n'
        return Codes(f'{indexes_drop}\n{tag_drop}')
