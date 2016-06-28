
------------------------------------------------
-- DDL Statements for Table "EAADMIN"."ALERT_INSTALLED_SOFTWARE"
------------------------------------------------
--DROP table   EAADMIN.ALERT_INSTALLED_SOFTWARE                           
--;

------------------------------------------------
-- DDL Statements for Table "EAADMIN "."ALERT_INSTALLED_SOFTWARE"
------------------------------------------------


CREATE TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"  (
                  "ID" BIGINT NOT NULL ,
                  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL )
                 IN "ALERTINDEX" ;


-- DDL Statements for Indexes on Table "EAADMIN "."ALERT_INSTALLED_SOFTWARE"

CREATE INDEX "EAADMIN "."IF1ALERTINSTALLEDSWPD" ON "EAADMIN "."ALERT_INSTALLED_SOFTWARE"
                ("INSTALLED_SOFTWARE_ID" ASC,
                 "ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;

-- DDL Statements for Indexes on Table "EAADMIN "."ALERT_INSTALLED_SOFTWARE"

CREATE UNIQUE INDEX "EAADMIN "."PKALERTINSTALLEDSWPD" ON "EAADMIN "."ALERT_INSTALLED_SOFTWARE"
                ("ID" ASC)

                COMPRESS NO ALLOW REVERSE SCANS;

ALTER TABLE EAADMIN.ALERT_INSTALLED_SOFTWARE DATA CAPTURE CHANGES;

-- DDL Statements for Indexes on Table "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE"

---------- Privilege For ALERT_INSTALLED_SOFTWARE ----------
GRANT REFERENCES ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"       TO GROUP "TRAILUPD" ;
GRANT DELETE ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO GROUP "TRAILPRD" ;    
GRANT INSERT ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO GROUP "TRAILPRD" ;    
GRANT SELECT ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO GROUP "TRAILPRD" ;    
GRANT UPDATE ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO GROUP "TRAILPRD" ; 

GRANT REFERENCES ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"       TO USER eaadmin ;   
GRANT DELETE ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO USER eaadmin ;   
GRANT INSERT ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO USER eaadmin ;   
GRANT SELECT ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO USER eaadmin ;   
GRANT UPDATE ON TABLE "EAADMIN "."ALERT_INSTALLED_SOFTWARE"           TO USER eaadmin ; 
		
------------------------------------------------
-- DDL Statements for Table "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE"
------------------------------------------------
DROP table   TRAILSPD_CD.ALERT_INSTALLED_SOFTWARE                           
;

CREATE TABLE "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE"  (
		  "IBMSNAP_COMMITSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_INTENTSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_OPERATION" CHAR(1) NOT NULL , 
		  "ID" BIGINT NOT NULL,
		  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL )   
		 IN TRAILSPD_CD_TABLES  INDEX IN TRAILSPD_CD_INDEX  ; 

ALTER TABLE "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE" VOLATILE CARDINALITY;


-- DDL Statements for Indexes on Table "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE"

CREATE UNIQUE INDEX "TRAILSPD_CD"."IXCDALERT_INSTWARE" ON "TRAILSPD_CD"."ALERT_INSTALLED_SOFTWARE" 
		("IBMSNAP_COMMITSEQ" ASC,
		 "IBMSNAP_INTENTSEQ" ASC)
		PCTFREE 0 
		COMPRESS NO ALLOW REVERSE SCANS;
------------------------------------------------
-- DDL Statements for Table "TRAILSPD_CC"."ALERT_INSTALLED_SOFTWARE"
------------------------------------------------
 DROP table   TRAILSPD_CC.ALERT_INSTALLED_SOFTWARE                           
;

CREATE TABLE "TRAILSPD_CC"."ALERT_INSTALLED_SOFTWARE"  (
		  "IBMSNAP_COMMITSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_INTENTSEQ" VARCHAR(16) FOR BIT DATA NOT NULL , 
		  "IBMSNAP_OPERATION" CHAR(1) NOT NULL , 
		  "ID" BIGINT NOT NULL,
		  "INSTALLED_SOFTWARE_ID" BIGINT NOT NULL )   
		 IN TRAILSPD_CD_TABLES  INDEX IN TRAILSPD_CD_INDEX  ; 

ALTER TABLE "TRAILSPD_CC"."ALERT_INSTALLED_SOFTWARE" VOLATILE CARDINALITY;



-- DDL Statements for Indexes on Table "TRAILSPD_CC"."ALERT_INSTALLED_SOFTWARE"

CREATE UNIQUE INDEX "TRAILSPD_CC"."IXCCALERT_INSTWARE" ON "TRAILSPD_CC"."ALERT_INSTALLED_SOFTWARE" 
		("IBMSNAP_COMMITSEQ" ASC,
		 "IBMSNAP_INTENTSEQ" ASC)
		PCTFREE 0 
		COMPRESS NO ALLOW REVERSE SCANS;
		
----------------------------------------------------------------------
-- DDL Statements for registering ALERT_INSTALLED_SOFTWARE TRAILSPD_CD
----------------------------------------------------------------------
DELETE FROM ASN.IBMSNAP_REGISTER where SOURCE_OWNER='EAADMIN' 
and SOURCE_TABLE='ALERT_INSTALLED_SOFTWARE' 
and CD_OWNER='TRAILSPD_CD' 
and CD_TABLE='ALERT_INSTALLED_SOFTWARE' 
and PHYS_CHANGE_OWNER='TRAILSPD_CD' 
and PHYS_CHANGE_TABLE='ALERT_INSTALLED_SOFTWARE'
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
'ALERT_INSTALLED_SOFTWARE',
0,
'N',
1,
'Y',
'Y',
'TRAILSPD_CD',
'ALERT_INSTALLED_SOFTWARE',
'TRAILSPD_CD',
'ALERT_INSTALLED_SOFTWARE',
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
-- DDL Statements for registering ALERT_INSTALLED_SOFTWARE for TRAILSPD_CC
----------------------------------------------------------------------
DELETE FROM NEWASN.IBMSNAP_REGISTER where SOURCE_OWNER='EAADMIN' 
and SOURCE_TABLE='ALERT_INSTALLED_SOFTWARE' 
and CD_OWNER='TRAILSPD_CC' 
and CD_TABLE='ALERT_INSTALLED_SOFTWARE' 
and PHYS_CHANGE_OWNER='TRAILSPD_CC' 
and PHYS_CHANGE_TABLE='ALERT_INSTALLED_SOFTWARE'
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
'ALERT_INSTALLED_SOFTWARE',
0,
'N',
1,
'Y',
'Y',
'TRAILSPD_CC',
'ALERT_INSTALLED_SOFTWARE',
'TRAILSPD_CC',
'ALERT_INSTALLED_SOFTWARE',
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
-- DDL Statements for registering  NEWASN PrunControl ALERT_INSTALLED_SOFTWARE for PD_TO_RP_QUAL
-----------------------------------------------------------------------------
DELETE FROM NEWASN.IBMSNAP_PRUNCNTL WHERE APPLY_QUAL = 'PD_TO_RP_QUAL' 
and SET_NAME = 'RPREP1'
and CNTL_SERVER = 'TRAILSRP'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'ALERT_INSTALLED_SOFTWARE'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'ALERT_INSTALLED_SOFTWARE'
and TARGET_SERVER = 'TRAILSRP'
and PHYS_CHANGE_OWNER = 'TRAILSPD_CC'
and PHYS_CHANGE_TABLE = 'ALERT_INSTALLED_SOFTWARE'
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
 'ALERT_INSTALLED_SOFTWARE',
 0,
 'EAADMIN',
 'ALERT_INSTALLED_SOFTWARE',
 'TRAILSRP',
 8,
 coalesce ( char(max(INT(MAP_ID)+1) ), '0' ),
 'TRAILSPD_CC',
 'ALERT_INSTALLED_SOFTWARE' FROM NEWASN.IBMSNAP_PRUNCNTL;
 -----------------------------------------------------------------------------
-- DDL Statements for registering ASN PrunControl ALERT_INSTALLED_SOFTWARE for PD_TO_ST_QUAL
-----------------------------------------------------------------------------
DELETE FROM ASN.IBMSNAP_PRUNCNTL WHERE APPLY_QUAL = 'PD_TO_ST_QUAL' 
and SET_NAME = 'STREP1'
and CNTL_SERVER = 'TRAILSST'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'ALERT_INSTALLED_SOFTWARE'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'ALERT_INSTALLED_SOFTWARE'
and TARGET_SERVER = 'TRAILSST'
and PHYS_CHANGE_OWNER = 'TRAILSPD_CD'
and PHYS_CHANGE_TABLE = 'ALERT_INSTALLED_SOFTWARE'
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
 'ALERT_INSTALLED_SOFTWARE',
 0,
 'EAADMIN',
 'ALERT_INSTALLED_SOFTWARE',
 'TRAILSST',
 8,
 coalesce ( char(max(INT(MAP_ID)+1) ), '0' ),
 'TRAILSPD_CD',
 'ALERT_INSTALLED_SOFTWARE' FROM ASN.IBMSNAP_PRUNCNTL;


COMMIT ;

 
 