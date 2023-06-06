CREATE TABLE IF NOT EXISTS t_user_info_mysql( 
	`id` INTEGER NOT NULL COMMENT '����', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`auth_flag` INTEGER NOT NULL COMMENT '�Ƿ�ע����֤ 1��֤��0����֤', 
	`wx_open_id` VARCHAR(32) DEFAULT NULL COMMENT '΢��openID', 
	`name` VARCHAR(100) NOT NULL COMMENT '����', 
	`sex` INTEGER DEFAULT NULL COMMENT '�Ա� 0�У�1Ů', 
	`birthday` DATE DEFAULT NULL COMMENT '����', 
	`in_Beijing` INTEGER DEFAULT NULL COMMENT '�Ƿ��ڱ��� 1�� 0��', 
	`status_type` INTEGER DEFAULT NULL COMMENT '��Ϣ״̬ 0�����1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ�ϣ�-1��֤�����û�', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '����appId', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '����appId', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��', 
	PRIMARY KEY (`id`) NOT ENFORCED 
 ) WITH ( 
	'connector' = 'mysql-cdc', 
	'hostname' = '172.16.1.7', 
	'port' = '3306', 
	'username' = 'flink', 
	'password' = '1234567890', 
	'database-name' = 'koala', 
	'table-name' = 't_user_info' 
 ); 



CREATE TABLE IF NOT EXISTS t_user_info_nebula( 
	`tag_id` VARCHAR(64), 
	`id` INTEGER NOT NULL COMMENT '����', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`auth_flag` INTEGER NOT NULL COMMENT '�Ƿ�ע����֤ 1��֤��0����֤', 
	`wx_open_id` VARCHAR(32) DEFAULT NULL COMMENT '΢��openID', 
	`name` VARCHAR(100) NOT NULL COMMENT '����', 
	`sex` INTEGER DEFAULT NULL COMMENT '�Ա� 0�У�1Ů', 
	`birthday` DATE DEFAULT NULL COMMENT '����', 
	`in_Beijing` INTEGER DEFAULT NULL COMMENT '�Ƿ��ڱ��� 1�� 0��', 
	`status_type` INTEGER DEFAULT NULL COMMENT '��Ϣ״̬ 0�����1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ�ϣ�-1��֤�����û�', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '����appId', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '����appId', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt', 
	'data-type' = 'vertex', 
	'label-name' = 'user' 
 ); 



INSERT INTO t_user_info_nebula SELECT user_id,id,user_id,auth_flag,wx_open_id,name,sex,birthday,in_Beijing,status_type,create_user,create_time,create_app,modify_user,modify_time,modify_app,del_stat,version_no FROM t_user_info_mysql; 



CREATE TABLE IF NOT EXISTS t_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '����', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '��ַ����', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '����ַ����', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '��ַ����', 
	`region_type` TINYINT DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '��ַȫ�������', 
	`leaf` TINYINT DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', 
	`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT DEFAULT '0' COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER DEFAULT NULL COMMENT '', 
	PRIMARY KEY (`id`) NOT ENFORCED 
 ) WITH ( 
	'connector' = 'mysql-cdc', 
	'hostname' = '172.16.1.7', 
	'port' = '3306', 
	'username' = 'flink', 
	'password' = '1234567890', 
	'database-name' = 'koala', 
	'table-name' = 't_region' 
 ); 



CREATE TABLE IF NOT EXISTS t_region_nebula( 
	`tag_id` VARCHAR(64), 
	`id` INTEGER NOT NULL COMMENT '����', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '��ַ����', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '����ַ����', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '��ַ����', 
	`region_type` TINYINT DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '��ַȫ�������', 
	`leaf` TINYINT DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', 
	`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT DEFAULT '0' COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt', 
	'data-type' = 'vertex', 
	'label-name' = 'region' 
 ); 



