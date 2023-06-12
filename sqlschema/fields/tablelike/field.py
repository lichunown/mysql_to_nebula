import dataclasses
from enum import Enum
from typing import Any, Optional, List, Union
from xml.dom.minidom import Document

from sqlschema.fields.tablelike.filedtype import FieldType
from sqlschema.connectors.mysql_conn import TableColumnOriginType
from sqlschema.fields.tablelike.filedtype import FieldType
from sqlschema.utils.dataclass import AutoChangeTypeMixin
from sqlschema.utils.xmls import py_to_xml_type


class GraphAnnotationType(Enum):
    TAG_ID = 'TAG_ID'
    ATTR = 'ATTR'
    NULL = None


@dataclasses.dataclass
class Field:
    name: str
    type: FieldType
    is_nullable: bool
    default: Any
    comment: str

    graph_anno_type: GraphAnnotationType = GraphAnnotationType.NULL
    """
    graph_belong_to: a list of its parent_id,
    for ATTR, the value is the name of `TAG_ID`,
    for TAG_ID, the value is the tag name,
    """
    graph_belong_to: List[str] = None

    @classmethod
    def from_origin_column_info(cls, col: TableColumnOriginType):
        field_type = FieldType.from_origin_column_info(col)
        default = field_type.apply_default(col.COLUMN_DEFAULT)
        return cls(name=col.COLUMN_NAME,
                   type=field_type,
                   is_nullable=col.IS_NULLABLE == 'YES',
                   default=default,
                   comment=col.COLUMN_COMMENT,
                   graph_anno_type=GraphAnnotationType.NULL,
                   graph_belong_to=[])

    def add_graph_belong_to(self, names: Union[List[str], str]):
        if isinstance(names, str):
            self.graph_belong_to.append(names)
        elif isinstance(names, list):
            self.graph_belong_to.extend(names)

    def to_xml(self, doc):
        column = doc.createElement('column')
        column.setAttribute('name', self.name)
        column.setAttribute('type', self.type.mysql)
        column.setAttribute('is_nullable', py_to_xml_type(self.is_nullable))
        column.setAttribute('default', self.default)
        column.setAttribute('comment', self.comment)
        column.setAttribute('graph_anno_type', self.graph_anno_type.value)
        column.setAttribute('graph_belong_to', py_to_xml_type(self.graph_belong_to))
        return column
