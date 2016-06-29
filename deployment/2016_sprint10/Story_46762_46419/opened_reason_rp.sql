ALTER TABLE "EAADMIN"."ALERT_UNLICENSED_SW" ADD COLUMN OPENED_REASON VARCHAR(255)
;
ALTER TABLE "EAADMIN"."ALERT_UNLICENSED_SW_H" ADD COLUMN OPENED_REASON VARCHAR(255)
;
REORG TABLE EAADMIN.ALERT_UNLICENSED_SW;
REORG TABLE EAADMIN.ALERT_UNLICENSED_SW_H;

INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 )SELECT 'PD_TO_RP_QUAL', 'RPREP1', 'S', 'EAADMIN', 'ALERT_UNLICENSED_SW', 'OPENED_REASON', 'A', 'N', MAX(COLNO + 1), 'OPENED_REASON' 
 FROM ASN.IBMSNAP_SUBS_COLS  WHERE APPLY_QUAL='PD_TO_RP_QUAL' AND SET_NAME='RPREP1' AND WHOS_ON_FIRST='S' AND 
 TARGET_OWNER='EAADMIN' AND TARGET_TABLE='ALERT_UNLICENSED_SW';
 
 INSERT INTO ASN.IBMSNAP_SUBS_COLS ( 
 APPLY_QUAL, SET_NAME, WHOS_ON_FIRST, 
 TARGET_OWNER, TARGET_TABLE, TARGET_NAME, 
 COL_TYPE, IS_KEY, COLNO, EXPRESSION 
 )SELECT 'PD_TO_RP_QUAL', 'RPREP1', 'S', 'EAADMIN', 'ALERT_UNLICENSED_SW_H', 'OPENED_REASON', 'A', 'N', MAX(COLNO + 1), 'OPENED_REASON' 
 FROM ASN.IBMSNAP_SUBS_COLS  WHERE APPLY_QUAL='PD_TO_RP_QUAL' AND SET_NAME='RPREP1' AND WHOS_ON_FIRST='S' AND 
 TARGET_OWNER='EAADMIN' AND TARGET_TABLE='ALERT_UNLICENSED_SW_H';