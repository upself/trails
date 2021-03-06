
------------------------------------------------
-- DDL Statements for Table "EAADMIN "."INSTALLED_SCRIPT"
------------------------------------------------


CREATE TABLE "EAADMIN "."INSTALLED_SCRIPT"  (
                  "ID" INTEGER NOT NULL GENERATED ALWAYS AS IDENTITY (
                    START WITH +1
                    INCREMENT BY +1
                    MINVALUE +1
                    MAXVALUE +2147483647
                    NO CYCLE
                    CACHE 20
                    NO ORDER ) ,
                  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL ,
                  "SOFTWARE_SCRIPT_ID" BIGINT NOT NULL ,
                  "BANK_ACCOUNT_ID" BIGINT NOT NULL ,
                  "STATUS" VARCHAR(32) )
                 DATA CAPTURE CHANGES
                 IN "INSTALLED" INDEX IN "INSTALLEDINDEX" ;


-- DDL Statements for Indexes on Table "EAADMIN "."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "EAADMIN "."IF1INSTALLEDSCRIPT" ON "EAADMIN "."INSTALLED_SCRIPT"
                ("INSTALLED_SOFTWARE_ID" ASC,
                 "SOFTWARE_SCRIPT_ID" ASC,
                 "BANK_ACCOUNT_ID" ASC,
                 "STATUS" ASC,
                 "ID" ASC)
                CLUSTER
                COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "EAADMIN "."IF2INSTALLEDSCRIPT" ON "EAADMIN "."INSTALLED_SCRIPT"
                ("BANK_ACCOUNT_ID" ASC,
                 "INSTALLED_SOFTWARE_ID" ASC,
                 "ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "EAADMIN "."IF3INSTALLEDSCRIPT" ON "EAADMIN "."INSTALLED_SCRIPT"
                ("SOFTWARE_SCRIPT_ID" ASC,
                 "INSTALLED_SOFTWARE_ID" ASC,
                 "BANK_ACCOUNT_ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."INSTALLED_SCRIPT"

CREATE INDEX "EAADMIN "."IF4INSTALLEDSCRIPT" ON "EAADMIN "."INSTALLED_SCRIPT"
                ("INSTALLED_SOFTWARE_ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "EAADMIN "."PKINSTALLEDSCRIPT" ON "EAADMIN "."INSTALLED_SCRIPT"
                ("ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;
-- DDL Statements for Primary Key on Table "EAADMIN "."INSTALLED_SCRIPT"

ALTER TABLE "EAADMIN "."INSTALLED_SCRIPT"
        ADD CONSTRAINT "PKINSTALLEDSCRIPT" PRIMARY KEY
                ("ID");

ALTER TABLE EAADMIN.INSTALLED_SCRIPT DATA CAPTURE CHANGES;
---------- Privilege For INSTALLED_SCRIPT ----------
GRANT REFERENCES ON TABLE "EAADMIN "."INSTALLED_SCRIPT"       TO GROUP "TRAILUPD" ;
GRANT DELETE ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO GROUP "TRAILPRD" ;    
GRANT INSERT ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO GROUP "TRAILPRD" ;    
GRANT SELECT ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO GROUP "TRAILPRD" ;    
GRANT UPDATE ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO GROUP "TRAILPRD" ; 

GRANT REFERENCES ON TABLE "EAADMIN "."INSTALLED_SCRIPT"       TO USER eaadmin ;   
GRANT DELETE ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO USER eaadmin ;   
GRANT INSERT ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO USER eaadmin ;   
GRANT SELECT ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO USER eaadmin ;   
GRANT UPDATE ON TABLE "EAADMIN "."INSTALLED_SCRIPT"           TO USER eaadmin ; 
------------------------------------------------
-- DDL Statements for Table "TRAILSPD_CD"."INSTALLED_SCRIPT"
------------------------------------------------
DROP table   TRAILSPD_CD.INSTALLED_SCRIPT                           
;

CREATE TABLE "TRAILSPD_CD"."INSTALLED_SCRIPT"  (
		  "IBMSNAP_COMMITSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_INTENTSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_OPERATION" CHAR(1) NOT NULL , 
		  "ID" INTEGER NOT NULL ,
		  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL ,
          "SOFTWARE_SCRIPT_ID" BIGINT NOT NULL ,
          "BANK_ACCOUNT_ID" BIGINT NOT NULL ,
          "STATUS" VARCHAR(32) )   
		 IN TRAILSPD_CD_TABLES  INDEX IN TRAILSPD_CD_INDEX  ; 

ALTER TABLE "TRAILSPD_CD"."INSTALLED_SCRIPT" VOLATILE CARDINALITY;


-- DDL Statements for Indexes on Table "TRAILSPD_CD"."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "TRAILSPD_CD"."IXCDINSTALLED_SCRIPT" ON "TRAILSPD_CD"."INSTALLED_SCRIPT" 
		("IBMSNAP_COMMITSEQ" ASC,
		 "IBMSNAP_INTENTSEQ" ASC)
		PCTFREE 0 
		COMPRESS NO ALLOW REVERSE SCANS;
------------------------------------------------
-- DDL Statements for Table "TRAILSPD_CC"."INSTALLED_SCRIPT"
------------------------------------------------
 DROP table   TRAILSPD_CC.INSTALLED_SCRIPT                           
;

CREATE TABLE "TRAILSPD_CC"."INSTALLED_SCRIPT"  (
		  "IBMSNAP_COMMITSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_INTENTSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_OPERATION" CHAR(1) NOT NULL , 
		  "ID" INTEGER NOT NULL ,
		  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL ,
          "SOFTWARE_SCRIPT_ID" BIGINT NOT NULL ,
          "BANK_ACCOUNT_ID" BIGINT NOT NULL ,
          "STATUS" VARCHAR(32) )   
		 IN TRAILSPD_CD_TABLES  INDEX IN TRAILSPD_CD_INDEX  ; 

ALTER TABLE "TRAILSPD_CC"."INSTALLED_SCRIPT" VOLATILE CARDINALITY;



-- DDL Statements for Indexes on Table "TRAILSPD_CC"."INSTALLED_SCRIPT"

CREATE UNIQUE INDEX "TRAILSPD_CC"."IXCCINSTALLED_SCRIPT" ON "TRAILSPD_CC"."INSTALLED_SCRIPT" 
		("IBMSNAP_COMMITSEQ" ASC,
		 "IBMSNAP_INTENTSEQ" ASC)
		PCTFREE 0 
		COMPRESS NO ALLOW REVERSE SCANS;

		
----------------------------------------------------------------------
-- DDL Statements for registering INSTALLED_SCRIPT TRAILSPD_CD
----------------------------------------------------------------------
DELETE FROM ASN.IBMSNAP_REGISTER where SOURCE_OWNER='EAADMIN' 
and SOURCE_TABLE='INSTALLED_SCRIPT' 
and CD_OWNER='TRAILSPD_CD' 
and CD_TABLE='INSTALLED_SCRIPT' 
and PHYS_CHANGE_OWNER='TRAILSPD_CD' 
and PHYS_CHANGE_TABLE='INSTALLED_SCRIPT'
;
INSERT INTO ASN.IBMSNAP_REGISTER (SOURCE_OWNER, SOURCE_TABLE,
SOURCE_VIEW_QUAL, GLOBAL_RECORD, SOURCE_STRUCTURE, SOURCE_CONDENSED,
SOURCE_COMPLETE, CD_OWNER, CD_TABLE, PHYS_CHANGE_OWNER, 
PHYS_CHANGE_TABLE, CD_OLD_SYNCHPOINT, CD_NEW_SYNCHPOINT, 
DISABLE_REFRESH, CCD_OWNER, CCD_TABLE, CCD_OLD_SYNCHPOINT, 
SYNCHPOINT, SYNCHTIME, CCD_CONDENSED, CCD_COMPLETE, ARCH_LEVEL, 
DESCRIPTION, BEFORE_IMG_PREFIX, CONFLICT_LEVEL, 
CHG_UPD_TO_DEL_INS, CHGONLY, RECAPTURE, OPTION_FLAGS,
STOP_ON_ERROR, STATE, STATE_INFO ) VALUES(
'EAADMIN',
'INSTALLED_SCRIPT',
0,
'N',
1,
'Y',
'Y',
'TRAILSPD_CD',
'INSTALLED_SCRIPT',
'TRAILSPD_CD',
'INSTALLED_SCRIPT',
null,
null,
0,
null,
null,
null,
null,
null,
null,
null,
'0801',
null,
null,
'0',
'N',
'N',
'Y',
'NNNN',
'Y',
'I',
null );
----------------------------------------------------------------------
-- DDL Statements for registering INSTALLED_SCRIPT for TRAILSPD_CC
----------------------------------------------------------------------
DELETE FROM NEWASN.IBMSNAP_REGISTER where SOURCE_OWNER='EAADMIN' 
and SOURCE_TABLE='INSTALLED_SCRIPT' 
and CD_OWNER='TRAILSPD_CC' 
and CD_TABLE='INSTALLED_SCRIPT' 
and PHYS_CHANGE_OWNER='TRAILSPD_CC' 
and PHYS_CHANGE_TABLE='INSTALLED_SCRIPT'
;
INSERT INTO NEWASN.IBMSNAP_REGISTER (SOURCE_OWNER, SOURCE_TABLE,
SOURCE_VIEW_QUAL, GLOBAL_RECORD, SOURCE_STRUCTURE, SOURCE_CONDENSED,
SOURCE_COMPLETE, CD_OWNER, CD_TABLE, PHYS_CHANGE_OWNER, 
PHYS_CHANGE_TABLE, CD_OLD_SYNCHPOINT, CD_NEW_SYNCHPOINT, 
DISABLE_REFRESH, CCD_OWNER, CCD_TABLE, CCD_OLD_SYNCHPOINT, 
SYNCHPOINT, SYNCHTIME, CCD_CONDENSED, CCD_COMPLETE, ARCH_LEVEL, 
DESCRIPTION, BEFORE_IMG_PREFIX, CONFLICT_LEVEL, 
CHG_UPD_TO_DEL_INS, CHGONLY, RECAPTURE, OPTION_FLAGS,
STOP_ON_ERROR, STATE, STATE_INFO ) VALUES(
'EAADMIN',
'INSTALLED_SCRIPT',
0,
'N',
1,
'Y',
'Y',
'TRAILSPD_CC',
'INSTALLED_SCRIPT',
'TRAILSPD_CC',
'INSTALLED_SCRIPT',
null,
null,
0,
null,
null,
null,
null,
null,
null,
null,
'0801',
null,
null,
'0',
'N',
'N',
'Y',
'NNNN',
'Y',
'I',
null );

-----------------------------------------------------------------------------
-- DDL Statements for registering  NEWASN PrunControl INSTALLED_SCRIPT for PD_TO_RP_QUAL
-----------------------------------------------------------------------------
DELETE FROM NEWASN.IBMSNAP_PRUNCNTL WHERE APPLY_QUAL = 'PD_TO_RP_QUAL' 
and SET_NAME = 'RPREP1'
and CNTL_SERVER = 'TRAILSRP'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'INSTALLED_SCRIPT'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'INSTALLED_SCRIPT'
and TARGET_SERVER = 'TRAILSRP'
and PHYS_CHANGE_OWNER = 'TRAILSPD_CC'
and PHYS_CHANGE_TABLE = 'INSTALLED_SCRIPT'
;
INSERT INTO NEWASN.IBMSNAP_PRUNCNTL ( 
 APPLY_QUAL, SET_NAME, CNTL_SERVER, CNTL_ALIAS, 
 SOURCE_OWNER, SOURCE_TABLE, SOURCE_VIEW_QUAL, 
 TARGET_OWNER, TARGET_TABLE, TARGET_SERVER, 
 TARGET_STRUCTURE, MAP_ID, 
 PHYS_CHANGE_OWNER, PHYS_CHANGE_TABLE 
 ) SELECT 
'PD_TO_RP_QUAL',
 'RPREP1',
 'TRAILSRP',
 'TRAILSRP',
 'EAADMIN',
 'INSTALLED_SCRIPT',
 0,
 'EAADMIN',
 'INSTALLED_SCRIPT',
 'TRAILSRP',
 8,
 coalesce ( char(max(INT(MAP_ID)+1) ), '0' ),
 'TRAILSPD_CC',
 'INSTALLED_SCRIPT' FROM NEWASN.IBMSNAP_PRUNCNTL;
 -----------------------------------------------------------------------------
-- DDL Statements for registering ASN PrunControl INSTALLED_SCRIPT for PD_TO_ST_QUAL
-----------------------------------------------------------------------------
DELETE FROM ASN.IBMSNAP_PRUNCNTL WHERE APPLY_QUAL = 'PD_TO_ST_QUAL' 
and SET_NAME = 'STREP1'
and CNTL_SERVER = 'TRAILSST'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'INSTALLED_SCRIPT'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'INSTALLED_SCRIPT'
and TARGET_SERVER = 'TRAILSST'
and PHYS_CHANGE_OWNER = 'TRAILSPD_CD'
and PHYS_CHANGE_TABLE = 'INSTALLED_SCRIPT'
;
 INSERT INTO ASN.IBMSNAP_PRUNCNTL ( 
 APPLY_QUAL, SET_NAME, CNTL_SERVER, CNTL_ALIAS, 
 SOURCE_OWNER, SOURCE_TABLE, SOURCE_VIEW_QUAL, 
 TARGET_OWNER, TARGET_TABLE, TARGET_SERVER, 
 TARGET_STRUCTURE, MAP_ID, 
 PHYS_CHANGE_OWNER, PHYS_CHANGE_TABLE 
 ) SELECT 
'PD_TO_ST_QUAL',
 'STREP1',
 'TRAILSST',
 'TRAILSST',
 'EAADMIN',
 'INSTALLED_SCRIPT',
 0,
 'EAADMIN',
 'INSTALLED_SCRIPT',
 'TRAILSST',
 8,
 coalesce ( char(max(INT(MAP_ID)+1) ), '0' ),
 'TRAILSPD_CD',
 'INSTALLED_SCRIPT' FROM ASN.IBMSNAP_PRUNCNTL;


COMMIT ;


