import dataclasses
from enum import Enum
from typing import List

from sqlschema.fields.graphlike.field import Field
from sqlschema.fields.tablelike.index import Index as TableIndex
from sqlschema.fields.tablelike.index import EdgeIndex as TableEdgeIndex
from sqlschema.utils.codes import Codes


class _IndexType(Enum):
    EDGE_INDEX = "EDGE"
    TAG_INDEX = 'TAG'


@dataclasses.dataclass
class Index:
    name: str
    fields: List["Field"]
    index_type: _IndexType

    @classmethod
    def from_table_index(cls, table_index: TableIndex):
        return cls(
            name=table_index.name,
            fields=[Field.from_table_field(item) for item in table_index.fields],
            index_type=_IndexType.TAG_INDEX,
        )

    @classmethod
    def from_table_edge_index(cls, table_index: TableEdgeIndex):
        return cls(
            name=table_index.name,
            fields=[Field.from_table_field(item) for item in table_index.fields],
            index_type=_IndexType.EDGE_INDEX,
        )

    def code_create(self, tag_or_edge_name):
        # CREATE TAG INDEX IF NOT EXISTS `uniq_idx_user_id` ON user(`user_id`);
        index_type = self.index_type.value
        fields = ','.join([f'`{item.name}`' for item in self.fields])
        return Codes(f'CREATE {index_type} INDEX IF NOT EXISTS `{self.name}` ON {tag_or_edge_name}({fields});')

    def code_drop(self):
        index_type = self.index_type.value
        return Codes(f'DROP {index_type} INDEX IF EXISTS `{self.name}`;\n')
