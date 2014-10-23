--HealthCheck and Monitoring Service Component - Phase 7
--TrailsST DB Apply Gap Monitoring Event Type
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(10,'TRAILSST_DB_APPLY_GAP_MONITORING','TrailsST DB Apply Gap Monitoring Event Type for Database Monitoring Event Group',3);
--TrailsRP DB Apply Gap Monitoring 2 Event Type
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(11,'TRAILSRP_DB_APPLY_GAP_MONITORING_2','TrailsRP DB Apply Gap Monitoring 2 Event Type for Database Monitoring Event Group',3);

COMMIT;
TERMINATE;