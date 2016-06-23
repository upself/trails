alter table eaadmin.alert_type alter column id restart with 69;
INSERT INTO "EAADMIN"."ALERT_TYPE" (NAME,CODE,IS_DQ) VALUES ('SW DISCREPANCY EXPIRED','SWDSCEXP',1);

CREATE TABLE ALERT_INSTALLED_SOFTWARE
(
   ID bigint NOT NULL, INSTALLED_SOFTWARE_ID bigint NOT NULL
);
CREATE INDEX IF1ALERTINSTALLEDSWLP ON ALERT_INSTALLED_SOFTWARE ( INSTALLED_SOFTWARE_ID, ID );
CREATE UNIQUE INDEX PKALERTINSTALLEDSWLP ON ALERT_INSTALLED_SOFTWARE(ID);

