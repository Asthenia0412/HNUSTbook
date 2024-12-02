/*
 Navicat Premium Data Transfer

 Source Server         : (开虚拟机)MySQL服务
 Source Server Type    : MySQL
 Source Server Version : 50742 (5.7.42-0ubuntu0.18.04.1)
 Source Host           : 192.168.11.128:3306
 Source Schema         : dataBaseDesign

 Target Server Type    : MySQL
 Target Server Version : 50742 (5.7.42-0ubuntu0.18.04.1)
 File Encoding         : 65001

 Date: 17/11/2024 15:37:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for Object_Department
-- ----------------------------
DROP TABLE IF EXISTS `Object_Department`;
CREATE TABLE `Object_Department`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '部门编号，设置为自增，作为每个部门的唯一标识符',
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门名称，不能为空，用于标识部门的名称',
  `MANAGER` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门经理，不能为空，记录该部门的负责人',
  `INTRO` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '部门简介，不能为空，用于简要描述部门的功能和职责',
  PRIMARY KEY (`ID`) USING BTREE COMMENT '设置 ID 字段为主键，确保每个部门的唯一性',
  INDEX `NAME`(`NAME`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_Department
-- ----------------------------
INSERT INTO `Object_Department` VALUES (1, '技术部', NULL, NULL);
INSERT INTO `Object_Department` VALUES (2, '后勤部', NULL, NULL);
INSERT INTO `Object_Department` VALUES (3, '行政部', NULL, NULL);

-- ----------------------------
-- Table structure for Object_EduLevel
-- ----------------------------
DROP TABLE IF EXISTS `Object_EduLevel`;
CREATE TABLE `Object_EduLevel`  (
  `NAME` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码',
  `DESCRIPTION` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  PRIMARY KEY (`NAME`) USING BTREE COMMENT '设置主键为代码字段'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_EduLevel
-- ----------------------------
INSERT INTO `Object_EduLevel` VALUES ('初中', '初级中学教育阶段');
INSERT INTO `Object_EduLevel` VALUES ('博士', '博士研究生阶段');
INSERT INTO `Object_EduLevel` VALUES ('博士后', '博士后科研阶段');
INSERT INTO `Object_EduLevel` VALUES ('大专', '专科学历教育');
INSERT INTO `Object_EduLevel` VALUES ('大本', '本科高等教育');
INSERT INTO `Object_EduLevel` VALUES ('小学', '基础教育阶段');
INSERT INTO `Object_EduLevel` VALUES ('硕士', '硕士研究生阶段');
INSERT INTO `Object_EduLevel` VALUES ('职高', '职业技术教育阶段');
INSERT INTO `Object_EduLevel` VALUES ('高中', '高级中学教育阶段');

-- ----------------------------
-- Table structure for Object_Job
-- ----------------------------
DROP TABLE IF EXISTS `Object_Job`;
CREATE TABLE `Object_Job`  (
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '代码',
  `DESCRIPTION` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '描述',
  PRIMARY KEY (`NAME`) USING BTREE COMMENT '设置主键为代码字段'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_Job
-- ----------------------------
INSERT INTO `Object_Job` VALUES ('中级职称', '负责独立完成项目，能够指导初级职员，具备一定的管理能力');
INSERT INTO `Object_Job` VALUES ('初级职称', '负责基础工作，执行日常任务，学习并掌握相关技能');
INSERT INTO `Object_Job` VALUES ('高级职称', '负责战略规划和决策，管理团队，具有深厚的行业经验和领导力');

-- ----------------------------
-- Table structure for Object_Person
-- ----------------------------
DROP TABLE IF EXISTS `Object_Person`;
CREATE TABLE `Object_Person`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PASSWD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（存储加密密码）',
  `AUTHORITY` enum('admin','user','manager') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户权限（管理员、用户、经理等）',
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `SEX` enum('M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '性别（M-男，F-女）',
  `BIRTHDAY` date NOT NULL COMMENT '生日（格式：YYYY-MM-DD）',
  `DEPARTMENT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所在部门',
  `JOB` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '职务',
  `EDU_LEVEL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '受教育程度',
  `SPCIALTY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '专业技能',
  `ADDRESS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '家庭住址',
  `TEL` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系电话',
  `EMAIL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子邮箱',
  `STATE` enum('T','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '当前状态（T-员工，F-非员工）',
  `REMARK` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注（可空）',
  PRIMARY KEY (`ID`) USING BTREE COMMENT '设置主键为员工号（ID）',
  INDEX `f1`(`JOB`) USING BTREE,
  INDEX `f2`(`DEPARTMENT`) USING BTREE,
  INDEX `f3`(`EDU_LEVEL`) USING BTREE,
  CONSTRAINT `f1` FOREIGN KEY (`JOB`) REFERENCES `Object_Job` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `f2` FOREIGN KEY (`DEPARTMENT`) REFERENCES `Object_Department` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `f3` FOREIGN KEY (`EDU_LEVEL`) REFERENCES `Object_EduLevel` (`NAME`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_Person
-- ----------------------------
INSERT INTO `Object_Person` VALUES (6, '123456', 'admin', '张三', 'F', '1990-05-12', '技术部', '初级职称', '大本', '计算机科学', '北京市朝阳区XXX街道', '13812345678', 'zhangsan@example.com', 'T', '暂无备注');
INSERT INTO `Object_Person` VALUES (7, 'password123', 'admin', '张三', 'M', '1985-02-14', '技术部', '初级职称', '硕士', '软件工程', '北京市朝阳区', '13800000001', 'zhangsan@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (8, 'password456', 'user', '李四', 'F', '1990-03-21', '后勤部', '初级职称', '大专', '行政管理', '上海市浦东新区', '13800000002', 'lisi@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (9, 'password789', 'manager', '王五', 'M', '1978-07-05', '行政部', '初级职称', '大本', '人力资源管理', '广州市天河区', '13800000003', 'wangwu@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (10, 'password101', 'user', '赵六', 'F', '1995-10-16', '技术部', '初级职称', '大专', '网络安全', '深圳市南山区', '13800000004', 'zhaoliu@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (11, 'password202', 'manager', '孙七', 'M', '1982-11-23', '行政部', '初级职称', '硕士', '人力资源管理', '天津市和平区', '13800000005', 'sunqi@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (12, 'password303', 'admin', '周八', 'F', '1975-01-10', '后勤部', '初级职称', '硕士', '设施管理', '杭州市西湖区', '13800000006', 'zhouba@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (13, 'password404', 'user', '吴九', 'M', '1992-04-28', '技术部', '中级职称', '大本', '软件开发', '南京市鼓楼区', '13800000007', 'wujiu@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (14, 'password505', 'manager', '郑十', 'F', '1980-09-11', '行政部', '高级职称', '大本', '办公室管理', '重庆市渝中区', '13800000008', 'zhengshi@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (15, 'password606', 'user', '钱十一', 'M', '1993-12-02', '后勤部', '高级职称', '职高', '机电技术', '北京市海淀区', '13800000009', 'qianshiyi@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (16, 'password707', 'admin', '刘十二', 'F', '1983-08-14', '技术部', '高级职称', '博士', '人工智能', '武汉市武昌区', '13800000010', 'liushier@example.com', 'T', NULL);
INSERT INTO `Object_Person` VALUES (17, '123456', 'admin', '新版本姓名', 'F', '2024-11-08', '后勤部', '高级职称', '大本', 'Java开发', '湖南科技大学逸夫楼', '137-8685-8487', '2283216402@qq.com', 'T', '1');

-- ----------------------------
-- Table structure for Object_Person_copy1
-- ----------------------------
DROP TABLE IF EXISTS `Object_Person_copy1`;
CREATE TABLE `Object_Person_copy1`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PASSWD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（存储加密密码）',
  `AUTHORITY` enum('admin','user','manager') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户权限（管理员、用户、经理等）',
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `SEX` enum('M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '性别（M-男，F-女）',
  `BIRTHDAY` date NOT NULL COMMENT '生日（格式：YYYY-MM-DD）',
  `DEPARTMENT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所在部门',
  `JOB` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '职务',
  `EDU_LEVEL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '受教育程度',
  `SPCIALTY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '专业技能',
  `ADDRESS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '家庭住址',
  `TEL` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系电话',
  `EMAIL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子邮箱',
  `STATE` enum('T','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '当前状态（T-员工，F-非员工）',
  `REMARK` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注（可空）',
  PRIMARY KEY (`ID`) USING BTREE COMMENT '设置主键为员工号（ID）'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_Person_copy1
-- ----------------------------

-- ----------------------------
-- Table structure for Object_Person_copy2
-- ----------------------------
DROP TABLE IF EXISTS `Object_Person_copy2`;
CREATE TABLE `Object_Person_copy2`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `PASSWD` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '密码（存储加密密码）',
  `AUTHORITY` enum('admin','user','manager') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户权限（管理员、用户、经理等）',
  `NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '姓名',
  `SEX` enum('M','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '性别（M-男，F-女）',
  `BIRTHDAY` date NOT NULL COMMENT '生日（格式：YYYY-MM-DD）',
  `DEPARTMENT` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '所在部门',
  `JOB` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '职务',
  `EDU_LEVEL` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '受教育程度',
  `SPCIALTY` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '专业技能',
  `ADDRESS` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '家庭住址',
  `TEL` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '联系电话',
  `EMAIL` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '电子邮箱',
  `STATE` enum('T','F') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '当前状态（T-员工，F-非员工）',
  `REMARK` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注（可空）',
  PRIMARY KEY (`ID`) USING BTREE COMMENT '设置主键为员工号（ID）'
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_Person_copy2
-- ----------------------------
INSERT INTO `Object_Person_copy2` VALUES (6, 'admin', 'admin', 'admin', 'M', '2024-10-30', '技术部', '高级职称', '本科', 'Java开发', '湖南科技大学逸夫楼', '137-8685-8487', '2283216402@qq.com', 'T', '这是管理员账号');

-- ----------------------------
-- Table structure for Object_PersonnelChange
-- ----------------------------
DROP TABLE IF EXISTS `Object_PersonnelChange`;
CREATE TABLE `Object_PersonnelChange`  (
  `CODE` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更代码，不能为空，作为每种变更类型的唯一标识符',
  `DESCRIPTION` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更类型的描述，不能为空，用于简要说明变更的内容',
  PRIMARY KEY (`CODE`) USING BTREE COMMENT '设置 CODE 字段为主键，保证变更代码的唯一性'
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Object_PersonnelChange
-- ----------------------------
INSERT INTO `Object_PersonnelChange` VALUES ('0', '新员工加入');
INSERT INTO `Object_PersonnelChange` VALUES ('1', '职务变动');
INSERT INTO `Object_PersonnelChange` VALUES ('2', '辞退');

-- ----------------------------
-- Table structure for Relation_Personnel
-- ----------------------------
DROP TABLE IF EXISTS `Relation_Personnel`;
CREATE TABLE `Relation_Personnel`  (
  `ID` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录编号，设置为自增，作为每条记录的唯一标识符',
  `PERSON` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '员工号，不能为空，用于标识该条记录所属的员工',
  `Change_` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '变更代码，不能为空，表示记录的变更类型',
  `DESCRIPTION` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '详细记录，不能为空，用于存储变更的具体描述信息',
  PRIMARY KEY (`ID`) USING BTREE COMMENT '设置 ID 字段为主键，确保每条记录的唯一性'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of Relation_Personnel
-- ----------------------------

-- ----------------------------
-- Table structure for blog
-- ----------------------------
DROP TABLE IF EXISTS `blog`;
CREATE TABLE `blog`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `author` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `is_published` tinyint(1) NULL DEFAULT 0,
  `creation_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1857445808031772692 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog
-- ----------------------------
INSERT INTO `blog` VALUES (1857445808031772685, '至少见一面让我当面道歉好吗？😭', '至少见一面让我当面道歉好吗？😭\n我也吓了一跳，没想到事情会演变成那个样子…😭\n所以我想好好说明一下😭\n我要是知道就会阻止她们的，但是明明编排表都已经结束了突然间开始演奏😭\n没能阻止大家真是对不起…😭\n小祥，你在生气对吧…😭\n我想你生气也是当然的😭\n但是请你相信我。春日影，本来没有在我们的演奏预定曲目里的😭\n真的很对不起😭\n我答应你再也不会随意演奏了😭\n我会让她们保证再也不演奏这首曲子😭\n能不能稍微谈一谈？😭\n我真的把CRYCHIC的一切看得非常重要😭\n所以说，擅自演奏春日影的时候我和小祥你一样难过\n我希望你能明白我的心情😭\n拜托了。我哪里都会去的😭\n我也会好好跟你说明我不得不组乐队的理由😭\n我想如果你能见我一面，你就一定能明白的😭\n我是小祥你的同伴😭\n我好想见你😭', '丰川祥子', '散文', 0, '2024-11-15 16:14:11');
INSERT INTO `blog` VALUES (1857445808031772686, '至少见一面让我当面道歉好吗？😭', '至少见一面让我当面道歉好吗？😭\n我也吓了一跳，没想到事情会演变成那个样子…😭\n所以我想好好说明一下😭\n我要是知道就会阻止她们的，但是明明编排表都已经结束了突然间开始演奏😭\n没能阻止大家真是对不起…😭\n小祥，你在生气对吧…😭\n我想你生气也是当然的😭\n但是请你相信我。春日影，本来没有在我们的演奏预定曲目里的😭\n真的很对不起😭\n我答应你再也不会随意演奏了😭\n我会让她们保证再也不演奏这首曲子😭\n能不能稍微谈一谈？😭\n我真的把CRYCHIC的一切看得非常重要😭\n所以说，擅自演奏春日影的时候我和小祥你一样难过\n我希望你能明白我的心情😭\n拜托了。我哪里都会去的😭\n我也会好好跟你说明我不得不组乐队的理由😭\n我想如果你能见我一面，你就一定能明白的😭\n我是小祥你的同伴😭\n我好想见你😭', '丰川祥子', '散文', 0, '2024-11-15 16:17:25');
INSERT INTO `blog` VALUES (1857445808031772687, '至少见一面让我当面道歉好吗？😭', '我也吓了一跳，没想到事情会演变成那个样子…😭\r\n    所以我想好好说明一下😭\r\n    我要是知道就会阻止她们的，但是明明编排表都已经结束了突然间开始演奏😭\r\n    没能阻止大家真是对不起…😭\r\n    小祥，你在生气对吧…😭\r\n    我想你生气也是当然的😭\r\n    但是请你相信我。春日影，本来没有在我们的演奏预定曲目里的😭\r\n    真的对不起😭\r\n    我答应你再也不会随意演奏了😭\r\n    我会让她们保证再也不演奏这首曲子😭\r\n    能不能稍微谈一谈？😭\r\n    我真的把CRYCHIC的一切看得非常重要😭\r\n    所以说，擅自演奏春日影的时候我和小祥你一样难过\r\n    我希望你能明白我的心情😭\r\n    拜托了。我哪里都会去的😭\r\n    我也会好好跟你说明我不得不组乐队的理由😭\r\n    我想如果你能见我一面，你就一定能明白的😭\r\n    我是小祥你的同伴😭\r\n    我好想见你😭', '千早爱音', '个人日记', 1, '2024-11-15 08:40:29');
INSERT INTO `blog` VALUES (1857445808031772688, '太好了，你终于来了😊', 'mygo酱～\r\n太好了，你终于来了😊\r\n你好久没有更新动画了，发弹幕也没有回…😔\r\n什么？全集限时公开结束了？？😨\r\n等一下，我们先坐下来讲吧\r\n为什么？发生什么事了？\r\n连我们都不能说吗？还是说我们就是原因？\r\n有问题的话我们都能改进…😖\r\n什么？你一个人的问题？😨\r\n为什么，之前限时公开大家不是都很开心吗？\r\n你也说过想一直公开下去吧\r\n什么？你没那么说过？😨\r\n是这样吗…可是mygo酱是mygo的创始人啊\r\n要是mygo酱下架动画的话…\r\n先冷静下来谈谈吧，好吗？\r\n难得大家都在一起开心看mygo这么久了\r\n其他观众也是这么想的吧？😊\r\n', '长崎素世', '个人日记', 1, '2024-11-15 08:40:29');
INSERT INTO `blog` VALUES (1857445808031772689, '🥰对你一见钟情啦🥰', '🥰对你一见钟情啦🥰\r\n🤗你只要爱我就好🤗\r\n❤️相信我对你的Heart❤️\r\n😘当然理解你心中😘\r\n🖐🏻肯定想在我手中🖐🏻\r\n🌏我是这世界上唯一🌏\r\n🏃🏻要想逃离我不容易🏃🏻\r\n😲你应该已经知道😲\r\n🤗我一定会把你抓到🤗\r\n', '丰川祥子', '个人日记', 1, '2024-11-15 08:40:29');
INSERT INTO `blog` VALUES (1857445808031772690, '“我真傻，真的，”😭', '“我真傻，真的，”她说。“我单知道那天会有演出，会弹几首歌；我不知道春日影也会有。我一大早起来就开了门，拿小篮盛了一篮蘑菇，叫我们的阿睦坐在门槛上弹吉他，她是很听话的孩子，我的话句句听；她就出去了。我就在屋后采蘑菇，拍黄瓜。我叫，‘阿睦！’没有应。出去一看，只见小黄瓜撒得满地，没有我们的阿睦了\r\n。各处去一问，都没有。我急了，央人去寻去。直到下半天，几个人寻到livehouse里，看见大厅里一个巧克力袋子。大家都说，完了，怕是遭了素世了。再进去；果然，她去听了mygo的live，边哭边嚼着小黄瓜，台上本来在弹没听过的曲子，却突然弹起了春日影。……”她于是淌下眼泪来，声音也呜咽了。', '高松灯', '个人日记', 1, '2024-11-15 08:40:29');
INSERT INTO `blog` VALUES (1857445808031772691, '太好了，你终于来了😊\r\n', 'mygo酱～\r\n太好了，你终于来了😊\r\n你好久没有更新动画了，发弹幕也没有回…😔\r\n什么？全集限时公开结束了？？😨\r\n等一下，我们先坐下来讲吧\r\n为什么？发生什么事了？\r\n连我们都不能说吗？还是说我们就是原因？\r\n有问题的话我们都能改进…😖\r\n什么？你一个人的问题？😨\r\n为什么，之前限时公开大家不是都很开心吗？\r\n你也说过想一直公开下去吧\r\n什么？你没那么说过？😨\r\n是这样吗…可是mygo酱是mygo的创始人啊\r\n要是mygo酱下架动画的话…\r\n先冷静下来谈谈吧，好吗？\r\n难得大家都在一起开心看mygo这么久了\r\n其他观众也是这么想的吧？😊', '要乐奈', '个人日记', 1, '2024-11-15 08:40:29');

-- ----------------------------
-- Table structure for blog_tags
-- ----------------------------
DROP TABLE IF EXISTS `blog_tags`;
CREATE TABLE `blog_tags`  (
  `blog_id` bigint(20) NOT NULL,
  `tag_id` bigint(20) NOT NULL,
  PRIMARY KEY (`blog_id`, `tag_id`) USING BTREE,
  INDEX `tag_id`(`tag_id`) USING BTREE,
  CONSTRAINT `blog_tags_ibfk_1` FOREIGN KEY (`blog_id`) REFERENCES `blog` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `blog_tags_ibfk_2` FOREIGN KEY (`tag_id`) REFERENCES `tags` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of blog_tags
-- ----------------------------

-- ----------------------------
-- Table structure for tags
-- ----------------------------
DROP TABLE IF EXISTS `tags`;
CREATE TABLE `tags`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tags
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
