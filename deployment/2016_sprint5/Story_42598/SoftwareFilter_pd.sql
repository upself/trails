ALTER TABLE "EAADMIN"."SOFTWARE_FILTER" ADD COLUMN CATALOG_TYPE VARCHAR(32)
;
ALTER TABLE TRAILSPD_CD.SOFTWARE_FILTER ADD COLUMN CATALOG_TYPE VARCHAR(32); 
ALTER TABLE TRAILSPD_CC.SOFTWARE_FILTER ADD COLUMN CATALOG_TYPE VARCHAR(32); 
ALTER TABLE "EAADMIN"."SOFTWARE_FILTER_H" ADD COLUMN CATALOG_TYPE VARCHAR(32)
;
ALTER TABLE TRAILSPD_CD.SOFTWARE_FILTER_H ADD COLUMN CATALOG_TYPE VARCHAR(32); 
ALTER TABLE TRAILSPD_CC.SOFTWARE_FILTER_H ADD COLUMN CATALOG_TYPE VARCHAR(32); 
REORG TABLE EAADMIN.SOFTWARE_FILTER;
REORG TABLE TRAILSPD_CD.SOFTWARE_FILTER;
REORG TABLE TRAILSPD_CC.SOFTWARE_FILTER;
REORG TABLE EAADMIN.SOFTWARE_FILTER_H;
REORG TABLE TRAILSPD_CD.SOFTWARE_FILTER_H;
REORG TABLE TRAILSPD_CC.SOFTWARE_FILTER_H;
RUNSTATS ON TABLE EAADMIN.SOFTWARE_FILTER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.SOFTWARE_FILTER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.SOFTWARE_FILTER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE EAADMIN.SOFTWARE_FILTER_H ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.SOFTWARE_FILTER_H ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.SOFTWARE_FILTER_H ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;