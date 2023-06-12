from enum import Enum


class ModifyType(Enum):
    ADD_IF_NOT_EXIST = 'ADD_IF_NOT_EXIST'
    DROP_IF_EXIST = 'DROP_IF_EXIST'
    NOTHING = None
