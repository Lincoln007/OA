-- 2017-10-09
CREATE TABLE `missive_webservice_log` (
	`ID` INT(11) NOT NULL,
	`Uid` VARCHAR(50) NOT NULL,
	`MissiveId` INT(11) NOT NULL,
	`Result` BIT(1) NOT NULL,
	`CreateTime` DATETIME NOT NULL,
	`UpdateTime` DATETIME NULL DEFAULT NULL,
	`Type` INT(11) NOT NULL,
	PRIMARY KEY (`ID`),
	INDEX `MissiveId` (`MissiveId`),
	INDEX `GUID` (`Uid`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- 2017-09-27
CREATE TABLE `salary` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`UserId` INT(11) NOT NULL,
	`Year` INT(11) NOT NULL,
	`Month` INT(11) NOT NULL,
	`CreateTime` DATETIME NOT NULL,
	`Data` TEXT NOT NULL,
	PRIMARY KEY (` ID`),
	INDEX `UserId_Year_Month` (`UserId`, `Year`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


-- 2017-09-12
ALTER TABLE `flow_node`
	ALTER `CanComplete` DROP DEFAULT;
ALTER TABLE `flow_node`
	CHANGE COLUMN `CanComplete` `CanSkip` BIT(1) NOT NULL AFTER `LimitMode`;


-- 2017-09-07
ALTER TABLE `form_info`
	ALTER `Remind` DROP DEFAULT;
ALTER TABLE `form_info`
	CHANGE COLUMN `Remind` `Reminded` BIT(1) NOT NULL AFTER `CreateTime`;

-- 2017-09-04
ALTER TABLE `sub_task`
	ADD COLUMN `LeaderId` INT NOT NULL AFTER `Content`;


-- 2017-09-03
RENAME TABLE `user_right` TO `group_right`;

-- 2017-08-28
ALTER TABLE `holiday`
	ADD INDEX `EndDate` (`EndDate`);

-- 2017-08-25
ALTER TABLE `flow_node`
	ADD COLUMN `CanComplete` BIT NOT NULL AFTER `LimitMode`;

INSERT INTO `form` (`Name`, `FlowID`,`EName`) VALUES ('请假', '7','leave');

ALTER TABLE `form_info`
	ADD COLUMN `Remind` BIT NOT NULL AFTER `CreateTime`;

ALTER TABLE `form_info`
	DROP COLUMN `ExtendId`;

ALTER TABLE `user_form_info`
	DROP COLUMN `FormID`;

ALTER TABLE `user_form_info`
	DROP COLUMN `FlowNodeDataID`;

ALTER TABLE `feed`
	DROP COLUMN `FormId`;


Update form_info set formId=7 where formId=3

-- 2017-08-21
ALTER TABLE `task`
	ADD COLUMN `Number` VARCHAR(50) NULL AFTER `ID`;

-- 2017-08-16 Ricepig
CREATE TABLE `sms` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Numbers` VARCHAR(512) NOT NULL,
	`Content` VARCHAR(512) NOT NULL,	
	`CreateTime` DATETIME NOT NULL,
	PRIMARY KEY (`ID`),
	INDEX `CreateTime` (`CreateTime`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- 2017-08-16
CREATE TABLE `user_flow_contact` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`UserId` INT(11) NOT NULL,
	`ContactId` INT(11) NOT NULL,
	PRIMARY KEY (`ID`),
	INDEX `UserId` (`UserId`)
)
ENGINE=InnoDB
;

-- 2017-08-14
update freeflow_nodedata set iscc=true;
update freeflow_nodedata set iscc=false where content is not null;
update freeflow_nodedata set iscc=false where userid in (9,11,12,13,192);

-- 2017-08-08
ALTER TABLE `missive`
	ADD COLUMN `Important` BIT NOT NULL AFTER `GK_FB`;

ALTER TABLE `freeflow_nodedata`
	ADD COLUMN `IsCc` BIT NOT NULL AFTER `UpdateTime`;


-- 2017-08-07
ALTER TABLE `user`
	ADD COLUMN `Deleted` BIT NOT NULL AFTER `Mobile`;


-- 2017-08-04
ALTER TABLE `sub_task`
	ADD COLUMN `Status` INT(11) NOT NULL AFTER `ToUserId`,
	DROP COLUMN `Completed`;

-- 2017-08-03
ALTER TABLE `task_todo`
	CHANGE COLUMN `TaskId` `SubTaskId` INT(11) NOT NULL DEFAULT '0' AFTER `ID`,
	DROP COLUMN `Note`;
ALTER TABLE `task_todo`
	CHANGE COLUMN `ScheduleTime` `ScheduleDate` DATETIME NULL DEFAULT NULL AFTER `CreateTime`;

-- 2017-07-31
ALTER TABLE `flow_node_data`
	ADD COLUMN `ExtendId` INT NOT NULL AFTER `FlowNodeId`,
	ADD INDEX `ExtendId` (`ExtendId`);

CREATE TABLE `sub_task` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`ParentId` INT(11) NOT NULL,
	`TaskId` INT(11) NOT NULL,
	`CreatorId` INT(11) NOT NULL,
	`ToUserId` INT(11) NOT NULL,
	`ToDepartmentId` INT(11) NOT NULL,
	`ToDepartmentName` VARCHAR(50) NOT NULL,
	`CreateTime` DATETIME NOT NULL,
	`UpdateTime` DATETIME NULL DEFAULT NULL,
	`Completed` BIT(1) NOT NULL,
	`ScheduleDate` DATETIME NULL DEFAULT NULL,
	`Content` VARCHAR(512) NOT NULL,
	PRIMARY KEY (`ID`),
	INDEX `ToUserId` (`ToUserId`),
	INDEX `TaskId` (`TaskId`),
	INDEX `ParentId` (`ParentId`),
	INDEX `CreatorId` (`CreatorId`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=6
;


DROP TABLE `task_progress`;
DROP TABLE `task`;

CREATE TABLE `task` (
	`ID` INT(11) NOT NULL,
	`Name` VARCHAR(50) NULL DEFAULT NULL,
	`FromType` INT(11) NOT NULL,
	`From` VARCHAR(128) NULL DEFAULT NULL,
	`Goal` VARCHAR(512) NULL DEFAULT NULL,
	`ScheduleDate` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- 2017-07-24
ALTER TABLE `task`
	DROP COLUMN `XB_DW`,
	DROP COLUMN `XBR`;


-- 2017-07-14
ALTER TABLE `task_todo`
	ADD COLUMN `CreatorId` INT(11) NOT NULL DEFAULT '0' AFTER `ToUserId`,
	ADD INDEX `CreatorId` (`CreatorId`);
ALTER TABLE `task_todo`
	ADD COLUMN `Note` VARCHAR(255) NULL DEFAULT '0' AFTER `Completed`;

-- 2017-07-13
ALTER TABLE `user`
	ADD COLUMN `Mobile` VARCHAR(50) NULL AFTER `JobTitleId`;
ALTER TABLE `user`
	ADD INDEX `Mobile` (`Mobile`);

ALTER TABLE `check_in_out`
	ADD COLUMN `ApiResult` BIT NULL AFTER `CreateTime`,
	ADD COLUMN `UpdateTime` DATETIME NULL AFTER `ApiResult`;

-- 2017-07-11
CREATE TABLE `task_todo` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`TaskId` INT(11) NOT NULL DEFAULT '0',
	`ToUserId` INT(11) NOT NULL DEFAULT '0',
	`Content` VARCHAR(255) NOT NULL,
	`CreateTime` DATETIME NOT NULL,
	`ScheduleTime` DATETIME NULL DEFAULT NULL,
	`Completed` BIT(1) NOT NULL,
	`UpdateTime` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	INDEX `TaskId` (`TaskId`),
	INDEX `ToUserId` (`ToUserId`),
	INDEX `ScheduleTime` (`ScheduleTime`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


-- 2017-07-07
ALTER TABLE `task`
	ADD COLUMN `XBR` VARCHAR(255) NULL AFTER `BZ`;

-- 2017-07-05
CREATE TABLE `holiday` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(50) NOT NULL,
	`BeginDate` DATE NOT NULL,
	`EndDate` DATE NOT NULL,
	`CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`Deleted` BIT(1) NOT NULL DEFAULT b'0',
	PRIMARY KEY (`ID`),
	INDEX `StartDate` (`BeginDate`)
)
ENGINE=InnoDB
;


-- 2017-06-30
CREATE TABLE `attendance` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`UserId` INT(11) NULL DEFAULT NULL,
	`Date` DATE NULL DEFAULT NULL,
	`AMResult` INT(11) NULL DEFAULT NULL,
	`PMResult` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	INDEX `UserId` (`UserId`),
	INDEX `Date` (`Date`)
)
ENGINE=InnoDB
;
CREATE TABLE `check_in_out` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`UserId` INT(11) NOT NULL,
	`CreateTime` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`ID`),
	INDEX `UserId` (`UserId`)
)
ENGINE=InnoDB
;


