CREATE TAG IF NOT EXISTS user (user_id FIXED_STRING(32) NOT NULL COMMENT '用户ID', \
            auth_flag INT8 NOT NULL DEFAULT 0 COMMENT '是否注册认证 1认证；0非认证', \
            wx_open_id FIXED_STRING(32) NULL DEFAULT NULL COMMENT '微信openID', \
            name FIXED_STRING(100) NOT NULL COMMENT '姓名', \
            sex INT8 NULL DEFAULT NULL COMMENT '性别 0男；1女', \
            birthday DATE NULL DEFAULT NULL COMMENT '生日', \
            in_Beijing INT8 NULL DEFAULT NULL COMMENT '是否在北京 1是 0否', \
            status_type INT8 NULL DEFAULT NULL COMMENT '信息状态 0待填报；1待确认(管理员)；2待确认(家人)；3已确认；-1无证件号用户', \
            create_user FIXED_STRING(32) NOT NULL COMMENT '创建用户id', \
            create_time DATETIME NOT NULL DEFAULT datetime() COMMENT '创建时间', \
            create_app FIXED_STRING(32) NULL DEFAULT NULL COMMENT '创建appId', \
            modify_user FIXED_STRING(32) NOT NULL COMMENT '更新用户id', \
            modify_time DATETIME NOT NULL DEFAULT datetime() COMMENT '修改时间', \
            modify_app FIXED_STRING(32) NULL DEFAULT NULL COMMENT '更新appId', \
            del_stat INT8 NOT NULL DEFAULT 0 COMMENT '0：正常 1：删除', \
            version_no INT16 NOT NULL DEFAULT 0 COMMENT '版本号') \
            COMMENT='人信息';

## 创建 地 TAG
CREATE TAG IF NOT EXISTS region (region_id FIXED_STRING(64) NULL DEFAULT NULL, \
	    parent_region_id FIXED_STRING(64) NULL DEFAULT NULL, \
            region_code FIXED_STRING(64) NULL DEFAULT NULL COMMENT '地址编码', \
            region_name FIXED_STRING(320) NULL DEFAULT NULL COMMENT '地址名称', \
            region_type INT8 NULL DEFAULT NULL COMMENT '地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户', \
            full_address FIXED_STRING(2000) NULL DEFAULT NULL COMMENT '地址全层次名称', \
            leaf INT8 NULL DEFAULT 0 COMMENT '是否叶子节点 0否 1是', \
            create_time DATETIME NOT NULL DEFAULT datetime() COMMENT '创建时间', \
            modify_time DATETIME NOT NULL DEFAULT datetime() COMMENT '修改时间', \
            del_stat INT8 NULL DEFAULT 0 COMMENT '0：正常 1：删除', \
            version_no INT16 NULL DEFAULT NULL) \
            COMMENT='地信息';

## 创建 人-人 Edge type
CREATE EDGE IF NOT EXISTS user_user_relation (relation_id FIXED_STRING(32) NOT NULL COMMENT '关系id', \
            user_id FIXED_STRING(32) NOT NULL COMMENT '用户ID', \
	    related_user_id FIXED_STRING(32) NOT NULL COMMENT '关联用户ID', \
            relationship1 INT8 NOT NULL COMMENT '一级关系 1血缘关系亲属及其配偶; 2婚姻关系亲属; 3法律拟制关系', \
            relationship2 INT8 NOT NULL COMMENT '二级关系类型，按照一级结构确定，结构过于复杂，不列出', \
            start_time DATETIME NULL DEFAULT NULL COMMENT '开始时间', \
            end_time DATETIME NULL DEFAULT NULL COMMENT '结束时间', \
            status_type INT8 NOT NULL COMMENT '状态类别 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', \
            roommate_status INT8 NOT NULL DEFAULT 0 COMMENT '是否为当前同住人 1是 0否', \
            create_user FIXED_STRING(32) NOT NULL COMMENT '创建用户id', \
            create_time DATETIME NOT NULL DEFAULT datetime() COMMENT '创建时间', \
            modify_user FIXED_STRING(32) NOT NULL COMMENT '更新用户id', \
            modify_time DATETIME NOT NULL DEFAULT datetime() COMMENT '修改时间', \
            del_stat INT8 NOT NULL DEFAULT 0 COMMENT '0：正常 1：删除', \
            version_no INT16 NOT NULL DEFAULT 0 COMMENT '版本号') \
            COMMENT='人-人关系';

