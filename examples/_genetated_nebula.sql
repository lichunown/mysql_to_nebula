CREATE TAG IF NOT EXISTS user(`id` INT32 NOT NULL COMMENT '主键', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '用户ID', \ 
`auth_flag` INT32 NOT NULL COMMENT '是否注册认证 1认证；0非认证', \ 
`wx_open_id` FIXED_STRING(32) DEFAULT NULL COMMENT '微信openID', \ 
`name` FIXED_STRING(100) NOT NULL COMMENT '姓名', \ 
`sex` INT32 DEFAULT NULL COMMENT '性别 0男；1女', \ 
`birthday` DATE DEFAULT NULL COMMENT '生日', \ 
`in_Beijing` INT32 DEFAULT NULL COMMENT '是否在北京 1是 0否', \ 
`status_type` INT32 DEFAULT NULL COMMENT '信息状态 0待填报；1待确认(管理员)；2待确认(家人)；3已确认；-1无证件号用户', \ 
`create_user` FIXED_STRING(32) NOT NULL COMMENT '创建用户id', \ 
`create_time` DATETIME NOT NULL COMMENT '创建时间', \ 
`create_app` FIXED_STRING(32) DEFAULT NULL COMMENT '创建appId', \ 
`modify_user` FIXED_STRING(32) NOT NULL COMMENT '更新用户id', \ 
`modify_time` DATETIME NOT NULL COMMENT '修改时间', \ 
`modify_app` FIXED_STRING(32) DEFAULT NULL COMMENT '更新appId', \ 
`del_stat` INT16 NOT NULL COMMENT '0：正常 1：删除', \ 
`version_no` INT32 NOT NULL COMMENT '版本号') \ 
COMMENT='用户表'; 
CREATE TAG INDEX IF NOT EXISTS user_uniq_idx_user_id_user_id ON user(`uniq_idx_user_id`, `user_id`);
CREATE TAG INDEX IF NOT EXISTS user_uniq_open_id_wx_open_id ON user(`uniq_open_id`, `wx_open_id`);


CREATE TAG IF NOT EXISTS region(`id` INT32 NOT NULL COMMENT '主键', \ 
`region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`parent_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '地址编码', \ 
`parent_region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '父地址编码', \ 
`region_name` FIXED_STRING(320) DEFAULT NULL COMMENT '地址名称', \ 
`region_type` INT16 DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', \ 
`full_address` FIXED_STRING(2000) DEFAULT NULL COMMENT '地址全层次名称', \ 
`leaf` INT16 DEFAULT '0' COMMENT '是否叶子节点 0否 1是', \ 
`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', \ 
`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', \ 
`del_stat` INT16 DEFAULT '0' COMMENT '0：正常 1：删除', \ 
`version_no` INT32 DEFAULT NULL COMMENT '') \ 
COMMENT='行政区域表'; 
CREATE TAG INDEX IF NOT EXISTS region_t_region_address_id_IDX_region_id ON region(`t_region_address_id_IDX`, `region_id`);
CREATE TAG INDEX IF NOT EXISTS region_region_code_del_stat ON region(`region_code`, `del_stat`);
CREATE TAG INDEX IF NOT EXISTS region_parent_region_code ON region(`parent_region_code`);
CREATE TAG INDEX IF NOT EXISTS region_modify_time ON region(`modify_time`);
CREATE TAG INDEX IF NOT EXISTS region_full_address ON region(`full_address`);
CREATE TAG INDEX IF NOT EXISTS region_region_type ON region(`region_type`);
CREATE TAG INDEX IF NOT EXISTS region_parent_region_id_del_stat ON region(`parent_region_id`, `del_stat`);
CREATE TAG INDEX IF NOT EXISTS region_region_id ON region(`region_id`);


CREATE EDGE IF NOT EXISTS user_region_relation(`id` INT32 NOT NULL COMMENT '主键', \ 
`user_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '唯一id', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '用户ID', \ 
`region_id` FIXED_STRING(32) DEFAULT NULL COMMENT '地址编码', \ 
`region_used_type` INT32 DEFAULT NULL COMMENT '常驻地址类型 1家庭居住; 2工作常驻; 3外派出差; 4学校进修; 5度假疗养; 6隔离管控；7其他', \ 
`start_time` DATE DEFAULT NULL COMMENT '驻留开始时间', \ 
`end_time` DATE DEFAULT NULL COMMENT '驻留结束时间', \ 
`duration_type` INT32 DEFAULT NULL COMMENT '驻留周期 1持续驻留；2工作日驻留；3周末驻留；4每周1-3天；5每周4-6天', \ 
`duration_cost_type` INT32 DEFAULT NULL COMMENT '驻留费用承担方式 1自有购买；2个人租赁；3单位承担；4政府安置；5安赠继承', \ 
`status_type` INT32 DEFAULT NULL COMMENT '信息状态 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', \ 
`region_context` STRING DEFAULT NULL COMMENT '地址描述', \ 
`building` FIXED_STRING(64) DEFAULT NULL COMMENT '楼/栋', \ 
`unit` FIXED_STRING(32) DEFAULT NULL COMMENT '单元', \ 
`room` FIXED_STRING(32) DEFAULT NULL COMMENT '门牌号', \ 
`create_user` FIXED_STRING(32) DEFAULT NULL COMMENT '创建用户id', \ 
`create_app` FIXED_STRING(32) DEFAULT NULL COMMENT '创建app', \ 
`create_time` DATETIME NOT NULL COMMENT '创建时间', \ 
`modify_user` FIXED_STRING(32) DEFAULT NULL COMMENT '更新用户id', \ 
`modify_app` FIXED_STRING(32) DEFAULT NULL COMMENT '更新app', \ 
`modify_time` DATETIME NOT NULL COMMENT '修改时间', \ 
`del_stat` INT16 NOT NULL COMMENT '0：正常 1：删除', \ 
`version_no` INT32 NOT NULL COMMENT '版本号', \ 
`residence_free_text` FIXED_STRING(256) DEFAULT NULL COMMENT '') \ 
COMMENT='常驻地址表'; 
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_id ON user_region_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_user_region_id_UNIQUE_user_region_id ON user_region_relation(`user_region_id_UNIQUE`, `user_region_id`);
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_region_id_user_id ON user_region_relation(`region_id`, `user_id`);


