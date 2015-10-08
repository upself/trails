SELECT CNDB.CUSTOMER.ACCOUNT_NUMBER, CNDB.CUSTOMER.CUSTOMER_NAME, CNDB.CUSTOMER.TME_OBJECT_ID, cndb.customer.status
FROM CNDB.CUSTOMER
where cndb.customer.status = 'ACTIVE'
GROUP BY CNDB.CUSTOMER.ACCOUNT_NUMBER, CNDB.CUSTOMER.CUSTOMER_NAME, CNDB.CUSTOMER.TME_OBJECT_ID, cndb.customer.status
--HAVING CNDB.customer.tme_object_id like '%HARTALT%'
--fetch first 8 row only
for fetch only
with ur
;
