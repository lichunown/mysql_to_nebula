import sqlparse
import os
import sqlparse.sql as parse_sql


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
            print(par_level)
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


sqls = ''.join(open('examples/mysql_schema.sql', 'r', encoding='utf8').readlines())
parsed_sqls = sqlparse.parse(sqls)

parsed_sql = parsed_sqls[1]
_, par = parsed_sql.token_next_by(parse_sql.Parenthesis)
columns = extract_definitions(par)