-- 2017-06-29
ALTER TABLE `task_progress`
	ADD COLUMN `Deleted` BIT NOT NULL AFTER `Content`;

ALTER TABLE `form_info_extend1`
	ADD COLUMN `Category` INT NOT NULL AFTER `ScheduleBeginTime`;


CREATE TABLE `config` (
	`Key` VARCHAR(50) NOT NULL,
	`Value` VARCHAR(50) NULL DEFAULT NULL,
	PRIMARY KEY (`Key`)
)
ENGINE=InnoDB
;


-- 2017-06-26
ALTER TABLE `task`
	ALTER `ZRR` DROP DEFAULT;
ALTER TABLE `task`
	CHANGE COLUMN `ZRR` `ZRR_ID` INT(11) NOT NULL AFTER `LY_LX`;
ALTER TABLE `task`
	ALTER `MC` DROP DEFAULT,
	ALTER `LY` DROP DEFAULT,
	ALTER `ZB_DW` DROP DEFAULT,
	ALTER `XB_DW` DROP DEFAULT,
	ALTER `GZ_MB` DROP DEFAULT;
ALTER TABLE `task`
	CHANGE COLUMN `MC` `MC` VARCHAR(50) NOT NULL AFTER `ZRR_ID`,
	CHANGE COLUMN `LY` `LY` VARCHAR(50) NULL AFTER `MC`,
	CHANGE COLUMN `ZB_DW` `ZB_DW` VARCHAR(50) NULL AFTER `LY`,
	CHANGE COLUMN `XB_DW` `XB_DW` VARCHAR(50) NULL AFTER `ZB_DW`,
	CHANGE COLUMN `GZ_MB` `GZ_MB` VARCHAR(128) NULL AFTER `XB_DW`;


