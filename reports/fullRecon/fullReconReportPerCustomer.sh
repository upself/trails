#/bin/sh 
 
prop_path=/opt/staging/v2/config/connectionConfig.txt 
 
NAME=`grep "$1.name=" $prop_path | sed "s/$1.name=//g"` 
USER=`grep "$1.user=" $prop_path | sed "s/$1.user=//g"` 
PASS=`grep "$1.password=" $prop_path | sed "s/$1.password=//g"` 
 
QUERY_OUTPUT="$3.tmp" 
CUSTOMER="$2"
db2 connect to $NAME user $USER using $PASS 
db2 "set schema eaadmin" 

sed -e "s,outputFilePar,$QUERY_OUTPUT,g" -e "s,customerIdPar,$2,g"  /opt/reports/fullRecon/fullRecon.sql  > /opt/reports/fullRecon/processing/$2.sql
 
OUTPUT=`db2 -tvsf /opt/reports/fullRecon/processing/$2.sql`

if [ "$?" = "0" ] || [ "$?" = "1" ] || [ "$?" = "2" ]; then
 cat $QUERY_OUTPUT >> $3 
 rm -f /opt/reports/fullRecon/processing/$2.sql
 exit 0
else
 echo $OUTPUT >> /opt/reports/fullRecon/logs/fullReconReportLogTest.txt
 exit 1
fi
