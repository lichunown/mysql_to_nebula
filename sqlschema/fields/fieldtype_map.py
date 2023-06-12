
mysql_to_nebula_numbers = {
    # NUMBERS
    'INT': 'INT32',
    'INTEGER': 'INT32',
    'BIGINT': 'INT64',
    'MEDIUMINT': 'INT32',
    'TINYINT': 'INT8',
    'SMALLINT': 'INT16',
    'FLOAT': 'FLOAT',
    'DOUBLE': 'DOUBLE',
    'DECIMAL': 'DOUBLE',
}


mysql_to_nebula_chars = {
    # CHARS
    'CHAR': 'FIXED_STRING',
    'VARCHAR': 'FIXED_STRING',
    'TINYBLOB': 'STRING',
    'TINYTEXT': 'STRING',
    'BLOB': 'STRING',
    'TEXT': 'STRING',
    'MEDIUMBLOB': 'STRING',
    'MEDIUMTEXT': 'STRING',
    'LONGBLOB': 'STRING',
    'LONGTEXT': 'STRING',
    'JSON': 'STRING',
}


mysql_to_nebula_datetimes = {
    # DATE AND TIME
    'DATE': 'DATE',
    'TIME': 'TIME',
    'YEAR': 'INT',
    'DATETIME': 'DATETIME',
    'TIMESTAMP': 'TIMESTAMP',
}


mysql_to_nebula = mysql_to_nebula_numbers | mysql_to_nebula_chars | mysql_to_nebula_datetimes
