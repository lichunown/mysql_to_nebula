import dataclasses
from typing import List

from sqlschema.fields.graphlike.field import Field
from sqlschema.fields.graphlike.index import Index
from sqlschema.fields.graphlike.enums import ModifyType
from sqlschema.utils.codes import Codes


@dataclasses.dataclass
class Tag:
    name: str
    id_field: Field
    attrs_field: List[Field]
    indexes: List[Index]

    def code_create_tag(self, include_id_field=True,
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
            fields = [self.id_field] + fields

        context_codes = ',\n\t'.join([item.code_desc() for item in fields])

        IF_EXISTS = 'IF NOT EXISTS' if modify_mode == modify_mode.ADD_IF_NOT_EXIST else ''
        res = f'CREATE TAG {IF_EXISTS} {self.name} ({context_codes});'
        if with_backslash:
            res = res.replace('\n', '\\\n')

        if modify_mode == modify_mode.DROP_IF_EXIST:
            res = f'{self.code_drop()}{res}'

        if with_indexes:
            code_indexes = '\n'.join([index.code_create(self.name) for index in self.indexes])
            res = f'{res}\n\n{code_indexes}\n'
        return Codes(res)

    def code_drop(self):
        indexes_drop = [index.code_drop() for index in self.indexes]
        indexes_drop = ''.join(indexes_drop)

        tag_drop = f'DROP TAG IF EXISTS `{self.name}`;\n'
        return Codes(f'{indexes_drop}\n{tag_drop}')

