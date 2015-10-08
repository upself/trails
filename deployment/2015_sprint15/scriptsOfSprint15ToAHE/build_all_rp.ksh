#!/bin/ksh

echo "build_all_rp.ksh started `date`"
typeset -i errorind=0
echo "checking for instance owner running build_all_rp.ksh"
db2 "get instance"|grep `whoami`
if [ "$?" -ne 0 ];then
  echo "You must be the DB2 instance owner to rn build_all_rp.ksh ERROR!"
  errorind=1
fi
INSTANCE="`whoami`"

echo "checking for all required files to run build_all_rp.ksh"

if test ! -r Trails_sw_alert_type_rp.sql;then
  echo "  Missing Trails_sw_alert_type_rp.sql file. ERROR!"
  errorind=1
fi
if test ! -r v_alert_report_rp.sql;then
  echo "  Missing v_alert_report_rp.sql file. ERROR!"
  errorind=1
fi
if test ! -r v_alerts_rp.sql;then
  echo "  Missing v_alerts_rp.sql file. ERROR!"
  errorind=1
fi
if test ! -r mqt_alert_report_TRAILSRP.sql;then
  echo "  Missing mqt_alert_report_TRAILSRP.sql file. ERROR!"
  errorind=1
fi

if [ $errorind -eq 1 ];then
  exit 1
else
  echo "  all required files to run build_all_rp.ksh exist"
fi

LOG="build_all_rp.log"
echo "">$LOG
echo "Add new build_all_rp built  `date`"|tee -a $LOG
db2 -v "connect to trailsrp">>$LOG
echo "Working on step0 Trails_sw_alert_type_rp  `date`"|tee -a $LOG
db2 -tvf Trails_sw_alert_type_rp.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step0 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step1 v_alert_report_rp `date`"|tee -a $LOG
db2 -tvf v_alert_report_rp.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step1 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step2 v_alerts_rp  `date`"|tee -a $LOG
db2 -tvf v_alerts_rp.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step2 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step3 mqt_alert_report_TRAILSRP `date`"|tee -a $LOG
db2 -tvf mqt_alert_report_TRAILSRP.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step3 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi

echo "End of steps `date`"|tee -a $LOG

db2 "connect reset">>$LOG

echo "build_all_rp.ksh complete for trailsrp `date`"
db2 terminate > /dev/null
exit 0
