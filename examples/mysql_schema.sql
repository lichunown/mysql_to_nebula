CREATE TABLE `t_user_info` (
	`id` INT(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID' COLLATE 'utf8mb4_general_ci',
	`auth_flag` INT(1) NOT NULL DEFAULT '0' COMMENT '是否注册认证 1认证；0非认证',
	`wx_open_id` VARCHAR(32) NULL DEFAULT NULL COMMENT '微信openID' COLLATE 'utf8mb4_general_ci',
	`name` VARCHAR(100) NOT NULL COMMENT '姓名' COLLATE 'utf8_bin',
	`sex` INT(1) NULL DEFAULT NULL COMMENT '性别 0男；1女',
	`birthday` DATE NULL DEFAULT NULL COMMENT '生日',
	`in_Beijing` INT(1) NULL DEFAULT NULL COMMENT '是否在北京 1是 0否',
	`status_type` INT(2) NULL DEFAULT NULL COMMENT '信息状态 0待填报；1待确认(管理员)；2待确认(家人)；3已确认；-1无证件号用户',
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id' COLLATE 'utf8_bin',
	`create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`create_app` VARCHAR(32) NULL DEFAULT NULL COMMENT '创建appId' COLLATE 'utf8mb4_general_ci',
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id' COLLATE 'utf8_bin',
	`modify_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
	`modify_app` VARCHAR(32) NULL DEFAULT NULL COMMENT '更新appId' COLLATE 'utf8mb4_general_ci',
	`del_stat` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0：正常 1：删除',
	`version_no` INT(11) NOT NULL DEFAULT '0' COMMENT '版本号',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `uniq_idx_user_id` (`user_id`) USING BTREE,
	UNIQUE INDEX `uniq_open_id` (`wx_open_id`) USING BTREE
)
COMMENT='用户表'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=585144
;



CREATE TABLE `t_region` (
	`id` INT(50) NOT NULL AUTO_INCREMENT COMMENT '主键',
	`region_id` VARCHAR(64) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`parent_region_id` VARCHAR(64) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	`region_code` VARCHAR(64) NULL DEFAULT NULL COMMENT '地址编码' COLLATE 'utf8mb4_general_ci',
	`parent_region_code` VARCHAR(64) NULL DEFAULT NULL COMMENT '父地址编码' COLLATE 'utf8mb4_general_ci',
	`region_name` VARCHAR(320) NULL DEFAULT NULL COMMENT '地址名称' COLLATE 'utf8mb4_general_ci',
	`region_type` TINYINT(3) UNSIGNED NULL DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户',
	`full_address` VARCHAR(2000) NULL DEFAULT NULL COMMENT '地址全层次名称' COLLATE 'utf8mb4_general_ci',
	`leaf` TINYINT(2) UNSIGNED NULL DEFAULT '0' COMMENT '是否叶子节点 0否 1是',
	`create_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`modify_time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
	`del_stat` TINYINT(1) NULL DEFAULT '0' COMMENT '0：正常 1：删除',
	`version_no` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `t_region_address_id_IDX` (`region_id`) USING BTREE,
	INDEX `t_region_address_area_code_IDX` (`region_code`, `del_stat`) USING BTREE,
	INDEX `t_region_address_parent_area_code_IDX` (`parent_region_code`) USING BTREE,
	INDEX `idx_modify_time` (`modify_time`) USING BTREE,
	INDEX `full_address` (`full_address`(250)) USING BTREE,
	INDEX `region_type` (`region_type`) USING BTREE,
	INDEX `parent_region_address_id` (`parent_region_id`, `del_stat`) USING BTREE,
	INDEX `idx_region_id` (`region_id`) USING BTREE
)
COMMENT='行政区域表'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
AUTO_INCREMENT=158183
;


CREATE TABLE `t_user_region` (
	`id` INT(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
	`user_region_id` VARCHAR(64) NULL DEFAULT NULL COMMENT '唯一id' COLLATE 'utf8mb4_general_ci',
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID' COLLATE 'utf8mb4_general_ci',
	`region_id` VARCHAR(32) NULL DEFAULT NULL COMMENT '地址编码' COLLATE 'utf8mb4_general_ci',
	`region_used_type` INT(2) NULL DEFAULT NULL COMMENT '常驻地址类型 1家庭居住; 2工作常驻; 3外派出差; 4学校进修; 5度假疗养; 6隔离管控；7其他',
	`start_time` DATE NULL DEFAULT NULL COMMENT '驻留开始时间',
	`end_time` DATE NULL DEFAULT NULL COMMENT '驻留结束时间',
	`duration_type` INT(2) NULL DEFAULT NULL COMMENT '驻留周期 1持续驻留；2工作日驻留；3周末驻留；4每周1-3天；5每周4-6天',
	`duration_cost_type` INT(2) NULL DEFAULT NULL COMMENT '驻留费用承担方式 1自有购买；2个人租赁；3单位承担；4政府安置；5安赠继承',
	`status_type` INT(2) NULL DEFAULT NULL COMMENT '信息状态 0待填写；1待确认(管理员)；2待确认(家人)；3已确认',
	`region_context` JSON NULL DEFAULT NULL COMMENT '地址描述',
	`building` VARCHAR(64) NULL DEFAULT NULL COMMENT '楼/栋' COLLATE 'utf8mb4_general_ci',
	`unit` VARCHAR(32) NULL DEFAULT NULL COMMENT '单元' COLLATE 'utf8mb4_general_ci',
	`room` VARCHAR(32) NULL DEFAULT NULL COMMENT '门牌号' COLLATE 'utf8mb4_general_ci',
	`create_user` VARCHAR(32) NULL DEFAULT NULL COMMENT '创建用户id' COLLATE 'utf8_bin',
	`create_app` VARCHAR(32) NULL DEFAULT NULL COMMENT '创建app' COLLATE 'utf8mb4_general_ci',
	`create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`modify_user` VARCHAR(32) NULL DEFAULT NULL COMMENT '更新用户id' COLLATE 'utf8_bin',
	`modify_app` VARCHAR(32) NULL DEFAULT NULL COMMENT '更新app' COLLATE 'utf8mb4_general_ci',
	`modify_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
	`del_stat` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0：正常 1：删除',
	`version_no` INT(11) NOT NULL DEFAULT '0' COMMENT '版本号',
	`residence_free_text` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `user_region_id_UNIQUE` (`user_region_id`) USING BTREE,
	INDEX `idx_user_region_id` (`region_id`, `user_id`) USING BTREE
)
COMMENT='常驻地址表'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=86442
;


CREATE TABLE `t_user_relation` (
	`id` INT(10) NOT NULL AUTO_INCREMENT COMMENT '主键',
	`relation_id` VARCHAR(32) NOT NULL COMMENT '关系id' COLLATE 'utf8mb4_general_ci',
	`user_id` VARCHAR(32) NOT NULL COMMENT '用户ID' COLLATE 'utf8mb4_general_ci',
	`related_user_id` VARCHAR(32) NOT NULL COMMENT '关联用户ID' COLLATE 'utf8mb4_general_ci',
	`relationship1` INT(2) NOT NULL COMMENT '一级关系 1血缘关系亲属及其配偶; 2婚姻关系亲属; 3法律拟制关系',
	`relationship2` INT(2) NOT NULL COMMENT '二级关系类型，按照一级结构确定，结构过于复杂，不列出',
	`start_time` DATETIME NULL DEFAULT NULL COMMENT '开始时间',
	`end_time` DATETIME NULL DEFAULT NULL COMMENT '结束时间',
	`status_type` INT(2) NOT NULL COMMENT '状态类别 0待填写；1待确认(管理员)；2待确认(家人)；3已确认',
	`roommate_status` TINYINT(2) NOT NULL DEFAULT '0' COMMENT '是否为当前同住人 1是 0否',
	`create_user` VARCHAR(32) NOT NULL COMMENT '创建用户id' COLLATE 'utf8_bin',
	`create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
	`modify_user` VARCHAR(32) NOT NULL COMMENT '更新用户id' COLLATE 'utf8_bin',
	`modify_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
	`del_stat` TINYINT(1) NOT NULL DEFAULT '0' COMMENT '0：正常 1：删除',
	`version_no` INT(11) NOT NULL DEFAULT '0' COMMENT '版本号',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `idx_relation_id` (`relation_id`) USING BTREE
)
COMMENT='用户关系表'
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1360
;
