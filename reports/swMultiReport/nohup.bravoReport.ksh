#!/bin/ksh

# num children
MAX=50

echo "`date` Running reports for those not in staging" >> /opt/reports/swMulti/logs/lifeCycle.log 2>&1
cd /opt/reports/swMulti
./bravoReportFork.pl -c $MAX  >> /dev/null 2>&1
echo "`date` Completed running reports for those not in staging" >> /opt/reports/swMulti/logs/lifeCycle.log 2>&1

echo "`date` Complete" >> /opt/reports/swMulti/logs/lifeCycle.log 2>&1

exit
