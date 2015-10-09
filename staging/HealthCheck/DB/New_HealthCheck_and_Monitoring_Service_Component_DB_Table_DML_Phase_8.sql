--HealthCheck and Monitoring Service Component - Phase 8
INSERT INTO EAADMIN.EVENT_GROUP(EVENT_GROUP_ID,NAME,DESCRIPTION) VALUES(4,'APPLICATION_MONITORING','Application Monitoring Event Group');
--WebApp Running Status Check Monitoring
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(12,'WEBAPP_RUNNING_STATUS_CHECK_MONITORING','WebApp Running Status Check Monitoring Event Type for Application Monitoring Event Group',4);

COMMIT;
TERMINATE;