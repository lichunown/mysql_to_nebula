import dataclasses
from typing import Optional, TYPE_CHECKING
from sqlschema.fields.fieldtype_map import mysql_to_nebula, mysql_to_nebula_numbers, \
    mysql_to_nebula_datetimes, mysql_to_nebula_chars

if TYPE_CHECKING:
    from sqlschema.fields.tablelike.filedtype import FieldType as _TableFieldType


@dataclasses.dataclass
class FieldType:
    data_type: str
    CHARACTER_MAXIMUM_LENGTH: Optional[int] = None

    @staticmethod
    def from_mysql_field_type(field_type: "_TableFieldType"):
        if field_type.DATA_TYPE.upper() in mysql_to_nebula_numbers:
            return NumberFieldType(data_type=mysql_to_nebula[field_type.DATA_TYPE.upper()],
                                   CHARACTER_MAXIMUM_LENGTH=field_type.CHARACTER_MAXIMUM_LENGTH)
        elif field_type.DATA_TYPE.upper() in mysql_to_nebula_chars:
            return StringFieldType(data_type=mysql_to_nebula[field_type.DATA_TYPE.upper()],
                                   CHARACTER_MAXIMUM_LENGTH=field_type.CHARACTER_MAXIMUM_LENGTH)
        elif field_type.DATA_TYPE.upper() in mysql_to_nebula_datetimes:
            return DateTimeFieldType(data_type=mysql_to_nebula[field_type.DATA_TYPE.upper()],
                                     CHARACTER_MAXIMUM_LENGTH=field_type.CHARACTER_MAXIMUM_LENGTH)
        raise ValueError

    def string(self):
        if self.CHARACTER_MAXIMUM_LENGTH is not None:
            return f'{self.data_type}({self.CHARACTER_MAXIMUM_LENGTH})'
        return f'{self.data_type}'

    def _default_apply(self, value):
        raise NotImplementedError

    def apply_default_to_code(self, is_nullable, value):
        if is_nullable:
            if value is None:
                return 'DEFAULT NULL'
            else:
                return f'DEFAULT {self._default_apply(value)}'
        else:
            if value is None:
                return ''
            else:
                return f'DEFAULT {self._default_apply(value)}'


class NumberFieldType(FieldType):

    def _default_apply(self, value):
        return f'{value}'


class StringFieldType(FieldType):

    def _default_apply(self, value):
        return f'"{value}"'


class DateTimeFieldType(FieldType):

    def _default_apply(self, value):
        pass

    def apply_default_to_code(self, is_nullable, value):
        return ''
