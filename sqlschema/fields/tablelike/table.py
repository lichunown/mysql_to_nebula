import dataclasses
from typing import List, Union, Dict
from xml.dom.minidom import Document

from sqlschema.fields.tablelike.edgeinfo import EdgeInfo
from sqlschema.fields.tablelike.field import Field, GraphAnnotationType
from sqlschema.fields.tablelike.index import Index


@dataclasses.dataclass
class TableInfo:
    name: str
    fields: List[Field]
    indexes: List[Index]
    edge_infos: List[EdgeInfo]

    @classmethod
    def from_sql_connect(cls, table_name, field_data, indexes_data):
        res = cls(table_name,
                  [Field.from_origin_column_info(item) for item in field_data],
                  [], [])
        res.indexes = Index.from_origin_columns_info(res, indexes_data)
        return res

    def _to_xml(self):
        doc = Document()
        mapper = doc.createElement('graphMapper')
        mapper.setAttribute('table_name', self.name)
        doc.appendChild(mapper)
        columns = doc.createElement('columns')
        edges = doc.createElement('edges')
        indexes = doc.createElement('indexes')
        mapper.appendChild(columns)
        mapper.appendChild(edges)
        mapper.appendChild(indexes)

        for field in self.fields:
            columns.appendChild(field.to_xml(doc))
        for edge_info in self.edge_infos:
            edges.appendChild(edge_info.to_xml(doc))
        for index in self.indexes:
            indexes.appendChild(index.to_xml(doc))
        return doc

    def to_xml(self, path):
        doc = self._to_xml()
        with open(path, 'w', encoding='utf8') as f:
            doc.writexml(f, indent='\t', newl='\n', addindent='\t', encoding='utf-8')

    def to_graph(self):
        from sqlschema.fields.graphlike.graph import Graph
        return Graph.from_table_info(self)

    def find_field(self, name):
        for field in self.fields:
            if field.name == name:
                return field

    def _remained_fields(self, names: List[str]):
        res = []
        for field in self.fields:
            if not field.name in names:
                res.append(field)
        return res

    @property
    def tags(self):
        for field in self.fields:
            if field.graph_anno_type == GraphAnnotationType.TAG_ID:
                yield field

    def get_attr_fields_by_tag_id_name(self, tag_id: str):
        for field in self.fields:
            if tag_id in field.graph_belong_to:
                yield field

    def get_index_by_tag_id_name(self, tag_id: str):
        fields = self.get_attr_fields_by_tag_id_name(tag_id)
        field_names = [item.name for item in fields]
        for index in self.indexes:
            if all([index_item.name in field_names for index_item in index.fields]):
                yield index

    def set_tag(self, tag_names: Union[str, List[str]],
                tag_id: str,
                tag_attrs: Union[List[str], str] = 'remain_all'):

        # set the id
        _field = self.find_field(tag_id)
        _field.graph_anno_type = GraphAnnotationType.TAG_ID
        _field.add_graph_belong_to(tag_names)

        # set the attrs
        if tag_attrs == 'remain_all':
            _fields = self._remained_fields([tag_id])
        else:
            if isinstance(tag_attrs, str):
                tag_attrs = [tag_attrs]
            _fields = [self.find_field(item) for item in tag_attrs]

        for field in _fields:
            field.graph_anno_type = GraphAnnotationType.ATTR
            field.add_graph_belong_to(tag_id)

        return self

    def set_edge(self, edge_type: str,
                 edge_src: str, edge_dst: str,
                 edge_attrs: Union[List[str], str] = 'remain_all',
                 edge_indexes: Dict[str, List[str]] = None):

        if edge_attrs == 'remain_all':
            _fields = self._remained_fields([edge_src, edge_dst])
        else:
            if isinstance(edge_attrs, str):
                tag_attrs = [edge_attrs]
            _fields = [self.find_field(item) for item in edge_attrs]

        if edge_indexes is None:
            edge_indexes = {}

        edge_info = EdgeInfo(
            edge_type,
            self.find_field(edge_src),
            self.find_field(edge_dst),
            _fields,
            [],
            self,
        )
        for name, values in edge_indexes.items():
            if isinstance(values, str):
                values = [values]
            edge_info.add_index(name, values)
        self.edge_infos.append(edge_info)

        return self

    def __repr__(self):
        tag_num = sum([1 for item in self.fields if item.graph_anno_type != GraphAnnotationType.NULL])
        return f'{self.name}:  field_num={len(self.fields)}  tag_num={tag_num}  edge_num={len(self.edge_infos)}'