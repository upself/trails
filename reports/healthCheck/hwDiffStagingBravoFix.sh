#!/bin/sh
cat /opt/IBMIHS/htdocs/en_US/bravo_hchks/bravoHwNotInStaging.txt |awk -F '|' '{print "insert into recon_hardware(customer_id,hardware_id, action, remote_user,record_time) values(" $8 "," $10 ",'"'"'UPDATE'"'"','"'"'STAGING'"'"',current timestamp);"}' |uniq > bravoHwNotInStaging.sql
cat /opt/IBMIHS/htdocs/en_US/bravo_hchks/bravoHwNotInStaging.txt |awk -F '|' '{print "update hardware set hardware_status = '"'"'REMOVED'"'"' where id = " $10 ";"}' |uniq >> bravoHwNotInStaging.sql
cat /opt/IBMIHS/htdocs/en_US/bravo_hchks/stagingHwNotInBravo.txt |awk -F '|' '{print "update hardware set action = '"'"'UPDATE'"'"' where id = " $11 ";"}' |uniq > stagingHwNotInBravo.sql
