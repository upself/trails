#!/bin/bash

#Test Scenario: Test of ReconEngine performance, test is deleting whole recon que and than enter to it only five customers and is periodicly checking processing of costomers records through recon_queue
#Prerequisities: nobody of during testing can work with reconEngine
#Test output: file with db checks for each customer each 5 minutes (CUSTOMER_ID,THE_DATE_O_OLDEST_RECORD_IN_RECON_QUEUE,COUNT_OF_ALL_RECORD_OF_CUSTOMER_IN_RECON_QUEUE)
echo db2 connect to TRAILSPD user eaadmin using may2012a >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 connect to TRAILSPD user eaadmin using may2012a >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from recon_customer" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from recon_customer" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_HARDWARE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_HARDWARE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_HS_COMPOSITE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_HS_COMPOSITE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_HW_LPAR" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_HW_LPAR" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_INSTALLED_SW" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_INSTALLED_SW" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_LICENSE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_LICENSE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_PVU" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_PVU" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_SOFTWARE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_SOFTWARE" >> /opt/staging/v2/t/tests/Reconstatistic.log;
echo db2 "delete from RECON_SW_LPAR" >> /opt/staging/v2/t/tests/Reconstatistic.log;
db2 "delete from RECON_SW_LPAR" >> /opt/staging/v2/t/tests/Reconstatistic.log;
counter=0;
while [  $counter -lt 1000 ]
do
  date >> /opt/staging/v2/t/tests/Reconstatistic.log;
  echo db2 "select vrq.customer_id as CUSTOMER_ID, date(vrq.RECORD_TIME) as THE_DATE_O_OLDEST_RECORD_IN_RECON_QUEUE,count(vrq.id) as COUNT_OF_ALL_RECORD_OF_CUSTOMER_IN_RECON_QUEUE from eaadmin.v_recon_queue vrq join (SELECT CUSTOMER_ID as cust_id, min(date(RECORD_TIME)) as stamp FROM EAADMIN.V_RECON_QUEUE group by CUSTOMER_ID) a on (date(vrq.RECORD_TIME) = a.stamp and vrq.customer_id = a.cust_id) where vrq.customer_id in (7345,2676,14891,5062,5252) group by vrq.customer_id, date(vrq.RECORD_TIME) with ur" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "select vrq.customer_id as CUSTOMER_ID, date(vrq.RECORD_TIME) as THE_DATE_O_OLDEST_RECORD_IN_RECON_QUEUE,count(vrq.id) as COUNT_OF_ALL_RECORD_OF_CUSTOMER_IN_RECON_QUEUE from eaadmin.v_recon_queue vrq join (SELECT CUSTOMER_ID as cust_id, min(date(RECORD_TIME)) as stamp FROM EAADMIN.V_RECON_QUEUE group by CUSTOMER_ID) a on (date(vrq.RECORD_TIME) = a.stamp and vrq.customer_id = a.cust_id) where vrq.customer_id in (7345,2676,14891,5062,5252) group by vrq.customer_id, date(vrq.RECORD_TIME) with ur" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  if [ $counter -eq 0 ]
  then
  echo db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (7345 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (7345 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )"
  echo db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (2676 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (2676 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )"
  echo db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (14891 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (14891 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )"
  echo db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (5062 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (5062 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )"
  echo db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (5252 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )" >> /opt/staging/v2/t/tests/Reconstatistic.log;
  db2 "insert into recon_customer (customer_id, action, remote_user, record_time) values (5252 , 'UPDATE', 'petra', '2014-06-14 07:30:00' )"
  fi;
sleep 60;
let counter+=1
date
echo $counter
done

