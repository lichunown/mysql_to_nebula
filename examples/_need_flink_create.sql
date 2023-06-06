SET execution.checkpointing.interval = 3s;

drop table if exists t_user_info_mysql;
CREATE TABLE t_user_info_mysql (
    `id` int,
    `user_id` VARCHAR(32),
    `auth_flag` INT,
    `wx_open_id` VARCHAR(32),
	  `name` VARCHAR(100),
	  `sex` int,
    `birthday` date,
    `in_Beijing` int,
	`status_type` int,
    `create_user` VARCHAR(32),
    `create_time` TIMESTAMP,
    `create_app` VARCHAR(32),
    `modify_user` VARCHAR(32),
    `modify_time` TIMESTAMP,
    `modify_app` VARCHAR(32),
    `del_stat` int,
    `version_no` int,
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

drop table if exists t_user_info_nebula;
CREATE TABLE t_user_info_nebula (
    `id` VARCHAR(64),
    `user_id` VARCHAR(32),
	  `name` VARCHAR(100),
    `create_user` VARCHAR(32),
    `modify_user` VARCHAR(32)
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

insert into t_user_info_nebula select user_id, user_id, name, create_user, modify_user from t_user_info_mysql;



  insert into t_user_info_nebula values ('user_idaaaa', 1, 'wx_open_id1111', 'lalala', 1, date '1997-4-12', 0, 1, 'test', TIMESTAMP '2023-5-31 00:00:00', 'no app', 'test', TIMESTAMP  '2023-5-31 00:00:00', 'no app', 0, 0);



    -- insert into t_user_info_nebula select * from t_user_info_mysql limit 10;

    -- 'write-mode' = 'insert',
    -- 'label-name' = 'user'

CREATE TABLE nba_player_nebula3 (
	  `vid` VARCHAR(32),
	  `age` BIGINT,
    `name` VARCHAR(100)
  ) WITH (
    'connector' = 'nebula',
    'meta-address' = '127.0.0.1:9559',
    'graph-address' = '127.0.0.1:9669',
    'username' = 'root',
    'password' = 'nebula',
    'graph-space' = 'nba',
    'data-type' = 'vertex',
    'label-name' = 'player'
  );

select * from nba_player_nebula2;
insert into nba_player_nebula3 values ('awtf', 18, 'awtf');
insert into nba_player_nebula3 values ('aaaaaaaaaaaa', 18, 'aaaaaaaaaaaaaaaa');


drop table if exists nba_like_nebula12;
CREATE TABLE nba_like_nebula12 (
    `sid` VARCHAR(32),
    `did` VARCHAR(32),
	  `rid`  BIGINT,
    `likeness` BIGINT
  ) WITH (
    'connector' = 'nebula',
    'meta-address' = '127.0.0.1:9559',
    'graph-address' = '127.0.0.1:9669',
    'username' = 'root',
    'password' = 'nebula',
    'graph-space' = 'nba',
    'data-type' = 'edge',
    'label-name' = 'like',
    'src-id-index' = '0',
    'dst-id-index' = '1',
    'rank-id-index' = '2'
  );
select * from nba_like_nebula12;


insert into nba_like_nebula12 values ('awtf', 'aaaaaaaaaaaa', 0, 99);


insert into nba_player_nebula2 select * from nba_player_nebula2 limit 10;