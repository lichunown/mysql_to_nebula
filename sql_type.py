from typing import List, Union


_type_class_map = {}


def _cat_length_str(type_str, length):
    if length is None:
        return type_str
    else:
        return f'{type_str}({length})'


def _make_field_type(sql_ftype_list: Union[str, List[str]],  # for alias
                     sql_allow_length: bool,
                     nebula_ftype: str, nebula_allow_length: bool,
                     flink_ftype: str, flink_allow_length: bool):

    if isinstance(sql_ftype_list, str):
        sql_ftype_list = [sql_ftype_list]

    sql_ftype_list = [item.upper() for item in sql_ftype_list]
    nebula_ftype = nebula_ftype.upper()
    flink_ftype = flink_ftype.upper()

    class _FieldType(object):

        def __init__(self, length=None):
            self.length = length
            if not sql_allow_length and length is not None:
                raise ValueError(f'the field type `{sql_ftype_list}` '
                                 f'are not allowed setting length.')

        @property
        def ftype(self):
            return _cat_length_str(sql_ftype_list[0], self.length)

        @property
        def nebula(self):
            if nebula_allow_length:
                return _cat_length_str(nebula_ftype, self.length)
            return nebula_ftype

        @property
        def flink(self):
            if flink_allow_length:
                return _cat_length_str(flink_ftype, self.length)
            else:
                return flink_ftype

        def __repr__(self):
            return self.ftype

    for item in sql_ftype_list:
        _type_class_map[item] = _FieldType

    return _FieldType


# Numbers
TINYINT = _make_field_type('TINYINT', True, 'INT16', False, 'TINYINT', False)
MEDIUMINT = _make_field_type('MEDIUMINT', True, 'INT32', False, 'INTEGER', False)
INT = _make_field_type(['INT', 'INTEGER'], True, 'INT32', False, 'INTEGER', False)
BIGINT = _make_field_type('BIGINT', True, 'INT64', False, 'BIGINT', False)
FLOAT = _make_field_type('FLOAT', True, 'FLOAT', False, 'FLOAT', False)
DOUBLE = _make_field_type('DOUBLE', True, 'DOUBLE', False, 'DOUBLE', False)


# date and time
DATE = _make_field_type('DATE', False, 'DATE', False, 'DATE', False)
TIME = _make_field_type('TIME', False, 'TIME', False, 'TIME', False)
DATETIME = _make_field_type('DATETIME', False, 'DATETIME', False, 'DATETIME', False)
TIMESTAMP = _make_field_type('TIMESTAMP', False, 'TIMESTAMP', False, 'TIMESTAMP', False)


# string
CHAR = _make_field_type('CHAR', True, 'FIXED_STRING', True, 'CHAR', True)
VARCHAR = _make_field_type('VARCHAR', True, 'FIXED_STRING', True, 'VARCHAR', True)
JSON = _make_field_type('JSON', False, 'STRING', False, 'STRING', False)


def auto_ftype(ftype: str, num: int = None):
    ftype = ftype.upper()
    if ftype not in _type_class_map:
        raise ValueError(f'the field type `{ftype}` have not support.')
    return _type_class_map[ftype](num)


