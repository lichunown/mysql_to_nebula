import dataclasses
from typing import List, TYPE_CHECKING

from sqlschema.fields.tablelike.index import Index, EdgeIndex
from sqlschema.fields.tablelike.field import Field
from sqlschema.utils.xmls import py_to_xml_type

from sqlschema.fields.base import FindFieldMixin

if TYPE_CHECKING:
    from sqlschema.fields.tablelike.table import TableInfo


@dataclasses.dataclass
class EdgeInfo(FindFieldMixin):
    edge_type: str
    src: Field
    dst: Field
    edge_attrs: List[Field]
    edge_indexes: List[EdgeIndex]
    _table_info: "TableInfo" = None

    def to_xml(self, doc):
        column = doc.createElement('edge')
        column.setAttribute('type', py_to_xml_type(self.edge_type))
        column.setAttribute('src', self.src.name)
        column.setAttribute('dst', self.dst.name)
        column.setAttribute('edge_attrs',
                            py_to_xml_type([field.name for field in self.edge_attrs]))
        edge_index = doc.createElement('index')
        column.appendChild(edge_index)
        for item in self.edge_indexes:
            edge_index.appendChild(item.to_xml(doc))
        return column

    def add_index(self, name, field_names: List[str]):
        index = EdgeIndex(name, self,
                          [self._table_info.find_field(item) for item in field_names])
        self.edge_indexes.append(index)
        return self