INSERT INTO t_region_nebula SELECT region_id,id,region_id,parent_region_id,region_code,parent_region_code,region_name,region_type,full_address,leaf,create_time,modify_time,del_stat,version_no FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_user_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '����', 
	`user_region_id` VARCHAR(64) DEFAULT NULL COMMENT 'Ψһid', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`region_id` VARCHAR(32) DEFAULT NULL COMMENT '��ַ����', 
	`region_used_type` INTEGER DEFAULT NULL COMMENT '��פ��ַ���� 1��ͥ��ס; 2������פ; 3���ɳ���; 4ѧУ����; 5�ȼ�����; 6����ܿأ�7����', 
	`start_time` DATE DEFAULT NULL COMMENT 'פ����ʼʱ��', 
	`end_time` DATE DEFAULT NULL COMMENT 'פ������ʱ��', 
	`duration_type` INTEGER DEFAULT NULL COMMENT 'פ������ 1����פ����2������פ����3��ĩפ����4ÿ��1-3�죻5ÿ��4-6��', 
	`duration_cost_type` INTEGER DEFAULT NULL COMMENT 'פ�����óе���ʽ 1���й���2�������ޣ�3��λ�е���4�������ã�5�����̳�', 
	`status_type` INTEGER DEFAULT NULL COMMENT '��Ϣ״̬ 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', 
	`region_context` STRING DEFAULT NULL COMMENT '��ַ����', 
	`building` VARCHAR(64) DEFAULT NULL COMMENT '¥/��', 
	`unit` VARCHAR(32) DEFAULT NULL COMMENT '��Ԫ', 
	`room` VARCHAR(32) DEFAULT NULL COMMENT '���ƺ�', 
	`create_user` VARCHAR(32) DEFAULT NULL COMMENT '�����û�id', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '����app', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`modify_user` VARCHAR(32) DEFAULT NULL COMMENT '�����û�id', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '����app', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��', 
	`residence_free_text` VARCHAR(256) DEFAULT NULL COMMENT '', 
	PRIMARY KEY (`id`) NOT ENFORCED 
 ) WITH ( 
	'connector' = 'mysql-cdc', 
	'hostname' = '172.16.1.7', 
	'port' = '3306', 
	'username' = 'flink', 
	'password' = '1234567890', 
	'database-name' = 'koala', 
	'table-name' = 't_user_region' 
 ); 



CREATE TABLE IF NOT EXISTS t_user_region_nebula( 
	`sid` VARCHAR(64), 
	`did` VARCHAR(64), 
	`rid` BIGINT, 
	`id` INTEGER NOT NULL COMMENT '����', 
	`user_region_id` VARCHAR(64) DEFAULT NULL COMMENT 'Ψһid', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`region_id` VARCHAR(32) DEFAULT NULL COMMENT '��ַ����', 
	`region_used_type` INTEGER DEFAULT NULL COMMENT '��פ��ַ���� 1��ͥ��ס; 2������פ; 3���ɳ���; 4ѧУ����; 5�ȼ�����; 6����ܿأ�7����', 
	`start_time` DATE DEFAULT NULL COMMENT 'פ����ʼʱ��', 
	`end_time` DATE DEFAULT NULL COMMENT 'פ������ʱ��', 
	`duration_type` INTEGER DEFAULT NULL COMMENT 'פ������ 1����פ����2������פ����3��ĩפ����4ÿ��1-3�죻5ÿ��4-6��', 
	`duration_cost_type` INTEGER DEFAULT NULL COMMENT 'פ�����óе���ʽ 1���й���2�������ޣ�3��λ�е���4�������ã�5�����̳�', 
	`status_type` INTEGER DEFAULT NULL COMMENT '��Ϣ״̬ 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', 
	`region_context` STRING DEFAULT NULL COMMENT '��ַ����', 
	`building` VARCHAR(64) DEFAULT NULL COMMENT '¥/��', 
	`unit` VARCHAR(32) DEFAULT NULL COMMENT '��Ԫ', 
	`room` VARCHAR(32) DEFAULT NULL COMMENT '���ƺ�', 
	`create_user` VARCHAR(32) DEFAULT NULL COMMENT '�����û�id', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '����app', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`modify_user` VARCHAR(32) DEFAULT NULL COMMENT '�����û�id', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '����app', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��', 
	`residence_free_text` VARCHAR(256) DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'user_region_relation' 
 ); 



