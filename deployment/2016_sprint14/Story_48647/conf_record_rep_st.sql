
------------------------------------------------
-- DDL Statements for Table "EAADMIN "."CONFIG_RECORD"
------------------------------------------------
DROP TABLE "EAADMIN "."CONFIG_RECORD"  ;

CREATE TABLE "EAADMIN "."CONFIG_RECORD"  (
            "ID" BIGINT NOT NULL , 
			"NAME" VARCHAR(255) NOT NULL,
            "SERIAL_NUMBER" VARCHAR(128) NOT NULL,
            "SOFTWARE_LPAR_ID" BIGINT ,
            "VCPU" INTEGER,
            "VMWARE_CLUSTER" VARCHAR(255),
            "VM_CAN_MIGRATE" SMALLINT,
            "HYPER_THREADING" SMALLINT,
			"BANK_ACCOUNT_ID" BIGINT NOT NULL,
			"COMPUTER_ID" VARCHAR(255) NOT NULL )
                 DATA CAPTURE CHANGES
                 IN "HARDWARE" INDEX IN "HARDWAREINDEX" ;


-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE UNIQUE INDEX "EAADMIN "."IF1CONFIGIDRECORD" ON "EAADMIN "."CONFIG_RECORD" 
		("BANK_ACCOUNT_ID" ASC,
		 "NAME" ASC,
		 "SERIAL_NUMBER" ASC)		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE INDEX "EAADMIN "."IF2CONFIGIDRECORD" ON "EAADMIN "."CONFIG_RECORD" 
		("SOFTWARE_LPAR_ID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;
		
-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE INDEX "EAADMIN "."IF3CONFIGIDRECORD" ON "EAADMIN "."CONFIG_RECORD" 
		("COMPUTER_ID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."CONFIG_RECORD"

CREATE UNIQUE INDEX "EAADMIN "."IN01CFREIDPK" ON "EAADMIN "."CONFIG_RECORD" 
		("ID" ASC)
		
		COMPRESS NO ALLOW REVERSE SCANS;
-- DDL Statements for Primary Key on Table "EAADMIN "."CONFIG_RECORD"

ALTER TABLE "EAADMIN "."CONFIG_RECORD" 
	ADD CONSTRAINT "CT01CFREIDPK" PRIMARY KEY
		("ID");
---------- Privilege For CONFIG_RECORD ----------
GRANT REFERENCES ON TABLE "EAADMIN "."CONFIG_RECORD"      TO GROUP "TRAILUPD" ;       
GRANT SELECT ON TABLE "EAADMIN "."CONFIG_RECORD"          TO GROUP "TRAILSTG" ; 
GRANT SELECT ON "EAADMIN"."CONFIG_RECORD" TO USER EAADMIN
;
---------Delete records from SUBS_MEMEBER first if exist------
DELETE FROM ASN.IBMSNAP_SUBS_MEMBR  WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
and SET_NAME ='STREP1'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'CONFIG_RECORD'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'CONFIG_RECORD'
;
DELETE FROM ASN.IBMSNAP_SUBS_COLS WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
and SET_NAME = 'STREP1'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'CONFIG_RECORD'
;

---------Register columns into apply SUBS_MEMEBER-------
INSERT INTO ASN.IBMSNAP_SUBS_MEMBR (
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 SOURCE_OWNER, SOURCE_TABLE, SOURCE_VIEW_QUAL, 
 TARGET_OWNER, TARGET_TABLE, TARGET_STRUCTURE, 
 TARGET_CONDENSED, TARGET_COMPLETE, 
 PREDICATES, UOW_CD_PREDICATES, JOIN_UOW_CD, 
 MEMBER_STATE,TARGET_KEY_CHG,LOADX_TYPE, 
 LOADX_SRC_N_OWNER,LOADX_SRC_N_TABLE 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 0,
 'EAADMIN',
 'CONFIG_RECORD',
 8,
 'Y',
 'Y',
 null,
 null,
 null,
 'N',
 'N',
 null,
 null,
 null
 );


INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'ID',
 'A',
 'Y',
 1,
 'ID'
 );


INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'NAME',
 'A',
 'N',
 2,
 'NAME'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'SERIAL_NUMBER',
 'A',
 'N',
 3,
 'SERIAL_NUMBER'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'SOFTWARE_LPAR_ID',
 'A',
 'N',
 4,
 'SOFTWARE_LPAR_ID'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'VCPU',
 'A',
 'N',
 5,
 'VCPU'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'VMWARE_CLUSTER',
 'A',
 'N',
 6,
 'VMWARE_CLUSTER'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'VM_CAN_MIGRATE',
 'A',
 'N',
 7,
 'VM_CAN_MIGRATE'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'HYPER_THREADING',
 'A',
 'N',
 8,
 'HYPER_THREADING'
 );
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'BANK_ACCOUNT_ID',
 'A',
 'N',
 9,
 'BANK_ACCOUNT_ID'
 );
 
  INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 ) VALUES (
 'PD_TO_ST_QUAL',
 'STREP1',
 'S',
 'EAADMIN',
 'CONFIG_RECORD',
 'COMPUTER_ID',
 'A',
 'N',
 10,
 'COMPUTER_ID'
 );
 
UPDATE ASN.IBMSNAP_SUBS_SET 
SET ACTIVATE = 1
  WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
  AND SET_NAME = 'STREP1';