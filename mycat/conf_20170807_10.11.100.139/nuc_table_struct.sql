/*
SQLyog 企业版 - MySQL GUI v8.14 
MySQL - 5.7.12-log : Database - nuc
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `admin` */

CREATE TABLE `admin` (
  `userName` varchar(50) DEFAULT '管理员用户名',
  `password` varchar(50) DEFAULT '登录密码'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `attachment_file` */

CREATE TABLE `attachment_file` (
  `ATTACH_FILE_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '文件流水号',
  `ATTACH_GROUP_ID` bigint(20) NOT NULL COMMENT '附件组ID',
  `FILE_NAME` varchar(256) NOT NULL COMMENT '文件名称',
  `FILE_SAVE_NAME` varchar(256) NOT NULL COMMENT '文件存储名',
  `FILE_SIZE` int(11) NOT NULL COMMENT '文件大小（字节为单位）',
  `FILE_TYPE` varchar(100) NOT NULL COMMENT '文件类型（doc,pdf等）',
  `ATTACH_FILE_STATUS` varchar(21) NOT NULL COMMENT '附件状态（temp：暂存；formal：正式）',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '附件创建时间',
  PRIMARY KEY (`ATTACH_FILE_ID`),
  KEY `idx_attach_group_id` (`ATTACH_GROUP_ID`),
  CONSTRAINT `FK_attachment_file` FOREIGN KEY (`ATTACH_GROUP_ID`) REFERENCES `attachment_group` (`ATTACH_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件';

/*Table structure for table `attachment_group` */

CREATE TABLE `attachment_group` (
  `ATTACH_GROUP_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '附件组ID',
  `ATTACH_TYPE_ID` varchar(12) DEFAULT NULL COMMENT '附件类型Id（为空表示无类型）',
  `ATTACH_GROUP_STATUS` varchar(12) NOT NULL COMMENT '附件状态（temp：暂存；formal：正式）',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '附件组创建时间',
  PRIMARY KEY (`ATTACH_GROUP_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件组';

/*Table structure for table `attachment_type` */

CREATE TABLE `attachment_type` (
  `ATTACH_TYPE_ID` varchar(12) NOT NULL COMMENT '附件类型Id',
  `ATTACH_TYPE_NAME` varchar(32) NOT NULL COMMENT '附件类型名称',
  `ATTACH_TYPE_DESC` varchar(200) NOT NULL COMMENT '附件类型描述',
  `ATTACH_COUNT_LIMIT` int(11) NOT NULL COMMENT '附件数量限制',
  `ATTACH_SIZE_LIMIT` int(11) NOT NULL COMMENT '附件大小总限制（字节为单位）',
  `SINGLE_SIZE_LIMIT` int(11) NOT NULL COMMENT '单个附件大小限制（字节为单位）',
  `FILE_SUFFIX_LIMIT` varchar(64) DEFAULT NULL COMMENT '文件后缀名限制（空表示不限制，如果支持多种后缀，通过；号分隔，如doc;pdf;rar等）',
  `SYNC_TYPE` varchar(10) DEFAULT NULL COMMENT '同步标志（同步：sync,为空表示不同步）',
  `MAX_FILE_NAME_LENGTH` int(11) NOT NULL DEFAULT '255' COMMENT '最大文件名长度,不能大于256',
  PRIMARY KEY (`ATTACH_TYPE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='附件类型';

/*Table structure for table `audit_count` */

CREATE TABLE `audit_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `AuditType` varchar(2) DEFAULT NULL COMMENT '稽核种类：0.用户实名稽核，1.用户查验稽核，2.安全事件审核',
  `AuditResult` varchar(2) DEFAULT NULL COMMENT '稽核结果：0.成功，1.失败',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='稽核统计表';

/*Table structure for table `business_log` */

CREATE TABLE `business_log` (
  `LOG_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '业务日志ID',
  `LOG_TYPE` varchar(32) NOT NULL COMMENT '日志类型',
  `OPERATOR_ID` varchar(64) NOT NULL COMMENT '操作员ID',
  `OPERATOR_NAME` varchar(64) NOT NULL COMMENT '操作员名称',
  `CLIENT_IP` varchar(100) NOT NULL COMMENT '客户端IP',
  `BUSINESS_ID` varchar(64) NOT NULL COMMENT '被操作实体ID',
  `BUSINESS_NAME` varchar(64) NOT NULL COMMENT '被操作实体名称',
  `DESCRIPTION` varchar(600) NOT NULL COMMENT '操作说明',
  `OPERATION_RESULT` varchar(400) NOT NULL COMMENT '操作结果',
  `OPERATION_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
  `BUSINESS_TYPE` int(11) NOT NULL COMMENT '被操作实体类型',
  `OPERATION_DOMAIN` int(11) NOT NULL COMMENT '操作所属域（admin,sp）',
  PRIMARY KEY (`LOG_ID`),
  KEY `idx_business_log_type` (`LOG_TYPE`),
  KEY `idx_business_log_date` (`OPERATION_DATE`),
  KEY `idx_business_log_OPR_id` (`OPERATOR_ID`),
  CONSTRAINT `FK_BUSINESS_LOG` FOREIGN KEY (`LOG_TYPE`) REFERENCES `business_log_type` (`LOG_TYPE`)
) ENGINE=InnoDB AUTO_INCREMENT=27191 DEFAULT CHARSET=utf8 COMMENT='业务日志';

/*Table structure for table `business_log_category` */

CREATE TABLE `business_log_category` (
  `CATEGORY_NAME` varchar(32) NOT NULL COMMENT '日志分类名称',
  `DESCRIPTION` varchar(32) DEFAULT NULL COMMENT '分类说明',
  `PARENT_NAME` varchar(32) DEFAULT NULL COMMENT '父分类名称（一级日志分类的父分类是root）',
  `CATEGORY_LEVEL` int(11) DEFAULT NULL COMMENT '级别（1级、2级、3级等，方便查询）',
  PRIMARY KEY (`CATEGORY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日志分类';

/*Table structure for table `business_log_type` */

CREATE TABLE `business_log_type` (
  `LOG_TYPE` varchar(20) NOT NULL COMMENT '日志类型',
  `LOG_TYPE_NAME` varchar(50) NOT NULL COMMENT '日志类型名称',
  `CATEGORY_NAME` varchar(32) NOT NULL COMMENT '日志分类名称',
  `PATTERN` varchar(500) NOT NULL COMMENT '日志操作说明模式字符串（采用java字符串的format格式）',
  PRIMARY KEY (`LOG_TYPE`),
  KEY `FK_BUSINESS_LOG_TYPE` (`CATEGORY_NAME`),
  CONSTRAINT `FK_BUSINESS_LOG_TYPE` FOREIGN KEY (`CATEGORY_NAME`) REFERENCES `business_log_category` (`CATEGORY_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='日志类型';

/*Table structure for table `check_stat` */

CREATE TABLE `check_stat` (
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `StatDate` varchar(8) DEFAULT NULL COMMENT '统计日期。格式:YYYYMMDD',
  `TotalCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '当日查验用户数总数',
  `SmsCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '短信验证码查验方式总数',
  `QrCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '凭证二维码查验方式总数',
  `WechatCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '微信验证码查验方式总数',
  `IDCardCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '有效证件查验方式总数',
  `IDRecDeviceCheckNumber` bigint(10) DEFAULT NULL COMMENT '身份证识别设备查验总数',
  `NFCSAMCheckUserNumber` bigint(10) DEFAULT NULL COMMENT 'NFC+SAM查验方式总数',
  `OCRCheckUserNumber` bigint(10) DEFAULT NULL COMMENT 'OCR识别查验方式总数',
  `AgreementCheckNumber` bigint(10) DEFAULT NULL COMMENT '协议客户查验总数',
  `IsAdopt` varchar(2) DEFAULT NULL COMMENT '用户查验稽核：0，通过，1不通过',
  `CheckUserNumberByManualMode` bigint(10) DEFAULT NULL COMMENT '人工查验方式总数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名查验日统计表';

/*Table structure for table `check_stat_msg` */

CREATE TABLE `check_stat_msg` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` varchar(2048) DEFAULT NULL COMMENT '上报查验日报请求消息报文',
  `RspMsg` varchar(2048) DEFAULT NULL COMMENT '上报查验日报应答消息报文',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报查验日报消息报文';

/*Table structure for table `city` */

CREATE TABLE `city` (
  `CITY_ID` int(8) NOT NULL COMMENT '市ID',
  `CITY_NAME` varchar(30) NOT NULL COMMENT '城市名称',
  `PROVINCE_ID` int(8) NOT NULL COMMENT '省份ID',
  `AREA_CODE` varchar(10) DEFAULT NULL COMMENT '区号',
  PRIMARY KEY (`CITY_ID`),
  KEY `FK_PROVINCE` (`PROVINCE_ID`),
  CONSTRAINT `FK_PROVINCE` FOREIGN KEY (`PROVINCE_ID`) REFERENCES `province` (`PROVINCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='市';

/*Table structure for table `code_dict` */

CREATE TABLE `code_dict` (
  `CODE_TYPE` varchar(60) NOT NULL COMMENT '编码类型',
  `KEY` varchar(60) NOT NULL COMMENT '编码key',
  `VALUE` varchar(100) NOT NULL COMMENT '编码值',
  `CODE_DESC` varchar(200) DEFAULT NULL COMMENT '描述',
  `VALID_FLAG` decimal(1,0) unsigned NOT NULL DEFAULT '1' COMMENT '是否有效or可见，1=是；0=否',
  `ORDER_ID` int(10) unsigned DEFAULT NULL COMMENT '排序（从1开始的正整数，NULL表示不排序，各level互不影响）',
  PRIMARY KEY (`CODE_TYPE`,`KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='编码表';

/*Table structure for table `compliance` */

CREATE TABLE `compliance` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `expOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `interfaceName` varchar(50) NOT NULL COMMENT '接口名称',
  `exceptionDesc` varchar(500) DEFAULT NULL COMMENT '异常描述',
  `createDate` datetime NOT NULL COMMENT '创建时间',
  `messageNo` varchar(30) DEFAULT NULL COMMENT '接口信息流水号',
  PRIMARY KEY (`id`,`createDate`)
) ENGINE=InnoDB AUTO_INCREMENT=80457 DEFAULT CHARSET=utf8 COMMENT='合规信息表';

/*Table structure for table `configitem` */

CREATE TABLE `configitem` (
  `Item` varchar(64) NOT NULL COMMENT '配置项',
  `Descript` varchar(256) NOT NULL COMMENT '配置项描述',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `Flag` varchar(2) NOT NULL COMMENT '配置项开关：0.关闭，1.打开',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置项开关表';

/*Table structure for table `courier` */

CREATE TABLE `courier` (
  `StaffCode` varchar(16) NOT NULL COMMENT '人员编码',
  `EcCompanyId` varchar(10) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `Name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(128) DEFAULT NULL COMMENT '移动电话',
  `CardType` varchar(2) DEFAULT NULL COMMENT '证件类型',
  `CardID` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码',
  `StaffStatus` varchar(2) DEFAULT NULL COMMENT '收派员状态',
  `province` varchar(6) DEFAULT NULL COMMENT '省',
  `city` varchar(6) DEFAULT NULL COMMENT '市',
  `county` varchar(6) DEFAULT NULL COMMENT '县',
  `Street` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `CreateTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `oprTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `StaffCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期开始时间',
  `StaffCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期结束时间',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '用户统一标识(伪码)',
  `PseudoStatus` int(2) DEFAULT '0' COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `MobilePhonedesc` varchar(128) DEFAULT NULL COMMENT '移动电话临时字段',
  `CardIDdesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  `OutletsName` varchar(64) DEFAULT NULL COMMENT '网点名称',
  PRIMARY KEY (`StaffCode`,`EcCompanyId`,`IsPublic`),
  KEY `index_county` (`county`),
  KEY `idx_cou_epccss` (`EcCompanyId`,`province`,`city`,`county`,`Street`,`StaffStatus`),
  KEY `idx_courier_createtime` (`CreateTime`),
  KEY `idx_courier_ecs` (`EcCompanyId`,`county`,`Street`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收派员信息表';

/*Table structure for table `courier_cache` */

CREATE TABLE `courier_cache` (
  `StaffCode` varchar(16) NOT NULL COMMENT '人员编码',
  `EcCompanyId` varchar(10) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `Name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(32) DEFAULT NULL COMMENT '移动电话',
  `CardType` varchar(2) DEFAULT NULL COMMENT '证件类型',
  `CardID` varchar(35) DEFAULT NULL COMMENT '证件号码',
  `StaffStatus` varchar(2) DEFAULT NULL COMMENT '收派员状态',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `Street` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `CreateTime` timestamp NOT NULL DEFAULT '1980-01-01 00:00:00',
  `oprTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `StaffUnifiedId` varchar(128) DEFAULT NULL COMMENT '统一标识',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `PseudoFlag` varchar(1) DEFAULT '1' COMMENT '是否需要生成伪码。0：不需要；1：需要。',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `StaffCardValidityStartDate` varchar(30) DEFAULT NULL,
  `StaffCardValidityEndDate` varchar(30) DEFAULT NULL,
  `OutletsName` varchar(64) DEFAULT NULL COMMENT '网点名称',
  PRIMARY KEY (`StaffCode`,`EcCompanyId`,`IsPublic`),
  KEY `index_county` (`County`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收派员信息缓存表';

/*Table structure for table `courier_his` */

CREATE TABLE `courier_his` (
  `HisSeq` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '序列号(自动递增)',
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `StaffCode` varchar(16) NOT NULL COMMENT '人员编码',
  `EcCompanyId` varchar(10) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `Name` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(128) DEFAULT NULL COMMENT '移动电话',
  `CardType` varchar(2) DEFAULT NULL COMMENT '证件类型',
  `CardID` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码',
  `StaffStatus` varchar(2) DEFAULT NULL COMMENT '收派员状态',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `Street` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `MobilePhonedesc` varchar(128) DEFAULT NULL COMMENT '移动电话临时字段',
  `CardIDdesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  `OutletsName` varchar(64) DEFAULT NULL COMMENT '网点名称',
  PRIMARY KEY (`HisSeq`)
) ENGINE=InnoDB AUTO_INCREMENT=1563363 DEFAULT CHARSET=utf8 COMMENT='收派员信息历史表';

/*Table structure for table `courieractive_count` */

CREATE TABLE `courieractive_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '统计维度：0.全部',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='收派员信息统计表';

/*Table structure for table `couriermessage` */

CREATE TABLE `couriermessage` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '上报收派员信息请求消息报文',
  `RspMsg` longtext COMMENT 'É±¨ÊÅԱÐϢӦ´ð¢±¨Î',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报收派员信息消息报文';

/*Table structure for table `delivery_all_count` */

CREATE TABLE `delivery_all_count` (
  `Time` varchar(20) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式： 01.面验，\r\n																										02.短信验证码，\r\n																										03.凭证二维码，\r\n																										04.微信验证码，\r\n																										05.有效身份证件，\r\n																										06.身份证识别设备，\r\n																										07.协议客户,\r\n																	',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `delivery_month_anjian` */

CREATE TABLE `delivery_month_anjian` (
  `uploadMonth` varchar(32) NOT NULL COMMENT '上报时间yyyy-mm',
  `areaCode` varchar(32) NOT NULL COMMENT '区域代码',
  `areaName` varchar(50) NOT NULL COMMENT '区域名称',
  `areaType` varchar(500) DEFAULT '2' COMMENT '区域类型 1 province 2 city',
  `amount` varchar(50) NOT NULL COMMENT '业务量',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `useFlag` varchar(2) DEFAULT 'Y' COMMENT '是否有效,Y有效，N无效',
  `createByPerson` varchar(32) DEFAULT NULL COMMENT '创建人',
  `createByOrgCode` varchar(2) DEFAULT NULL COMMENT '创建部门',
  PRIMARY KEY (`uploadMonth`,`areaCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='安监每月提供业务量';

/*Table structure for table `dic` */

CREATE TABLE `dic` (
  `type` varchar(32) NOT NULL COMMENT '字典类型',
  `name` varchar(32) NOT NULL COMMENT '键名',
  `value` varchar(64) NOT NULL COMMENT '键值',
  `dicDesc` varchar(256) DEFAULT NULL COMMENT '描述',
  `status` int(1) DEFAULT '0' COMMENT '状态  0：有效 1：无效',
  `seqNo` int(2) DEFAULT NULL COMMENT '同一个字典类型的排列顺序'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='字典';

/*Table structure for table `district_code` */

CREATE TABLE `district_code` (
  `code` varchar(35) NOT NULL COMMENT '编号',
  `province` varchar(64) NOT NULL COMMENT '省',
  `city` varchar(64) DEFAULT NULL COMMENT '市',
  `county` varchar(64) NOT NULL COMMENT '县/区'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='区县代码表';

/*Table structure for table `ec_indiv_addrs` */

CREATE TABLE `ec_indiv_addrs` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码',
  `Type` int(1) DEFAULT NULL COMMENT '地址类型.1：证件地址;2：常用地址',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `UserIDNodesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  `CreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  KEY `INDEX_IDTYPE_IDNO` (`ExpOrgCode`,`UserIDType`,`UserIDNo`) USING BTREE,
  KEY `index_exporgcode` (`ExpOrgCode`),
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址接口信息表';

/*Table structure for table `ec_indiv_mobils` */

CREATE TABLE `ec_indiv_mobils` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `UserIDType` varchar(2) NOT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) NOT NULL COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(128) NOT NULL COMMENT '移动电话',
  `UserIDNodesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  `MobilePhonedesc` varchar(128) DEFAULT NULL COMMENT '移动电话临时字段',
  `CreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  PRIMARY KEY (`ExpOrgCode`,`UserIDType`,`UserIDNo`,`MobilePhone`),
  KEY `INDEX_IDTYPE_IDNO` (`ExpOrgCode`,`UserIDType`,`UserIDNo`) USING BTREE,
  KEY `index_exporgcode` (`ExpOrgCode`),
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户移动电话接口信息表';

/*Table structure for table `ec_indiv_mobils_update` */

CREATE TABLE `ec_indiv_mobils_update` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(32) DEFAULT NULL COMMENT '移动电话',
  KEY `INDEX_IDTYPE_IDNO` (`ExpOrgCode`,`UserIDType`,`UserIDNo`) USING BTREE,
  KEY `index_exporgcode` (`ExpOrgCode`),
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户移动电话申请表（补全数据）';

/*Table structure for table `ec_indivuser` */

CREATE TABLE `ec_indivuser` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` int(2) DEFAULT NULL COMMENT '用户信息采集方式',
  `PseudoStatus` int(2) DEFAULT '0' COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `IsChecked` varchar(2) DEFAULT NULL COMMENT '是否已查验:0：未查验 1：已查验',
  `CheckDate` varchar(20) DEFAULT '00000000000000' COMMENT '查验时间',
  `Province` varchar(32) DEFAULT '000000' COMMENT '省',
  `City` varchar(32) DEFAULT '000000' COMMENT '市',
  `County` varchar(32) DEFAULT '000000' COMMENT '县',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `UserUnifiedId` varchar(128) DEFAULT NULL COMMENT '用户统一标识',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `Status` varchar(2) DEFAULT NULL COMMENT '状态  10：正常 20：解除协议   用户类型为1时填空，为2时必填',
  `UserIDNodesc` varchar(128) NOT NULL DEFAULT '' COMMENT '有效身份证件号码临时字段',
  PRIMARY KEY (`ExpOrgCode`,`UserIDType`,`UserIDNo`,`IsPublic`),
  KEY `index_userseq` (`UserSeq`),
  KEY `index_time` (`CheckDate`),
  KEY `index_province` (`Province`),
  KEY `index_city` (`City`),
  KEY `index_county` (`County`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报寄递用户实名身份接口信息表';

/*Table structure for table `ec_indivuser_count_temp` */

CREATE TABLE `ec_indivuser_count_temp` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` int(2) DEFAULT NULL COMMENT '用户信息采集方式',
  `PseudoStatus` int(2) DEFAULT '0' COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `IsChecked` varchar(2) DEFAULT NULL COMMENT '是否已查验:0：未查验 1：已查验',
  `CheckDate` varchar(32) DEFAULT '00000000000000' COMMENT '查验时间',
  `Province` varchar(32) DEFAULT '000000' COMMENT '省',
  `City` varchar(32) DEFAULT '000000' COMMENT '市',
  `County` varchar(32) DEFAULT '000000' COMMENT '县',
  `CreateTime` varchar(20) DEFAULT '0' COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `UserUnifiedId` varchar(30) DEFAULT NULL,
  `UserCardValidityStartDate` varchar(30) DEFAULT NULL,
  `UserCardValidityEndDate` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ExpOrgCode`,`UserIDType`,`UserIDNo`,`IsPublic`),
  KEY `index_userseq` (`UserSeq`) USING BTREE,
  KEY `index_exporgcode` (`ExpOrgCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报寄递用户实名身份信息统计快照表';

/*Table structure for table `ec_indivuser_temp` */

CREATE TABLE `ec_indivuser_temp` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(44) DEFAULT '' COMMENT '实名身份伪码',
  `CollectMethod` int(2) DEFAULT NULL COMMENT '用户信息采集方式',
  `PseudoStatus` int(2) DEFAULT NULL COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`ExpOrgCode`,`UserIDType`,`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报寄递用户实名身份信息企业临时表';

/*Table structure for table `ec_indivuser_update` */

CREATE TABLE `ec_indivuser_update` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` int(2) DEFAULT NULL COMMENT '用户信息采集方式',
  `PseudoStatus` int(2) DEFAULT NULL COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `IsChecked` varchar(2) DEFAULT NULL COMMENT '是否已查验:0：未查验 1：已查验',
  KEY `index_userseq` (`UserSeq`),
  KEY `index_exporgcode` (`ExpOrgCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报寄递用户实名身份信息申请表（补全数据）';

/*Table structure for table `email_attachment` */

CREATE TABLE `email_attachment` (
  `EMAIL_ID` bigint(20) NOT NULL COMMENT '附件所属Email标识',
  `NAME` varchar(32) DEFAULT NULL COMMENT '附件名称',
  `DESCRIPTION` varchar(200) DEFAULT NULL COMMENT '附件描述',
  `PATH` varchar(500) DEFAULT NULL COMMENT '附件路径',
  KEY `idx_email_attachment` (`EMAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Email附件';

/*Table structure for table `email_send` */

CREATE TABLE `email_send` (
  `EMAIL_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Email标识',
  `EMAIL_FROM` varchar(128) DEFAULT NULL COMMENT '发件人',
  `EMAIL_TO` varchar(2000) DEFAULT NULL COMMENT '收件人',
  `EMAIL_CC` varchar(2000) DEFAULT NULL COMMENT '抄送',
  `EMAIL_BCC` varchar(2000) DEFAULT NULL COMMENT '暗送',
  `SUBJECT` blob COMMENT '主题',
  `MESSAGE` blob COMMENT '内容',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `SEND_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '发送时间',
  `STATUS` varchar(20) NOT NULL DEFAULT 'waiting' COMMENT '处理次数',
  `DEAL_TIMES` int(11) NOT NULL DEFAULT '0' COMMENT '发送状态：waiting-等待处理；success-成功；failure-失败',
  `TYPE` varchar(20) DEFAULT NULL COMMENT '邮件类型：PLAIN-简单类型邮件；HTML-HTML类型邮件',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`EMAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件发送';

/*Table structure for table `email_send_history` */

CREATE TABLE `email_send_history` (
  `EMAIL_ID` bigint(20) NOT NULL COMMENT 'Email标识',
  `EMAIL_FROM` varchar(128) DEFAULT NULL COMMENT '发件人',
  `EMAIL_TO` varchar(2000) DEFAULT NULL COMMENT '收件人',
  `EMAIL_CC` varchar(2000) DEFAULT NULL COMMENT '抄送',
  `EMAIL_BCC` varchar(2000) DEFAULT NULL COMMENT '暗送',
  `SUBJECT` blob COMMENT '主题',
  `MESSAGE` blob COMMENT '内容',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `SEND_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '发送时间',
  `STATUS` varchar(20) NOT NULL DEFAULT 'waiting' COMMENT '处理次数',
  `DEAL_TIMES` int(11) DEFAULT NULL COMMENT '发送状态：waiting-等待处理；success-成功；failure-失败',
  `TYPE` varchar(20) DEFAULT NULL COMMENT '邮件类型：PLAIN-简单类型邮件；HTML-HTML类型邮件',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`EMAIL_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='邮件发送历史';

/*Table structure for table `exceptionmessage` */

CREATE TABLE `exceptionmessage` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '上报异常事件请求消息报文',
  `RspMsg` varchar(2048) DEFAULT NULL COMMENT '上报异常事件应答消息报文',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报异常事件消息报文';

/*Table structure for table `exp_city_userdiv` */

CREATE TABLE `exp_city_userdiv` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL COMMENT '创建时间',
  `OprTime` datetime DEFAULT NULL COMMENT '操作时间',
  `OrgCode` varchar(10) NOT NULL DEFAULT '',
  `SocialCode` varchar(20) NOT NULL DEFAULT '',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
  `UserType` varchar(1) NOT NULL DEFAULT '1',
  UNIQUE KEY `exp_userid_pro_city_index` (`UserSeq`,`ExpOrgCode`,`Province`,`City`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息表（市级）';

/*Table structure for table `exp_city_userdiv_result` */

CREATE TABLE `exp_city_userdiv_result` (
  `Time` varchar(20) NOT NULL COMMENT '统计时间',
  `NewUserNums` varchar(32) NOT NULL COMMENT '新增用户的数量',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `UserType` varchar(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息结果表（市级）';

/*Table structure for table `exp_provice_userdiv` */

CREATE TABLE `exp_provice_userdiv` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL COMMENT '创建时间',
  `OprTime` datetime DEFAULT NULL COMMENT '操作时间',
  `OrgCode` varchar(10) NOT NULL DEFAULT '',
  `SocialCode` varchar(20) NOT NULL DEFAULT '',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
  `UserType` varchar(1) NOT NULL DEFAULT '1',
  UNIQUE KEY `exp_userId_pro_index` (`UserSeq`,`ExpOrgCode`,`Province`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息表（省级）';

/*Table structure for table `exp_provice_userdiv_result` */

CREATE TABLE `exp_provice_userdiv_result` (
  `Time` varchar(20) NOT NULL COMMENT '统计时间',
  `NewUserNums` varchar(32) NOT NULL COMMENT '新增用户的数量',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `UserType` varchar(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息结果表（省级）';

/*Table structure for table `exp_user_id_temp` */

CREATE TABLE `exp_user_id_temp` (
  `exp_org_code` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `user_id` varchar(16) NOT NULL DEFAULT '' COMMENT '个人用户序列号',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `flag` varchar(2) NOT NULL DEFAULT '' COMMENT '是否更新'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='查验记录关联更新';

/*Table structure for table `exp_userdiv` */

CREATE TABLE `exp_userdiv` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL COMMENT '创建时间',
  `OprTime` datetime DEFAULT NULL COMMENT '操作时间',
  `OrgCode` varchar(10) NOT NULL DEFAULT '',
  `SocialCode` varchar(20) NOT NULL DEFAULT '',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
  `UserType` varchar(1) NOT NULL DEFAULT '1',
  UNIQUE KEY `exp_userid_index` (`UserSeq`,`ExpOrgCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息表';

/*Table structure for table `exp_userdiv_result` */

CREATE TABLE `exp_userdiv_result` (
  `Time` varchar(20) NOT NULL COMMENT '统计时间',
  `NewUserNums` varchar(32) NOT NULL COMMENT '新增用户的数量',
  `IsReported` varchar(2) DEFAULT NULL,
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `UserType` varchar(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户实名身份信息结果表';

/*Table structure for table `exporg` */

CREATE TABLE `exporg` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `ExpOrgDesc` varchar(128) DEFAULT NULL COMMENT '寄递企业描述',
  `IpAddr` varchar(64) DEFAULT NULL COMMENT 'IP',
  `Port` varchar(10) DEFAULT NULL COMMENT '端口',
  `UrlType` varchar(2) NOT NULL COMMENT 'url类型。1：伪码下发url；2：个人安全级别下发',
  `Url` varchar(256) DEFAULT NULL COMMENT 'url',
  PRIMARY KEY (`ExpOrgCode`,`UrlType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='寄递企业';

/*Table structure for table `express_delivery_status_count_temp` */

CREATE TABLE `express_delivery_status_count_temp` (
  `exp_org_code` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `user_type` varchar(1) NOT NULL DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `bill_number` varchar(35) NOT NULL COMMENT '快递单号',
  `id_pseude_code` varchar(128) DEFAULT NULL COMMENT '个人用户实名身份伪码',
  `user_id` varchar(16) NOT NULL DEFAULT '' COMMENT '个人用户序列号',
  `org_code` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `social_code` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `staff_code` varchar(16) NOT NULL COMMENT '收派员编号',
  `check_date` datetime NOT NULL COMMENT '查验时间 YYYY-MM-DD HH:mm:ss',
  `check_method` varchar(2) NOT NULL COMMENT '查验方式，01首次面验，02凭证二维码，03短信验证码，04微信验证码，05有效身份证，06身份证识别设备，07NFC+SAM，08OCR识别，99协议客户',
  `province` varchar(32) NOT NULL COMMENT '省',
  `city` varchar(32) NOT NULL COMMENT '市',
  `county` varchar(32) NOT NULL COMMENT '区县',
  `IsReported` varchar(2) DEFAULT NULL COMMENT '是否已上报:0：未上报 1：已上报',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `createDate` datetime NOT NULL DEFAULT '1980-01-01 00:00:00' COMMENT '创建时间',
  `TaxRegNo` varchar(32) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `UserUnifiedId` varchar(128) DEFAULT NULL COMMENT '用户统一标识',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期结束时间',
  `StaffUnifiedId` varchar(128) DEFAULT NULL COMMENT '收派员统一标识',
  `StaffCardType` varchar(2) DEFAULT NULL COMMENT '收派员有效身份证件类型',
  `StaffCardID` varchar(35) DEFAULT NULL COMMENT '收派员有效身份证件号码',
  `StaffCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期开始时间',
  `StaffCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期结束时间',
  KEY `index_exporgcode` (`exp_org_code`) USING BTREE,
  KEY `index_userid` (`user_id`) USING BTREE,
  KEY `index_county` (`county`) USING BTREE,
  KEY `index_city` (`city`) USING BTREE,
  KEY `index_province` (`province`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='快件状态信息查验记录统计快照表';

/*Table structure for table `express_delivery_status_firstfacecount_temp` */

CREATE TABLE `express_delivery_status_firstfacecount_temp` (
  `exp_org_code` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `user_type` varchar(1) NOT NULL DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `bill_number` varchar(35) NOT NULL COMMENT '快递单号',
  `id_pseude_code` varchar(128) DEFAULT NULL COMMENT '个人用户实名身份伪码',
  `user_id` varchar(16) NOT NULL DEFAULT '' COMMENT '个人用户序列号',
  `org_code` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `social_code` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `staff_code` varchar(16) NOT NULL COMMENT '收派员编号',
  `check_date` datetime NOT NULL COMMENT '查验时间 YYYY-MM-DD HH:mm:ss',
  `check_method` varchar(2) NOT NULL COMMENT '查验方式，01首次面验，02凭证二维码，03短信验证码，04微信验证码，05有效身份证，06身份证识别设备，07NFC+SAM，08OCR识别，99协议客户',
  `province` varchar(32) NOT NULL COMMENT '省',
  `city` varchar(32) NOT NULL COMMENT '市',
  `county` varchar(32) NOT NULL COMMENT '区县',
  `IsReported` varchar(2) DEFAULT NULL COMMENT '是否已上报:0：未上报 1：已上报',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `createDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `UserUnifiedId` varchar(128) DEFAULT NULL COMMENT '用户统一标识',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期结束时间',
  `StaffUnifiedId` varchar(128) DEFAULT NULL COMMENT '收派员统一标识',
  `StaffCardType` varchar(2) DEFAULT NULL COMMENT '收派员有效身份证件类型',
  `StaffCardID` varchar(35) DEFAULT NULL COMMENT '收派员有效身份证件号码',
  `StaffCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期开始时间',
  `StaffCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期结束时间',
  KEY `index_exporgcode` (`exp_org_code`) USING BTREE,
  KEY `index_userid` (`user_id`) USING BTREE,
  KEY `index_county` (`county`) USING BTREE,
  KEY `index_city` (`city`) USING BTREE,
  KEY `index_province` (`province`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='快件状态信息查验记录首次面验统计快照表';

/*Table structure for table `express_delivery_status_user_temp` */

CREATE TABLE `express_delivery_status_user_temp` (
  `exp_org_code` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `user_type` varchar(1) NOT NULL DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `bill_number` varchar(35) NOT NULL COMMENT '快递单号',
  `id_pseude_code` varchar(128) DEFAULT NULL COMMENT '个人用户实名身份伪码',
  `user_id` varchar(16) NOT NULL DEFAULT '' COMMENT '个人用户序列号',
  `org_code` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `social_code` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `staff_code` varchar(16) NOT NULL COMMENT '收派员编号',
  `check_date` datetime NOT NULL COMMENT '查验时间 YYYY-MM-DD HH:mm:ss',
  `check_method` varchar(2) NOT NULL COMMENT '查验方式，01首次面验，02凭证二维码，03短信验证码，04微信验证码，05有效身份证，06身份证识别设备，07NFC+SAM，08OCR识别，99协议客户',
  `province` varchar(32) NOT NULL COMMENT '省',
  `city` varchar(32) NOT NULL COMMENT '市',
  `county` varchar(32) NOT NULL COMMENT '区县',
  `IsReported` varchar(2) DEFAULT NULL COMMENT '是否已上报:0：未上报 1：已上报',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `createDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `UserUnifiedId` varchar(128) DEFAULT NULL COMMENT '用户统一标识',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期结束时间',
  `StaffUnifiedId` varchar(128) DEFAULT NULL COMMENT '收派员统一标识',
  `StaffCardType` varchar(2) DEFAULT NULL COMMENT '收派员有效身份证件类型',
  `StaffCardID` varchar(35) DEFAULT NULL COMMENT '收派员有效身份证件号码',
  `StaffCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期开始时间',
  `StaffCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期结束时间',
  KEY `index_county` (`county`) USING BTREE,
  KEY `index_city` (`city`) USING BTREE,
  KEY `index_province` (`province`) USING BTREE,
  KEY `index_userid` (`user_id`),
  KEY `index_exporgcode` (`exp_org_code`),
  KEY `INDEX_IDTYPE_IDNO02` (`exp_org_code`,`user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='快件状态信息查验记录临时表';

/*Table structure for table `first_face_userdiv` */

CREATE TABLE `first_face_userdiv` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `Country` varchar(32) DEFAULT NULL COMMENT '县区',
  `CheckType` varchar(4) NOT NULL DEFAULT '00' COMMENT '面验类型',
  `CheckTime` datetime NOT NULL COMMENT '查验时间 YYYY-MM-DD HH:mm:ss',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `IsReported` varchar(2) NOT NULL DEFAULT '0' COMMENT '是否已上报:0：未上报 1：已上报',
  UNIQUE KEY `exp_userid_index` (`UserSeq`,`ExpOrgCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='首次面验用户信息中间表';

/*Table structure for table `first_face_userdiv_time` */

CREATE TABLE `first_face_userdiv_time` (
  `time` varchar(20) NOT NULL DEFAULT '' COMMENT '首次面验-中间表统计时间表',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `indiv_addrs` */

CREATE TABLE `indiv_addrs` (
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码',
  `Type` int(1) DEFAULT NULL COMMENT '地址类型.1：证件地址;2：常用地址',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `UserIDNodesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  KEY `INDEX_IDTYPE_IDNO` (`UserIDType`,`UserIDNo`) USING BTREE,
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址信息';

/*Table structure for table `indiv_addrs_his` */

CREATE TABLE `indiv_addrs_his` (
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `Type` int(1) DEFAULT NULL COMMENT '地址类型.1：证件地址;2：常用地址',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  KEY `INDEX_IDTYPE_IDNO` (`UserIDType`,`UserIDNo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户实名身份信息';

/*Table structure for table `indiv_except` */

CREATE TABLE `indiv_except` (
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserSeq` varchar(16) DEFAULT NULL COMMENT '用户序列号',
  `IDPseudeCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `UnusualEvent` varchar(500) DEFAULT NULL COMMENT '异常事件',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `Status` varchar(2) DEFAULT NULL COMMENT '状态。0：未处理；1：已审批；2：已下发',
  `AuditMessage` varchar(200) DEFAULT NULL COMMENT '审核意见',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间',
  `UserCardType` varchar(2) DEFAULT NULL COMMENT '用户有效身份证件类型',
  `UserCardID` varchar(35) DEFAULT NULL COMMENT '用户有效身份证件号码',
  KEY `INDEX_EXPCODE_USERSEQ` (`ExpOrgCode`,`UserSeq`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人用户异常事件信息';

/*Table structure for table `indiv_mobils` */

CREATE TABLE `indiv_mobils` (
  `UserIDType` varchar(2) NOT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) NOT NULL COMMENT '有效身份证件号码',
  `MobilePhone` varchar(128) NOT NULL COMMENT '移动电话',
  `UserIDNodesc` varchar(128) DEFAULT NULL COMMENT '有效身份证件号码临时字段',
  `MobilePhonedesc` varchar(128) DEFAULT NULL COMMENT '移动电话临时字段',
  PRIMARY KEY (`UserIDType`,`UserIDNo`,`MobilePhone`),
  KEY `INDEX_IDTYPE_IDNO` (`UserIDType`,`UserIDNo`) USING BTREE,
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户移动电话信息';

/*Table structure for table `indivuser` */

CREATE TABLE `indivuser` (
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(128) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `ExpOrgCode` varchar(1024) DEFAULT NULL COMMENT '寄递企业代码',
  `UserName` varchar(100) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(10) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(100) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(100) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(300) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` varchar(100) DEFAULT NULL COMMENT '用户信息采集方式',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `Status` varchar(2) DEFAULT NULL COMMENT '状态  10：正常 20：解除协议   用户类型为1时填空，为2时必填',
  `UserIDNodesc` varchar(128) NOT NULL DEFAULT '' COMMENT '有效身份证件号码临时字段',
  PRIMARY KEY (`UserIDType`,`UserIDNo`),
  KEY `index_useridno` (`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户实名身份信息';

/*Table structure for table `indivuser_cache` */

CREATE TABLE `indivuser_cache` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `ProcId` varchar(34) DEFAULT NULL COMMENT '记录流水号',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `PseudoFlag` varchar(1) DEFAULT '1' COMMENT '是否需要生成伪码。0：不需要；1：需要。',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` varchar(4) DEFAULT NULL COMMENT '采集方式',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  `UserUnifiedId` varchar(128) DEFAULT NULL COMMENT '用户统一标识',
  `UserCardValidityStartDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `UserCardValidityEndDate` varchar(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',
  `Status` varchar(2) DEFAULT NULL COMMENT '状态  10：正常 20：解除协议   用户类型为1时填空，为2时必填'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='寄递用户实名身份信息缓存表';

/*Table structure for table `indivuser_his` */

CREATE TABLE `indivuser_his` (
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`UserIDType`,`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户实名身份信息';

/*Table structure for table `indivuser_interface` */

CREATE TABLE `indivuser_interface` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '上报个人用户请求消息报文',
  `status` varchar(2) DEFAULT NULL COMMENT '状态',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人用户消息上报接口表';

/*Table structure for table `indivuser_time_addr` */

CREATE TABLE `indivuser_time_addr` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserIDType` varchar(2) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `CheckTime` varchar(20) DEFAULT '00000000000000' COMMENT '查验时间',
  `Province` varchar(32) DEFAULT '000000' COMMENT '省',
  `City` varchar(32) DEFAULT '000000' COMMENT '市',
  `County` varchar(32) DEFAULT '000000' COMMENT '县',
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`UserIDType`,`UserIDNo`,`ExpOrgCode`),
  KEY `index_usertype` (`UserType`),
  KEY `index_checktime` (`CheckTime`),
  KEY `index_province` (`Province`),
  KEY `index_city` (`City`),
  KEY `index_county` (`County`),
  KEY `index_userseq` (`UserSeq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名用户查验时间查验地址表';

/*Table structure for table `indivuseractive_count` */

CREATE TABLE `indivuseractive_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表(全国)';

/*Table structure for table `indivuseractive_count_city` */

CREATE TABLE `indivuseractive_count_city` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（市）';

/*Table structure for table `indivuseractive_count_county` */

CREATE TABLE `indivuseractive_count_county` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（县区）';

/*Table structure for table `indivuseractive_count_exp` */

CREATE TABLE `indivuseractive_count_exp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表(企业，全国)';

/*Table structure for table `indivuseractive_count_expcity` */

CREATE TABLE `indivuseractive_count_expcity` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、市）';

/*Table structure for table `indivuseractive_count_expcounty` */

CREATE TABLE `indivuseractive_count_expcounty` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、县区）';

/*Table structure for table `indivuseractive_count_expprovince` */

CREATE TABLE `indivuseractive_count_expprovince` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、省）';

/*Table structure for table `indivuseractive_count_province` */

CREATE TABLE `indivuseractive_count_province` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_IC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（省）';

/*Table structure for table `indivuseractive_count_time` */

CREATE TABLE `indivuseractive_count_time` (
  `time` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名个人用户-统计时间表';

/*Table structure for table `inmessage` */

CREATE TABLE `inmessage` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '上报个人用户请求消息报文',
  `RspMsg` longtext COMMENT 'É±¨¸öû§·µ»ØûÎ',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报个人用户请求消息报文';

/*Table structure for table `interface_data_todisk` */

CREATE TABLE `interface_data_todisk` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `interface_type` int(4) NOT NULL COMMENT '接口数据类型，3101个人用户，3102机构用户，3103收派员用户,1102快件状态',
  `path` varchar(256) NOT NULL COMMENT '存储路径',
  `status` int(1) NOT NULL COMMENT '处理状态',
  `createTime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `service_flag` int(2) NOT NULL COMMENT '服务标识',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48160905 DEFAULT CHARSET=utf8 COMMENT='接口信息存储记录表';

/*Table structure for table `links` */

CREATE TABLE `links` (
  `LINK_ID` tinyint(4) NOT NULL AUTO_INCREMENT COMMENT '链接ID',
  `LINK_NAME` varchar(100) NOT NULL COMMENT '链接名称',
  `DISP_TYPE` varchar(20) NOT NULL DEFAULT 'before' COMMENT '显示类型,登陆前(before),登陆后(after)',
  `LINK_TYPE` varchar(20) NOT NULL DEFAULT 'commonlink' COMMENT '链接类型,commonlink,iframe',
  `LINK_URL` varchar(200) NOT NULL COMMENT '链接URL',
  `TARGET` varchar(30) NOT NULL DEFAULT 'self' COMMENT '链接打开方式:self,popup',
  `SUB_SYSTEM` varchar(20) NOT NULL COMMENT '链接归属子系统',
  `DOMAIN` varchar(20) NOT NULL COMMENT '链接归属域',
  `NEED_RIGHT` varchar(100) DEFAULT NULL COMMENT '显示此链接需要的权限，支持三形式的权限表示：menu(menuKey, ...) role(roleKey, ...),resoper(resKey-operKey,...)分别表示权限菜单描述,权限角色描述及权限资源操作key描述.各权限间以“,”分割，表示或的关系。空表示无权限限制',
  PRIMARY KEY (`LINK_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='链接';

/*Table structure for table `menu` */

CREATE TABLE `menu` (
  `MENU_ID` bigint(10) NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `MENU_NAME` varchar(64) NOT NULL COMMENT '菜单名称',
  `MENU_KEY` varchar(100) NOT NULL COMMENT '菜单外码',
  `PARENT_ID` bigint(10) NOT NULL COMMENT '父菜单ID',
  `IMAGE_URL` varchar(128) DEFAULT NULL COMMENT '图标Url',
  `URL` varchar(128) DEFAULT NULL COMMENT '资源URL',
  `MENU_ORDER` varchar(6) DEFAULT NULL COMMENT '菜单顺序',
  `SUBSYSTEM` varchar(32) DEFAULT NULL COMMENT '子系统名称',
  `DOMAIN` varchar(32) DEFAULT NULL COMMENT '菜单所属域（admin、sp）',
  PRIMARY KEY (`MENU_ID`),
  UNIQUE KEY `idx_menu_key` (`MENU_KEY`)
) ENGINE=InnoDB AUTO_INCREMENT=1588 DEFAULT CHARSET=utf8 COMMENT='菜单';

/*Table structure for table `mon_address` */

CREATE TABLE `mon_address` (
  `monAddressId` varchar(64) NOT NULL COMMENT '主键',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `CountyCode` varchar(32) DEFAULT NULL COMMENT '地区编码',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `CruxWord` varchar(32) DEFAULT NULL COMMENT '关键词',
  `monStatus` varchar(64) DEFAULT NULL COMMENT '监控状态',
  `monStartTime` varchar(20) DEFAULT NULL COMMENT '开始监控时间',
  `monEndTime` varchar(20) DEFAULT NULL COMMENT '结束监控时间',
  `CreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `useFlag` varchar(2) NOT NULL DEFAULT 'Y' COMMENT '是否有效,Y有效，N无效',
  `CreateByPerson` varchar(32) NOT NULL COMMENT '创建人',
  `CreateByOrgCode` varchar(2) NOT NULL COMMENT '创建部门'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='地址监控信息表';

/*Table structure for table `mon_bill_number` */

CREATE TABLE `mon_bill_number` (
  `monBillNumberId` varchar(64) NOT NULL COMMENT '主键',
  `exp_org_code` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `user_type` varchar(1) DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `bill_number` varchar(35) NOT NULL COMMENT '快递单号',
  `monStatus` varchar(64) DEFAULT NULL COMMENT '监控状态',
  `monStartTime` varchar(20) DEFAULT NULL COMMENT '开始监控时间',
  `monEndTime` varchar(20) DEFAULT NULL COMMENT '结束监控时间',
  `CreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `useFlag` varchar(2) NOT NULL DEFAULT 'Y' COMMENT '是否有效,Y有效，N无效',
  `CreateByPerson` varchar(32) NOT NULL COMMENT '创建人',
  `CreateByOrgCode` varchar(2) NOT NULL COMMENT '创建部门'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='快递号监控信息表';

/*Table structure for table `mon_express` */

CREATE TABLE `mon_express` (
  `expOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `bill_number` varchar(100) NOT NULL COMMENT '快递单号',
  `userName` varchar(10) NOT NULL COMMENT '寄件人',
  `consignee` varchar(10) DEFAULT NULL COMMENT '收件人',
  `sendTime` varchar(20) NOT NULL COMMENT '寄件时间',
  `userType` varchar(1) DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `userIDType` varchar(10) DEFAULT '' COMMENT '证件类型',
  `userIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '证件号码',
  `addressLocation` varchar(2) NOT NULL DEFAULT '查看' COMMENT '地址定位',
  `details` varchar(2) NOT NULL DEFAULT '查看' COMMENT '详情'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='重点关注快件监控表';

/*Table structure for table `mon_indivuser` */

CREATE TABLE `mon_indivuser` (
  `UserType` varchar(1) NOT NULL DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `UserIDType` varchar(10) NOT NULL DEFAULT '' COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `MobileTelephone` varchar(32) DEFAULT NULL COMMENT '移动号码',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `monStatus` varchar(64) DEFAULT NULL COMMENT '监控状态',
  `monStartTime` varchar(20) DEFAULT NULL COMMENT '开始监控时间',
  `monEndTime` varchar(20) DEFAULT NULL COMMENT '结束监控时间',
  `CreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `useFlag` varchar(2) NOT NULL DEFAULT 'Y' COMMENT '是否有效,Y有效，N无效',
  `CreateByPerson` varchar(32) NOT NULL COMMENT '创建人',
  `CreateByOrgCode` varchar(2) NOT NULL COMMENT '创建部门',
  PRIMARY KEY (`UserType`,`UserIDType`,`UserIDNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='人员监控信息表';

/*Table structure for table `mon_send_address` */

CREATE TABLE `mon_send_address` (
  `region` varchar(256) DEFAULT NULL COMMENT '所属区域',
  `detailAddr` varchar(256) DEFAULT NULL COMMENT '重点关注地址',
  `keyword` varchar(50) DEFAULT NULL COMMENT '关键词',
  `province` varchar(256) DEFAULT NULL COMMENT '寄递地址-省',
  `city` varchar(256) DEFAULT NULL COMMENT '寄递地址-市',
  `county` varchar(256) DEFAULT NULL COMMENT '寄递地址-县',
  `expOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业',
  `sendTime` varchar(20) DEFAULT NULL COMMENT '寄件时间',
  `userName` varchar(10) DEFAULT NULL COMMENT '寄件人',
  `userIDType` varchar(10) NOT NULL DEFAULT '' COMMENT '证件类型',
  `userIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '证件号码',
  `telephone` varchar(20) DEFAULT NULL COMMENT '联系电话',
  `addressLocation` varchar(2) DEFAULT '查看' COMMENT '地址定位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='重点关注地址寄件信息监控表';

/*Table structure for table `mon_sender` */

CREATE TABLE `mon_sender` (
  `userName` varchar(100) NOT NULL COMMENT '用户名称',
  `userType` varchar(1) DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',
  `userIDType` varchar(10) DEFAULT '' COMMENT '证件类型',
  `userIDNo` varchar(35) NOT NULL DEFAULT '' COMMENT '证件号码',
  `telephone` varchar(100) NOT NULL COMMENT '联系电话',
  `expOrgCode` varchar(32) NOT NULL COMMENT '寄递企业',
  `province` varchar(256) DEFAULT NULL COMMENT '寄递地址-省',
  `city` varchar(256) DEFAULT NULL COMMENT '寄递地址-市',
  `county` varchar(256) DEFAULT NULL COMMENT '寄递地址-县',
  `sendTime` varchar(20) NOT NULL COMMENT '寄件时间',
  `addressLocation` varchar(2) NOT NULL DEFAULT '查看' COMMENT '地址定位'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='重点关注人员寄件信息监控表';

/*Table structure for table `new_user_stat` */

CREATE TABLE `new_user_stat` (
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `StatDate` varchar(8) DEFAULT NULL COMMENT '统计日期。格式:YYYYMMDD',
  `NewCheckedUserNumber` bigint(10) DEFAULT NULL COMMENT '新增已面验用户数',
  `TotalCheckedUserNumber` bigint(10) DEFAULT NULL COMMENT '总已面验用户数',
  `ToCheckUserNumber` bigint(10) DEFAULT NULL COMMENT '待面验用户数',
  `TotalUserNumber` bigint(10) DEFAULT NULL COMMENT '总用户数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新增用户日统计';

/*Table structure for table `newuser_stat_msg` */

CREATE TABLE `newuser_stat_msg` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` varchar(2048) DEFAULT NULL COMMENT '上报新增用户日报请求消息报文',
  `RspMsg` varchar(2048) DEFAULT NULL COMMENT '上报新增用户日报应答消息报文',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报新增用户日报消息报文';

/*Table structure for table `orguser` */

CREATE TABLE `orguser` (
  `ExpOrgCode` varchar(10) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `OrgName` varchar(64) DEFAULT NULL COMMENT '机构名称',
  `OrgCode` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `USCCode` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `IsChecked` varchar(2) DEFAULT '0' COMMENT '是否已查验:0：未查验 1：已查验',
  `CheckTime` varchar(20) DEFAULT '00000000000000' COMMENT '查验时间',
  `CheckProvince` varchar(32) DEFAULT '000000' COMMENT '省',
  `CheckCity` varchar(32) DEFAULT '000000' COMMENT '市',
  `CheckCounty` varchar(32) DEFAULT '000000' COMMENT '县',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `Status` varchar(2) DEFAULT '10' COMMENT '状态:10-正常,20-解除协议',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '用户统一标识(伪码)',
  `PseudoStatus` int(2) DEFAULT '0' COMMENT '用户伪码状态。0：赋码未下发 1：赋码已下发',
  `Operator` varchar(32) DEFAULT 'default' COMMENT '实际寄件的机构用户员工姓名',
  KEY `index_checktime` (`CheckTime`),
  KEY `index_checkprovince` (`CheckProvince`),
  KEY `index_checkcity` (`CheckCity`),
  KEY `index_checkcounty` (`CheckCounty`),
  KEY `idx_orgcode` (`OrgCode`),
  KEY `idx_exporgcode` (`ExpOrgCode`),
  KEY `INDEX_IDTYPE_EXPORGUSC` (`ExpOrgCode`,`OrgCode`,`USCCode`) USING BTREE,
  KEY `INDEX_IDTYPE_EXPORG` (`ExpOrgCode`,`OrgCode`) USING BTREE,
  KEY `INDEX_IDTYPE_EXPUSC` (`ExpOrgCode`,`USCCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构用户信息表';

/*Table structure for table `orguser_cache` */

CREATE TABLE `orguser_cache` (
  `ExpOrgCode` varchar(10) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `OrgName` varchar(64) DEFAULT NULL COMMENT '机构名称',
  `OrgCode` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `USCCode` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `PseudoFlag` varchar(1) DEFAULT '1' COMMENT '是否需要生成伪码。0：不需要；1：需要。',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  `Status` varchar(2) DEFAULT '10' COMMENT '状态:10-正常,20-解除协议',
  `Operator` varchar(32) DEFAULT 'default' COMMENT '实际寄件的机构用户员工姓名'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构用户信息缓存表';

/*Table structure for table `orguser_count` */

CREATE TABLE `orguser_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `UserType` varchar(32) DEFAULT NULL COMMENT '机构用户类别：0.全部，1.有查验记录，2.无查验记录',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`),
  KEY `IDX_OC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构用户信息统计表';

/*Table structure for table `orguser_count_temp` */

CREATE TABLE `orguser_count_temp` (
  `ExpOrgCode` varchar(10) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `OrgName` varchar(64) DEFAULT NULL COMMENT '机构名称',
  `OrgCode` varchar(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',
  `USCCode` varchar(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `IsChecked` varchar(2) DEFAULT '0' COMMENT '是否已查验:0：未查验 1：已查验',
  `CheckTime` varchar(20) DEFAULT '00000000000000' COMMENT '查验时间',
  `CheckProvince` varchar(32) DEFAULT '000000' COMMENT '省',
  `CheckCity` varchar(32) DEFAULT '000000' COMMENT '市',
  `CheckCounty` varchar(32) DEFAULT '000000' COMMENT '县',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '系统时间',
  `IsPublic` varchar(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',
  KEY `index_checktime` (`CheckTime`),
  KEY `index_checkprovince` (`CheckProvince`),
  KEY `index_checkcity` (`CheckCity`),
  KEY `index_checkcounty` (`CheckCounty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构用户信息统计快照表';

/*Table structure for table `orguser_his` */

CREATE TABLE `orguser_his` (
  `HisSeq` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '序列号(自动递增)',
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `ExpOrgCode` varchar(10) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `OrgName` varchar(64) DEFAULT NULL COMMENT '机构名称',
  `OrgCode` varchar(10) DEFAULT NULL COMMENT '组织机构代码',
  `USCCode` varchar(20) DEFAULT NULL COMMENT '统一社会信用代码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '联系电话',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  `TaxRegNo` varchar(30) DEFAULT NULL COMMENT '税务登记证号',
  `Status` varchar(2) DEFAULT '10' COMMENT '状态:10-正常,20-解除协议',
  `Operator` varchar(32) DEFAULT 'default' COMMENT '实际寄件的机构用户员工姓名',
  PRIMARY KEY (`HisSeq`)
) ENGINE=InnoDB AUTO_INCREMENT=619286 DEFAULT CHARSET=utf8 COMMENT='机构用户信息表';

/*Table structure for table `orguser_time_addr` */

CREATE TABLE `orguser_time_addr` (
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `CheckTime` varchar(20) DEFAULT '00000000000000' COMMENT '查验时间',
  `Province` varchar(32) DEFAULT '000000' COMMENT '省',
  `City` varchar(32) DEFAULT '000000' COMMENT '市',
  `County` varchar(32) DEFAULT '000000' COMMENT '县',
  `OrgCode` varchar(10) NOT NULL DEFAULT '' COMMENT '组织机构代码',
  `USCCode` varchar(20) NOT NULL DEFAULT '' COMMENT '统一社会信用代码',
  `TaxRegNo` varchar(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`ExpOrgCode`,`OrgCode`,`USCCode`,`TaxRegNo`),
  KEY `index_checktime` (`CheckTime`),
  KEY `index_province` (`Province`),
  KEY `index_city` (`City`),
  KEY `index_county` (`County`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='机构用户查验时间查验地址表';

/*Table structure for table `orgusermessage` */

CREATE TABLE `orgusermessage` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '上报机构用户请求消息报文',
  `RspMsg` longtext COMMENT 'É±¨»ú»§Ӧ´ð¢±¨Î',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报机构用户消息报文';

/*Table structure for table `outmessage` */

CREATE TABLE `outmessage` (
  `MessageNo` varchar(20) NOT NULL COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) NOT NULL DEFAULT '' COMMENT '寄递企业代码',
  `ReqMsg` varchar(2048) DEFAULT NULL COMMENT '下发请求消息报文',
  `RspMsg` varchar(2048) DEFAULT NULL COMMENT '下发应答消息报文',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` varchar(128) DEFAULT NULL COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间',
  PRIMARY KEY (`MessageNo`,`ExpOrgCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='下发个人用户伪码消息报文';

/*Table structure for table `outmessage_cache` */

CREATE TABLE `outmessage_cache` (
  `MessageNo` varchar(20) NOT NULL COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `ReqMsg` varchar(2048) DEFAULT NULL COMMENT '下发请求消息报文',
  `TemType` varchar(2) DEFAULT NULL COMMENT '模块类型：1：个人用户 2：收派员 3: 机构用户',
  PRIMARY KEY (`MessageNo`,`ExpOrgCode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待下发消息报文缓存表';

/*Table structure for table `pend_task_remind` */

CREATE TABLE `pend_task_remind` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '流水号',
  `CATEGORY` varchar(64) NOT NULL COMMENT '待办分类',
  `NAME` varchar(64) NOT NULL COMMENT '待办名称',
  `TITLE` varchar(128) DEFAULT NULL COMMENT '待办标题',
  `LINKURL` varchar(2000) DEFAULT NULL COMMENT '待办链接URL',
  `BUSINESSID` varchar(25) DEFAULT NULL COMMENT '待办业务ID(用于细分待办,可为空)',
  `COUNT` varchar(12) NOT NULL COMMENT '待办数量',
  `REMARK` varchar(128) DEFAULT NULL COMMENT '备注字段',
  `CONTENT` varchar(2000) DEFAULT NULL COMMENT '内容',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `NEWINDEX1` (`CATEGORY`,`NAME`,`BUSINESSID`,`REMARK`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办';

/*Table structure for table `pend_task_remind_log` */

CREATE TABLE `pend_task_remind_log` (
  `STAFF_ID` bigint(20) DEFAULT NULL COMMENT '成员ID',
  `CATEGORY` varchar(64) DEFAULT NULL COMMENT '待办分类',
  `PEND_TASK_ITEM` varchar(64) DEFAULT NULL COMMENT '待办项',
  `COUNT` varchar(12) DEFAULT NULL COMMENT '待办数量',
  `SEND_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '发送日期',
  `SEND_METHOD` varchar(16) DEFAULT NULL COMMENT '发送类型(SMS-短信,EMAIL-电子邮件)',
  `ISMULTITASK` varchar(1) NOT NULL DEFAULT '0' COMMENT '是否是多条代办,1是，0不是，默认0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办日志';

/*Table structure for table `pend_task_setting` */

CREATE TABLE `pend_task_setting` (
  `STAFFID` bigint(20) NOT NULL COMMENT '员工ID',
  `SENDEMAIL` varchar(1) NOT NULL COMMENT 'Email发送标志,1发送 0不发',
  `SENDSMS` varchar(1) NOT NULL COMMENT 'Sms发送标志,1发送 0不发',
  `EMAILSENDTIME` varchar(36) DEFAULT NULL COMMENT 'Email发送时间,格式：N个HH，并且每个HH后要带逗号, 如08,09',
  `SMSSENDTIME` varchar(36) DEFAULT NULL COMMENT 'Sms发送时间,格式：N个HH，如0809',
  `EMAILSENDTYPE` varchar(1) DEFAULT NULL COMMENT 'Email发送方式,1合并待办发送 0不合并待办发送 缺省为不合并，每条待办一封邮件',
  PRIMARY KEY (`STAFFID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='待办设置';

/*Table structure for table `person_setting` */

CREATE TABLE `person_setting` (
  `STAFF_ID` bigint(20) NOT NULL COMMENT '用户ID',
  `PROP_NAME` varchar(100) NOT NULL COMMENT '属性名',
  `PROP_VALUE` varchar(4000) DEFAULT NULL COMMENT '属性值',
  PRIMARY KEY (`STAFF_ID`,`PROP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户设置';

/*Table structure for table `person_shortcut` */

CREATE TABLE `person_shortcut` (
  `SHORTCUT_ID` tinyint(4) NOT NULL AUTO_INCREMENT COMMENT '快捷方式ID',
  `STAFF_ID` bigint(20) NOT NULL COMMENT '用户ID',
  `TITLE` varchar(64) NOT NULL COMMENT '标题',
  `MENU_ID` bigint(10) NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`SHORTCUT_ID`),
  KEY `FK_PERSON_SHORTCUT` (`MENU_ID`),
  CONSTRAINT `FK_PERSON_SHORTCUT` FOREIGN KEY (`MENU_ID`) REFERENCES `menu` (`MENU_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户快捷方式设置';

/*Table structure for table `portal_session` */

CREATE TABLE `portal_session` (
  `SESSION_ID` varchar(100) NOT NULL COMMENT 'portal中的sessionId',
  `STAFF_ID` bigint(20) NOT NULL COMMENT '登录用户ID',
  `LOGIN_TIME` varchar(15) NOT NULL COMMENT '该session登录的精确时间，取自1970 年 1 月 1 日午夜以来的毫秒数',
  `LOGIN_TIME2` datetime DEFAULT NULL COMMENT '该session登录的近似时间，取应用的sysdate。该值作为备注',
  PRIMARY KEY (`SESSION_ID`),
  KEY `INDEX_STAFF_ID` (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户会话';

/*Table structure for table `province` */

CREATE TABLE `province` (
  `PROVINCE_ID` int(8) NOT NULL COMMENT '省份ID',
  `PROV_NAME` varchar(30) NOT NULL COMMENT '省份名称',
  `SHORT_NAME` varchar(20) DEFAULT NULL COMMENT '简称',
  PRIMARY KEY (`PROVINCE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='省份';

/*Table structure for table `report_indiv_addrs` */

CREATE TABLE `report_indiv_addrs` (
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `ProcId` varchar(34) NOT NULL COMMENT '记录流水号',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `Type` int(1) DEFAULT NULL COMMENT '地址类型.1：证件地址;2：常用地址',
  `Province` varchar(32) DEFAULT NULL COMMENT '省',
  `City` varchar(32) DEFAULT NULL COMMENT '市',
  `County` varchar(32) DEFAULT NULL COMMENT '县',
  `DetailAddr` varchar(256) DEFAULT NULL COMMENT '详细地址',
  KEY `INDEX_IDTYPE_IDNO` (`UserIDType`,`UserIDNo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户地址信息申请表';

/*Table structure for table `report_indiv_mobils` */

CREATE TABLE `report_indiv_mobils` (
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `ProcId` varchar(34) NOT NULL COMMENT '记录流水号',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `MobilePhone` varchar(32) DEFAULT NULL COMMENT '移动电话',
  KEY `INDEX_IDTYPE_IDNO` (`UserIDType`,`UserIDNo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户移动电话申请表';

/*Table structure for table `report_indivuser` */

CREATE TABLE `report_indivuser` (
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `ProcId` varchar(34) NOT NULL COMMENT '记录流水号',
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CollectMethod` int(2) DEFAULT NULL COMMENT '用户信息采集方式',
  `IsAdopt` varchar(2) DEFAULT NULL COMMENT '实名用户稽核：0，通过，1不通过',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='上报寄递用户实名身份信息申请表';

/*Table structure for table `report_indivuser_his` */

CREATE TABLE `report_indivuser_his` (
  `HisSeq` bigint(16) NOT NULL AUTO_INCREMENT COMMENT '序列号(自动递增)',
  `OperCode` int(1) NOT NULL COMMENT '操作类型',
  `UserSeq` varchar(16) DEFAULT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) DEFAULT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `OprTime` varchar(20) DEFAULT NULL COMMENT '操作时间',
  PRIMARY KEY (`HisSeq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='个人用户信息变动历史记录表';

/*Table structure for table `sec_department` */

CREATE TABLE `sec_department` (
  `DEPARTMENT_ID` varchar(254) NOT NULL,
  `DEPARTMENT_NAME` varchar(100) NOT NULL COMMENT '组织名称',
  `DEPARTMENT_DESC` varchar(100) DEFAULT NULL COMMENT '组织描述',
  `PARENT_ID` varchar(254) DEFAULT NULL,
  `EMAIL` varchar(50) DEFAULT NULL COMMENT '组织的邮件',
  `ADDRESS` varchar(200) DEFAULT NULL COMMENT '组织地址',
  `ADD_SUB` varchar(1) NOT NULL DEFAULT '1' COMMENT '是否可以创建下级组织',
  `CREATE_USER` varchar(20) NOT NULL COMMENT '组织创建者',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '组织创建时间',
  `LAST_UPDATE_DATE` timestamp NULL DEFAULT NULL COMMENT '组织最后修改时间',
  `DOMAIN` varchar(10) DEFAULT 'SYS_ADMIN' COMMENT '管理域：SP、SYS_ADMIN',
  `ORGUUID` varchar(80) DEFAULT NULL COMMENT '组织唯一ID',
  `ORGTYPE` varchar(1) DEFAULT NULL COMMENT '组织类型 1单位 2部门',
  `CONTACT` varchar(1000) DEFAULT NULL COMMENT '联系方式',
  `MEMO` varchar(254) DEFAULT NULL COMMENT '说明',
  `ENNAME` varchar(254) DEFAULT NULL COMMENT '组织简称',
  `SERIALINDEX` varchar(10) DEFAULT NULL COMMENT '组织排序',
  `ORGDISTRICT` varchar(6) DEFAULT NULL COMMENT '组织行政区划',
  `ORGADD` varchar(500) DEFAULT NULL COMMENT '详细地址',
  `ORGLEVELCODE` varchar(200) DEFAULT NULL COMMENT '组织级别编码',
  `DELFLAG` varchar(1) NOT NULL DEFAULT '1' COMMENT '部门状态 0 启用 1 禁用',
  PRIMARY KEY (`DEPARTMENT_ID`),
  KEY `FK_sec_department` (`PARENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织';

/*Table structure for table `sec_department_extend_property` */

CREATE TABLE `sec_department_extend_property` (
  `DEPARTMENT_ID` varchar(254) NOT NULL,
  `PROPERTY` varchar(32) NOT NULL,
  `VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`DEPARTMENT_ID`,`PROPERTY`),
  CONSTRAINT `FK_sec_department_extend_property` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `sec_department` (`DEPARTMENT_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成员扩展属性表';

/*Table structure for table `sec_department_role` */

CREATE TABLE `sec_department_role` (
  `DEPARTMENT_ID` varchar(254) NOT NULL,
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`DEPARTMENT_ID`,`ROLE_ID`),
  KEY `FK_sec_department_role2` (`ROLE_ID`),
  CONSTRAINT `FK_sec_department_role` FOREIGN KEY (`DEPARTMENT_ID`) REFERENCES `sec_department` (`DEPARTMENT_ID`),
  CONSTRAINT `FK_sec_department_role2` FOREIGN KEY (`ROLE_ID`) REFERENCES `sec_role` (`ROLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织角色关联表';

/*Table structure for table `sec_login_history` */

CREATE TABLE `sec_login_history` (
  `STAFF_ID` bigint(20) NOT NULL COMMENT '成员ID',
  `LOGIN_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '登录时间',
  `LOGIN_FLAG` varchar(10) NOT NULL COMMENT 'LOGOUT：注销；SUCCESS：登录成功；FAIL：登录失败；TIMEOUT：用户超时；UNLOCK：解锁；AUTOLOCK：密码尝试过多被锁',
  `DESCRIPTION` varchar(20) DEFAULT NULL COMMENT '备注，现在用来记录用户登录密码尝试过多被锁前的用户状态',
  PRIMARY KEY (`STAFF_ID`,`LOGIN_TIME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成员登录日志';

/*Table structure for table `sec_metadata_log` */

CREATE TABLE `sec_metadata_log` (
  `LOG_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Logid',
  `HOST_NAME` varchar(250) DEFAULT NULL COMMENT '执行导入操作的主机名',
  `CLIENT_IP` varchar(32) DEFAULT NULL COMMENT '执行导入操作的主机IP',
  `FILE_NAME` varchar(500) DEFAULT NULL COMMENT '导入的文件名',
  `BACKUP_FILE_NAME` varchar(500) DEFAULT NULL COMMENT '导入的文件名备份的名字',
  `SUFFIX` varchar(20) DEFAULT NULL COMMENT '备份表的后缀',
  `OPERATION_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
  `OPERATOR` varchar(50) DEFAULT NULL COMMENT '操作人(操作系统的当前成员)',
  `RESULT` varchar(50) DEFAULT NULL COMMENT '导入结果',
  `OPERATION` varchar(50) DEFAULT NULL COMMENT '操作类型:delete| import',
  `METADATA_ID` varchar(500) DEFAULT NULL COMMENT '元数据ID',
  `SYSTEM_NAME` varchar(32) DEFAULT NULL COMMENT '系统名称',
  `PREFIX` varchar(5) DEFAULT NULL COMMENT '备份表的前缀',
  `domain` varchar(20) DEFAULT NULL COMMENT '管理域：SP、ADMIN',
  PRIMARY KEY (`LOG_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='元数据导入日志';

/*Table structure for table `sec_operation` */

CREATE TABLE `sec_operation` (
  `OPERATION_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资源操作主键',
  `RESOURCE_ID` bigint(20) NOT NULL COMMENT '资源主键',
  `OPERATION_KEY` varchar(32) NOT NULL COMMENT '操作关键字',
  `OPERATION_NAME` varchar(100) NOT NULL COMMENT '操作名称',
  `OPERATION_DESC` varchar(100) DEFAULT NULL COMMENT '操作描述',
  `DEPEND_KEY` varchar(32) DEFAULT NULL COMMENT '依赖操作KEY',
  `DEPEND_BY_KEY` varchar(500) DEFAULT NULL COMMENT '被依赖操作KEY',
  `METADATA_ID` varchar(32) DEFAULT NULL COMMENT '元数据ID',
  `DOMAIN` varchar(20) DEFAULT NULL COMMENT '管理域：SP、ADMIN',
  `ORDER_KEY` int(5) DEFAULT NULL COMMENT '操作的顺序',
  PRIMARY KEY (`OPERATION_ID`),
  UNIQUE KEY `SEC_OPERATION_IDX` (`RESOURCE_ID`,`OPERATION_KEY`),
  CONSTRAINT `FK_sec_operation` FOREIGN KEY (`RESOURCE_ID`) REFERENCES `sec_resources` (`RESOURCE_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1780 DEFAULT CHARSET=utf8 COMMENT='资源操作';

/*Table structure for table `sec_operation_address` */

CREATE TABLE `sec_operation_address` (
  `ADDRESS_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '访问地址ID',
  `RESOURCE_ID` bigint(20) NOT NULL COMMENT '资源ID',
  `OPERATION_KEY` varchar(32) NOT NULL COMMENT '资源操作外码',
  `OPERATION_ADDRESS_NAME` varchar(100) DEFAULT NULL COMMENT '访问地址名称',
  `OPERATION_ADDRESS_URL` varchar(128) NOT NULL COMMENT '访问地址URL（不包含协议、IP、端口、contextpath）',
  `PARAMETER_NAME1` varchar(64) DEFAULT NULL COMMENT '参数名一',
  `PARAMETER_VALUE1` varchar(64) DEFAULT NULL COMMENT '参数值一',
  `PARAMETER_NAME2` varchar(64) DEFAULT NULL COMMENT '参数名二',
  `PARAMETER_VALUE2` varchar(64) DEFAULT NULL COMMENT '参数值二',
  `PARAMETER_NAME3` varchar(64) DEFAULT NULL COMMENT '参数名三',
  `PARAMETER_VALUE3` varchar(64) DEFAULT NULL COMMENT '参数值三',
  `METADATA_ID` varchar(32) DEFAULT NULL COMMENT '元数据ID',
  `DOMAIN` varchar(20) DEFAULT NULL COMMENT '管理域：SP、ADMIN',
  PRIMARY KEY (`ADDRESS_ID`),
  KEY `FK_sec_operation_address` (`RESOURCE_ID`,`OPERATION_KEY`),
  KEY `idx_sec_operation_address` (`OPERATION_ADDRESS_URL`),
  CONSTRAINT `FK_sec_operation_address` FOREIGN KEY (`RESOURCE_ID`, `OPERATION_KEY`) REFERENCES `sec_operation` (`RESOURCE_ID`, `OPERATION_KEY`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10236 DEFAULT CHARSET=utf8 COMMENT='资源操作地址';

/*Table structure for table `sec_password_history` */

CREATE TABLE `sec_password_history` (
  `STAFF_ID` bigint(20) NOT NULL COMMENT '成员ID',
  `PASSWORD` varchar(128) NOT NULL COMMENT '密码',
  `UPDATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '变更时间',
  PRIMARY KEY (`STAFF_ID`,`UPDATE_DATE`),
  CONSTRAINT `FK_SEC_PASSWORD_HISTORY` FOREIGN KEY (`STAFF_ID`) REFERENCES `sec_staff` (`STAFF_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户密码变更日志';

/*Table structure for table `sec_resource_category` */

CREATE TABLE `sec_resource_category` (
  `CATEGORY_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资源分类ID',
  `PARENT_ID` bigint(20) DEFAULT NULL COMMENT '上级资源分类ID',
  `CATEGORY_NAME` varchar(100) DEFAULT NULL COMMENT '资源分类名称',
  `CATEGORY_DESC` varchar(100) DEFAULT NULL COMMENT '资源分类描述',
  `METADATA_ID` varchar(32) DEFAULT NULL COMMENT '元数据ID',
  `CATEGORY_KEY` varchar(100) DEFAULT NULL COMMENT '资源分类外码',
  `DOMAIN` varchar(20) DEFAULT NULL COMMENT '管理域：SP、ADMIN',
  `ORDER_KEY` int(11) DEFAULT NULL COMMENT '资源分类的顺序',
  PRIMARY KEY (`CATEGORY_ID`),
  KEY `FK_sec_resource_category` (`PARENT_ID`),
  CONSTRAINT `FK_sec_resource_category` FOREIGN KEY (`PARENT_ID`) REFERENCES `sec_resource_category` (`CATEGORY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8 COMMENT='资源分类';

/*Table structure for table `sec_resources` */

CREATE TABLE `sec_resources` (
  `RESOURCE_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '资源ID',
  `RESOURCE_KEY` varchar(100) NOT NULL COMMENT '资源外码',
  `RESOURCE_NAME` varchar(100) NOT NULL COMMENT '资源名称',
  `RESOURCE_DESC` varchar(100) DEFAULT NULL COMMENT '资源描述',
  `CATEGORY_ID` bigint(20) NOT NULL COMMENT '资源分类ID',
  `AUTH_TYPE` varchar(10) NOT NULL COMMENT '鉴权类型(AUTH：鉴权，UNAUTH：不鉴权，LOGIN_AUTH：登录鉴权)',
  `METADATA_ID` varchar(32) DEFAULT NULL COMMENT '元数据ID',
  `DOMAIN` varchar(20) DEFAULT NULL COMMENT '管理域：SP、ADMIN',
  `ORDER_KEY` int(11) DEFAULT NULL COMMENT '资源的顺序',
  PRIMARY KEY (`RESOURCE_ID`),
  UNIQUE KEY `UNQ_RESOURCE_KEY` (`RESOURCE_KEY`),
  KEY `FK_sec_resources` (`CATEGORY_ID`),
  CONSTRAINT `FK_sec_resources` FOREIGN KEY (`CATEGORY_ID`) REFERENCES `sec_resource_category` (`CATEGORY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1329 DEFAULT CHARSET=utf8 COMMENT='资源';

/*Table structure for table `sec_role` */

CREATE TABLE `sec_role` (
  `ROLE_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `ROLE_NAME` varchar(100) NOT NULL COMMENT '角色名称',
  `ROLE_DESC` varchar(400) DEFAULT NULL COMMENT '角色描述',
  `CREATE_USER` varchar(20) NOT NULL COMMENT '角色创建者',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '角色创建时间',
  `CAN_MODIFY` int(11) NOT NULL DEFAULT '1' COMMENT '是否允许修改 1：允许 0: 不充许 缺省=1',
  `LAST_UPDATE_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '角色最后修改时间',
  `ROLE_KEY` varchar(64) DEFAULT NULL COMMENT '角色外码',
  `AUTO_ASSIGN` int(1) NOT NULL DEFAULT '0' COMMENT '自动分配(0:不自动分配；1：自动分配给所有注册成员)',
  `visible` int(1) NOT NULL DEFAULT '1' COMMENT '是否在界面上可见(0：不可见；1：可见)',
  PRIMARY KEY (`ROLE_ID`),
  UNIQUE KEY `ROLE_KEY` (`ROLE_KEY`),
  KEY `IDX_ROLE_NAME` (`ROLE_NAME`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COMMENT='角色';

/*Table structure for table `sec_role_resource_operation` */

CREATE TABLE `sec_role_resource_operation` (
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  `RESOURCE_ID` bigint(32) NOT NULL COMMENT '资源ID',
  `OPERATION_KEY` varchar(32) NOT NULL COMMENT '资源操作关键字',
  PRIMARY KEY (`ROLE_ID`,`RESOURCE_ID`,`OPERATION_KEY`),
  KEY `FK_sec_role_resource_operation` (`RESOURCE_ID`,`OPERATION_KEY`),
  CONSTRAINT `FK_sec_role_resource_operation` FOREIGN KEY (`RESOURCE_ID`, `OPERATION_KEY`) REFERENCES `sec_operation` (`RESOURCE_ID`, `OPERATION_KEY`) ON DELETE CASCADE,
  CONSTRAINT `FK_sec_role_resource_operation_role` FOREIGN KEY (`ROLE_ID`) REFERENCES `sec_role` (`ROLE_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色与资源操作';

/*Table structure for table `sec_staff` */

CREATE TABLE `sec_staff` (
  `STAFF_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '成员ID',
  `LOGIN_NAME` varchar(100) NOT NULL COMMENT '登录名',
  `DEPARTMENT_ID` varchar(254) DEFAULT NULL,
  `REAL_NAME` varchar(100) NOT NULL COMMENT '成员姓名',
  `PASSWORD` varchar(128) NOT NULL COMMENT '密码（经过加密）',
  `STATUS` varchar(20) NOT NULL DEFAULT 'INITIAL' COMMENT '成员状态',
  `SEX` varchar(10) DEFAULT NULL COMMENT '性别：MALE-男性；FEMALE-女性；',
  `TELEPHONE` varchar(30) DEFAULT NULL COMMENT '电话',
  `MOBILE` varchar(100) NOT NULL COMMENT '手机号码',
  `EMAIL` varchar(64) DEFAULT NULL COMMENT '邮件地址',
  `CREATE_USER` varchar(100) NOT NULL COMMENT '成员创建者',
  `CREATE_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '成员创建时间',
  `EXPIRE_DATE` timestamp NULL DEFAULT NULL COMMENT '成员帐号过期时间',
  `LAST_UPDATE_DATE` timestamp NULL DEFAULT NULL COMMENT '成员最后修改时间',
  `PASSWORD_EXPIRE_DATE` timestamp NULL DEFAULT NULL COMMENT '密码失效时间',
  `LOCK_DATE` timestamp NULL DEFAULT NULL COMMENT '用户锁定时间',
  `CITY_ID` int(11) DEFAULT NULL COMMENT '成员所在城市（参见CITY表）',
  `PERSONUUID` varchar(80) DEFAULT NULL COMMENT '人员唯一ID',
  `ALIASNAME` varchar(128) DEFAULT NULL COMMENT '别名',
  `PERSONCODE` varchar(128) DEFAULT NULL COMMENT '人员统一编码',
  `FIRSTNAME` varchar(128) DEFAULT NULL COMMENT '名',
  `LASTNAME` varchar(128) DEFAULT NULL COMMENT '姓',
  `IDNUM` varchar(50) DEFAULT NULL COMMENT '证件号',
  `CARDTYPE` varchar(1) DEFAULT NULL COMMENT '证件类型 1身份证 2军人证 3工作证 4学生证',
  `BIRTHDATE` varchar(30) DEFAULT NULL COMMENT '出生年月',
  `NATIONALITY` varchar(2) DEFAULT NULL COMMENT '民族',
  `NATIVE_PLACE` varchar(128) DEFAULT NULL COMMENT '籍贯',
  `MARRIAGE` varchar(2) DEFAULT NULL COMMENT '婚姻 1未婚 2已婚 3丧偶 4离婚',
  `HOMETEL` varchar(32) DEFAULT NULL COMMENT '家庭电话',
  `OFFICETEL` varchar(32) DEFAULT NULL COMMENT '办公电话',
  `OFFICEFAX` varchar(32) DEFAULT NULL COMMENT '办公传真',
  `CONNECTADDR` varchar(6) DEFAULT NULL COMMENT '联系地址',
  `ZIP` varchar(32) DEFAULT NULL COMMENT '邮编',
  `EDU` varchar(2) DEFAULT NULL COMMENT '学历 1 博士生毕业 2 博士生结业 3 博士生肄业 4 硕士生毕业 5 硕士生结业 6 硕士生肄业 7 研班毕业 8 双学位毕业 9 本科生毕业 10 本科生结业 11 本科生肄业 12 专科生毕业 13 专科生结业 14 专科生肄业 15 中专生生毕业 16 中专生结业 17 中专生肄业 18 高职 19 职业中专 20 技校 21 高中 22 初中 99 无学历 ',
  `DEGREE` varchar(1) DEFAULT NULL COMMENT '学位 1 名誉博士2 博士3 硕士4 学士',
  `POLITICAL` varchar(1) DEFAULT NULL COMMENT '政治面貌 1 中共党员2 共青团员3 群众4 预备党员5 民建会员6 民进会员',
  `LAW_CARD` varchar(64) DEFAULT NULL COMMENT '执法证号',
  `SEQUENCENO` varchar(22) DEFAULT NULL COMMENT '人员排序',
  `DELFLAG` varchar(1) DEFAULT '1' COMMENT '人员状态 0 启用 1 禁用',
  `ISGRANT` varchar(1) DEFAULT '1' COMMENT '是否授权 0 已授权 1 未授权',
  PRIMARY KEY (`STAFF_ID`),
  KEY `idx_login_name` (`LOGIN_NAME`),
  KEY `FK_sec_staff` (`DEPARTMENT_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=14680 DEFAULT CHARSET=utf8 COMMENT='成员';

/*Table structure for table `sec_staff_department_role` */

CREATE TABLE `sec_staff_department_role` (
  `STAFF_ID` bigint(20) NOT NULL COMMENT '成员ID',
  `DEPARTMENT_ID` varchar(254) DEFAULT NULL,
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  KEY `idx_ssdr_staff_id` (`STAFF_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成员组织角色关联表';

/*Table structure for table `sec_staff_extend_property` */

CREATE TABLE `sec_staff_extend_property` (
  `STAFF_ID` bigint(20) NOT NULL,
  `PROPERTY` varchar(32) NOT NULL,
  `VALUE` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`STAFF_ID`,`PROPERTY`),
  CONSTRAINT `FK_SEC_STAFF_EXTEND_PROPERTY` FOREIGN KEY (`STAFF_ID`) REFERENCES `sec_staff` (`STAFF_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成员扩展属性表';

/*Table structure for table `sec_staff_role` */

CREATE TABLE `sec_staff_role` (
  `STAFF_ID` bigint(20) NOT NULL COMMENT '成员ID',
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`STAFF_ID`,`ROLE_ID`),
  KEY `FK_sec_staff_role2` (`ROLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='成员角色关系表';

/*Table structure for table `seclevel_message` */

CREATE TABLE `seclevel_message` (
  `MessageNo` text COMMENT '报文流水号',
  `ExpOrgCode` varchar(32) NOT NULL DEFAULT '' COMMENT '寄递企业代码',
  `ReqMsg` longtext COMMENT '下发个人用户安全级别请求消息报文',
  `RspMsg` varchar(2048) DEFAULT NULL COMMENT '下发个人用户安全级别应答消息报文',
  `ErrCode` varchar(2) DEFAULT NULL COMMENT '错误码',
  `ErrDesc` text COMMENT '错误描述',
  `OprDate` varchar(20) DEFAULT NULL COMMENT '记录插入的时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='下发个人用户安全级别消息报文';

/*Table structure for table `seq_attach_file_id` */

CREATE TABLE `seq_attach_file_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `seq_attach_type_id` */

CREATE TABLE `seq_attach_type_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `seq_email_id` */

CREATE TABLE `seq_email_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_department_id` */

CREATE TABLE `seq_sec_department_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_metadata_log_id` */

CREATE TABLE `seq_sec_metadata_log_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_operation_id` */

CREATE TABLE `seq_sec_operation_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=1780 DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_resource_category_id` */

CREATE TABLE `seq_sec_resource_category_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=519 DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_resources_id` */

CREATE TABLE `seq_sec_resources_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=1329 DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_role_id` */

CREATE TABLE `seq_sec_role_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

/*Table structure for table `seq_sec_staff_id` */

CREATE TABLE `seq_sec_staff_id` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `stub` char(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `stub` (`stub`)
) ENGINE=InnoDB AUTO_INCREMENT=17501 DEFAULT CHARSET=utf8;

/*Table structure for table `sms_receive` */

CREATE TABLE `sms_receive` (
  `SMS_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '短信ID',
  `CLIENT_ID` varchar(128) DEFAULT NULL COMMENT '客户端ID',
  `DESTINATION` varchar(20) NOT NULL COMMENT '短信地址（手机号码）',
  `MESSAGE_ID` varchar(32) DEFAULT NULL COMMENT '源终端号码',
  `MSISDN` varchar(32) NOT NULL COMMENT '消息编号',
  `SERVICE_ID` varchar(10) DEFAULT NULL COMMENT '业务ID',
  `CONTENT` varchar(4000) DEFAULT NULL COMMENT '短信内容',
  `STATUS` varchar(20) NOT NULL COMMENT '短信状态 waiting-等待处理,sending-正在处理,retry-需要重试,success-处理成功,failure-处理失败',
  `DEAL_TIMES` int(11) NOT NULL COMMENT '处理次数',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `LAST_DEAL_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '上次处理的时间',
  `ISCRYPT` varchar(1) NOT NULL DEFAULT '0' COMMENT '是否加密',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`SMS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信接收';

/*Table structure for table `sms_receive_history` */

CREATE TABLE `sms_receive_history` (
  `SMS_ID` bigint(20) NOT NULL COMMENT '短信ID',
  `CLIENT_ID` varchar(128) DEFAULT NULL COMMENT '客户端ID',
  `DESTINATION` varchar(20) NOT NULL COMMENT '短信地址（手机号码）',
  `MESSAGE_ID` varchar(32) DEFAULT NULL COMMENT '源终端号码',
  `MSISDN` varchar(32) NOT NULL COMMENT '消息编号',
  `SERVICE_ID` varchar(10) DEFAULT NULL COMMENT '业务ID',
  `CONTENT` varchar(4000) DEFAULT NULL COMMENT '短信内容',
  `STATUS` varchar(20) NOT NULL COMMENT '短信状态 waiting-等待处理,sending-正在处理,retry-需要重试,success-处理成功,failure-处理失败',
  `DEAL_TIMES` int(11) NOT NULL COMMENT '处理次数',
  `CREATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `LAST_DEAL_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '上次处理的时间',
  `ISCRYPT` varchar(1) NOT NULL DEFAULT '0' COMMENT '是否加密',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  PRIMARY KEY (`SMS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信接收历史表';

/*Table structure for table `sms_segment` */

CREATE TABLE `sms_segment` (
  `SMS_ID` varchar(32) DEFAULT NULL COMMENT '短信ID',
  `SEQUENCE_NUM` int(11) DEFAULT NULL COMMENT '扩展序号',
  `CONTENT` varchar(500) DEFAULT NULL COMMENT '短信片断内容'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信片段';

/*Table structure for table `sms_send` */

CREATE TABLE `sms_send` (
  `SMS_ID` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'SMS标识',
  `CLIENT_ID` varchar(128) NOT NULL COMMENT '客户端标识',
  `DESTINATION` varchar(20) NOT NULL COMMENT '目的地址',
  `CONTENT` varchar(4000) DEFAULT NULL COMMENT '短信内容',
  `MESSAGE_ID` varchar(32) DEFAULT NULL COMMENT '短信编号',
  `LAST_SEND_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后发送时间',
  `DEAL_TIMES` int(11) DEFAULT NULL COMMENT '处理次数',
  `STATUS` varchar(20) NOT NULL DEFAULT 'waiting' COMMENT '发送状态：waiting-等待发送 sending-正在发送 retry-需要重试 success-发送成功 failure-发送失败',
  `CREATE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `EXPECTED_SEND_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '预期发送时间',
  `ISCRYPT` varchar(1) DEFAULT '0' COMMENT '是否加密',
  `ERROR_CODE` varchar(20) DEFAULT NULL COMMENT '异常代码',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  `SOURCE` varchar(20) DEFAULT NULL COMMENT '源地址',
  PRIMARY KEY (`SMS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信发送';

/*Table structure for table `sms_send_history` */

CREATE TABLE `sms_send_history` (
  `SMS_ID` bigint(20) NOT NULL COMMENT 'SMS标识',
  `CLIENT_ID` varchar(128) NOT NULL COMMENT '客户端标识',
  `DESTINATION` varchar(20) NOT NULL COMMENT '目的地址',
  `CONTENT` varchar(4000) DEFAULT NULL COMMENT '短信内容',
  `MESSAGE_ID` varchar(32) DEFAULT NULL COMMENT '短信编号',
  `LAST_SEND_DATE` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后发送时间',
  `DEAL_TIMES` int(11) DEFAULT NULL COMMENT '处理次数',
  `STATUS` varchar(20) NOT NULL DEFAULT 'waiting' COMMENT '发送状态：waiting-等待发送 sending-正在发送 retry-需要重试 success-发送成功 failure-发送失败',
  `CREATE_TIME` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  `EXPECTED_SEND_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '预期发送时间',
  `ISCRYPT` varchar(1) DEFAULT '0' COMMENT '是否加密',
  `ERROR_CODE` varchar(20) DEFAULT NULL COMMENT '异常代码',
  `ERROR_MESSAGE` varchar(2000) DEFAULT NULL COMMENT '异常信息',
  `SOURCE` varchar(20) DEFAULT NULL COMMENT '源地址',
  PRIMARY KEY (`SMS_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信发送历史表';

/*Table structure for table `sms_session_info` */

CREATE TABLE `sms_session_info` (
  `MSISDN` varchar(32) NOT NULL COMMENT '终端号码(手机号)',
  `TOKEN` varchar(4) NOT NULL COMMENT '4位会话识别码',
  `FEATURE_TYPE` varchar(140) NOT NULL COMMENT '4位会话识别码',
  `KEY` varchar(100) NOT NULL COMMENT '键',
  `VALUE` varchar(100) DEFAULT NULL COMMENT '值',
  `LAST_UPDATE_TIME` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近更新时间',
  PRIMARY KEY (`MSISDN`,`TOKEN`,`FEATURE_TYPE`,`KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信会话信息';

/*Table structure for table `sub_system` */

CREATE TABLE `sub_system` (
  `SUB_SYSTEM_ID` varchar(20) NOT NULL COMMENT '子系统ID',
  `SUB_SYSTEM_NAME` varchar(50) NOT NULL COMMENT '子系统名称',
  `SUB_SYSTEM_DESC` varchar(200) DEFAULT NULL COMMENT '子系统描述',
  `HOP_DOMAIN` varchar(200) DEFAULT NULL COMMENT 'PORTAL跳转业务系统使用的域名',
  `INTERFACE_DOMAIN` varchar(200) DEFAULT NULL,
  `DEPLOY_MODE` varchar(20) NOT NULL DEFAULT 'Remote',
  `DOMAIN` varchar(20) NOT NULL COMMENT '子系统所属的域',
  PRIMARY KEY (`SUB_SYSTEM_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='子系统表';

/*Table structure for table `suspend_indivuser` */

CREATE TABLE `suspend_indivuser` (
  `UserSeq` varchar(16) NOT NULL COMMENT '用户序列号',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `PostalDeptCode` varchar(10) DEFAULT NULL COMMENT '邮政管理部门代码',
  `ProcId` varchar(34) DEFAULT NULL COMMENT '记录流水号',
  `UserName` varchar(32) DEFAULT NULL COMMENT '姓名',
  `Gender` varchar(1) DEFAULT NULL COMMENT '性别',
  `UserIDType` varchar(2) DEFAULT NULL COMMENT '有效身份证件类型',
  `UserIDNo` varchar(35) DEFAULT NULL COMMENT '有效身份证件号码',
  `Telephone` varchar(32) DEFAULT NULL COMMENT '固定电话',
  `Wechat` varchar(64) DEFAULT NULL COMMENT '微信号',
  `SecurityLevel` varchar(2) DEFAULT NULL COMMENT '安全风险级别',
  `UserType` varchar(5) DEFAULT NULL COMMENT '用户类别',
  `PseudoFlag` varchar(1) DEFAULT '1' COMMENT '是否需要生成伪码。0：不需要；1：需要。',
  `UserPseudoCode` varchar(128) DEFAULT NULL COMMENT '实名身份伪码',
  `CreateTime` varchar(20) DEFAULT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='暂时不需要赋码的寄递用户实名身份信息缓存表，挂起';

/*Table structure for table `temptable01` */

CREATE TABLE `temptable01` (
  `user_id` char(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*Table structure for table `user_count` */

CREATE TABLE `user_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码：0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `UserType` varchar(32) DEFAULT NULL COMMENT '实名用户类别：0.全部，1.非协议，2.协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名用户信息统计表';

/*Table structure for table `useractive_count` */

CREATE TABLE `useractive_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表(全国)';

/*Table structure for table `useractive_count_city` */

CREATE TABLE `useractive_count_city` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（市）';

/*Table structure for table `useractive_count_city_temp` */

CREATE TABLE `useractive_count_city_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（市）';

/*Table structure for table `useractive_count_county` */

CREATE TABLE `useractive_count_county` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（县区）';

/*Table structure for table `useractive_count_county_temp` */

CREATE TABLE `useractive_count_county_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（县区）';

/*Table structure for table `useractive_count_exp` */

CREATE TABLE `useractive_count_exp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UCE_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表(企业，全国)';

/*Table structure for table `useractive_count_exp_temp` */

CREATE TABLE `useractive_count_exp_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表(企业，全国)';

/*Table structure for table `useractive_count_expcity` */

CREATE TABLE `useractive_count_expcity` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UCE_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、市）';

/*Table structure for table `useractive_count_expcity_temp` */

CREATE TABLE `useractive_count_expcity_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：2.市',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、市）';

/*Table structure for table `useractive_count_expcounty` */

CREATE TABLE `useractive_count_expcounty` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UCE_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、县区）';

/*Table structure for table `useractive_count_expcounty_temp` */

CREATE TABLE `useractive_count_expcounty_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、县区）';

/*Table structure for table `useractive_count_expprovince` */

CREATE TABLE `useractive_count_expprovince` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UCE_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、省）';

/*Table structure for table `useractive_count_expprovince_temp` */

CREATE TABLE `useractive_count_expprovince_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（企业、省）';

/*Table structure for table `useractive_count_province` */

CREATE TABLE `useractive_count_province` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（省）';

/*Table structure for table `useractive_count_province_temp` */

CREATE TABLE `useractive_count_province_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报，01：散件总数，11:已实名上报散件，21:未实名上报散件，02：协议总数，12:已实名上报协议，22:未实名上报协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表（省）';

/*Table structure for table `useractive_count_temp` */

CREATE TABLE `useractive_count_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：0：总数，1:已实名上报，2:未实名上报',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='活跃用户信息统计表';

/*Table structure for table `useractive_count_time` */

CREATE TABLE `useractive_count_time` (
  `time` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名用户-统计时间表';

/*Table structure for table `usercheck_count` */

CREATE TABLE `usercheck_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：00：全部，01:首次面验，02:凭证二维码查验，03:短信验证码查验，04:微信验证码查验，05:有效身份证件查验，06:身份证识别设备查验，07: NFC+SAM查验，08：OCR识别查验，99:协议客户',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名查验信息统计表';

/*Table structure for table `usercheck_count_temp` */

CREATE TABLE `usercheck_count_temp` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：00：全部，01:首次面验，02:凭证二维码查验，03:短信验证码查验，04:微信验证码查验，05:有效身份证件查验，06:身份证识别设备查验，07: NFC+SAM查验，08：OCR识别查验，99:协议客户',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名查验信息统计表';

/*Table structure for table `usercheck_count_time` */

CREATE TABLE `usercheck_count_time` (
  `time` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名业务量-统计时间表';

/*Table structure for table `usercheck_count_xieyi` */

CREATE TABLE `usercheck_count_xieyi` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码:0.全部',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `CheckType` varchar(32) DEFAULT NULL COMMENT '用户类型：0:全部，1:非协议，2:协议',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '统计时间',
  `IsPublic` varchar(8) NOT NULL DEFAULT 'normal' COMMENT '数据类型:企业上传normal,公共版common',
  KEY `IDX_UCX_TIME` (`Address`,`CheckType`,`ExpOrgCode`,`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名查验信息协议非协议统计表';

/*Table structure for table `userexcept_count` */

CREATE TABLE `userexcept_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `SecurityLevel` varchar(32) DEFAULT NULL COMMENT '安全风险级别',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='安全风险级别信息统计表';

/*Table structure for table `userfacecheck_count` */

CREATE TABLE `userfacecheck_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `Province` varchar(32) DEFAULT NULL COMMENT '区域类型：省',
  `City` varchar(32) DEFAULT NULL COMMENT '区域类型：市',
  `Country` varchar(32) DEFAULT NULL COMMENT '区域类型：市',
  `FaceCheckType` varchar(32) DEFAULT NULL COMMENT '查验方式：00：全部，01:首次面验，06:身份证识别设备查验，07: NFC+SAM查验，08：OCR识别查验',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  `CreateTime` datetime DEFAULT NULL COMMENT '操作时间',
  `IsReported` varchar(2) NOT NULL DEFAULT '0' COMMENT '是否已上报:0：未上报 1：已上报',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='实名用户首次面验信息统计表';

/*Table structure for table `userpseudecode_count` */

CREATE TABLE `userpseudecode_count` (
  `Time` varchar(16) NOT NULL COMMENT '统计时间',
  `ExpOrgCode` varchar(32) NOT NULL COMMENT '寄递企业代码',
  `AddressType` varchar(2) DEFAULT NULL COMMENT '区域类型：0.全部，1.省，2.市，3.县区',
  `Address` varchar(35) DEFAULT NULL COMMENT '区域',
  `PseudoCodeType` varchar(32) DEFAULT NULL COMMENT '实名用户类别：0.全部，1.已赋码，2.未赋码',
  `Amount` varchar(20) DEFAULT NULL COMMENT '数量',
  KEY `IDX_UC_TIME` (`Time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='赋码用户统计表';

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


CREATE TABLE `express_delivery_status` (
   `exp_org_code` varchar(32) NOT NULL,
   `user_type` varchar(1) NOT NULL DEFAULT '1',
   `user_sign` varchar(128) NOT NULL COMMENT '用户内码',
   `bill_number` varchar(35) NOT NULL,
   `id_pseude_code` varchar(128) DEFAULT NULL,
   `user_id` varchar(16) NOT NULL DEFAULT '',
   `org_code` varchar(10) NOT NULL DEFAULT '',
   `social_code` varchar(20) NOT NULL DEFAULT '',
   `staff_code` varchar(16) NOT NULL,
   `check_date` datetime NOT NULL,
   `check_method` varchar(2) NOT NULL,
   `province` varchar(32) NOT NULL,
   `city` varchar(32) NOT NULL,
   `county` varchar(32) NOT NULL,
   `IsReported` varchar(2) DEFAULT NULL,
   `UserIDType` varchar(2) DEFAULT NULL,
   `UserIDNo` varchar(35) DEFAULT NULL,
   `createDate` datetime NOT NULL DEFAULT '1980-01-01 00:00:00',
   `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
   `IsPublic` varchar(20) NOT NULL DEFAULT 'normal',
   `UserUnifiedId` varchar(128) DEFAULT NULL,
   `UserCardValidityStartDate` varchar(8) DEFAULT NULL,
   `UserCardValidityEndDate` varchar(8) DEFAULT NULL,
   `StaffUnifiedId` varchar(128) DEFAULT NULL,
   `StaffCardType` varchar(2) DEFAULT NULL,
   `StaffCardID` varchar(35) DEFAULT NULL,
   `StaffCardValidityStartDate` varchar(8) DEFAULT NULL,
   `StaffCardValidityEndDate` varchar(8) DEFAULT NULL,
   `Street` varchar(256) DEFAULT '',
   `SenderLatLng` varchar(31) DEFAULT '',
   `InternalsType` varchar(2) DEFAULT '',
   `InternalsName` varchar(32) DEFAULT '',
   `InternalsAmount` int(8) DEFAULT NULL,
   `ReceiverPhone` varchar(32) DEFAULT '',
   `check_date_sign` bigint(20) DEFAULT '0',
    KEY `index_exporgcode_un` (`exp_org_code`) USING BTREE,
  KEY `index_userid` (`user_id`) USING BTREE,
  KEY `index_county` (`county`) USING BTREE,
  KEY `index_city` (`city`) USING BTREE,
  KEY `index_province` (`province`) USING BTREE,
  KEY `INDEX_IDTYPE_IDNO02` (`exp_org_code`,`user_id`) USING BTREE,
  KEY `index_check_date_sign` (`check_date_sign`),
  KEY `idx_eds_orgcode_useridno_useridtype` (`exp_org_code`,`UserIDNo`,`UserIDType`),
  KEY `index_exp_county` (`exp_org_code`,`county`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE `express_delivery_status_linked` (
   `exp_org_code` varchar(32) NOT NULL,
   `user_type` varchar(1) NOT NULL DEFAULT '1',
   `user_sign` varchar(128) NOT NULL COMMENT '用户内码',
   `bill_number` varchar(35) NOT NULL,
   `id_pseude_code` varchar(128) DEFAULT NULL,
   `user_id` varchar(16) NOT NULL DEFAULT '',
   `org_code` varchar(10) NOT NULL DEFAULT '',
   `social_code` varchar(20) NOT NULL DEFAULT '',
   `staff_code` varchar(16) NOT NULL,
   `check_date` datetime NOT NULL,
   `check_method` varchar(2) NOT NULL,
   `province` varchar(32) NOT NULL,
   `city` varchar(32) NOT NULL,
   `county` varchar(32) NOT NULL,
   `IsReported` varchar(2) DEFAULT NULL,
   `UserIDType` varchar(2) DEFAULT NULL,
   `UserIDNo` varchar(35) DEFAULT NULL,
   `createDate` datetime NOT NULL DEFAULT '1980-01-01 00:00:00',
   `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
   `IsPublic` varchar(20) NOT NULL DEFAULT 'normal',
   `UserUnifiedId` varchar(128) DEFAULT NULL,
   `UserCardValidityStartDate` varchar(8) DEFAULT NULL,
   `UserCardValidityEndDate` varchar(8) DEFAULT NULL,
   `StaffUnifiedId` varchar(128) DEFAULT NULL,
   `StaffCardType` varchar(2) DEFAULT NULL,
   `StaffCardID` varchar(35) DEFAULT NULL,
   `StaffCardValidityStartDate` varchar(8) DEFAULT NULL,
   `StaffCardValidityEndDate` varchar(8) DEFAULT NULL,
   `Street` varchar(256) DEFAULT '',
   `SenderLatLng` varchar(31) DEFAULT '',
   `InternalsType` varchar(2) DEFAULT '',
   `InternalsName` varchar(32) DEFAULT '',
   `InternalsAmount` int(8) DEFAULT NULL,
   `ReceiverPhone` varchar(32) DEFAULT '',
   `check_date_sign` bigint(20) DEFAULT '0',
    KEY `index_exporgcode_un` (`exp_org_code`) USING BTREE,
  KEY `index_userid` (`user_id`) USING BTREE,
  KEY `index_county` (`county`) USING BTREE,
  KEY `index_city` (`city`) USING BTREE,
  KEY `index_province` (`province`) USING BTREE,
  KEY `INDEX_IDTYPE_IDNO02` (`exp_org_code`,`user_id`) USING BTREE,
  KEY `index_check_date_sign` (`check_date_sign`),
  KEY `idx_eds_orgcode_useridno_useridtype` (`exp_org_code`,`UserIDNo`,`UserIDType`),
  KEY `index_exp_county` (`exp_org_code`,`county`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;


 CREATE TABLE `express_delivery_status_unlinked` (
   `exp_org_code` varchar(32) NOT NULL,
   `user_type` varchar(1) NOT NULL DEFAULT '1',
   `user_sign` varchar(128) NOT NULL COMMENT '用户内码',
   `bill_number` varchar(35) NOT NULL,
   `id_pseude_code` varchar(128) DEFAULT NULL,
   `user_id` varchar(16) NOT NULL DEFAULT '',
   `org_code` varchar(10) NOT NULL DEFAULT '',
   `social_code` varchar(20) NOT NULL DEFAULT '',
   `staff_code` varchar(16) NOT NULL,
   `check_date` datetime NOT NULL,
   `check_method` varchar(2) NOT NULL,
   `province` varchar(32) NOT NULL,
   `city` varchar(32) NOT NULL,
   `county` varchar(32) NOT NULL,
   `IsReported` varchar(2) DEFAULT NULL,
   `UserIDType` varchar(2) DEFAULT NULL,
   `UserIDNo` varchar(35) DEFAULT NULL,
   `createDate` datetime NOT NULL DEFAULT '1980-01-01 00:00:00',
   `TaxRegNo` varchar(30) NOT NULL DEFAULT '',
   `IsPublic` varchar(20) NOT NULL DEFAULT 'normal',
   `UserUnifiedId` varchar(128) DEFAULT NULL,
   `UserCardValidityStartDate` varchar(8) DEFAULT NULL,
   `UserCardValidityEndDate` varchar(8) DEFAULT NULL,
   `StaffUnifiedId` varchar(128) DEFAULT NULL,
   `StaffCardType` varchar(2) DEFAULT NULL,
   `StaffCardID` varchar(35) DEFAULT NULL,
   `StaffCardValidityStartDate` varchar(8) DEFAULT NULL,
   `StaffCardValidityEndDate` varchar(8) DEFAULT NULL,
   `Street` varchar(256) DEFAULT '',
   `SenderLatLng` varchar(31) DEFAULT '',
   `InternalsType` varchar(2) DEFAULT '',
   `InternalsName` varchar(32) DEFAULT '',
   `InternalsAmount` int(8) DEFAULT NULL,
   `ReceiverPhone` varchar(32) DEFAULT '',
   `check_date_sign` bigint(20) DEFAULT '0',
    KEY `index_exporgcode_un` (`exp_org_code`) USING BTREE,
  KEY `index_userid_un` (`user_id`) USING BTREE,
  KEY `index_county_un` (`county`) USING BTREE,
  KEY `index_city_un` (`city`) USING BTREE,
  KEY `index_province_un` (`province`) USING BTREE,
  KEY `INDEX_IDTYPE_IDNO02_un` (`exp_org_code`,`user_id`) USING BTREE,
  KEY `index_check_date_sign_un` (`check_date_sign`),
  KEY `idx_eds_orgcode_useridno_useridtype_un` (`exp_org_code`,`UserIDNo`,`UserIDType`),
  KEY `index_exp_county_un` (`exp_org_code`,`county`)
 ) ENGINE=innodb DEFAULT CHARSET=utf8;

 CREATE TABLE `sec_department_role` (
  `DEPARTMENT_ID` varchar(254) NOT NULL,
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`DEPARTMENT_ID`,`ROLE_ID`),
  KEY `FK_sec_department_role2` (`ROLE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='组织角色关联表';

CREATE TABLE `sec_role_resource_operation` (
  `ROLE_ID` bigint(20) NOT NULL COMMENT '角色ID',
  `RESOURCE_ID` bigint(32) NOT NULL COMMENT '资源ID',
  `OPERATION_KEY` varchar(32) NOT NULL COMMENT '资源操作关键字',
  PRIMARY KEY (`ROLE_ID`,`RESOURCE_ID`,`OPERATION_KEY`),
  KEY `FK_sec_role_resource_operation` (`RESOURCE_ID`,`OPERATION_KEY`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色与资源操作';


drop table if exists express_delivery_status;

CREATE TABLE `express_delivery_status` (                                                                                                                                        
  `exp_org_code` VARCHAR(32) NOT NULL COMMENT '寄递企业代码',                                                                                                                   
  `user_type` VARCHAR(1) NOT NULL DEFAULT '1' COMMENT '用户类型，1个人用户，2机构用户',                                                                                         
  `bill_number` VARCHAR(35) NOT NULL COMMENT '快递单号',                                                                                                                        
  `id_pseude_code` VARCHAR(128) DEFAULT NULL COMMENT '个人用户实名身份伪码',                                                                                                    
  `user_id` VARCHAR(16) NOT NULL DEFAULT '' COMMENT '个人用户序列号',                                                                                                           
  `org_code` VARCHAR(10) NOT NULL DEFAULT '' COMMENT '机构用户企业代码',                                                                                                        
  `social_code` VARCHAR(20) NOT NULL DEFAULT '' COMMENT '机构用户统一社会信用代码',                                                                                             
  `staff_code` VARCHAR(16) NOT NULL COMMENT '收派员编号',                                                                                                                       
  `check_date` DATETIME NOT NULL COMMENT '查验时间 YYYY-MM-DD HH:mm:ss',                                                                                                        
  `check_method` VARCHAR(2) NOT NULL COMMENT '查验方式，01首次面验，02凭证二维码，03短信验证码，04微信验证码，05有效身份证，06身份证识别设备，07NFC+SAM，08OCR识别，99协议客户',
  `province` VARCHAR(32) NOT NULL COMMENT '省',                                                                                                                                 
  `city` VARCHAR(32) NOT NULL COMMENT '市',                                                                                                                                     
  `county` VARCHAR(32) NOT NULL COMMENT '区县',                                                                                                                                 
  `IsReported` VARCHAR(2) DEFAULT NULL COMMENT '是否已上报:0：未上报 1：已上报',                                                                                                
  `UserIDType` VARCHAR(2) DEFAULT NULL COMMENT '有效身份证件类型',                                                                                                              
  `UserIDNo` VARCHAR(35) DEFAULT NULL COMMENT '有效身份证件号码',                                                                                                               
  `createDate` DATETIME NOT NULL DEFAULT '1980-01-01 00:00:00' COMMENT '创建时间',                                                                                              
  `TaxRegNo` VARCHAR(30) NOT NULL DEFAULT '' COMMENT '税务登记证号',                                                                                                            
  `IsPublic` VARCHAR(20) NOT NULL DEFAULT 'normal' COMMENT '公共版数据类型,默认值为normal',                                                                                     
  `UserUnifiedId` VARCHAR(128) DEFAULT NULL COMMENT '用户统一标识',                                                                                                             
  `UserCardValidityStartDate` VARCHAR(8) DEFAULT NULL COMMENT '用户有效身份证件有效期开始时间',                                                                                 
  `UserCardValidityEndDate` VARCHAR(8) DEFAULT NULL COMMENT '用户有效身份证件有效期结束时间',                                                                                   
  `StaffUnifiedId` VARCHAR(128) DEFAULT NULL COMMENT '收派员统一标识',                                                                                                          
  `StaffCardType` VARCHAR(2) DEFAULT NULL COMMENT '收派员有效身份证件类型',                                                                                                     
  `StaffCardID` VARCHAR(35) DEFAULT NULL COMMENT '收派员有效身份证件号码',                                                                                                      
  `StaffCardValidityStartDate` VARCHAR(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期开始时间',                                                                              
  `StaffCardValidityEndDate` VARCHAR(8) DEFAULT NULL COMMENT '收派员有效身份证件有效期结束时间',                                                                                
  `Street` VARCHAR(256) DEFAULT '' COMMENT '详细地址',                                                                                                                          
  `SenderLatLng` VARCHAR(31) DEFAULT '' COMMENT '寄件行为发生地的GPS经纬度',                                                                                                    
  `InternalsType` VARCHAR(2) DEFAULT '' COMMENT '内件类型',                                                                                                                     
  `InternalsName` VARCHAR(32) DEFAULT '' COMMENT '内件名称',                                                                                                                    
  `InternalsAmount` INT(8) DEFAULT NULL COMMENT '内件数量',                                                                                                                     
  `ReceiverPhone` VARCHAR(32) DEFAULT '' COMMENT '收件人联系电话',                                                                                                              
  `check_date_sign` BIGINT(20) DEFAULT '0' COMMENT '查验时间',
  `user_sign` VARCHAR(128) DEFAULT '' COMMENT '用户内码',                                                                                                                   
  KEY `idx_exp_province` (`exp_org_code`,`province`),                                                                                                                         
  KEY `idx_city` (`city`),                                                                                                                                                    
  KEY `idx_exp_city` (`exp_org_code`,`city`),                                                                                                                                 
  KEY `idx_county` (`county`),                                                                                                                                                
  KEY `idx_exp` (`exp_org_code`),                                                                                                                                             
  KEY `idx_province` (`province`),                                                                                                                                            
  KEY `idx_exp_county` (`exp_org_code`,`county`)   
) ENGINE=INNODB DEFAULT CHARSET=utf8  COMMENT='快件状态信息查验记录'       
PARTITION BY RANGE  COLUMNS(check_date)             
(PARTITION p_20170731 VALUES LESS THAN ('2017-08-01') ,
 PARTITION p_20170801 VALUES LESS THAN ('2017-08-02') ,
 PARTITION p_20170802 VALUES LESS THAN ('2017-08-03') ,
 PARTITION p_20170803 VALUES LESS THAN ('2017-08-04') ,
 PARTITION p_20170804 VALUES LESS THAN ('2017-08-05') ,
 PARTITION p_20170805 VALUES LESS THAN ('2017-08-06') ,
 PARTITION p_20170806 VALUES LESS THAN ('2017-08-07') ,
 PARTITION p_20170807 VALUES LESS THAN ('2017-08-08') ,
 PARTITION p_20170808 VALUES LESS THAN ('2017-08-09') ,
 PARTITION p_20170809 VALUES LESS THAN ('2017-08-10') ,
 PARTITION p_20170810 VALUES LESS THAN ('2017-08-11') ,
 PARTITION p_20170811 VALUES LESS THAN ('2017-08-12') ,
 PARTITION p_20170812 VALUES LESS THAN ('2017-08-13') ,
 PARTITION p_20170813 VALUES LESS THAN ('2017-08-14') ,
 PARTITION p_20170814 VALUES LESS THAN ('2017-08-15') ,
 PARTITION p_20170815 VALUES LESS THAN ('2017-08-16') ,
 PARTITION p_20170816 VALUES LESS THAN ('2017-08-17') ,
 PARTITION p_20170817 VALUES LESS THAN ('2017-08-18') ,
 PARTITION p_20170818 VALUES LESS THAN ('2017-08-19') ,
 PARTITION p_20170819 VALUES LESS THAN ('2017-08-20') ,
 PARTITION p_20170820 VALUES LESS THAN ('2017-08-21') ,
 PARTITION p_20170821 VALUES LESS THAN ('2017-08-22') ,
 PARTITION p_20170822 VALUES LESS THAN ('2017-08-23') ,
 PARTITION p_20170823 VALUES LESS THAN ('2017-08-24') ,
 PARTITION p_20170824 VALUES LESS THAN ('2017-08-25') ,
 PARTITION p_20170825 VALUES LESS THAN ('2017-08-26') ,
 PARTITION p_20170826 VALUES LESS THAN ('2017-08-27') ,
 PARTITION p_20170827 VALUES LESS THAN ('2017-08-28') ,
 PARTITION p_20170828 VALUES LESS THAN ('2017-08-29') ,
 PARTITION p_20170829 VALUES LESS THAN ('2017-08-30') ,
 PARTITION p_20170830 VALUES LESS THAN ('2017-08-31') ,
 PARTITION p_20170831 VALUES LESS THAN ('2017-09-01') ,
 PARTITION p_20170901 VALUES LESS THAN ('2017-09-02') ,
 PARTITION p_20170902 VALUES LESS THAN ('2017-09-03') ,
 PARTITION p_20170903 VALUES LESS THAN ('2017-09-04') ,
 PARTITION p_20170904 VALUES LESS THAN ('2017-09-05') ,
 PARTITION p_20170905 VALUES LESS THAN ('2017-09-06') ,
 PARTITION p_20170906 VALUES LESS THAN ('2017-09-07') ,
 PARTITION p_20170907 VALUES LESS THAN ('2017-09-08') ,
 PARTITION p_20170908 VALUES LESS THAN ('2017-09-09') ,
 PARTITION p_20170909 VALUES LESS THAN ('2017-09-10') ,
 PARTITION p_20170910 VALUES LESS THAN ('2017-09-11') ,
 PARTITION p_20170911 VALUES LESS THAN ('2017-09-12') ,
 PARTITION p_20170912 VALUES LESS THAN ('2017-09-13') ,
 PARTITION p_20170913 VALUES LESS THAN ('2017-09-14') ,
 PARTITION p_20170914 VALUES LESS THAN ('2017-09-15') ,
 PARTITION p_20170915 VALUES LESS THAN ('2017-09-16') ,
 PARTITION p_20170916 VALUES LESS THAN ('2017-09-17') ,
 PARTITION p_20170917 VALUES LESS THAN ('2017-09-18') ,
 PARTITION p_20170918 VALUES LESS THAN ('2017-09-19') ,
 PARTITION p_20170919 VALUES LESS THAN ('2017-09-20') ,
 PARTITION p_20170920 VALUES LESS THAN ('2017-09-21') ,
 PARTITION p_20170921 VALUES LESS THAN ('2017-09-22') ,
 PARTITION p_20170922 VALUES LESS THAN ('2017-09-23') ,
 PARTITION p_20170923 VALUES LESS THAN ('2017-09-24') ,
 PARTITION p_20170924 VALUES LESS THAN ('2017-09-25') ,
 PARTITION p_20170925 VALUES LESS THAN ('2017-09-26') ,
 PARTITION p_20170926 VALUES LESS THAN ('2017-09-27') ,
 PARTITION p_20170927 VALUES LESS THAN ('2017-09-28') ,
 PARTITION p_20170928 VALUES LESS THAN ('2017-09-29') ,
 PARTITION p_20170929 VALUES LESS THAN ('2017-09-30') ,
 PARTITION p_20170930 VALUES LESS THAN ('2017-10-01') ,
 PARTITION p_20171001 VALUES LESS THAN ('2017-10-02') ,
 PARTITION p_20171002 VALUES LESS THAN ('2017-10-03') ,
 PARTITION p_20171003 VALUES LESS THAN ('2017-10-04') ,
 PARTITION p_20171004 VALUES LESS THAN ('2017-10-05') ,
 PARTITION p_20171005 VALUES LESS THAN ('2017-10-06') ,
 PARTITION p_20171006 VALUES LESS THAN ('2017-10-07') ,
 PARTITION p_20171007 VALUES LESS THAN ('2017-10-08') ,
 PARTITION p_20171008 VALUES LESS THAN ('2017-10-09') ,
 PARTITION p_20171009 VALUES LESS THAN ('2017-10-10') ,
 PARTITION p_20171010 VALUES LESS THAN ('2017-10-11') ,
 PARTITION p_20171011 VALUES LESS THAN ('2017-10-12') ,
 PARTITION p_20171012 VALUES LESS THAN ('2017-10-13') ,
 PARTITION p_20171013 VALUES LESS THAN ('2017-10-14') ,
 PARTITION p_20171014 VALUES LESS THAN ('2017-10-15') ,
 PARTITION p_20171015 VALUES LESS THAN ('2017-10-16') ,
 PARTITION p_20171016 VALUES LESS THAN ('2017-10-17') ,
 PARTITION p_20171017 VALUES LESS THAN ('2017-10-18') ,
 PARTITION p_20171018 VALUES LESS THAN ('2017-10-19') ,
 PARTITION p_20171019 VALUES LESS THAN ('2017-10-20') ,
 PARTITION p_20171020 VALUES LESS THAN ('2017-10-21') ,
 PARTITION p_20171021 VALUES LESS THAN ('2017-10-22') ,
 PARTITION p_20171022 VALUES LESS THAN ('2017-10-23') ,
 PARTITION p_20171023 VALUES LESS THAN ('2017-10-24') ,
 PARTITION p_20171024 VALUES LESS THAN ('2017-10-25') ,
 PARTITION p_20171025 VALUES LESS THAN ('2017-10-26') ,
 PARTITION p_20171026 VALUES LESS THAN ('2017-10-27') ,
 PARTITION p_20171027 VALUES LESS THAN ('2017-10-28') ,
 PARTITION p_20171028 VALUES LESS THAN ('2017-10-29') ,
 PARTITION p_20171029 VALUES LESS THAN ('2017-10-30') ,
 PARTITION p_20171030 VALUES LESS THAN ('2017-10-31') ,
 PARTITION p_20171031 VALUES LESS THAN ('2017-11-01') ,
 PARTITION p_20171101 VALUES LESS THAN ('2017-11-02') ,
 PARTITION p_20171102 VALUES LESS THAN ('2017-11-03') ,
 PARTITION p_20171103 VALUES LESS THAN ('2017-11-04') ,
 PARTITION p_20171104 VALUES LESS THAN ('2017-11-05') ,
 PARTITION p_20171105 VALUES LESS THAN ('2017-11-06') ,
 PARTITION p_20171106 VALUES LESS THAN ('2017-11-07') ,
 PARTITION p_20171107 VALUES LESS THAN ('2017-11-08') ,
 PARTITION p_20171108 VALUES LESS THAN ('2017-11-09') ,
 PARTITION p_20171109 VALUES LESS THAN ('2017-11-10') ,
 PARTITION p_20171110 VALUES LESS THAN ('2017-11-11') ,
 PARTITION p_20171111 VALUES LESS THAN ('2017-11-12') ,
 PARTITION p_20171112 VALUES LESS THAN ('2017-11-13') ,
 PARTITION p_20171113 VALUES LESS THAN ('2017-11-14') ,
 PARTITION p_20171114 VALUES LESS THAN ('2017-11-15') ,
 PARTITION p_20171115 VALUES LESS THAN ('2017-11-16') ,
 PARTITION p_20171116 VALUES LESS THAN ('2017-11-17') ,
 PARTITION p_20171117 VALUES LESS THAN ('2017-11-18') ,
 PARTITION p_20171118 VALUES LESS THAN ('2017-11-19') ,
 PARTITION p_20171119 VALUES LESS THAN ('2017-11-20') ,
 PARTITION p_20171120 VALUES LESS THAN ('2017-11-21') ,
 PARTITION p_20171121 VALUES LESS THAN ('2017-11-22') ,
 PARTITION p_20171122 VALUES LESS THAN ('2017-11-23') ,
 PARTITION p_20171123 VALUES LESS THAN ('2017-11-24') ,
 PARTITION p_20171124 VALUES LESS THAN ('2017-11-25') ,
 PARTITION p_20171125 VALUES LESS THAN ('2017-11-26') ,
 PARTITION p_20171126 VALUES LESS THAN ('2017-11-27') ,
 PARTITION p_20171127 VALUES LESS THAN ('2017-11-28') ,
 PARTITION p_20171128 VALUES LESS THAN ('2017-11-29') ,
 PARTITION p_20171129 VALUES LESS THAN ('2017-11-30') ,
 PARTITION p_20171130 VALUES LESS THAN ('2017-12-01') ,
 PARTITION p_20171201 VALUES LESS THAN ('2017-12-02') ,
 PARTITION p_20171202 VALUES LESS THAN ('2017-12-03') ,
 PARTITION p_20171203 VALUES LESS THAN ('2017-12-04') ,
 PARTITION p_20171204 VALUES LESS THAN ('2017-12-05') ,
 PARTITION p_20171205 VALUES LESS THAN ('2017-12-06') ,
 PARTITION p_20171206 VALUES LESS THAN ('2017-12-07') ,
 PARTITION p_20171207 VALUES LESS THAN ('2017-12-08') ,
 PARTITION p_20171208 VALUES LESS THAN ('2017-12-09') ,
 PARTITION p_20171209 VALUES LESS THAN ('2017-12-10') ,
 PARTITION p_20171210 VALUES LESS THAN ('2017-12-11') ,
 PARTITION p_20171211 VALUES LESS THAN ('2017-12-12') ,
 PARTITION p_20171212 VALUES LESS THAN ('2017-12-13') ,
 PARTITION p_20171213 VALUES LESS THAN ('2017-12-14') ,
 PARTITION p_20171214 VALUES LESS THAN ('2017-12-15') ,
 PARTITION p_20171215 VALUES LESS THAN ('2017-12-16') ,
 PARTITION p_20171216 VALUES LESS THAN ('2017-12-17') ,
 PARTITION p_20171217 VALUES LESS THAN ('2017-12-18') ,
 PARTITION p_20171218 VALUES LESS THAN ('2017-12-19') ,
 PARTITION p_20171219 VALUES LESS THAN ('2017-12-20') ,
 PARTITION p_20171220 VALUES LESS THAN ('2017-12-21') ,
 PARTITION p_20171221 VALUES LESS THAN ('2017-12-22') ,
 PARTITION p_20171222 VALUES LESS THAN ('2017-12-23') ,
 PARTITION p_20171223 VALUES LESS THAN ('2017-12-24') ,
 PARTITION p_20171224 VALUES LESS THAN ('2017-12-25') ,
 PARTITION p_20171225 VALUES LESS THAN ('2017-12-26') ,
 PARTITION p_20171226 VALUES LESS THAN ('2017-12-27') ,
 PARTITION p_20171227 VALUES LESS THAN ('2017-12-28') ,
 PARTITION p_20171228 VALUES LESS THAN ('2017-12-29') ,
 PARTITION p_20171229 VALUES LESS THAN ('2017-12-30') ,
 PARTITION p_20171230 VALUES LESS THAN ('2017-12-31') ,
 PARTITION p_20171231 VALUES LESS THAN ('2018-01-01') ,
 PARTITION p_20180101 VALUES LESS THAN ('2018-01-02') ,
 PARTITION p_20180102 VALUES LESS THAN ('2018-01-03') ,
 PARTITION p_20180103 VALUES LESS THAN ('2018-01-04') ,
 PARTITION p_20180104 VALUES LESS THAN ('2018-01-05') ,
 PARTITION p_20180105 VALUES LESS THAN ('2018-01-06') ,
 PARTITION p_20180106 VALUES LESS THAN ('2018-01-07') ,
 PARTITION p_20180107 VALUES LESS THAN ('2018-01-08') ,
 PARTITION p_20180108 VALUES LESS THAN ('2018-01-09') ,
 PARTITION p_20180109 VALUES LESS THAN ('2018-01-10') ,
 PARTITION p_20180110 VALUES LESS THAN ('2018-01-11') ,
 PARTITION p_20180111 VALUES LESS THAN ('2018-01-12') ,
 PARTITION p_20180112 VALUES LESS THAN ('2018-01-13') ,
 PARTITION p_20180113 VALUES LESS THAN ('2018-01-14') ,
 PARTITION p_20180114 VALUES LESS THAN ('2018-01-15') ,
 PARTITION p_20180115 VALUES LESS THAN ('2018-01-16') ,
 PARTITION p_20180116 VALUES LESS THAN ('2018-01-17') ,
 PARTITION p_20180117 VALUES LESS THAN ('2018-01-18') ,
 PARTITION p_20180118 VALUES LESS THAN ('2018-01-19') ,
 PARTITION p_20180119 VALUES LESS THAN ('2018-01-20') ,
 PARTITION p_20180120 VALUES LESS THAN ('2018-01-21') ,
 PARTITION p_20180121 VALUES LESS THAN ('2018-01-22') ,
 PARTITION p_20180122 VALUES LESS THAN ('2018-01-23') ,
 PARTITION p_20180123 VALUES LESS THAN ('2018-01-24') ,
 PARTITION p_20180124 VALUES LESS THAN ('2018-01-25') ,
 PARTITION p_20180125 VALUES LESS THAN ('2018-01-26') ,
 PARTITION p_20180126 VALUES LESS THAN ('2018-01-27') ,
 PARTITION p_20180127 VALUES LESS THAN ('2018-01-28') ,
 PARTITION p_20180128 VALUES LESS THAN ('2018-01-29') ,
 PARTITION p_20180129 VALUES LESS THAN ('2018-01-30') ,
 PARTITION p_20180130 VALUES LESS THAN ('2018-01-31') ,
 PARTITION p_20180131 VALUES LESS THAN ('2018-02-01') ,
 PARTITION p_20180201 VALUES LESS THAN ('2018-02-02') ,
 PARTITION p_20180202 VALUES LESS THAN ('2018-02-03') ,
 PARTITION p_20180203 VALUES LESS THAN ('2018-02-04') ,
 PARTITION p_20180204 VALUES LESS THAN ('2018-02-05') ,
 PARTITION p_20180205 VALUES LESS THAN ('2018-02-06') ,
 PARTITION p_20180206 VALUES LESS THAN ('2018-02-07') ,
 PARTITION p_20180207 VALUES LESS THAN ('2018-02-08') ,
 PARTITION p_20180208 VALUES LESS THAN ('2018-02-09') ,
 PARTITION p_20180209 VALUES LESS THAN ('2018-02-10') ,
 PARTITION p_20180210 VALUES LESS THAN ('2018-02-11') ,
 PARTITION p_20180211 VALUES LESS THAN ('2018-02-12') ,
 PARTITION p_20180212 VALUES LESS THAN ('2018-02-13') ,
 PARTITION p_20180213 VALUES LESS THAN ('2018-02-14') ,
 PARTITION p_20180214 VALUES LESS THAN ('2018-02-15') ,
 PARTITION p_20180215 VALUES LESS THAN ('2018-02-16') ,
 PARTITION p_20180216 VALUES LESS THAN ('2018-02-17') ,
 PARTITION p_20180217 VALUES LESS THAN ('2018-02-18') ,
 PARTITION p_20180218 VALUES LESS THAN ('2018-02-19') ,
 PARTITION p_20180219 VALUES LESS THAN ('2018-02-20') ,
 PARTITION p_20180220 VALUES LESS THAN ('2018-02-21') ,
 PARTITION p_20180221 VALUES LESS THAN ('2018-02-22') ,
 PARTITION p_20180222 VALUES LESS THAN ('2018-02-23') ,
 PARTITION p_20180223 VALUES LESS THAN ('2018-02-24') ,
 PARTITION p_20180224 VALUES LESS THAN ('2018-02-25') ,
 PARTITION p_20180225 VALUES LESS THAN ('2018-02-26') ,
 PARTITION p_20180226 VALUES LESS THAN ('2018-02-27') ,
 PARTITION p_20180227 VALUES LESS THAN ('2018-02-28') ,
 PARTITION p_20180228 VALUES LESS THAN ('2018-03-01') ,
 PARTITION p_20180301 VALUES LESS THAN ('2018-03-02') ,
 PARTITION p_20180302 VALUES LESS THAN ('2018-03-03') ,
 PARTITION p_20180303 VALUES LESS THAN ('2018-03-04') ,
 PARTITION p_20180304 VALUES LESS THAN ('2018-03-05') ,
 PARTITION p_20180305 VALUES LESS THAN ('2018-03-06') ,
 PARTITION p_20180306 VALUES LESS THAN ('2018-03-07') ,
 PARTITION p_20180307 VALUES LESS THAN ('2018-03-08') ,
 PARTITION p_20180308 VALUES LESS THAN ('2018-03-09') ,
 PARTITION p_20180309 VALUES LESS THAN ('2018-03-10') ,
 PARTITION p_20180310 VALUES LESS THAN ('2018-03-11') ,
 PARTITION p_20180311 VALUES LESS THAN ('2018-03-12') ,
 PARTITION p_20180312 VALUES LESS THAN ('2018-03-13') ,
 PARTITION p_20180313 VALUES LESS THAN ('2018-03-14') ,
 PARTITION p_20180314 VALUES LESS THAN ('2018-03-15') ,
 PARTITION p_20180315 VALUES LESS THAN ('2018-03-16') ,
 PARTITION p_20180316 VALUES LESS THAN ('2018-03-17') ,
 PARTITION p_20180317 VALUES LESS THAN ('2018-03-18') ,
 PARTITION p_20180318 VALUES LESS THAN ('2018-03-19') ,
 PARTITION p_20180319 VALUES LESS THAN ('2018-03-20') ,
 PARTITION p_20180320 VALUES LESS THAN ('2018-03-21') ,
 PARTITION p_20180321 VALUES LESS THAN ('2018-03-22') ,
 PARTITION p_20180322 VALUES LESS THAN ('2018-03-23') ,
 PARTITION p_20180323 VALUES LESS THAN ('2018-03-24') ,
 PARTITION p_20180324 VALUES LESS THAN ('2018-03-25') ,
 PARTITION p_20180325 VALUES LESS THAN ('2018-03-26') ,
 PARTITION p_20180326 VALUES LESS THAN ('2018-03-27') ,
 PARTITION p_20180327 VALUES LESS THAN ('2018-03-28') ,
 PARTITION p_20180328 VALUES LESS THAN ('2018-03-29') ,
 PARTITION p_20180329 VALUES LESS THAN ('2018-03-30') ,
 PARTITION p_20180330 VALUES LESS THAN ('2018-03-31') ,
 PARTITION p_20180331 VALUES LESS THAN ('2018-04-01') ,
 PARTITION p_20180401 VALUES LESS THAN ('2018-04-02') ,
 PARTITION p_20180402 VALUES LESS THAN ('2018-04-03') ,
 PARTITION p_20180403 VALUES LESS THAN ('2018-04-04') ,
 PARTITION p_20180404 VALUES LESS THAN ('2018-04-05') ,
 PARTITION p_20180405 VALUES LESS THAN ('2018-04-06') ,
 PARTITION p_20180406 VALUES LESS THAN ('2018-04-07') ,
 PARTITION p_20180407 VALUES LESS THAN ('2018-04-08') ,
 PARTITION p_20180408 VALUES LESS THAN ('2018-04-09') ,
 PARTITION p_20180409 VALUES LESS THAN ('2018-04-10') ,
 PARTITION p_20180410 VALUES LESS THAN ('2018-04-11') ,
 PARTITION p_20180411 VALUES LESS THAN ('2018-04-12') ,
 PARTITION p_20180412 VALUES LESS THAN ('2018-04-13') ,
 PARTITION p_20180413 VALUES LESS THAN ('2018-04-14') ,
 PARTITION p_20180414 VALUES LESS THAN ('2018-04-15') ,
 PARTITION p_20180415 VALUES LESS THAN ('2018-04-16') ,
 PARTITION p_20180416 VALUES LESS THAN ('2018-04-17') ,
 PARTITION p_20180417 VALUES LESS THAN ('2018-04-18') ,
 PARTITION p_20180418 VALUES LESS THAN ('2018-04-19') ,
 PARTITION p_20180419 VALUES LESS THAN ('2018-04-20') ,
 PARTITION p_20180420 VALUES LESS THAN ('2018-04-21') ,
 PARTITION p_20180421 VALUES LESS THAN ('2018-04-22') ,
 PARTITION p_20180422 VALUES LESS THAN ('2018-04-23') ,
 PARTITION p_20180423 VALUES LESS THAN ('2018-04-24') ,
 PARTITION p_20180424 VALUES LESS THAN ('2018-04-25') ,
 PARTITION p_20180425 VALUES LESS THAN ('2018-04-26') ,
 PARTITION p_20180426 VALUES LESS THAN ('2018-04-27') ,
 PARTITION p_20180427 VALUES LESS THAN ('2018-04-28') ,
 PARTITION p_20180428 VALUES LESS THAN ('2018-04-29') ,
 PARTITION p_20180429 VALUES LESS THAN ('2018-04-30') ,
 PARTITION p_20180430 VALUES LESS THAN ('2018-05-01') ,
 PARTITION p_20180501 VALUES LESS THAN ('2018-05-02') ,
 PARTITION p_20180502 VALUES LESS THAN ('2018-05-03') ,
 PARTITION p_20180503 VALUES LESS THAN ('2018-05-04') ,
 PARTITION p_20180504 VALUES LESS THAN ('2018-05-05') ,
 PARTITION p_20180505 VALUES LESS THAN ('2018-05-06') ,
 PARTITION p_20180506 VALUES LESS THAN ('2018-05-07') ,
 PARTITION p_20180507 VALUES LESS THAN ('2018-05-08') ,
 PARTITION p_20180508 VALUES LESS THAN ('2018-05-09') ,
 PARTITION p_20180509 VALUES LESS THAN ('2018-05-10') ,
 PARTITION p_20180510 VALUES LESS THAN ('2018-05-11') ,
 PARTITION p_20180511 VALUES LESS THAN ('2018-05-12') ,
 PARTITION p_20180512 VALUES LESS THAN ('2018-05-13') ,
 PARTITION p_20180513 VALUES LESS THAN ('2018-05-14') ,
 PARTITION p_20180514 VALUES LESS THAN ('2018-05-15') ,
 PARTITION p_20180515 VALUES LESS THAN ('2018-05-16') ,
 PARTITION p_20180516 VALUES LESS THAN ('2018-05-17') ,
 PARTITION p_20180517 VALUES LESS THAN ('2018-05-18') ,
 PARTITION p_20180518 VALUES LESS THAN ('2018-05-19') ,
 PARTITION p_20180519 VALUES LESS THAN ('2018-05-20') ,
 PARTITION p_20180520 VALUES LESS THAN ('2018-05-21') ,
 PARTITION p_20180521 VALUES LESS THAN ('2018-05-22') ,
 PARTITION p_20180522 VALUES LESS THAN ('2018-05-23') ,
 PARTITION p_20180523 VALUES LESS THAN ('2018-05-24') ,
 PARTITION p_20180524 VALUES LESS THAN ('2018-05-25') ,
 PARTITION p_20180525 VALUES LESS THAN ('2018-05-26') ,
 PARTITION p_20180526 VALUES LESS THAN ('2018-05-27') ,
 PARTITION p_20180527 VALUES LESS THAN ('2018-05-28') ,
 PARTITION p_20180528 VALUES LESS THAN ('2018-05-29') ,
 PARTITION p_20180529 VALUES LESS THAN ('2018-05-30') ,
 PARTITION p_20180530 VALUES LESS THAN ('2018-05-31') ,
 PARTITION p_20180531 VALUES LESS THAN ('2018-06-01') ,
 PARTITION p_20180601 VALUES LESS THAN ('2018-06-02') ,
 PARTITION p_20180602 VALUES LESS THAN ('2018-06-03') ,
 PARTITION p_20180603 VALUES LESS THAN ('2018-06-04') ,
 PARTITION p_20180604 VALUES LESS THAN ('2018-06-05') ,
 PARTITION p_20180605 VALUES LESS THAN ('2018-06-06') ,
 PARTITION p_20180606 VALUES LESS THAN ('2018-06-07') ,
 PARTITION p_20180607 VALUES LESS THAN ('2018-06-08') ,
 PARTITION p_20180608 VALUES LESS THAN ('2018-06-09') ,
 PARTITION p_20180609 VALUES LESS THAN ('2018-06-10') ,
 PARTITION p_20180610 VALUES LESS THAN ('2018-06-11') ,
 PARTITION p_20180611 VALUES LESS THAN ('2018-06-12') ,
 PARTITION p_20180612 VALUES LESS THAN ('2018-06-13') ,
 PARTITION p_20180613 VALUES LESS THAN ('2018-06-14') ,
 PARTITION p_20180614 VALUES LESS THAN ('2018-06-15') ,
 PARTITION p_20180615 VALUES LESS THAN ('2018-06-16') ,
 PARTITION p_20180616 VALUES LESS THAN ('2018-06-17') ,
 PARTITION p_20180617 VALUES LESS THAN ('2018-06-18') ,
 PARTITION p_20180618 VALUES LESS THAN ('2018-06-19') ,
 PARTITION p_20180619 VALUES LESS THAN ('2018-06-20') ,
 PARTITION p_20180620 VALUES LESS THAN ('2018-06-21') ,
 PARTITION p_20180621 VALUES LESS THAN ('2018-06-22') ,
 PARTITION p_20180622 VALUES LESS THAN ('2018-06-23') ,
 PARTITION p_20180623 VALUES LESS THAN ('2018-06-24') ,
 PARTITION p_20180624 VALUES LESS THAN ('2018-06-25') ,
 PARTITION p_20180625 VALUES LESS THAN ('2018-06-26') ,
 PARTITION p_20180626 VALUES LESS THAN ('2018-06-27') ,
 PARTITION p_20180627 VALUES LESS THAN ('2018-06-28') ,
 PARTITION p_20180628 VALUES LESS THAN ('2018-06-29') ,
 PARTITION p_20180629 VALUES LESS THAN ('2018-06-30') , 
 PARTITION p_20180630 VALUES LESS THAN ('2018-07-01') , 
 PARTITION p_max VALUES LESS THAN (MAXVALUE) ) ;