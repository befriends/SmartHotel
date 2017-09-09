# Ashish Mohite 13th Jan, 2017
ALTER TABLE `smarthotel`.`user` 
DROP COLUMN `customid`;

ALTER TABLE `smarthotel`.`userlogin` 
DROP INDEX `username_UNIQUE` ;

ALTER TABLE `smarthotel`.`ordertable` 
ADD COLUMN `paymentmode` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '' AFTER `isdeleted`,
ADD COLUMN `chequeno` VARCHAR(45) NULL DEFAULT NULL COMMENT '' AFTER `paymentmode`;

# Ashish Mohite 22nd Jan, 2017
ALTER TABLE `smarthotel`.`userlogin`  ADD COLUMN `summarymsgsentdate` VARCHAR(255) NOT NULL COMMENT '' AFTER `messagenotificationflag`;

# Rupesh Didwagh 24th jan,2017
ALTER TABLE `smarthotel`.`payment` 
CHANGE COLUMN `paymentdate` `paymentdate` BIGINT(255) NULL DEFAULT NULL COMMENT '' ;

ALTER TABLE `smarthotel`.`userlogin` 
CHANGE COLUMN `summarymsgsentdate` `summarymsgsentdate` VARCHAR(255) NULL COMMENT '' ;

ALTER TABLE `smarthotel`.`userlogin` 
CHANGE COLUMN `summarymsgsentdate` `summarymsgsentdate` VARCHAR(255) NOT NULL COMMENT '' ;

# Ashish Mohite 26th Jan, 2017
ALTER TABLE `smarthotel`.`menuitem` 
ADD COLUMN `isspecial` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '' AFTER `desription`;

# rupesh 27th jan,2017

CREATE TABLE `printheader` (
  `printheaderid` varchar(255) NOT NULL,
  `printheadername` varchar(255) NOT NULL,
  `printheaderaddress` varchar(555) DEFAULT NULL,
  PRIMARY KEY (`printheaderid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1

# Ashish Mohite 29th Jan, 2017
ALTER TABLE `smarthotel`.`category` 
ADD COLUMN `printername` VARCHAR(255) NOT NULL COMMENT '' AFTER `isdeleted`;

# Rupesh

insert into printheader(printheaderid,printheadername,printheaderaddress)values('d059f69a-f295-11e6-b9eb-d4c5608ea9a5','HOTEL KALYANI','VEG-NONVEG FAMILY GARDEN RESTAURANT <br>NAGAR-PUNE HIGHWAY, BORHADE MALA,<br>SHIRUR, DIST-PUNE,<br>MOB. 8805014009, 9923521010');


# Ashish Mohite 01 Apr 2017
CREATE TABLE `smarthotel`.`mastersetting` (
  `isduplicateprint` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '',
  `duplicateprintername` VARCHAR(255) NULL COMMENT '');

insert into mastersetting (isduplicateprint, duplicateprintername) values(0, "");

# Rupesh Didwagh 27 june,2017

ALTER TABLE `smarthotel`.`ordertable` 
ADD COLUMN `billdate` BIGINT(255) NOT NULL DEFAULT 0 COMMENT '' AFTER `chequeno`,
ADD COLUMN `billdatetime` BIGINT(255) NOT NULL DEFAULT 0 COMMENT '' AFTER `billdate`;
# Rupesh 14 july,2017

ALTER TABLE `mastersetting` 
ADD COLUMN `CGST` DOUBLE NULL DEFAULT 0 COMMENT '' AFTER `duplicateprintername`,
ADD COLUMN `SGST` DOUBLE NULL DEFAULT 0 COMMENT '' AFTER `CGST`;

# Rupesh 18 July, 2017
ALTER TABLE `ordertable` 
ADD COLUMN `CGST` DOUBLE NULL COMMENT '' AFTER `billdatetime`,
ADD COLUMN `SGST` DOUBLE NULL COMMENT '' AFTER `CGST`,
ADD COLUMN `totalpaidamount` DOUBLE NULL COMMENT '' AFTER `SGST`;

ALTER TABLE `ordertable` 
CHANGE COLUMN `CGST` `CGST` DOUBLE NULL DEFAULT 0 COMMENT '' ,
CHANGE COLUMN `SGST` `SGST` DOUBLE NULL DEFAULT 0 COMMENT '' ,
CHANGE COLUMN `totalpaidamount` `totalpaidamount` DOUBLE NULL DEFAULT 0 COMMENT '' ;

ALTER TABLE `customerborrowings` 
ADD COLUMN `totalpaidamount` DOUBLE NULL DEFAULT 0 COMMENT '' AFTER `customerborrowingsdate`;

# Rupesh 21 Agust,2017


ALTER TABLE `mastersetting` 
ADD COLUMN `isborrow` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `SGST`,
ADD COLUMN `ishide` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `isborrow`,
ADD COLUMN `isgst` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `ishide`;

# Rupesh 04 Sep,2017

ALTER TABLE `ordertable` 
ADD COLUMN `isedited` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `totalpaidamount`;


# Rupesh 05 sep,2017

ALTER TABLE `mastersetting` 
ADD COLUMN `servicetax` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `isgst`;

ALTER TABLE `mastersetting` 
ADD COLUMN `isservice` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `servicetax`;


ALTER TABLE `ordertable` 
ADD COLUMN `servicetax` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `isedited`;

ALTER TABLE `ordertable` 
ADD COLUMN `servicetaxperAmount` TINYINT(11) NOT NULL DEFAULT 0 COMMENT '' AFTER `servicetax`;




