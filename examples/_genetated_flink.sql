CREATE TABLE IF NOT EXISTS t_user_info_mysql( 
	`id` INTEGER NOT NULL COMMENT '主键', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`auth_flag` INTEGER NOT NULL COMMENT '是否注册认证 1认证；0非认证', 
	`wx_open_id` VARCHAR(32) DEFAULT NULL COMMENT '微信openID', 
	`name` VARCHAR(100) NOT NULL COMMENT '姓名', 
	`sex` INTEGER DEFAULT NULL COMMENT '性别 0男；1女', 
	`birthday` DATE DEFAULT NULL COMMENT '生日', 
	`in_Beijing` INTEGER DEFAULT NULL COMMENT '是否在北京 1是 0否', 
	`status_type` INTEGER DEFAULT NULL COMMENT '信息状态 0待填报；1待确认(管理员)；2待确认(家人)；3已确认；-1无证件号用户', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '创建appId', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '更新appId', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号', 
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
	`id` INTEGER NOT NULL COMMENT '主键', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`auth_flag` INTEGER NOT NULL COMMENT '是否注册认证 1认证；0非认证', 
	`wx_open_id` VARCHAR(32) DEFAULT NULL COMMENT '微信openID', 
	`name` VARCHAR(100) NOT NULL COMMENT '姓名', 
	`sex` INTEGER DEFAULT NULL COMMENT '性别 0男；1女', 
	`birthday` DATE DEFAULT NULL COMMENT '生日', 
	`in_Beijing` INTEGER DEFAULT NULL COMMENT '是否在北京 1是 0否', 
	`status_type` INTEGER DEFAULT NULL COMMENT '信息状态 0待填报；1待确认(管理员)；2待确认(家人)；3已确认；-1无证件号用户', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '创建appId', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '更新appId', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt2', 
	'data-type' = 'vertex', 
	'label-name' = 'user' 
 ); 



INSERT INTO t_user_info_nebula SELECT user_id,id,user_id,auth_flag,wx_open_id,name,sex,birthday,in_Beijing,status_type,create_user,create_time,create_app,modify_user,modify_time,modify_app,del_stat,version_no FROM t_user_info_mysql; 



CREATE TABLE IF NOT EXISTS t_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '主键', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '地址编码', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '父地址编码', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '地址名称', 
	`region_type` TINYINT DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '地址全层次名称', 
	`leaf` TINYINT DEFAULT 0 COMMENT '是否叶子节点 0否 1是', 
	`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT DEFAULT 0 COMMENT '0：正常 1：删除', 
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
	`id` INTEGER NOT NULL COMMENT '主键', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '地址编码', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '父地址编码', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '地址名称', 
	`region_type` TINYINT DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '地址全层次名称', 
	`leaf` TINYINT DEFAULT 0 COMMENT '是否叶子节点 0否 1是', 
	`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT DEFAULT 0 COMMENT '0：正常 1：删除', 
	`version_no` INTEGER DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt2', 
	'data-type' = 'vertex', 
	'label-name' = 'region' 
 ); 



