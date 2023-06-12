import dataclasses
import typing
from typing import Optional

from sqlschema.connectors.mysql_conn import TableColumnOriginType
from sqlschema.fields.tablelike.utils import split_token_of_date_type_string

from sqlschema.utils.dataclass import AutoChangeTypeMixin


@dataclasses.dataclass
class FieldType(AutoChangeTypeMixin):

    DATA_TYPE: str
    CHARACTER_MAXIMUM_LENGTH: Optional[int] = None
    CHARACTER_OCTET_LENGTH: Optional[int] = None
    NUMERIC_PRECISION: Optional[int] = None
    NUMERIC_SCALE: Optional[int] = None
    DATETIME_PRECISION: Optional[int] = None
    unsigned: Optional[bool] = False

    @staticmethod
    def from_origin_column_info(col: TableColumnOriginType):
        cls = _type_to_class_map[col.DATA_TYPE.upper()]
        unsigned = 'unsigned'.upper() in col.COLUMN_TYPE.upper()
        res = cls(col.DATA_TYPE,
                  col.CHARACTER_MAXIMUM_LENGTH,
                  col.CHARACTER_OCTET_LENGTH,
                  col.NUMERIC_PRECISION,
                  col.NUMERIC_SCALE,
                  col.DATETIME_PRECISION,
                  unsigned)
        return res

    @staticmethod
    def from_string(string: str):
        type = string.strip()
        if '(' in string:
            type = string.split('(')[0]
        cls = _type_to_class_map[type.upper()]
        return cls.from_string(string)

    @staticmethod
    def _analysis_string(string):
        return split_token_of_date_type_string(string)

    def apply_default(self, default_value):
        raise NotImplementedError

    @property
    def mysql(self):
        raise NotImplementedError

    @property
    def nebula(self):
        from sqlschema.fields.graphlike.fieldtype import FieldType as NebulaFieldType
        return NebulaFieldType.from_mysql_field_type(self)


class NumberFieldType(FieldType):
    _float_type = ['FLOAT', 'DOUBLE', 'DECIMAL']
    _int_type = ['INT', 'INTEGER', 'BIGINT',
                 'TINYINT', 'SMALLINT', 'MEDIUMINT']

    @classmethod
    def from_string(cls, string: str):
        tokens = cls._analysis_string(string)
        assert tokens.type.upper() in cls._float_type + cls._int_type
        nums = tokens.nums

        NUMERIC_PRECISION, NUMERIC_SCALE = None, None
        if nums is not None:
            if len(nums) == 1:
                NUMERIC_PRECISION = nums[0]
            elif len(nums) == 2:
                NUMERIC_PRECISION, NUMERIC_SCALE = nums
            else:
                raise ValueError

        return cls(tokens.type,
                   CHARACTER_MAXIMUM_LENGTH=None,
                   CHARACTER_OCTET_LENGTH=None,
                   NUMERIC_PRECISION=NUMERIC_PRECISION,
                   NUMERIC_SCALE=NUMERIC_SCALE,
                   DATETIME_PRECISION=None,
                   unsigned=tokens.unsigned)

    def apply_default(self, default_value):
        if default_value is None:
            return None
        if default_value.upper() == 'NULL':
            return None
        if self.DATA_TYPE.upper() in self._float_type:
            return float(default_value)
        elif self.DATA_TYPE.upper() in self._int_type:
            return int(default_value)

    @property
    def mysql(self):
        if self.NUMERIC_PRECISION is not None:
            return f'{self.DATA_TYPE}({self.NUMERIC_PRECISION})'
        if self.NUMERIC_SCALE is not None:
            return f'{self.DATA_TYPE}({self.NUMERIC_PRECISION},{self.NUMERIC_SCALE})'
        return f'{self.DATA_TYPE}'


class DateTimeFieldType(FieldType):
    _datetime_types = ['DATE', 'TIME', 'YEAR', 'DATETIME', 'TIMESTAMP']

    @classmethod
    def from_string(cls, string: str):
        tokens = cls._analysis_string(string)
        assert tokens.type in cls._datetime_types

        return cls(tokens.type,
                   CHARACTER_MAXIMUM_LENGTH=None,
                   CHARACTER_OCTET_LENGTH=None,
                   NUMERIC_PRECISION=None,
                   NUMERIC_SCALE=None,
                   DATETIME_PRECISION=None,
                   unsigned=None)

    def apply_default(self, default_value: str):
        if default_value.upper() == 'NULL':
            return None
        return default_value

    @property
    def mysql(self):
        return f'{self.DATA_TYPE}'


class StringFieldType(FieldType):
    _string_types = ['CHAR', 'VARCHAR',
                      'TINYBLOB', 'TINYTEXT',
                      'BLOB', 'TEXT',
                      'MEDIUMBLOB', 'MEDIUMTEXT',
                      'LONGBLOB', 'LONGTEXT',
                      'JSON']

    @classmethod
    def from_string(cls, string: str):
        tokens = cls._analysis_string(string)
        assert tokens.type in cls._string_types

        nums = tokens.nums

        CHARACTER_MAXIMUM_LENGTH = None
        if nums is not None:
            if len(nums) == 1:
                CHARACTER_MAXIMUM_LENGTH = nums[0]
            else:
                raise ValueError

        return cls(tokens.type,
                   CHARACTER_MAXIMUM_LENGTH=CHARACTER_MAXIMUM_LENGTH,
                   CHARACTER_OCTET_LENGTH=None,
                   NUMERIC_PRECISION=None,
                   NUMERIC_SCALE=None,
                   DATETIME_PRECISION=None,
                   unsigned=None)

    def apply_default(self, default_value: str):
        if default_value is None:
            return None
        if default_value.upper() == 'NULL':
            return None
        return default_value

    @property
    def mysql(self):
        if self.CHARACTER_MAXIMUM_LENGTH is not None:
            return f'{self.DATA_TYPE}({self.CHARACTER_MAXIMUM_LENGTH})'
        return f'{self.DATA_TYPE}'


_field_map = {
    NumberFieldType: ['INT', 'INTEGER', 'BIGINT',
                      'FLOAT', 'DOUBLE', 'DECIMAL',
                      'TINYINT', 'SMALLINT', 'MEDIUMINT'],
    StringFieldType: ['CHAR', 'VARCHAR',
                      'TINYBLOB', 'TINYTEXT',
                      'BLOB', 'TEXT',
                      'MEDIUMBLOB', 'MEDIUMTEXT',
                      'LONGBLOB', 'LONGTEXT',
                      'JSON'],
    DateTimeFieldType: ['DATE', 'TIME', 'YEAR', 'DATETIME', 'TIMESTAMP'],
}
_type_to_class_map = {type_item: k for k, v in _field_map.items()
                      for type_item in v}

