--New Alert Type for SOM3
INSERT INTO "EAADMIN"."ALERT_TYPE" (NAME,CODE) VALUES ('SOM3: SW Instances with Defined Contract Scope','SWISCOPE');
INSERT INTO "EAADMIN"."ALERT_TYPE_CAUSE" (ALERT_TYPE_ID,ALERT_CAUSE_ID,STATUS) VALUES ((select id from eaadmin.alert_type where code = 'SWISCOPE'),1,'ACTIVE');

--New Alert Type for SOM4b
INSERT INTO "EAADMIN"."ALERT_TYPE" (NAME,CODE) VALUES ('SOM4b: Priority ISV SW Instances Reviewed','SWISVPR');
INSERT INTO "EAADMIN"."ALERT_TYPE_CAUSE" (ALERT_TYPE_ID,ALERT_CAUSE_ID,STATUS) VALUES ((select id from eaadmin.alert_type where code = 'SWISVPR'),1,'ACTIVE');

--New Alert Type for SOM4c
INSERT INTO "EAADMIN"."ALERT_TYPE" (NAME,CODE) VALUES ('SOM4c: ISV SW Instances Reviewed','SWISVNPR');
INSERT INTO "EAADMIN"."ALERT_TYPE_CAUSE" (ALERT_TYPE_ID,ALERT_CAUSE_ID,STATUS) VALUES ((select id from eaadmin.alert_type where code = 'SWISVNPR'),1,'ACTIVE');

--Update the exising Alert Type for SOM4a
UPDATE "EAADMIN"."ALERT_TYPE" SET NAME='SOM4a: IBM SW Instances Reviewed', CODE='SWIBM' where CODE = 'NOLICIBM';
--INSERT INTO "EAADMIN"."ALERT_TYPE_CAUSE" (ALERT_TYPE_ID,ALERT_CAUSE_ID,STATUS) VALUES ((select id from eaadmin.alert_type where code = 'SWIBM'),1,'ACTIVE');

--DELETE FROM "EAADMIN"."ALERT_TYPE" WHERE CODE = 'NOLICISV';