INSERT INTO t_region_nebula SELECT region_id,id,region_id,parent_region_id,region_code,parent_region_code,region_name,region_type,full_address,leaf,create_time,modify_time,del_stat,version_no FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_user_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '主键', 
	`user_region_id` VARCHAR(64) DEFAULT NULL COMMENT '唯一id', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`region_id` VARCHAR(32) DEFAULT NULL COMMENT '地址编码', 
	`region_used_type` INTEGER DEFAULT NULL COMMENT '常驻地址类型 1家庭居住; 2工作常驻; 3外派出差; 4学校进修; 5度假疗养; 6隔离管控；7其他', 
	`start_time` DATE DEFAULT NULL COMMENT '驻留开始时间', 
	`end_time` DATE DEFAULT NULL COMMENT '驻留结束时间', 
	`duration_type` INTEGER DEFAULT NULL COMMENT '驻留周期 1持续驻留；2工作日驻留；3周末驻留；4每周1-3天；5每周4-6天', 
	`duration_cost_type` INTEGER DEFAULT NULL COMMENT '驻留费用承担方式 1自有购买；2个人租赁；3单位承担；4政府安置；5安赠继承', 
	`status_type` INTEGER DEFAULT NULL COMMENT '信息状态 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', 
	`region_context` STRING DEFAULT NULL COMMENT '地址描述', 
	`building` VARCHAR(64) DEFAULT NULL COMMENT '楼/栋', 
	`unit` VARCHAR(32) DEFAULT NULL COMMENT '单元', 
	`room` VARCHAR(32) DEFAULT NULL COMMENT '门牌号', 
	`create_user` VARCHAR(32) DEFAULT NULL COMMENT '创建用户id', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '创建app', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`modify_user` VARCHAR(32) DEFAULT NULL COMMENT '更新用户id', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '更新app', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号', 
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
	`id` INTEGER NOT NULL COMMENT '主键', 
	`user_region_id` VARCHAR(64) DEFAULT NULL COMMENT '唯一id', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`region_id` VARCHAR(32) DEFAULT NULL COMMENT '地址编码', 
	`region_used_type` INTEGER DEFAULT NULL COMMENT '常驻地址类型 1家庭居住; 2工作常驻; 3外派出差; 4学校进修; 5度假疗养; 6隔离管控；7其他', 
	`start_time` DATE DEFAULT NULL COMMENT '驻留开始时间', 
	`end_time` DATE DEFAULT NULL COMMENT '驻留结束时间', 
	`duration_type` INTEGER DEFAULT NULL COMMENT '驻留周期 1持续驻留；2工作日驻留；3周末驻留；4每周1-3天；5每周4-6天', 
	`duration_cost_type` INTEGER DEFAULT NULL COMMENT '驻留费用承担方式 1自有购买；2个人租赁；3单位承担；4政府安置；5安赠继承', 
	`status_type` INTEGER DEFAULT NULL COMMENT '信息状态 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', 
	`region_context` STRING DEFAULT NULL COMMENT '地址描述', 
	`building` VARCHAR(64) DEFAULT NULL COMMENT '楼/栋', 
	`unit` VARCHAR(32) DEFAULT NULL COMMENT '单元', 
	`room` VARCHAR(32) DEFAULT NULL COMMENT '门牌号', 
	`create_user` VARCHAR(32) DEFAULT NULL COMMENT '创建用户id', 
	`create_app` VARCHAR(32) DEFAULT NULL COMMENT '创建app', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`modify_user` VARCHAR(32) DEFAULT NULL COMMENT '更新用户id', 
	`modify_app` VARCHAR(32) DEFAULT NULL COMMENT '更新app', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号', 
	`residence_free_text` VARCHAR(256) DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt2', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'user_region_relation' 
 ); 



INSERT INTO t_user_region_nebula SELECT user_id,region_id,0,id,user_region_id,user_id,region_id,region_used_type,start_time,end_time,duration_type,duration_cost_type,status_type,region_context,building,unit,room,create_user,create_app,create_time,modify_user,modify_app,modify_time,del_stat,version_no,residence_free_text FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_region_mysql( 
	`id` INTEGER NOT NULL COMMENT '主键', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '地址编码', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '父地址编码', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '地址名称', 
	`region_type` TINYINT DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '地址全层次名称', 
	`leaf` TINYINT DEFAULT 0 COMMENT '是否叶子节点 0否 1是', 
	`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT DEFAULT 0 COMMENT '0：正常 1：删除', 
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
	`id` INTEGER NOT NULL COMMENT '主键', 
	`region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`parent_region_id` VARCHAR(64) DEFAULT NULL COMMENT '', 
	`region_code` VARCHAR(64) DEFAULT NULL COMMENT '地址编码', 
	`parent_region_code` VARCHAR(64) DEFAULT NULL COMMENT '父地址编码', 
	`region_name` VARCHAR(320) DEFAULT NULL COMMENT '地址名称', 
	`region_type` TINYINT DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', 
	`full_address` VARCHAR(2000) DEFAULT NULL COMMENT '地址全层次名称', 
	`leaf` TINYINT DEFAULT 0 COMMENT '是否叶子节点 0否 1是', 
	`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', 
	`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT DEFAULT 0 COMMENT '0：正常 1：删除', 
	`version_no` INTEGER DEFAULT NULL COMMENT '' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt2', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'region_region_relation' 
 ); 