## 创建 地-地 Edge type
CREATE EDGE IF NOT EXISTS region_region_relation(region_id FIXED_STRING(64) NULL DEFAULT NULL, \
	        parent_region_id FIXED_STRING(64) NULL DEFAULT NULL, \
                region_code FIXED_STRING(64) NULL DEFAULT NULL COMMENT '地址编码', \
	        parent_region_code FIXED_STRING(64) NULL DEFAULT NULL COMMENT '父地址编码') \
            COMMENT='地-地关系';

## 创建 人-地 Edge type
CREATE EDGE IF NOT EXISTS user_region_relation(user_region_id FIXED_STRING(64) NULL DEFAULT NULL COMMENT '唯一id', \
            user_id FIXED_STRING(32) NOT NULL COMMENT '用户ID', \
	    region_id FIXED_STRING(32) NULL DEFAULT NULL COMMENT '地址编码', \
            region_used_type INT8 NULL DEFAULT NULL COMMENT '常驻地址类型 1家庭居住; 2工作常驻; 3外派出差; 4学校进修; 5度假疗养; 6隔离管控；7其他', \
            start_time DATE NULL DEFAULT NULL COMMENT '驻留开始时间', \
            end_time DATE NULL DEFAULT NULL COMMENT '驻留结束时间', \
            duration_type INT8 NULL DEFAULT NULL COMMENT '驻留周期 1持续驻留；2工作日驻留；3周末驻留；4每周1-3天；5每周4-6天', \
            duration_cost_type INT8 NULL DEFAULT NULL COMMENT '驻留费用承担方式 1自有购买；2个人租赁；3单位承担；4政府安置；5安赠继承', \
            status_type INT8 NULL DEFAULT NULL COMMENT '信息状态 0待填写；1待确认(管理员)；2待确认(家人)；3已确认', \
            region_context STRING NULL DEFAULT NULL COMMENT '地址描述', \
            building FIXED_STRING(64) NULL DEFAULT NULL COMMENT '楼/栋', \
            unit FIXED_STRING(32) NULL DEFAULT NULL COMMENT '单元', \
            room FIXED_STRING(32) NULL DEFAULT NULL COMMENT '门牌号', \
            residence_free_text2 FIXED_STRING(256) NULL DEFAULT NULL COMMENT '常驻地址自由文本', \
            create_user FIXED_STRING(32) NULL DEFAULT NULL COMMENT '创建用户id', \
            create_app FIXED_STRING(32) NULL DEFAULT NULL COMMENT '创建app', \
            create_time DATETIME NOT NULL DEFAULT datetime() COMMENT '创建时间', \
            modify_user FIXED_STRING(32) NULL DEFAULT NULL COMMENT '更新用户id', \
            modify_app FIXED_STRING(32) NULL DEFAULT NULL COMMENT '更新app', \
            modify_time DATETIME NOT NULL DEFAULT datetime() COMMENT '修改时间', \
            del_stat INT8 NOT NULL DEFAULT 0 COMMENT '0：正常 1：删除', \
            version_no INT16 NOT NULL DEFAULT 0 COMMENT '版本号', \
            residence_free_text FIXED_STRING(256) NULL DEFAULT NULL, \
            region_code FIXED_STRING(32) NULL DEFAULT NULL COMMENT '地址层级编码') \
            COMMENT='人-地关系';
