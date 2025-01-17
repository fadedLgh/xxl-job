#
创建数据库 并创建用户

CREATE
TABLESPACE XXL_JOB DATAFILE 'XXL_JOB.DBF' SIZE 128;

CREATE
USER XXL_JOB IDENTIFIED BY "XXL_JOB123" DEFAULT TABLESPACE "XXL_JOB";

GRANT RESOURCE TO XXL_JOB;


CREATE TABLE "XXL_JOB"."XXL_JOB_GROUP"
(
    "ID"           INT IDENTITY(1, 1) NOT NULL,
    "APP_NAME"     VARCHAR(64)   NOT NULL,
    "TITLE"        VARCHAR(64)   NOT NULL,
    "ADDRESS_TYPE" INT DEFAULT 0 NOT NULL,
    "ADDRESS_LIST" TEXT,
    "UPDATE_TIME"  TIMESTAMP(0),
    NOT            CLUSTER PRIMARY KEY("ID")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

CREATE UNIQUE INDEX "INDEX28886984886800" ON "XXL_JOB"."XXL_JOB_GROUP" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_info"
(
    "ID"                        INT IDENTITY(1, 1) NOT NULL,
    "JOB_GROUP"                 INT                               NOT NULL,
    "JOB_DESC"                  VARCHAR(64)                       NOT NULL,
    "ADD_TIME"                  TIMESTAMP(0),
    "UPDATE_TIME"               TIMESTAMP(0),
    "AUTHOR"                    VARCHAR(64),
    "ALARM_EMAIL"               VARCHAR(255),
    "SCHEDULE_TYPE"             VARCHAR(512) DEFAULT 'NONE'       NOT NULL,
    "SCHEDULE_CONF"             VARCHAR(50),
    "MISFIRE_STRATEGY"          VARCHAR(50)  DEFAULT 'DO_NOTHING' NOT NULL,
    "EXECUTOR_ROUTE_STRATEGY"   VARCHAR(128),
    "EXECUTOR_HANDLER"          VARCHAR(3900),
    "EXECUTOR_PARAM"            VARCHAR(50),
    "EXECUTOR_BLOCK_STRATEGY"   VARCHAR(50),
    "EXECUTOR_TIMEOUT"          INT          DEFAULT 0            NOT NULL,
    "EXECUTOR_FAIL_RETRY_COUNT" INT          DEFAULT 0            NOT NULL,
    "GLUE_TYPE"                 VARCHAR(50)                       NOT NULL,
    "GLUE_SOURCE"               TEXT,
    "GLUE_REMARK"               VARCHAR(128),
    "GLUE_UPDATETIME"           TIMESTAMP(0),
    "CHILD_JOB_ID"              VARCHAR(255),
    "TRIGGER_STATUS"            TINYINT      DEFAULT 0            NOT NULL,
    "TRIGGER_LAST_TIME"         BIGINT       DEFAULT 0            NOT NULL,
    "TRIGGER_NEXT_TIME"         BIGINT       DEFAULT 0            NOT NULL,
    NOT                         CLUSTER PRIMARY KEY("ID")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

CREATE UNIQUE INDEX "INDEX28886981133900" ON "XXL_JOB"."XXL_JOB_info" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_LOCK"
(
    "LOCK_NAME" VARCHAR(50) NOT NULL,
    NOT         CLUSTER PRIMARY KEY("LOCK_NAME")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOCK"."LOCK_NAME" IS '锁名称';


CREATE UNIQUE INDEX "INDEX28505579072800" ON "XXL_JOB"."XXL_JOB_LOCK" ("LOCK_NAME" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_LOG"
(
    "ID"                        BIGINT IDENTITY(1, 1) NOT NULL,
    "JOB_GROUP"                 INT               NOT NULL,
    "JOB_ID"                    INT               NOT NULL,
    "EXECUTOR_ADDRESS"          VARCHAR(255),
    "EXECUTOR_HANDLER"          VARCHAR(512),
    "EXECUTOR_PARAM"            VARCHAR(20),
    "EXECUTOR_SHARDING_PARAM"   VARCHAR(20),
    "EXECUTOR_FAIL_RETRY_COUNT" INT     DEFAULT 0 NOT NULL,
    "TRIGGER_TIME"              TIMESTAMP(0),
    "TRIGGER_CODE"              INT               NOT NULL,
    "TRIGGER_MSG"               TEXT,
    "HANDLE_TIME"               TIMESTAMP(0),
    "HANDLE_CODE"               INT               NOT NULL,
    "HANDLE_MSG"                TEXT,
    "ALARM_STATUS"              TINYINT DEFAULT 0 NOT NULL,
    NOT                         CLUSTER PRIMARY KEY("ID")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."ALARM_STATUS" IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."EXECUTOR_ADDRESS" IS '执行器地址，本次执行的地址';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."EXECUTOR_FAIL_RETRY_COUNT" IS '失败重试次数';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."EXECUTOR_HANDLER" IS '执行器任务handler';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."EXECUTOR_PARAM" IS '执行器任务参数';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."EXECUTOR_SHARDING_PARAM" IS '执行器任务分片参数，格式如 1/2';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."HANDLE_CODE" IS '执行-状态';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."HANDLE_MSG" IS '执行-日志';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."HANDLE_TIME" IS '执行-时间';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."JOB_GROUP" IS '执行器主键ID';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."JOB_ID" IS '任务，主键ID';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."TRIGGER_CODE" IS '调度-结果';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."TRIGGER_MSG" IS '调度-日志';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG"."TRIGGER_TIME" IS '调度-时间';


CREATE INDEX "I_TRIGGER_TIME" ON "XXL_JOB"."XXL_JOB_LOG" ("TRIGGER_TIME" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);
CREATE INDEX "I_HANDLE_CODE" ON "XXL_JOB"."XXL_JOB_LOG" ("HANDLE_CODE" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);
CREATE UNIQUE INDEX "INDEX28505560681100" ON "XXL_JOB"."XXL_JOB_LOG" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_LOG_REPORT"
(
    "ID"            INT IDENTITY(1, 1) NOT NULL,
    "TRIGGER_DAY"   TIMESTAMP(6),
    "RUNNING_COUNT" INT DEFAULT 0 NOT NULL,
    "SUC_COUNT"     INT DEFAULT 0 NOT NULL,
    "FAIL_COUNT"    INT DEFAULT 0 NOT NULL,
    "UPDATE_TIME"   TIMESTAMP(0),
    NOT             CLUSTER PRIMARY KEY("ID"),
    CONSTRAINT "I_TRIGGER_DAY" UNIQUE ("TRIGGER_DAY")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG_REPORT"."FAIL_COUNT" IS '执行失败-日志数量';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG_REPORT"."RUNNING_COUNT" IS '运行中-日志数量';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG_REPORT"."SUC_COUNT" IS '执行成功-日志数量';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOG_REPORT"."TRIGGER_DAY" IS '调度-时间';


CREATE UNIQUE INDEX "INDEX28505545217700" ON "XXL_JOB"."XXL_JOB_LOG_REPORT" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_LOGGLUE"
(
    "ID"          INT IDENTITY(1, 1) NOT NULL,
    "JOB_ID"      INT NOT NULL,
    "GLUE_TYPE"   VARCHAR(3900),
    "GLUE_SOURCE" CLOB,
    "GLUE_REMARK" INT NOT NULL,
    "ADD_TIME"    TIMESTAMP(0),
    "UPDATE_TIME" TIMESTAMP(0),
    NOT           CLUSTER PRIMARY KEY("ID")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOGGLUE"."GLUE_REMARK" IS 'GLUE备注';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOGGLUE"."GLUE_SOURCE" IS 'GLUE源代码';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOGGLUE"."GLUE_TYPE" IS 'GLUE类型';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_LOGGLUE"."JOB_ID" IS '任务，主键ID';


CREATE UNIQUE INDEX "INDEX28505534543500" ON "XXL_JOB"."XXL_JOB_LOGGLUE" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_registry"
(
    "ID"             INT IDENTITY(1, 1) NOT NULL,
    "REGISTRY_GROUP" VARCHAR(50)  NOT NULL,
    "REGISTRY_KEY"   VARCHAR(255) NOT NULL,
    "REGISTRY_VALUE" VARCHAR(255) NOT NULL,
    "UPDATE_TIME"    TIMESTAMP(0),
    NOT              CLUSTER PRIMARY KEY("ID")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

CREATE INDEX "I_G_K_V" ON "XXL_JOB"."XXL_JOB_registry" ("REGISTRY_GROUP" ASC, "REGISTRY_KEY" ASC, "REGISTRY_VALUE" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);
CREATE UNIQUE INDEX "INDEX28505530355400" ON "XXL_JOB"."XXL_JOB_registry" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


CREATE TABLE "XXL_JOB"."XXL_JOB_USER"
(
    "ID"         INT IDENTITY(1, 1) NOT NULL,
    "USERNAME"   VARCHAR(50)  NOT NULL,
    "PASSWORD"   VARCHAR(255) NOT NULL,
    "ROLE"       TINYINT      NOT NULL,
    "PERMISSION" VARCHAR(50),
    NOT          CLUSTER PRIMARY KEY("ID"),
    CONSTRAINT "I_USERNAME" UNIQUE ("USERNAME")
) STORAGE(ON "XXL_JOB", CLUSTERBTR);

COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_USER"."PASSWORD" IS '密码';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_USER"."PERMISSION" IS '权限：执行器ID列表，多个逗号分割';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_USER"."ROLE" IS '角色：0-普通用户、1-管理员';
COMMENT
ON COLUMN "XXL_JOB"."XXL_JOB_USER"."USERNAME" IS '账号';


CREATE UNIQUE INDEX "PRIMARY" ON "XXL_JOB"."XXL_JOB_USER" ("ID" ASC) STORAGE(ON "XXL_JOB", CLUSTERBTR);


INSERT INTO XXL_JOB.XXL_JOB_group(app_name, title, address_type, address_list, update_time)
VALUES ('xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31');
INSERT INTO XXL_JOB.XXL_JOB_info (job_group, job_desc, add_time, update_time, author, alarm_email, schedule_type,
                                  schedule_conf, misfire_strategy, executor_route_strategy,
                                  executor_handler, executor_param, executor_block_strategy, executor_timeout,
                                  executor_fail_retry_count, glue_type, glue_source, glue_remark, glue_updatetime,
                                  child_job_id,
                                  trigger_status, trigger_last_time, trigger_next_time)
VALUES (1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *', 'DO_NOTHING',
        'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化', '2018-11-03 22:21:31', '', 0,
        0, 0);
INSERT INTO XXL_JOB.XXL_JOB_user(username, password, role, permission)
VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);
INSERT INTO XXL_JOB.XXL_JOB_lock (lock_name)
VALUES ('schedule_lock');

commit;