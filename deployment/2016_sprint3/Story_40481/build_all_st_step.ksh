#!/bin/ksh

echo "build_all_st_step.ksh started `date`"
typeset -i errorind=0
echo "checking for instance owner running build_all_st_step.ksh"
db2 "get instance"|grep `whoami`
if [ "$?" -ne 0 ];then
  echo "You must be the DB2 instance owner to rn build_all_st_step.ksh ERROR!"
  errorind=1
fi
INSTANCE="`whoami`"

echo "checking for all required files to run build_all_st_step.ksh"

if test ! -r SysPlex_st.sql;then
  echo "  Missing SysPlex_st.sql file. ERROR!"
  errorind=1
fi
if test ! -r add_md5_col_st.sql;then
  echo "  Missing add_md5_col_st.sql file. ERROR!"
  errorind=1
fi


LOG="build_all_st_step.log"
echo "">$LOG
echo "Add new build_all_st_step building  `date`"|tee -a $LOG
db2 -v "connect to trailsst">>$LOG

echo "Working on step1  SysPlex_st `date`"|tee -a $LOG
db2 -tvf SysPlex_st.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step1 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi
echo "Working on step2  add_md5_col_st `date`"|tee -a $LOG
db2 -tvf add_md5_col_st.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Step2 has. ERROR!"|tee -a $LOG
  echo " --- Check output in $LOG"|tee -a $LOG
fi



echo "End of steps  `date`"|tee -a $LOG

db2 "connect reset">>$LOG

echo "build_all_st_step.ksh complete for trailsst `date`"
db2 terminate > /dev/null
exit 0
