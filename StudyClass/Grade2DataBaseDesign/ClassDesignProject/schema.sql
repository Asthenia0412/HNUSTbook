-- 如果数据库已经存在，先删除
DROP DATABASE IF EXISTS dataBaseDesign;

-- 创建新的数据库，指定字符集为 utf8mb4，并设置排序规则为 utf8mb4_general_ci
CREATE DATABASE dataBaseDesign
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;

-- 创建员工表
CREATE TABLE Object_Person (
    ID INT NOT NULL AUTO_INCREMENT,           -- 员工号（主键，唯一标识员工）
    PASSWD VARCHAR(255) NOT NULL COMMENT '密码（存储加密密码）',             -- 密码（存储加密密码）
    AUTHORITY ENUM('admin', 'user', 'manager') NOT NULL COMMENT '用户权限（管理员、用户、经理等）', -- 用户权限（管理员、用户、经理等）
    NAME VARCHAR(100) NOT NULL COMMENT '姓名',               -- 姓名
    SEX ENUM('M', 'F') NOT NULL COMMENT '性别（M-男，F-女）',              -- 性别（M-男，F-女）
    BIRTHDAY DATE NOT NULL COMMENT '生日（格式：YYYY-MM-DD）',                   -- 生日（格式：YYYY-MM-DD）
    DEPARTMENT VARCHAR(100) NOT NULL COMMENT '所在部门',         -- 所在部门
    JOB VARCHAR(100) NOT NULL COMMENT '职务',                -- 职务
    EDU_LEVEL VARCHAR(50) NOT NULL COMMENT '受教育程度',           -- 受教育程度
    SPCIALTY VARCHAR(100) NOT NULL COMMENT '专业技能',           -- 专业技能
    ADDRESS VARCHAR(255) NOT NULL COMMENT '家庭住址',            -- 家庭住址
    TEL VARCHAR(15) NOT NULL COMMENT '联系电话',                 -- 联系电话
    EMAIL VARCHAR(100) NOT NULL COMMENT '电子邮箱',              -- 电子邮箱
    STATE ENUM('T', 'F') NOT NULL COMMENT '当前状态（T-员工，F-非员工）',            -- 当前状态（T-员工，F-非员工）
    REMARK TEXT COMMENT '备注（可空）',                              -- 备注（可空）
    PRIMARY KEY (ID) COMMENT '设置主键为员工号（ID）'                          -- 设置主键为员工号（ID）
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;  -- 设置字符集和排序规则

-- 创建 Object_EduLevel 表
CREATE TABLE Object_EduLevel (
    CODE INT NOT NULL COMMENT '代码',                 -- 代码（唯一标识教育级别）
    DESCRIPTION VARCHAR(50) NOT NULL COMMENT '描述',   -- 描述（教育级别的描述）
    PRIMARY KEY (CODE) COMMENT '设置主键为代码字段'  -- 设置主键为代码字段
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;   -- 设置字符集和排序规则

-- 创建 Object_Job 表
CREATE TABLE Object_Job (
    CODE INT NOT NULL COMMENT '代码',                 -- 代码（唯一标识职务）
    DESCRIPTION VARCHAR(50) NOT NULL COMMENT '描述',   -- 描述（职务的描述）
    PRIMARY KEY (CODE) COMMENT '设置主键为代码字段'  -- 设置主键为代码字段
) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;   -- 设置字符集和排序规则

-- 插入数据到 Object_Job 表
INSERT INTO Object_Job (CODE, DESCRIPTION) VALUES
(0, '小学'),
(1, '初中'),
(2, '高中'),
(3, '职高'),
(4, '大本'),
(5, '大专'),
(6, '硕士'),
(7, '博士'),
(8, '博士后');

CREATE TABLE Object_Department (
    ID INT NOT NULL AUTO_INCREMENT COMMENT '部门编号，设置为自增，作为每个部门的唯一标识符',  -- 部门编号，设置为自增
    NAME VARCHAR(100) NOT NULL COMMENT '部门名称，不能为空，用于标识部门的名称',              -- 部门名称
    MANAGER VARCHAR(100) NOT NULL COMMENT '部门经理，不能为空，记录该部门的负责人',            -- 部门经理
    INTRO TEXT NOT NULL COMMENT '部门简介，不能为空，用于简要描述部门的功能和职责',            -- 部门简介
    PRIMARY KEY (ID) COMMENT '设置 ID 字段为主键，确保每个部门的唯一性'                       -- 设置 ID 为主键
);

CREATE TABLE Object_PersonnelChange (
    CODE VARCHAR(50) NOT NULL COMMENT '变更代码，不能为空，作为每种变更类型的唯一标识符',  -- 代码，不能为空
    DESCRIPTION VARCHAR(255) NOT NULL COMMENT '变更类型的描述，不能为空，用于简要说明变更的内容',  -- 描述，不能为空
    PRIMARY KEY (CODE) COMMENT '设置 CODE 字段为主键，保证变更代码的唯一性'  -- 设置 CODE 为主键
);

INSERT INTO Object_PersonnelChange (CODE, DESCRIPTION)
VALUES 
    ('0', '新员工加入'),
    ('1', '职务变动'),
    ('2', '辞退');

CREATE TABLE Relation_Personnel (
    ID INT NOT NULL AUTO_INCREMENT COMMENT '记录编号，设置为自增，作为每条记录的唯一标识符',   -- 记录编号，设置为自增
    PERSON VARCHAR(50) NOT NULL COMMENT '员工号，不能为空，用于标识该条记录所属的员工',         -- 员工号，不能为空
    Change_ VARCHAR(50) NOT NULL COMMENT '变更代码，不能为空，表示记录的变更类型',                 -- 变更代码，不能为空
    DESCRIPTION TEXT NOT NULL COMMENT '详细记录，不能为空，用于存储变更的具体描述信息',           -- 详细记录，不能为空
    PRIMARY KEY (ID) COMMENT '设置 ID 字段为主键，确保每条记录的唯一性'                   -- 设置 ID 为主
);
