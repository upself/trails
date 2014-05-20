#!/bin/ksh


# source db2 env
. /home/eaadmin/sqllib/db2profile


echo "`date` start" >>/opt/bravo/scripts/report/logs/dbsSglifeCycle.log 2>&1
/opt/perl-5.10.1/bin/perl /opt/bravo/scripts/report/bravoReport.pl -c 6266 > /dev/null 2>&1
echo "`date` complete" >>/opt/bravo/scripts/report/logs/dbsSglifeCycle.log 2>&1

exit

