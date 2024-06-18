use fda

SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS `Product_tecode`;
DROP TABLE IF EXISTS `Product`;
DROP TABLE IF EXISTS `AppDoc`;
DROP TABLE IF EXISTS `RegActionDate`;
DROP TABLE IF EXISTS `Application`;
DROP TABLE IF EXISTS `ChemTypeLookup`;
DROP TABLE IF EXISTS `AppDocType_Lookup`;
DROP TABLE IF EXISTS `DocType_lookup`;
DROP TABLE IF EXISTS `ReviewClass_Lookup`;


CREATE TABLE IF NOT EXISTS `ReviewClass_Lookup` (
	`ReviewClassID`	INTEGER,
	`ReviewCode`	VARCHAR(250) UNIQUE,
	`LongDescription`	VARCHAR(250),
	`ShortDescription`	VARCHAR(250),
	PRIMARY KEY(`ReviewClassID`)
);

CREATE TABLE IF NOT EXISTS `ChemTypeLookup` (
	`ChemicalTypeID`	INTEGER,
	`ChemicalTypeCode`	INTEGER,
	`ChemicalTypeDescription`	VARCHAR(250),
	PRIMARY KEY(`ChemicalTypeID`),
    INDEX(`ChemicalTypeCode`)
);


CREATE TABLE IF NOT EXISTS `Application` (
	`ApplNo`	INTEGER,
	`ApplType`	VARCHAR(250),
	`SponsorApplicant`	VARCHAR(250),
	`MostRecentLabelAvailableFlag`	VARCHAR(250),
	`CurrentPatentFlag`	VARCHAR(250),
	`ActionType`	VARCHAR(250),
	`Chemical_Type`	INTEGER,
	`Ther_Potential`	VARCHAR(250),
	`Orphan_Code`	VARCHAR(250),
	PRIMARY KEY(`ApplNo`),
    INDEX (`ActionType`),
	FOREIGN KEY(`Orphan_Code`) REFERENCES `ReviewClass_Lookup`(`ReviewCode`),
	FOREIGN KEY(`Chemical_Type`) REFERENCES `ChemTypeLookup`(`ChemicalTypeCode`),
	FOREIGN KEY(`Ther_Potential`) REFERENCES `ReviewClass_Lookup`(`ReviewCode`)
);


CREATE TABLE IF NOT EXISTS `Product` (
	`ApplNo`	INTEGER,
	`ProductNo`	INTEGER,
	`Form`	VARCHAR(250),
	`Dosage`	VARCHAR(250),
	`ProductMktStatus`	INTEGER,
	`TECode`	VARCHAR(250),
	`ReferenceDrug`	INTEGER,
	`drugname`	VARCHAR(200),
	`activeingred`	VARCHAR(250),
    INDEX (`TECode`),
    INDEX(`ProductMktStatus`),
    INDEX(`ProductNo`),
	PRIMARY KEY(`ApplNo`,`ProductNo`,`ProductMktStatus`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Application`(`ApplNo`)
);


CREATE TABLE IF NOT EXISTS `AppDocType_Lookup` (
	`AppDocType` VARCHAR(250),
	`SortOrder`	INTEGER,
	PRIMARY KEY(`AppDocType`)
);


CREATE TABLE IF NOT EXISTS `DocType_lookup` (
	`DocType`	VARCHAR(250),
	`DocTypeDesc`	VARCHAR(250),
	PRIMARY KEY(`DocType`)
);

CREATE TABLE IF NOT EXISTS `Product_tecode` (
	`ApplNo`	INTEGER,
	`ProductNo`	INTEGER,
	`TECode`	VARCHAR(250),
	`TESequence`	INTEGER,
	`ProductMktStatus`	INTEGER,
	FOREIGN KEY(`ProductMktStatus`) REFERENCES `Product`(`ProductMktStatus`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Product`(`ApplNo`),
    FOREIGN KEY(`ProductNo`) REFERENCES `Product`(`ProductNo`),
	FOREIGN KEY(`TECode`) REFERENCES `Product`(`TECode`),
	PRIMARY KEY(`TESequence`,`ApplNo`,`ProductNo`,`ProductMktStatus`)
);

CREATE TABLE IF NOT EXISTS `RegActionDate` (
	`ApplNo`	INTEGER,
	`ActionType`	VARCHAR(250),
	`InDocTypeSeqNo`	INTEGER,
	`DuplicateCounter`	INTEGER,
	`ActionDate`	VARCHAR(250),
	`DocType`	VARCHAR(250),
    INDEX(`InDocTypeSeqNo`),
    INDEX(`DuplicateCounter`),
    INDEX(`ActionDate`),
	FOREIGN KEY(`ActionType`) REFERENCES `Application`(`ActionType`),
	FOREIGN KEY(`ApplNo`) REFERENCES `Application`(`ApplNo`),
	FOREIGN KEY(`DocType`) REFERENCES `DocType_lookup`(`DocType`),
	PRIMARY KEY(`ApplNo`,`InDocTypeSeqNo`,`DuplicateCounter`)
);

CREATE TABLE IF NOT EXISTS `AppDoc` (
	`AppDocID`	INTEGER,
	`ApplNo`	INTEGER,
	`SeqNo`	INTEGER,
	`DocType`	VARCHAR(250),
	`DocTitle`	VARCHAR(250),
	`DocURL`	VARCHAR(200),
	`DocDate`	VARCHAR(250),
	`ActionType`	VARCHAR(250),
	`DuplicateCounter`	INTEGER,
	PRIMARY KEY(`AppDocID`),
	FOREIGN KEY(`DocType`) REFERENCES `AppDocType_Lookup`(`AppDocType`),
	FOREIGN KEY(`ActionType`) REFERENCES `RegActionDate`(`ActionType`),
	FOREIGN KEY(`SeqNo`) REFERENCES `RegActionDate`(`InDocTypeSeqNo`),
	FOREIGN KEY(`ApplNo`) REFERENCES `RegActionDate`(`ApplNo`),
	FOREIGN KEY(`DuplicateCounter`) REFERENCES `RegActionDate`(`DuplicateCounter`),
	FOREIGN KEY(`DocDate`) REFERENCES `RegActionDate`(`ActionDate`)
);