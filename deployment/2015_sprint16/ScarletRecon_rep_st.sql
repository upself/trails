 CONNECT TO TRAILSST
 ;
 
DELETE FROM ASN.IBMSNAP_SUBS_MEMBR  WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
and SET_NAME ='STREP1'
and SOURCE_OWNER ='EAADMIN'
and SOURCE_TABLE = 'SCARLET_RECONCILE'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'SCARLET_RECONCILE'
;
DELETE FROM ASN.IBMSNAP_SUBS_COLS WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
and SET_NAME = 'STREP1'
and TARGET_OWNER = 'EAADMIN'
and TARGET_TABLE = 'SCARLET_RECONCILE'
;

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
 'SCARLET_RECONCILE',
 0,
 'EAADMIN',
 'SCARLET_RECONCILE',
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
 'SCARLET_RECONCILE',
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
 'SCARLET_RECONCILE',
 'LAST_VALIDATE_TIME',
 'A',
 'Y',
 2,
 'LAST_VALIDATE_TIME'
 );
 
 UPDATE ASN.IBMSNAP_SUBS_SET 
SET ACTIVATE = 1
  WHERE APPLY_QUAL = 'PD_TO_ST_QUAL'
  AND SET_NAME = 'STREP1';

 COMMIT ;

 connect reset;