-- 2017-06-22
ALTER TABLE `missive`
	ADD COLUMN `RedTitleId` INT(11) NOT NULL AFTER `ID`;

ALTER TABLE `missive`
	CHANGE COLUMN `WordId` `ContentId` INT(11) NULL DEFAULT NULL AFTER `RedTitleId`;


-- 2017-06-21 已经执行
-- 把已经结束流程的 更新到归档箱
--update user_form_info
--set status=3
--where status!=3 and infoid in (
--select i.ID 
--from form_info i
--left join flow_data f
--on i.ID = f.InfoId
--where completed =1
--)

-- --更新已读的
--update user_form_info uf
--join freeflow_nodedata ffnd
--on uf.UserID = ffnd.UserId
--join flow_node_data fnd
--on ffnd.freeflowdataid = fnd.ID
--join flow_data fd
--on fnd.FlowDataId = fd.ID
-- set status=2
--where ffnd.updatetime is not null and uf.InfoID =fd.InfoId

-- --删除不该存在的user_form_info

-- CREATE TEMPORARY TABLE IF NOT EXISTS Temp_UserFlowInfo(
-- 	ID INT(11)
-- );
 
-- insert into Temp_UserFlowInfo (id) (select uf.id from user_form_info uf
--	join
--	(select fd.infoid as infoid,ffnd.userid from freeflow_nodedata ffnd
--		join flow_node_data fnd
--		on ffnd.freeflowdataid = fnd.ID
--		join flow_data fd
--		on fnd.FlowDataId = fd.ID
--		where ffnd.updatetime is not null
--	) ufr
--	on uf.InfoID = ufr.infoid and uf.userid = ufr.userid);
	
--	 insert into Temp_UserFlowInfo (id) (select uf.id from user_form_info uf
--	join
--	(select fnd.UserId ,fd.InfoId from flow_node_data fnd
--		join flow_node fn
--		on fnd.flownodeid = fn.id
--		join flow_data fd
--		on fnd.FlowDataId = fd.ID
--	) ufr
--	on uf.InfoID = ufr.infoid and uf.userid = ufr.userid);
	
--	delete from user_form_info where id not in(select * from Temp_UserFlowInfo);
--	DROP TEMPORARY TABLE IF EXISTS Temp_UserFlowInfo

-- 2017-06-20
RENAME TABLE `organization` TO `department`;

ALTER TABLE `user`
	ADD COLUMN `Sort` INT NOT NULL AFTER `Password`;


