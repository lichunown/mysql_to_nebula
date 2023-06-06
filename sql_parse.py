import pprint
from typing import Union, List

import sqlparse
import os
import sqlparse.sql as parse_sql

from utils.util import IterWrapper, clean_name
from sql_type import auto_ftype, NumberFieldType


class Column(object):

    @staticmethod
    def auto_column(cols: List[sqlparse.sql.Token]):
        if cols[0].ttype == sqlparse.tokens.Name:
            return FieldColumn(cols)
        elif cols[0].normalized == 'PRIMARY':
            return PrimaryKeyColumn(cols)
        else:
            return IndexColumn(cols)

    def __init__(self, cols: List[sqlparse.sql.Token]):
        self.cols = cols
        self._check_cols()

    def _check_cols(self):
        raise NotImplementedError

    @property
    def type(self):
        return self.__class__.__name__


class FieldColumn(Column):
    """
    an example:
     [<Name '`statu...' at 0x19EAF504220>,
      <Name 'INT' at 0x19EAF5042E0>,
      <Integer '2' at 0x19EAF5043A0>,
      <Keyword 'NULL' at 0x19EAF5044C0>,
      <Keyword 'DEFAULT' at 0x19EAF504580>,
      <Keyword 'NULL' at 0x19EAF504640>,
      <Keyword 'COMMENT' at 0x19EAF504700>,
      <Single ''信息状态 ...' at 0x19EAF5047C0>]
    """
    def _check_cols(self):
        assert len(self.cols) > 2, f'The col: {self.cols} have less than 2 item.' \
                                   f'but it is {self.cols}'
        assert self.cols[0].ttype == sqlparse.tokens.Name, f'The col[0] must be the name of field, ' \
                                                           f'but it is {self.cols}'

    @property
    def name(self):
        return self.cols[0].value

    @property
    def ftype_num(self):
        res = []
        for token in self.cols[2:]:
            if token.ttype == sqlparse.tokens.Literal.Number.Integer:
                res.append(token.value)
            else:
                break
        return res

    @property
    def ftype(self):
        # print(self.cols, self.cols[0].value)
        return auto_ftype(self.cols[1].value, *self.ftype_num)

    @property
    def is_not_null(self):
        for token in self.cols:
            if token.ttype == sqlparse.tokens.Keyword:
                if token.normalized == 'NOT NULL':
                    return True
        return False

    @property
    def default(self, default='NULL'):
        for i, token in enumerate(self.cols):
            if token.ttype == sqlparse.tokens.Keyword:
                if token.normalized == 'DEFAULT':
                    res = self.cols[i + 1].normalized
                    if res == 'NULL':
                        return default
                    if isinstance(self.ftype, NumberFieldType):
                        res = self.ftype.apply(res)
                    return res
        return default

    def comment(self, default='\'\''):
        for i, token in enumerate(self.cols):
            if token.ttype == sqlparse.tokens.Keyword:
                if token.normalized == 'COMMENT':
                    return self.cols[i + 1].normalized
        return default

    def __repr__(self):
        return f'{self.name} {self.ftype}'


class PrimaryKeyColumn(Column):
    def _check_cols(self):
        assert len(self.cols) > 2, f'The col: {self.cols} have less than 2 item.' \
                                   f'but it is {self.cols}'
        assert self.cols[0].normalized == 'PRIMARY' and \
            self.cols[1].normalized == 'KEY'

    @property
    def name(self):
        if self.cols[2].ttype == sqlparse.tokens.Name:
            return self.cols[2].value
        raise ValueError(f'cannot identify the tokens: {self.cols}')


class IndexColumn(Column):
    """
    examples:
        [<Keyword 'PRIMARY' at 0x17AF2299520>,
         <Keyword 'KEY' at 0x17AF22995E0>,
         <Name '`id`' at 0x17AF2299700>,
         <Keyword 'USING' at 0x17AF2299820>,
         <Name 'BTREE' at 0x17AF22998E0>]

        [<Keyword 'UNIQUE' at 0x17AF229A0A0>,
         <Keyword 'INDEX' at 0x17AF229A160>,
         <Name '`uniq_...' at 0x17AF229A220>,
         <Name '`wx_op...' at 0x17AF229A340>,
         <Keyword 'USING' at 0x17AF229A460>,
         <Name 'BTREE' at 0x17AF229A520>]
    """
    def _check_cols(self):
        assert len(self.cols) > 2, f'The col: {self.cols} have less than 2 item.' \
                                   f'but it is {self.cols}'
        assert self.cols[0].ttype == sqlparse.tokens.Keyword, f'The col[0] must be `PRIMARY KEY` or `UNIQUE INDEX`, ' \
                                                              f'but it is {self.cols}'

    @property
    def name(self):
        _start = False
        for token in self.cols:
            if token.ttype == sqlparse.tokens.Keyword:
                if _start:
                    break
            elif token.ttype == sqlparse.tokens.Name:
                _start = True
                return token.value

    @property
    def is_unique(self):
        for token in self.cols:
            if token.ttype == sqlparse.tokens.Keyword:
                if token.normalized == 'UNIQUE':
                    return True
            else:
                break
        return False

    @property
    def index_fields(self):
        res = []
        _start = False
        for token in self.cols:
            if token.ttype == sqlparse.tokens.Keyword:
                if _start:
                    break
            elif token.ttype == sqlparse.tokens.Name:
                if _start:
                    res.append(token.value)
                _start = True
        return res

    def __repr__(self):
        return f'Index({self.index_fields})'


