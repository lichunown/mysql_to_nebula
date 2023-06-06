from typing import List, Union
from utils.util import clean_name


_type_class_map = {}


def _cat_length_str(type_str, *length):
    if len(length) == 0:
        return type_str

    length = ','.join([str(item) for item in length])
    return f'{type_str}({length})'


class FieldType(object):
    pass


class NumberFieldType(FieldType):
    pass


class StringFieldType(FieldType):
    pass


class DateTimeFieldType(FieldType):
    pass


def _check_inputs(allow_inputs_type, inputs):
    if isinstance(allow_inputs_type, bool):
        return allow_inputs_type or (len(inputs) == 0)
    elif isinstance(allow_inputs_type, int):
        return len(inputs) == int(allow_inputs_type)


def _make_field_type(class_name, base_class, changing_value_class,
                     sql_ftype_list: Union[str, List[str]], sql_allow_inputs: Union[bool, int],
                     nebula_ftype: str, nebula_allow_inputs: Union[bool, int],
                     flink_ftype: str, flink_allow_inputs: Union[bool, int]):

    if isinstance(sql_ftype_list, str):
        sql_ftype_list = [sql_ftype_list]

    sql_ftype_list = [item.upper() for item in sql_ftype_list]
    nebula_ftype = nebula_ftype.upper()
    flink_ftype = flink_ftype.upper()

    class _FieldFactory(type):
        def __new__(mcs, name, bases, attrs):
            return super().__new__(mcs, class_name, bases, attrs)

        def __repr__(self):
            return class_name

    class _FieldType(base_class, metaclass=_FieldFactory):

        alias = sql_ftype_list

        def __init__(self, *lengths):
            self.length = lengths
            if not _check_inputs(sql_allow_inputs, lengths):
                raise ValueError(f'the field type `{sql_ftype_list}` '
                                 f'are not allowed setting length: {lengths}.')

        @property
        def ftype(self):
            return _cat_length_str(sql_ftype_list[0], *self.length)

        @property
        def nebula(self):
            if nebula_allow_inputs:
                return _cat_length_str(nebula_ftype, *self.length)
            return nebula_ftype

        @property
        def flink(self):
            if flink_allow_inputs:
                return _cat_length_str(flink_ftype, *self.length)
            else:
                return flink_ftype

        @staticmethod
        def apply(value):
            return changing_value_class(clean_name(value))

        def __repr__(self):
            return self.ftype

    for item in sql_ftype_list:
        _type_class_map[item] = _FieldType

    return _FieldType



# Numbers
TINYINT = _make_field_type('TINYINT', NumberFieldType, int, 'TINYINT', True, 'INT16', False, 'TINYINT', False)
INT = _make_field_type('INT', NumberFieldType, int, ['INT', 'INTEGER', 'MEDIUMINT'], True, 'INT32', False, 'INTEGER', False)
BIGINT = _make_field_type('BIGINT', NumberFieldType, int, 'BIGINT', True, 'INT64', False, 'BIGINT', False)
FLOAT = _make_field_type('FLOAT', NumberFieldType, float, 'FLOAT', True, 'FLOAT', False, 'FLOAT', False)
DOUBLE = _make_field_type('DOUBLE', NumberFieldType, float, 'DOUBLE', True, 'DOUBLE', False, 'DOUBLE', False)


# date and time
DATE = _make_field_type('DATE', DateTimeFieldType, str, 'DATE', False, 'DATE', False, 'DATE', False)
TIME = _make_field_type('TIME', DateTimeFieldType, str, 'TIME', False, 'TIME', False, 'TIME', False)
DATETIME = _make_field_type('DATETIME', DateTimeFieldType, str, 'DATETIME', False, 'DATETIME', False, 'DATETIME', False)
TIMESTAMP = _make_field_type('TIMESTAMP', DateTimeFieldType, str, 'TIMESTAMP', False, 'TIMESTAMP', False, 'TIMESTAMP', False)


# string
FIXED_CHAR = _make_field_type('FIXED_CHAR', StringFieldType, str, 'CHAR', True, 'FIXED_STRING', True, 'CHAR', True)
VARCHAR = _make_field_type('VARCHAR', StringFieldType, str, 'VARCHAR', True, 'FIXED_STRING', True, 'VARCHAR', True)
TEXT = _make_field_type('TEXT', StringFieldType, str, ['JSON', 'TEXT'], False, 'STRING', False, 'STRING', False)


def auto_ftype(ftype: str, *num: int):
    ftype = ftype.upper()
    if ftype not in _type_class_map:
        raise ValueError(f'the field type `{ftype}` have not support.')
    return _type_class_map[ftype](*num)
