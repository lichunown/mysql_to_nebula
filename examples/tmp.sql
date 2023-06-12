DROP SPACE IF EXISTS jmt3;
CREATE SPACE  jmt3 (vid_type=FIXED_STRING(64),partition_num=10,replica_factor=1);
use jmt3;CREATE TAG IF NOT EXISTS region (`region_id` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "",
	`id` INT32 NOT NULL  COMMENT "主键",
	`parent_region_id` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "",
	`region_code` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "地址编码",
	`parent_region_code` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "父地址编码",
	`region_name` FIXED_STRING(320) NULL DEFAULT NULL COMMENT "地址名称",
	`region_type` INT8 NULL DEFAULT NULL COMMENT "地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户",
	`full_address` FIXED_STRING(2000) NULL DEFAULT NULL COMMENT "地址全层次名称",
	`leaf` INT8 NULL DEFAULT 0 COMMENT "是否叶子节点 0否 1是",
	`create_time` TIMESTAMP NOT NULL  COMMENT "创建时间",
	`modify_time` TIMESTAMP NOT NULL  COMMENT "修改时间",
	`del_stat` INT8 NULL DEFAULT 0 COMMENT "0：正常 1：删除",
	`version_no` INT32 NULL DEFAULT NULL COMMENT "");

CREATE TAG INDEX IF NOT EXISTS `parent_region_address_id` ON region(`parent_region_id`,`del_stat`);
CREATE TAG INDEX IF NOT EXISTS `t_region_address_area_code_IDX` ON region(`region_code`,`del_stat`);
CREATE TAG INDEX IF NOT EXISTS `PRIMARY` ON region(`id`);
CREATE TAG INDEX IF NOT EXISTS `idx_modify_time` ON region(`modify_time`);
CREATE TAG INDEX IF NOT EXISTS `t_region_address_parent_area_code_IDX` ON region(`parent_region_code`);
CREATE TAG INDEX IF NOT EXISTS `full_address` ON region(`full_address`);
CREATE TAG INDEX IF NOT EXISTS `region_type` ON region(`region_type`);



CREATE EDGE IF NOT EXISTS parent (`region_id` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "",
	`parent_region_id` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "",
	`id` INT32 NOT NULL  COMMENT "主键",
	`region_code` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "地址编码",
	`parent_region_code` FIXED_STRING(64) NULL DEFAULT NULL COMMENT "父地址编码",
	`region_name` FIXED_STRING(320) NULL DEFAULT NULL COMMENT "地址名称",
	`region_type` INT8 NULL DEFAULT NULL COMMENT "地址类型，1-省 2-市 3-区县 4-乡镇/街道 5-社区/村屯  6-住宅小区 7-楼栋  8-单元  9-住户",
	`full_address` FIXED_STRING(2000) NULL DEFAULT NULL COMMENT "地址全层次名称",
	`leaf` INT8 NULL DEFAULT 0 COMMENT "是否叶子节点 0否 1是",
	`create_time` TIMESTAMP NOT NULL  COMMENT "创建时间",
	`modify_time` TIMESTAMP NOT NULL  COMMENT "修改时间",
	`del_stat` INT8 NULL DEFAULT 0 COMMENT "0：正常 1：删除",
	`version_no` INT32 NULL DEFAULT NULL COMMENT "");

CREATE EDGE INDEX IF NOT EXISTS `id` ON parent(`region_id`);
