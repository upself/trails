ALTER TABLE TRAILSPD_CD.CUSTOMER ADD COLUMN CUSTOMER_PREFIX VARCHAR(16);
ALTER TABLE TRAILSPD_CD.CUSTOMER ADD COLUMN CUSTOMER_SUFFIX VARCHAR(16);
ALTER TABLE TRAILSPD_CD.CUSTOMER ADD COLUMN HOSTNAME_PREFIX VARCHAR(64);
ALTER TABLE TRAILSPD_CC.CUSTOMER ADD COLUMN CUSTOMER_PREFIX VARCHAR(16);
ALTER TABLE TRAILSPD_CC.CUSTOMER ADD COLUMN CUSTOMER_SUFFIX VARCHAR(16);
ALTER TABLE TRAILSPD_CC.CUSTOMER ADD COLUMN HOSTNAME_PREFIX VARCHAR(64);
REORG TABLE TRAILSPD_CD.CUSTOMER;
REORG TABLE TRAILSPD_CC.CUSTOMER;
RUNSTATS ON TABLE EAADMIN.CUSTOMER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CD.CUSTOMER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;
RUNSTATS ON TABLE TRAILSPD_CC.CUSTOMER ON ALL COLUMNS WITH DISTRIBUTION ON ALL COLUMNS AND DETAILED INDEXES ALL ALLOW WRITE ACCESS UTIL_IMPACT_PRIORITY 50
;