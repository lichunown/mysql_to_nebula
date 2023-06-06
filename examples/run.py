from sqlschema import MainGenerator


main_generator = MainGenerator.load_mysql_sqls('./mysql_schema.sql')
main_generator.tag_data_type = 'VARCHAR(64)'


main_generator.update_flink_mysql_meta_info({
    'connector': 'mysql-cdc',
    'hostname': '172.16.1.7',
    'port': '3306',
    'username': 'flink',
    'password': '1234567890',
    'database-name': 'koala',
}).update_flink_nebula_meta_info({
    'connector': 'nebula',
    'meta-address': '127.0.0.1:9559',
    'graph-address': '127.0.0.1:9669',
    'username': 'root',
    'password': 'nebula',
    'graph-space': 'jmt2',
}) \
    .define_tag('t_user_info', 'user_id', 'user') \
    .define_tag('t_region', 'region_id', 'region') \
    .define_edge('t_user_region', 'user_id', 'region_id',
                 'user_region_relation') \
    .define_edge('t_region', 'region_id', 'parent_region_id',
                 'region_region_relation') \
    .define_edge('t_user_relation', 'user_id', 'related_user_id',
                 'user_user_relation')

main_generator.create_nebula_space_sql('jmt2').save('./_genetated_nebula.sql')
main_generator.create_nebula_sql().add_to('./_genetated_nebula.sql')
main_generator.create_flink_sql().save('./_genetated_flink.sql')