CREATE EDGE IF NOT EXISTS region_region_relation(`id` INT32 NOT NULL COMMENT '主键', \ 
`region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`parent_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '地址编码', \ 
`parent_region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '父地址编码', \ 
`region_name` FIXED_STRING(320) DEFAULT NULL COMMENT '地址名称', \ 
`region_type` INT16 DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', \ 
`full_address` FIXED_STRING(2000) DEFAULT NULL COMMENT '地址全层次名称', \ 
`leaf` INT16 DEFAULT '0' COMMENT '是否叶子节点 0否 1是', \ 
`create_time` TIMESTAMP NOT NULL COMMENT '创建时间', \ 
`modify_time` TIMESTAMP NOT NULL COMMENT '修改时间', \ 
`del_stat` INT16 DEFAULT '0' COMMENT '0：正常 1：删除', \ 
`version_no` INT32 DEFAULT NULL COMMENT '') \ 
COMMENT='行政区域表'; 
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_id ON region_region_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_t_region_address_id_IDX_region_id ON region_region_relation(`t_region_address_id_IDX`, `region_id`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_code_del_stat ON region_region_relation(`region_code`, `del_stat`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_parent_region_code ON region_region_relation(`parent_region_code`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_modify_time ON region_region_relation(`modify_time`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_full_address ON region_region_relation(`full_address`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_type ON region_region_relation(`region_type`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_parent_region_id_del_stat ON region_region_relation(`parent_region_id`, `del_stat`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_id ON region_region_relation(`region_id`);


CREATE EDGE IF NOT EXISTS user_user_relation(`id` INT32 NOT NULL COMMENT '主键', \ 
`relation_id` FIXED_STRING(32) NOT NULL COMMENT '关系id', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '用户ID', \ 
`related_user_id` FIXED_STRING(32) NOT NULL COMMENT '关联用户ID', \ 
`relationship1` INT32 NOT NULL COMMENT '一级关系 1血缘关系亲属及其配偶; 2婚姻关系亲属; 3法律拟制关系', \ 
`relationship2` INT32 NOT NULL COMMENT '二级关系类型，按照一级结构确定，结构过于复杂，不列出', \ 
`start_time` DATETIME DEFAULT NULL COMMENT '开始时间', \ 
`end_time` DATETIME DEFAULT NULL COMMENT '结束时间', \ 
`status_type` INT32 NOT NULL COMMENT '状态类别 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', \ 
`roommate_status` INT16 NOT NULL COMMENT '是否为当前同住人 1是 0否', \ 
`create_user` FIXED_STRING(32) NOT NULL COMMENT '创建用户id', \ 
`create_time` DATETIME NOT NULL COMMENT '创建时间', \ 
`modify_user` FIXED_STRING(32) NOT NULL COMMENT '更新用户id', \ 
`modify_time` DATETIME NOT NULL COMMENT '修改时间', \ 
`del_stat` INT16 NOT NULL COMMENT '0：正常 1：删除', \ 
`version_no` INT32 NOT NULL COMMENT '版本号') \ 
COMMENT='用户关系表'; 
CREATE EDGE INDEX IF NOT EXISTS user_user_relation_id ON user_user_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS user_user_relation_idx_relation_id_relation_id ON user_user_relation(`idx_relation_id`, `relation_id`);