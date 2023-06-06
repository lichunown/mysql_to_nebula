CREATE TAG IF NOT EXISTS user(`id` INT32 NOT NULL COMMENT '����', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '�û�ID', \ 
`auth_flag` INT32 NOT NULL COMMENT '�Ƿ�ע����֤ 1��֤��0����֤', \ 
`wx_open_id` FIXED_STRING(32) DEFAULT NULL COMMENT '΢��openID', \ 
`name` FIXED_STRING(100) NOT NULL COMMENT '����', \ 
`sex` INT32 DEFAULT NULL COMMENT '�Ա� 0�У�1Ů', \ 
`birthday` DATE DEFAULT NULL COMMENT '����', \ 
`in_Beijing` INT32 DEFAULT NULL COMMENT '�Ƿ��ڱ��� 1�� 0��', \ 
`status_type` INT32 DEFAULT NULL COMMENT '��Ϣ״̬ 0�����1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ�ϣ�-1��֤�����û�', \ 
`create_user` FIXED_STRING(32) NOT NULL COMMENT '�����û�id', \ 
`create_time` DATETIME NOT NULL COMMENT '����ʱ��', \ 
`create_app` FIXED_STRING(32) DEFAULT NULL COMMENT '����appId', \ 
`modify_user` FIXED_STRING(32) NOT NULL COMMENT '�����û�id', \ 
`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', \ 
`modify_app` FIXED_STRING(32) DEFAULT NULL COMMENT '����appId', \ 
`del_stat` INT16 NOT NULL COMMENT '0������ 1��ɾ��', \ 
`version_no` INT32 NOT NULL COMMENT '�汾��') \ 
COMMENT='�û���'; 
CREATE TAG INDEX IF NOT EXISTS user_uniq_idx_user_id_user_id ON user(`uniq_idx_user_id`, `user_id`);
CREATE TAG INDEX IF NOT EXISTS user_uniq_open_id_wx_open_id ON user(`uniq_open_id`, `wx_open_id`);


CREATE TAG IF NOT EXISTS region(`id` INT32 NOT NULL COMMENT '����', \ 
`region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`parent_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '��ַ����', \ 
`parent_region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '����ַ����', \ 
`region_name` FIXED_STRING(320) DEFAULT NULL COMMENT '��ַ����', \ 
`region_type` INT16 DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', \ 
`full_address` FIXED_STRING(2000) DEFAULT NULL COMMENT '��ַȫ�������', \ 
`leaf` INT16 DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', \ 
`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', \ 
`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', \ 
`del_stat` INT16 DEFAULT '0' COMMENT '0������ 1��ɾ��', \ 
`version_no` INT32 DEFAULT NULL COMMENT '') \ 
COMMENT='���������'; 
CREATE TAG INDEX IF NOT EXISTS region_t_region_address_id_IDX_region_id ON region(`t_region_address_id_IDX`, `region_id`);
CREATE TAG INDEX IF NOT EXISTS region_region_code_del_stat ON region(`region_code`, `del_stat`);
CREATE TAG INDEX IF NOT EXISTS region_parent_region_code ON region(`parent_region_code`);
CREATE TAG INDEX IF NOT EXISTS region_modify_time ON region(`modify_time`);
CREATE TAG INDEX IF NOT EXISTS region_full_address ON region(`full_address`);
CREATE TAG INDEX IF NOT EXISTS region_region_type ON region(`region_type`);
CREATE TAG INDEX IF NOT EXISTS region_parent_region_id_del_stat ON region(`parent_region_id`, `del_stat`);
CREATE TAG INDEX IF NOT EXISTS region_region_id ON region(`region_id`);


CREATE EDGE IF NOT EXISTS user_region_relation(`id` INT32 NOT NULL COMMENT '����', \ 
`user_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT 'Ψһid', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '�û�ID', \ 
`region_id` FIXED_STRING(32) DEFAULT NULL COMMENT '��ַ����', \ 
`region_used_type` INT32 DEFAULT NULL COMMENT '��פ��ַ���� 1��ͥ��ס; 2������פ; 3���ɳ���; 4ѧУ����; 5�ȼ�����; 6����ܿأ�7����', \ 
`start_time` DATE DEFAULT NULL COMMENT 'פ����ʼʱ��', \ 
`end_time` DATE DEFAULT NULL COMMENT 'פ������ʱ��', \ 
`duration_type` INT32 DEFAULT NULL COMMENT 'פ������ 1����פ����2������פ����3��ĩפ����4ÿ��1-3�죻5ÿ��4-6��', \ 
`duration_cost_type` INT32 DEFAULT NULL COMMENT 'פ�����óе���ʽ 1���й���2�������ޣ�3��λ�е���4�������ã�5�����̳�', \ 
`status_type` INT32 DEFAULT NULL COMMENT '��Ϣ״̬ 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', \ 
`region_context` STRING DEFAULT NULL COMMENT '��ַ����', \ 
`building` FIXED_STRING(64) DEFAULT NULL COMMENT '¥/��', \ 
`unit` FIXED_STRING(32) DEFAULT NULL COMMENT '��Ԫ', \ 
`room` FIXED_STRING(32) DEFAULT NULL COMMENT '���ƺ�', \ 
`create_user` FIXED_STRING(32) DEFAULT NULL COMMENT '�����û�id', \ 
`create_app` FIXED_STRING(32) DEFAULT NULL COMMENT '����app', \ 
`create_time` DATETIME NOT NULL COMMENT '����ʱ��', \ 
`modify_user` FIXED_STRING(32) DEFAULT NULL COMMENT '�����û�id', \ 
`modify_app` FIXED_STRING(32) DEFAULT NULL COMMENT '����app', \ 
`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', \ 
`del_stat` INT16 NOT NULL COMMENT '0������ 1��ɾ��', \ 
`version_no` INT32 NOT NULL COMMENT '�汾��', \ 
`residence_free_text` FIXED_STRING(256) DEFAULT NULL COMMENT '') \ 
COMMENT='��פ��ַ��'; 
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_id ON user_region_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_user_region_id_UNIQUE_user_region_id ON user_region_relation(`user_region_id_UNIQUE`, `user_region_id`);
CREATE EDGE INDEX IF NOT EXISTS user_region_relation_region_id_user_id ON user_region_relation(`region_id`, `user_id`);


