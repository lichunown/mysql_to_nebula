import dataclasses
from typing import List, TYPE_CHECKING

from sqlschema.connectors.mysql_conn import TableIndexOriginType
from sqlschema.utils.xmls import py_to_xml_type


if TYPE_CHECKING:
    from sqlschema.fields.tablelike.field import Field
    from sqlschema.fields.tablelike.table import TableInfo as _TableInfo
    from sqlschema.fields.tablelike.edgeinfo import EdgeInfo


@dataclasses.dataclass
class Index:
    name: str
    fields: List["Field"]
    is_primary_key: bool = False

    @classmethod
    def from_origin_columns_info(cls, table: "_TableInfo", cols: List[TableIndexOriginType]) -> List["Index"]:
        res = []
        key_names = set([col.Key_name for col in cols])
        for key_name in key_names:
            _tmp_cols = [item for item in cols if item.Key_name == key_name]
            res.append(cls(
                name=key_name,
                fields=[table.find_field(item.Column_name) for item in _tmp_cols],
                is_primary_key=(key_name == 'PRIMARY')
            ))
        return res

    def to_xml(self, doc):
        column = doc.createElement('index')
        column.setAttribute('name', self.name)
        column.setAttribute('is_primary_key', py_to_xml_type(self.is_primary_key))
        column.setAttribute('fields', py_to_xml_type([field.name for field in self.fields]))
        return column


@dataclasses.dataclass
class EdgeIndex:
    name: str
    edge_info: "EdgeInfo"
    fields: List["Field"]

    def to_xml(self, doc):
        column = doc.createElement('edgeIndex')
        column.setAttribute('name', self.name)
        column.setAttribute('edge_type', self.edge_info.edge_type)
        column.setAttribute('fields', py_to_xml_type([field.name for field in self.fields]))
        return column
