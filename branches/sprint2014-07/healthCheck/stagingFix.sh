#!/bin/sh
cat /opt/IBMIHS/htdocs/en_US/bravo_hchks/stagingSwLparNotInBravo.txt |awk -F '|' '{print "update software_lpar set action = '"'"'UPDATE'"'"' where id = " $3 ";"}' |uniq > temp.sql
cat /opt/IBMIHS/htdocs/en_US/bravo_hchks/bravoSwLparNotInStaging.txt |awk -F '|' '{print "insert into software_lpar(customer_id,name,status,scan_time,computer_id,action) values("$1",'"'"'"$2"'"'"','"'"'INACTIVE'"'"','"'"'"$5"'"'"','"'"'"$6"'"'"','"'"'DELETE'"'"');"}' |uniq >> temp.sql
