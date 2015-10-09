--HealthCheck and Monitor Service Component - Phase 4
--Database Monitoring Event Group
INSERT INTO EAADMIN.EVENT_GROUP(EVENT_GROUP_ID,NAME,DESCRIPTION) VALUES(3,'DATABASE_MONITORING','Database Monitoring Event Group');
--TrailsRP DB Apply Gap Monitoring Event Type
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(8,'TRAILSRP_DB_APPLY_GAP_MONITORING','TrailsRP DB Apply Gap Monitoring Event Type for Database Monitoring Event Group',3);

COMMIT;
TERMINATE;