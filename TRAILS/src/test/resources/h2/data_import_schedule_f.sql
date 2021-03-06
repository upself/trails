--story 42595 by Abner
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (1, 2541, 999265, 'IBM AIX', 'IBM AIX', 'IBM', 1, 1, 'GDF-AP-ART-01', 2, 'df', 'dllhao@cn.ibm.com', '2015-05-12 02:22:21', 'PRODUCT', null, null, null, null, 'IBM');

INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (2, 2541, 218119, 'MICROSOFT SQL SERVER 2000 CAL', 'MICROSOFT SQL SERVER 2000 CAL', 'MICROSOFT', 3, 3, 'Dalian',    2, 'TEST', 'dllhao@cn.ibm.com', '2015-1-28 23:59:59','PRODUCT', null, null, null, null, 'IBM');

--Story 43236 by Larry
--Scope 'IBM owned, IBM managed' + Level 'MANUFACTURER' + Manufacturer Name 'IBM'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (3, 2541, null, null, null, 'IBM', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'MANUFACTURER', null, null, null, null, 'IBM');

--Scope 'IBM owned, IBM managed' + Level 'PRODUCT'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (4, 2541, 218097, 'IBM Lotus Notes', 'IBM Lotus Notes', 'IBM', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'PRODUCT', null, null, null, null, 'IBM');

--Scope 'IBM owned, IBM managed' + Level 'HWOWNER' + HW OWNER 'IBM'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (5, 2541, 218097, 'IBM Lotus Notes', 'IBM Lotus Notes', 'IBM', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'HWOWNER', 'IBM', null, null, null, 'IBM');

--Scope 'IBM owned, IBM managed' + Level 'HWBOX' + Serail '00RTST5' + Machine Type '2373'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (6, 2541, 218097, 'IBM Lotus Notes', 'IBM Lotus Notes', 'IBM', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'HWBOX', null, '00RTST5','2373', null, 'IBM');

--Scope 'IBM owned, IBM managed' + Level 'HOSTNAME' + Hostname 'RECONTEST3'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (7, 2541, 218097, 'IBM Lotus Notes', 'IBM Lotus Notes', 'IBM', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'HOSTNAME', null, null, null, 'RECONTEST3', 'IBM');

--Scope 'IBM owned, IBM managed' + Level 'MANUFACTURER' + Manufacturer Name 'IBM_ITD'
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP) 
VALUES (8, 2541, null, null, null, 'IBM_ITD', 3, 1, 'ScheduleF Auto Testing', 2, 'ScheduleF Auto Testing', 'liuhaidl@cn.ibm.com', '2016-04-11 23:00:00', 'MANUFACTURER', null, null, null, null, 'IBM');

INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP, MANUFACTURER_NAME) 
VALUES 
(3001, 2541, 119274, 'ADOBE ACROBAT ELEMENTS','ADOBE ACROBAT ELEMENTS','ADOBE', 3, 4, 'AMCB-SLM-16206-03',2,'This is for test','zhysz@cn.ibm.com','2015-4-5 23:59:59','HWOWNER','IBM',NULL,NULL,NULL,'IBM','IBM');
INSERT INTO EAADMIN.SCHEDULE_F 
(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME, LEVEL, HW_OWNER, SERIAL, MACHINE_TYPE, HOSTNAME, SW_FINANCIAL_RESP, MANUFACTURER_NAME) 
VALUES 
(3002, 2541,NULL,NULL,NULL,'CI SOLUTIONS', 3, 4, 'JMCB-SLM-10197-03',2,'This is for Manufacturer Level','zhysz@cn.ibm.com','2015-4-13 20:59:59','MANUFACTURER',NULL,NULL,NULL,NULL,'IBM','CI SOLUTIONS');