CREATE TABLE `missive_redtitle` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(50) NOT NULL,
	`FormId` INT(11) NOT NULL DEFAULT '0',
	`TemplateId` INT(11) NOT NULL,
	PRIMARY KEY (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

-- 2017-06-15

CREATE TABLE `meetingroom` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Name` VARCHAR(50) NOT NULL,
	`Number` VARCHAR(50) NOT NULL,
	`UpdateTime` DATETIME NULL DEFAULT NULL,
	`Type` INT(11) NOT NULL,
	`Status` INT(11) NOT NULL,
	`Deleted` BIT(1) NOT NULL,
	`PhotoId` INT(11) NOT NULL,
	PRIMARY KEY (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=8
;
CREATE TABLE `seal` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`Deleted` BIT(1) NOT NULL DEFAULT b'0',
	`Name` VARCHAR(50) NOT NULL,
	`Status` INT(11) NOT NULL,
	PRIMARY KEY (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;

CREATE TABLE `task` (
	`ID` INT(11) NOT NULL,
	`LY_LX` INT(11) NOT NULL,
	`ZRR` INT(11) NOT NULL,
	`MC` VARCHAR(50) NOT NULL,
	`LY` VARCHAR(50) NOT NULL,
	`ZB_DW` VARCHAR(50) NOT NULL,
	`XB_DW` VARCHAR(50) NOT NULL,
	`GZ_MB` VARCHAR(128) NOT NULL,
	`JH_SJ` DATETIME NULL DEFAULT NULL,
	`BZ` VARCHAR(255) NULL DEFAULT NULL,
	PRIMARY KEY (`ID`)
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;


CREATE TABLE `task_progress` (
	`ID` INT(11) NOT NULL AUTO_INCREMENT,
	`TaskId` INT(11) NOT NULL DEFAULT '0',
	`UserId` INT(11) NOT NULL DEFAULT '0',
	`CreateTime` DATETIME NOT NULL,
	`Content` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`ID`),
	INDEX `UserId` (`UserId`),
	INDEX `TaskId` (`TaskId`)
)
ENGINE=InnoDB
;



-- 2017-06-14
ALTER TABLE `car_apply`
	ALTER `CarId` DROP DEFAULT;
ALTER TABLE `car_apply`
	CHANGE COLUMN `CarId` `InfoId` INT(11) NOT NULL AFTER `ID`;
RENAME TABLE `car_apply` TO `form_info_extend1`;

-- 2017-06-09
ALTER TABLE `car_apply`
	ADD COLUMN `ApprovalUserId` INT NOT NULL AFTER `CreateTime`,
	ADD INDEX `ApprovalUserId` (`ApprovalUserId`);


-- 2017-06-06
CREATE TABLE `car_apply` (
	`ID` INT(11) NOT NULL,
	`CarId` INT(11) NOT NULL,
	`UserId` INT(11) NOT NULL,
	`CreateTime` DATETIME NOT NULL,
	`ScheduleBeginTime` DATETIME NOT NULL,
	`ScheduleEndTime` DATETIME NULL DEFAULT NULL,
	`RealEndTime` DATETIME NULL DEFAULT NULL,
	`Reason` VARCHAR(255) NULL DEFAULT NULL,
	`Result` BIT(1) NULL DEFAULT NULL,
	`UpdateTime` DATETIME NULL DEFAULT NULL,
	PRIMARY KEY (`ID`),
	INDEX `CarId` (`CarId`),
	INDEX `UserId` (`UserId`),
	INDEX `CreateTime` (`CreateTime`)
)
ENGINE=InnoDB
;

-- 2017-05-26 zlj

ALTER TABLE `missive`
	ALTER `MJ` DROP DEFAULT;
ALTER TABLE `missive`
	CHANGE COLUMN `WH` `WJ_ZH` VARCHAR(50) NULL DEFAULT NULL AFTER `WJ_BT`,
	CHANGE COLUMN `MJ` `WJ_MJ` INT(11) NOT NULL AFTER `WJ_ZH`,
	ADD COLUMN `JJ_DJ` INT(11) NOT NULL AFTER `WJ_MJ`,
	ADD COLUMN `DJR` VARCHAR(50) NULL DEFAULT NULL AFTER `ZRR`,
	ADD COLUMN `JB_RQ` DATETIME NULL DEFAULT NULL AFTER `FW_RQ`,
	CHANGE COLUMN `LY` `WJ_LY` VARCHAR(255) NULL DEFAULT NULL AFTER `QX_RQ`;

	ALTER TABLE `missive`
	ALTER `ZWGK` DROP DEFAULT,
	ALTER `GKFB` DROP DEFAULT;
ALTER TABLE `missive`
	CHANGE COLUMN `WordId` `WordId` INT(11) NULL DEFAULT NULL AFTER `ID`,
	CHANGE COLUMN `QX_RQ` `QX_RQ` DATETIME NULL DEFAULT NULL AFTER `JB_RQ`,
	CHANGE COLUMN `ZWGK` `ZW_GK` INT(11) NOT NULL AFTER `WJ_LY`,
	CHANGE COLUMN `GKFB` `GK_FB` BIT(1) NOT NULL AFTER `ZW_GK`,
	DROP COLUMN `SX_SJ`,
	DROP COLUMN `HLW_FB`;


ALTER TABLE `flow_node`
	ALTER `Name` DROP DEFAULT,
	ALTER `JobTitleId` DROP DEFAULT;
ALTER TABLE `flow_node`
	CHANGE COLUMN `Name` `Name` VARCHAR(50) NOT NULL AFTER `FlowId`,
	CHANGE COLUMN `UserId` `UserIds` VARCHAR(50) NULL DEFAULT '0' AFTER `Name`,
	CHANGE COLUMN `JobTitleId` `JobTitleIds` VARCHAR(50) NULL AFTER `DepartmentIds`,
	DROP COLUMN `GroupID`;

