--HealthCheck and Monitoring Service Component - Phase 9
--Database Exception Status Check Monitoring Event Type
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(13,'DB_EXCEPTION_STATUS_CHECK_MONITORING','Database Exception Status Check Monitoring Event Type for Database Monitoring Event Group',3);

COMMIT;
TERMINATE;