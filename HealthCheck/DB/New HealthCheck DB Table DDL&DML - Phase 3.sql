--HealthCheck and Monitor Module - Phase 3
INSERT INTO EAADMIN.EVENT_GROUP(EVENT_GROUP_ID,NAME,DESCRIPTION) VALUES(2,'FILE_SYSTEM_MONITORING','File System Monitoring Event Group');
--File System Threshold Monitoring
INSERT INTO EAADMIN.EVENT_TYPE(EVENT_ID,NAME,DESCRIPTION,EVENT_GROUP_ID) VALUES(7,'FILE_SYSTEM_THRESHOLD_MONITORING','File System Threshold Monitoring Event Type for File System Monitoring Event Group',2);

COMMIT;
TERMINATE;