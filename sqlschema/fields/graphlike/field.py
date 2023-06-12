import dataclasses
from typing import Any

from sqlschema.fields.graphlike.fieldtype import FieldType
from sqlschema.fields.tablelike.field import Field as TableField


@dataclasses.dataclass
class Field:
    name: str
    type: FieldType
    is_nullable: bool
    default: Any
    comment: str

    @classmethod
    def from_table_field(cls, table_field: TableField):
        return cls(
            name=table_field.name,
            type=table_field.type.nebula,
            is_nullable=table_field.is_nullable,
            default=table_field.default,
            comment=table_field.comment
        )

    def code_desc(self):
        null_str = 'NULL' if self.is_nullable else 'NOT NULL'
        return f'`{self.name}` {self.type.string()} {null_str} ' \
               f'{self.type.apply_default_to_code(self.is_nullable, self.default)} COMMENT "{self.comment}"'
