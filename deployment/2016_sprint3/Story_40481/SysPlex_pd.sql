ALTER TABLE "EAADMIN"."SOFTWARE_LPAR" ADD COLUMN SYSPLEX VARCHAR(8)
;
ALTER TABLE TRAILSPD_CD.SOFTWARE_LPAR ADD COLUMN SYSPLEX VARCHAR(8); 
ALTER TABLE TRAILSPD_CC.SOFTWARE_LPAR ADD COLUMN SYSPLEX VARCHAR(8); 
REORG TABLE EAADMIN.SOFTWARE_LPAR;
REORG TABLE TRAILSPD_CD.SOFTWARE_LPAR;
REORG TABLE TRAILSPD_CC.SOFTWARE_LPAR;
RUNSTATS ON TABLE EAADMIN.SOFTWARE_LPAR ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.SOFTWARE_LPAR ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.SOFTWARE_LPAR ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;