INSERT INTO t_region_nebula SELECT region_id,parent_region_id,0,id,region_id,parent_region_id,region_code,parent_region_code,region_name,region_type,full_address,leaf,create_time,modify_time,del_stat,version_no FROM t_region_mysql; 



CREATE TABLE IF NOT EXISTS t_user_relation_mysql( 
	`id` INTEGER NOT NULL COMMENT '主键', 
	`relation_id` VARCHAR(32) NOT NULL COMMENT '关系id', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`related_user_id` VARCHAR(32) NOT NULL COMMENT '关联用户ID', 
	`relationship1` INTEGER NOT NULL COMMENT '一级关系 1血缘关系亲属及其配偶; 2婚姻关系亲属; 3法律拟制关系', 
	`relationship2` INTEGER NOT NULL COMMENT '二级关系类型，按照一级结构确定，结构过于复杂，不列出', 
	`start_time` DATETIME DEFAULT NULL COMMENT '开始时间', 
	`end_time` DATETIME DEFAULT NULL COMMENT '结束时间', 
	`status_type` INTEGER NOT NULL COMMENT '状态类别 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', 
	`roommate_status` TINYINT NOT NULL COMMENT '是否为当前同住人 1是 0否', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号', 
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
	`id` INTEGER NOT NULL COMMENT '主键', 
	`relation_id` VARCHAR(32) NOT NULL COMMENT '关系id', 
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID', 
	`related_user_id` VARCHAR(32) NOT NULL COMMENT '关联用户ID', 
	`relationship1` INTEGER NOT NULL COMMENT '一级关系 1血缘关系亲属及其配偶; 2婚姻关系亲属; 3法律拟制关系', 
	`relationship2` INTEGER NOT NULL COMMENT '二级关系类型，按照一级结构确定，结构过于复杂，不列出', 
	`start_time` DATETIME DEFAULT NULL COMMENT '开始时间', 
	`end_time` DATETIME DEFAULT NULL COMMENT '结束时间', 
	`status_type` INTEGER NOT NULL COMMENT '状态类别 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', 
	`roommate_status` TINYINT NOT NULL COMMENT '是否为当前同住人 1是 0否', 
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id', 
	`create_time` DATETIME NOT NULL COMMENT '创建时间', 
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id', 
	`modify_time` DATETIME NOT NULL COMMENT '修改时间', 
	`del_stat` TINYINT NOT NULL COMMENT '0：正常 1：删除', 
	`version_no` INTEGER NOT NULL COMMENT '版本号' 
 ) WITH ( 
	'connector' = 'nebula', 
	'meta-address' = '127.0.0.1:9559', 
	'graph-address' = '127.0.0.1:9669', 
	'username' = 'root', 
	'password' = 'nebula', 
	'graph-space' = 'jmt2', 
	'data-type' = 'edge', 
	'src-id-index' = '0', 
	'dst-id-index' = '1', 
	'rank-id-index' = '2', 
	'label-name' = 'user_user_relation' 
 ); 



INSERT INTO t_user_relation_nebula SELECT user_id,related_user_id,0,id,relation_id,user_id,related_user_id,relationship1,relationship2,start_time,end_time,status_type,roommate_status,create_user,create_time,modify_user,modify_time,del_stat,version_no FROM t_region_mysql; 
