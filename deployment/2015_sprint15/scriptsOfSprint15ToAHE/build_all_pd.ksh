#!/bin/ksh

echo "build_all_pd.ksh started `date`"
typeset -i errorind=0
echo "checking for instance owner running build_all_pd.ksh"
db2 "get instance"|grep `whoami`
if [ "$?" -ne 0 ];then
  echo "You must be the DB2 instance owner to rn build_all_pd.ksh ERROR!"
  errorind=1
fi
INSTANCE="`whoami`"

echo "checking for all required files to run build_all_pd.ksh"

if test ! -r Trails_sw_alert_type_pd.sql;then
  echo "  Missing Trails_sw_alert_type_pd.sql file. ERROR!"
  errorind=1
fi
if test ! -r v_alert_report_pd.sql;then
  echo "  Missing v_alert_report_pd.sql file. ERROR!"
  errorind=1
fi
if test ! -r v_alerts_pd.sql;then
  echo "  Missing v_alerts_pd.sql file. ERROR!"
  errorind=1
fi
if test ! -r mqt_alert_report_TRAILSPD.sql;then
  echo "  Missing mqt_alert_report_TRAILSPD.sql file. ERROR!"
  errorind=1
fi
if test ! -r ALERT_TYPES_UPDATE_FOR_SOMx.sql;then
  echo "  Missing ALERT_TYPES_UPDATE_FOR_SOMx.sql file. ERROR!"
  errorind=1
fi
if test ! -r alert_hardware_cfgdata.sql;then
  echo "  Missing alert_hardware_cfgdata.sql file. ERROR!"
  errorind=1
fi
if test ! -r update_alert_cause.sql;then
  echo "  Missing update_alert_cause.sql file. ERROR!"
  errorind=1
fi

if [ $errorind -eq 1 ];then
  exit 1
else
  echo "  all required files to run build_all_pd.ksh exist"
fi

LOG="build_all_pd.log"
echo "">$LOG
echo "Add new build_all_pd built  `date`"|tee -a $LOG
db2 -v "connect to trailspd">>$LOG
echo "Working on step0  Trails_sw_alert_type_pd `date`"|tee -a $LOG
db2 -tvf Trails_sw_alert_type_pd.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step0 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step1 v_alert_report_pd  `date`"|tee -a $LOG
db2 -tvf v_alert_report_pd.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step1 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step2 v_alerts_pd `date`"|tee -a $LOG
db2 -tvf v_alerts_pd.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step2 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step3 mqt_alert_report_TRAILSPD `date`"|tee -a $LOG
db2 -tvf mqt_alert_report_TRAILSPD.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step3 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step4 ALERT_TYPES_UPDATE_FOR_SOMx `date`"|tee -a $LOG
db2 -tvf ALERT_TYPES_UPDATE_FOR_SOMx.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step4 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step5 alert_hardware_cfgdata `date`"|tee -a $LOG
db2 -tvf alert_hardware_cfgdata.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step5 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step6 update_alert_cause `date`"|tee -a $LOG
db2 -tvf update_alert_cause.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step5 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi

echo "End of all steps  `date`"|tee -a $LOG

db2 "connect reset">>$LOG

echo "build_all_pd.ksh complete for trailspd `date`"
db2 terminate > /dev/null
exit 0
