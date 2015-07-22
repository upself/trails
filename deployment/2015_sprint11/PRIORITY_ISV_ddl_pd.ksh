#!/bin/ksh

echo "PRIORITY_ISV_ddl_pd.ksh started `date`"
typeset -i errorind=0
echo "checking for instance owner running PRIORITY_ISV_ddl_pd.ksh"
db2 "get instance"|grep `whoami`
if [ "$?" -ne 0 ];then
  echo "You must be the DB2 instance owner to rn PRIORITY_ISV_ddl_pd.ksh ERROR!"
  errorind=1
fi
INSTANCE="`whoami`"

echo "checking for all required files to run PRIORITY_ISV_ddl_pd.ksh"

if test ! -r PRIORITY_ISV_ddl_pd.sql;then
  echo "  Missing PRIORITY_ISV_ddl_pd.sql file. ERROR!"
  errorind=1
fi

if [ $errorind -eq 1 ];then
  exit 1
else
  echo "  all required files to run PRIORITY_ISV_ddl_pd.ksh exist"
fi

LOG="PRIORITY_ISV_ddl_pd.log"
echo "">$LOG
echo "Add new PRIORITY_ISV_ddl_pd rebuilt  `date`"|tee -a $LOG
db2 -v "connect to trailspd">>$LOG
db2 -tvf PRIORITY_ISV_ddl_pd.sql>>$LOG
if [ "$?" -gt 3 ];then
  echo "  Add new PRIORITY_ISV_ddl_pd built  failed. ERROR!"|tee -a $LOG
  echo "  Check output in $LOG"|tee -a $LOG
  exit 1
else
  echo "Add new PRIORITY_ISV_ddl_pd built  `date`"|tee -a $LOG
fi
db2 "connect reset">>$LOG

echo "PRIORITY_ISV_ddl_pd.ksh complete for trailspd `date`"
db2 terminate > /dev/null
exit 0