INSERT INTO t_user_region_nebula SELECT user_id,region_id,0,id,user_region_id,user_id,region_id,region_used_type,start_time,end_time,duration_type,duration_cost_type,status_type,region_context,building,unit,room,create_user,create_app,create_time,modify_user,modify_app,modify_time,del_stat,version_no,residence_free_text FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '����', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '��ַ����', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '����ַ����', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '��ַ����', 
	`region_type` TINYINT DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '��ַȫ�������', 
	`leaf` TINYINT DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', 
	`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT DEFAULT '0' COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER DEFAULT NULL COMMENT '', 
	PRIMARY KEY (`id`) NOT ENFORCED 
 ) WITH ( 
	'connector' = 'mysql-cdc', 
	'hostname' = '172.16.1.7', 
	'port' = '3306', 
	'username' = 'flink', 
	'password' = '1234567890', 
	'database-name' = 'koala', 
	'table-name' = 't_region' 
 ); 



CREATE TABLE IF NOT EXISTS t_region_nebula( 
	`sid` VARCHAR(64), 
	`did` VARCHAR(64), 
	`rid` BIGINT, 
	`id` INTEGER NOT NULL COMMENT '����', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '��ַ����', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '����ַ����', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '��ַ����', 
	`region_type` TINYINT DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '��ַȫ�������', 
	`leaf` TINYINT DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', 
	`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT DEFAULT '0' COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'region_region_relation' 
 ); 



INSERT INTO t_region_nebula SELECT region_id,parent_region_id,0,id,region_id,parent_region_id,region_code,parent_region_code,region_name,region_type,full_address,leaf,create_time,modify_time,del_stat,version_no FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_user_relation_mysql( 
	`id` INTEGER NOT NULL COMMENT '����', 
	`relation_id` VARCHAR(32) NOT NULL COMMENT '��ϵid', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`related_user_id` VARCHAR(32) NOT NULL COMMENT '�����û�ID', 
	`relationship1` INTEGER NOT NULL COMMENT 'һ����ϵ 1ѪԵ��ϵ����������ż; 2������ϵ����; 3�������ƹ�ϵ', 
	`relationship2` INTEGER NOT NULL COMMENT '������ϵ���ͣ�����һ���ṹȷ�����ṹ���ڸ��ӣ����г�', 
	`start_time` DATETIME DEFAULT NULL COMMENT '��ʼʱ��', 
	`end_time` DATETIME DEFAULT NULL COMMENT '����ʱ��', 
	`status_type` INTEGER NOT NULL COMMENT '״̬��� 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', 
	`roommate_status` TINYINT NOT NULL COMMENT '�Ƿ�Ϊ��ǰͬס�� 1�� 0��', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��', 
	PRIMARY KEY (`id`) NOT ENFORCED 
 ) WITH ( 
	'connector' = 'mysql-cdc', 
	'hostname' = '172.16.1.7', 
	'port' = '3306', 
	'username' = 'flink', 
	'password' = '1234567890', 
	'database-name' = 'koala', 
	'table-name' = 't_user_relation' 
 ); 



CREATE TABLE IF NOT EXISTS t_user_relation_nebula( 
	`sid` VARCHAR(64), 
	`did` VARCHAR(64), 
	`rid` BIGINT, 
	`id` INTEGER NOT NULL COMMENT '����', 
	`relation_id` VARCHAR(32) NOT NULL COMMENT '��ϵid', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '�û�ID', 
	`related_user_id` VARCHAR(32) NOT NULL COMMENT '�����û�ID', 
	`relationship1` INTEGER NOT NULL COMMENT 'һ����ϵ 1ѪԵ��ϵ����������ż; 2������ϵ����; 3�������ƹ�ϵ', 
	`relationship2` INTEGER NOT NULL COMMENT '������ϵ���ͣ�����һ���ṹȷ�����ṹ���ڸ��ӣ����г�', 
	`start_time` DATETIME DEFAULT NULL COMMENT '��ʼʱ��', 
	`end_time` DATETIME DEFAULT NULL COMMENT '����ʱ��', 
	`status_type` INTEGER NOT NULL COMMENT '״̬��� 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', 
	`roommate_status` TINYINT NOT NULL COMMENT '�Ƿ�Ϊ��ǰͬס�� 1�� 0��', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`create_time` DATETIME NOT NULL COMMENT '����ʱ��', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '�����û�id', 
	`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', 
	`del_stat` TINYINT NOT NULL COMMENT '0������ 1��ɾ��', 
	`version_no` INTEGER NOT NULL COMMENT '�汾��' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'user_user_relation' 
 ); 



INSERT INTO t_user_relation_nebula SELECT user_id,related_user_id,0,id,relation_id,user_id,related_user_id,relationship1,relationship2,start_time,end_time,status_type,roommate_status,create_user,create_time,modify_user,modify_time,del_stat,version_no FROM t_region_mysql; 
