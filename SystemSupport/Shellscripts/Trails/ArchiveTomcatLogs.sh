#!/bin/sh
TOMCATLOGS=/var/trails/tomcat/logs
TEMPFOLDER=/var/trails/tmp
TOMCATBKUPFILE=TRAILSTomcatLogs`date '+%Y%m%d%H%M'`.tar.gz
PROPERTY_FILE=/opt/trails/conf/trails.properties
GSA_USER=`cat $PROPERTY_FILE|grep gsa.user.name|cut -d'=' -f2`
GSA_PWD=`cat $PROPERTY_FILE|grep gsa.password|cut -d'=' -f2`
MY_LOG=$LOGS_FOLDER/TrailsArchiveTomcatLogs.log
LOG_CONTENT="starting TrailsArchiveTomcatLogs script\n"
RETURN_CODE=0;


cd $TEMPFOLDER
tar -zcvf $TOMCATBKUPFILE $TOMCATLOGS/* 2> tar.error

if [ -s tar.error ] then 
	LOG_CONTENT.="Error during 'taring' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT.="Succesfully 'tared' the logs\n" 
fi

ftp -n<<! 2> ftp.error
close
open bejgsa.ibm.com
user $GSA_USER $GSA_PWD
binary
prompt

cd /gsa/bejgsa/projects/s/swtools/trails/

lcd $TEMPFOLDER
put $TOMCATBKUPFILE 

close
bye
!


if [ -s ftp.error ] then 
	LOG_CONTENT.="Error during 'ftping' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT.="Succesfully 'ftped' the logs\n" 
fi

cd $TOMCATLOGS
rm -f *
rm -f $TEMPFOLDER/$TOMCATBKUPFILE

LOG_CONTENT="Removed logs file\n"
LOG_CONTENT="Ending TrailsArchiveTomcatLogs script\n"
return RETURN_CODE