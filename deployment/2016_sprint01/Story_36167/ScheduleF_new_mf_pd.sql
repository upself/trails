ALTER TABLE "EAADMIN"."SCHEDULE_F" ADD COLUMN MANUFACTURER_NAME VARCHAR(255)
;
ALTER TABLE TRAILSPD_CD.SCHEDULE_F ADD COLUMN MANUFACTURER_NAME VARCHAR(255); 
ALTER TABLE TRAILSPD_CC.SCHEDULE_F ADD COLUMN MANUFACTURER_NAME VARCHAR(255); 
REORG TABLE EAADMIN.SCHEDULE_F;
REORG TABLE TRAILSPD_CD.SCHEDULE_F;
REORG TABLE TRAILSPD_CC.SCHEDULE_F;
RUNSTATS ON TABLE EAADMIN.SCHEDULE_F ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.SCHEDULE_F ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.SCHEDULE_F ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;