CREATE EDGE IF NOT EXISTS region_region_relation(`id` INT32 NOT NULL COMMENT '����', \ 
`region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`parent_region_id` FIXED_STRING(64) DEFAULT NULL COMMENT '', \ 
`region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '��ַ����', \ 
`parent_region_code` FIXED_STRING(64) DEFAULT NULL COMMENT '����ַ����', \ 
`region_name` FIXED_STRING(320) DEFAULT NULL COMMENT '��ַ����', \ 
`region_type` INT16 DEFAULT NULL COMMENT '��ַ���ͣ�1-ʡ 2-�� 3-���� 4-����/�ֵ� 5-����/����  6-סլС�� 7-¥��  8-��Ԫ  9-ס��', \ 
`full_address` FIXED_STRING(2000) DEFAULT NULL COMMENT '��ַȫ�������', \ 
`leaf` INT16 DEFAULT '0' COMMENT '�Ƿ�Ҷ�ӽڵ� 0�� 1��', \ 
`create_time` TIMESTAMP NOT NULL COMMENT '����ʱ��', \ 
`modify_time` TIMESTAMP NOT NULL COMMENT '�޸�ʱ��', \ 
`del_stat` INT16 DEFAULT '0' COMMENT '0������ 1��ɾ��', \ 
`version_no` INT32 DEFAULT NULL COMMENT '') \ 
COMMENT='���������'; 
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_id ON region_region_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_t_region_address_id_IDX_region_id ON region_region_relation(`t_region_address_id_IDX`, `region_id`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_code_del_stat ON region_region_relation(`region_code`, `del_stat`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_parent_region_code ON region_region_relation(`parent_region_code`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_modify_time ON region_region_relation(`modify_time`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_full_address ON region_region_relation(`full_address`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_type ON region_region_relation(`region_type`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_parent_region_id_del_stat ON region_region_relation(`parent_region_id`, `del_stat`);
CREATE EDGE INDEX IF NOT EXISTS region_region_relation_region_id ON region_region_relation(`region_id`);


CREATE EDGE IF NOT EXISTS user_user_relation(`id` INT32 NOT NULL COMMENT '����', \ 
`relation_id` FIXED_STRING(32) NOT NULL COMMENT '��ϵid', \ 
`user_id` FIXED_STRING(32) NOT NULL COMMENT '�û�ID', \ 
`related_user_id` FIXED_STRING(32) NOT NULL COMMENT '�����û�ID', \ 
`relationship1` INT32 NOT NULL COMMENT 'һ����ϵ 1ѪԵ��ϵ����������ż; 2������ϵ����; 3�������ƹ�ϵ', \ 
`relationship2` INT32 NOT NULL COMMENT '������ϵ���ͣ�����һ���ṹȷ�����ṹ���ڸ��ӣ����г�', \ 
`start_time` DATETIME DEFAULT NULL COMMENT '��ʼʱ��', \ 
`end_time` DATETIME DEFAULT NULL COMMENT '����ʱ��', \ 
`status_type` INT32 NOT NULL COMMENT '״̬��� 0����д��1��ȷ��(����Ա)��2��ȷ��(����)��3��ȷ��', \ 
`roommate_status` INT16 NOT NULL COMMENT '�Ƿ�Ϊ��ǰͬס�� 1�� 0��', \ 
`create_user` FIXED_STRING(32) NOT NULL COMMENT '�����û�id', \ 
`create_time` DATETIME NOT NULL COMMENT '����ʱ��', \ 
`modify_user` FIXED_STRING(32) NOT NULL COMMENT '�����û�id', \ 
`modify_time` DATETIME NOT NULL COMMENT '�޸�ʱ��', \ 
`del_stat` INT16 NOT NULL COMMENT '0������ 1��ɾ��', \ 
`version_no` INT32 NOT NULL COMMENT '�汾��') \ 
COMMENT='�û���ϵ��'; 
CREATE EDGE INDEX IF NOT EXISTS user_user_relation_id ON user_user_relation(`id`);
CREATE EDGE INDEX IF NOT EXISTS user_user_relation_idx_relation_id_relation_id ON user_user_relation(`idx_relation_id`, `relation_id`);