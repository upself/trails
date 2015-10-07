ALTER TABLE "EAADMIN"."ALERT_UNLICENSED_SW_H" ADD COLUMN TYPE	VARCHAR(16)
;
REORG TABLE EAADMIN.ALERT_UNLICENSED_SW_H;

INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 )SELECT 'PD_TO_ST_QUAL', 'STREP1', 'S', 'EAADMIN', 'ALERT_UNLICENSED_SW_H', 'TYPE', 'A', 'N', MAX(COLNO + 1), 'TYPE' 
 FROM ASN.IBMSNAP_SUBS_COLS  WHERE APPLY_QUAL='PD_TO_ST_QUAL' AND SET_NAME='STREP1' AND WHOS_ON_FIRST='S' AND 
 TARGET_OWNER='EAADMIN' AND TARGET_TABLE='ALERT_UNLICENSED_SW_H';
 
