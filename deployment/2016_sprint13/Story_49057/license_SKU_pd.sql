ALTER TABLE "EAADMIN"."LICENSE" ADD COLUMN SKU VARCHAR(40)
;
ALTER TABLE TRAILSPD_CD.LICENSE ADD COLUMN SKU VARCHAR(40); 
ALTER TABLE TRAILSPD_CC.LICENSE ADD COLUMN SKU VARCHAR(40); 
REORG TABLE EAADMIN.LICENSE;
REORG TABLE TRAILSPD_CD.LICENSE;
REORG TABLE TRAILSPD_CC.LICENSE;
RUNSTATS ON TABLE EAADMIN.LICENSE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.LICENSE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.LICENSE ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;