class CreateSql(object):
    def __init__(self, strings):
        self.parsed_sql = sqlparse.parse(strings)[0]

        if not self.match_ddl(self.parsed_sql.tokens) in ['CREATE', 'create']:
            raise ValueError(f'the input sql: \n {strings}\n'
                             f'IS NOT create table sql.')

        _, par = self.parsed_sql.token_next_by(parse_sql.Parenthesis)
        self.columns = [Column.auto_column(item) for item in
                        self.extract_definitions(par)]

    @property
    def field_names(self):
        return [clean_name(c.name) for c in self.columns if c.type == 'FieldColumn']

    @property
    def name(self):
        _, par = self.parsed_sql.token_next_by(parse_sql.Identifier)
        return par.value

    @staticmethod
    def match_ddl(tokens):
        for token in tokens:
            if token.is_whitespace:
                continue
            if token.ttype == sqlparse.tokens.DDL:
                return token.normalized
            else:
                raise ValueError(f'matching token {token.value} is `{token.ttype}`, is not `tokens.DDL`.')

    @staticmethod
    # def extract_definitions(token_list):
    #     # assumes that token_list is a parenthesis
    #     definitions = []
    #     tmp = []
    #     par_level = 0
    #     for token in token_list.flatten():
    #         if token.is_whitespace:
    #             continue
    #         elif token.match(sqlparse.tokens.Punctuation, '('):
    #             par_level += 1
    #             continue
    #         if token.match(sqlparse.tokens.Punctuation, ')'):
    #             if par_level == 0:
    #                 break
    #             else:
    #                 par_level += 1
    #         elif token.match(sqlparse.tokens.Punctuation, ','):
    #             if tmp:
    #                 definitions.append(tmp)
    #             tmp = []
    #         else:
    #             tmp.append(token)
    #     if tmp:
    #         definitions.append(tmp)
    #     return definitions
    def extract_definitions(token_list):
        # assumes that token_list is a parenthesis
        definitions = []
        tmp = []
        par_level = 0
        for token in token_list.flatten():
            if token.is_whitespace:
                continue
            elif token.match(sqlparse.tokens.Punctuation, '('):
                par_level += 1
                continue
            if token.match(sqlparse.tokens.Punctuation, ')'):
                par_level -= 1
            elif token.match(sqlparse.tokens.Punctuation, ','):
                # print(par_level)
                if par_level > 1:
                    continue
                if tmp:
                    definitions.append(tmp)
                    tmp = []
            else:
                tmp.append(token)
        if tmp:
            definitions.append(tmp)
        return definitions

    def comment(self, default=''):
        for i, token in enumerate(self.parsed_sql.tokens):
            if token.ttype == sqlparse.tokens.Keyword \
                    and token.normalized == 'COMMENT':
                return self.parsed_sql.tokens[i + 2].value
        return default

    def __iter__(self):
        return IterWrapper(self.columns)

    def __getitem__(self, item: int):
        return self.columns[item]

    def __repr__(self):
        return f'{self.name}: \n' + pprint.pformat(self.columns)


class CreateSqlList(object):
    def __init__(self, strings):
        self.id_name_map = []
        self.data = {}

        for item in sqlparse.split(strings):
            _cs = CreateSql(item)
            self.data[_cs.name] = _cs
            self.id_name_map.append(_cs.name)

    def __contains__(self, inputs):
        return clean_name(inputs) in [clean_name(item) for item in self.data.keys()]

    def __iter__(self):
        return IterWrapper(self)

    def __getitem__(self, item: Union[str, int]):
        if isinstance(item, str):
            res = self.data.get(item)
            if res is None:
                return self.data[f'`{item}`']
        elif isinstance(item, int):
            return self.data[self.id_name_map[item]]

    def __len__(self):
        return len(self.data)

    def __repr__(self):
        return str(list(self.data.keys()))


if __name__ == '__main__':
    sqls = ''.join(open('examples/mysql_schema.sql', 'r', encoding='utf8').readlines())
    create_sql_list = CreateSqlList(sqls)
