--software related data
INSERT INTO eaadmin.software VALUES(126, 1000, 999265, 'IBM AIX', NULL, 26335, 'LICENSABLE', 'A', 'SWKBT', 'SW_PRODUCT', 'SWKBT', TIMESTAMP '2008-11-27 23:59:59', 'ACTIVE', 0, 'SOFTWARE_PRODUCT', NULL);
INSERT INTO eaadmin.software VALUES(126, 1000, 218119, 'MICROSOFT SQL SERVER 2000 CAL', NULL, 26335, 'LICENSABLE', 'A', 'SWKBT', 'SW_PRODUCT', 'SWKBT', TIMESTAMP '2008-11-27 23:59:59', 'INACTIVE', 0, 'SOFTWARE_PRODUCT', NULL);

INSERT INTO eaadmin.software_item VALUES(999265, 'IBM AIX', null, null, null, null, null, null);
INSERT INTO eaadmin.product VALUES(999265, 126, null, null, null);
INSERT INTO eaadmin.product_info VALUES(421056, 1000, 1, 1, 'New Add', null, 'SWKBT', TIMESTAMP '2008-11-26 23:59:59');
INSERT INTO eaadmin.manufacturer VALUES(126, null, 'ADOBE', null);
INSERT INTO eaadmin.kb_definition VALUES(1, null, TIMESTAMP '2008-10-28 23:59:59', null, null, null, null, null, null, null, null, null, null);
INSERT INTO eaadmin.product_alias VALUES(999265, 1);
INSERT INTO eaadmin.alias VALUES(1, 'Beyond Trust', 0);

--account
INSERT INTO eaadmin.customer
		(CUSTOMER_ID, CUSTOMER_TYPE_ID, POD_ID, INDUSTRY_ID, ACCOUNT_NUMBER, CREATION_DATE_TIME, UPDATE_DATE_TIME) 
	VALUES
		(2541, 9, 3753, 501, 35400, TIMESTAMP '2008-1-28 23:59:59', TIMESTAMP '2008-2-28 23:59:59');
	
--schedule_f
INSERT INTO eaadmin.schedule_f 
		(ID, CUSTOMER_ID, SOFTWARE_ID, SOFTWARE_TITLE, SOFTWARE_NAME, MANUFACTURER, SCOPE_ID, SOURCE_ID, SOURCE_LOCATION, STATUS_ID, BUSINESS_JUSTIFICATION, REMOTE_USER, RECORD_TIME) 
	VALUES
		(1, 2541, 999265, 'IBM AIX', 'IBM AIX', 'IBM', 1, 1, 'ChengDu', 2, 'TEST Purpose', 'gfengg@cn.ibm.com',  TIMESTAMP '2015-1-28 23:59:59'),
		(2, 2541, 218119, 'MICROSOFT SQL SERVER 2000 CAL', 'MICROSOFT SQL SERVER 2000 CAL', 'MICROSOFT', 3, 3, 'ChengDu', 2, 'TEST Purpose', 'gfengg@cn.ibm.com',  TIMESTAMP '2015-1-28 23:59:59');

--schedule_f related
INSERT INTO eaadmin.scope VALUES (1, 'Customer owned, Customer managed', 'CUSTOCUSTM');
INSERT INTO eaadmin.source VALUES (1, 'C&N contract reading');
INSERT INTO eaadmin.status VALUES (1, 'INACTIVE'), (2, 'ACTIVE');