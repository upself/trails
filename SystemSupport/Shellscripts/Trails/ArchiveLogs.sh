#!/bin/sh
LOGS_FOLDER=/var/trails/logs
TEMP_FOLDER=/var/trails/tmp
ARCHIVE_FILE_NAME=TrailsLogs`date '+%Y%m%d%H%M'`.tar.gz
PROPERTY_FILE=/opt/trails/conf/trails.properties
GSA_USER=`cat $PROPERTY_FILE|grep gsa.user.name|cut -d'=' -f2`
GSA_PWD=`cat $PROPERTY_FILE|grep gsa.password|cut -d'=' -f2`
MY_LOG=$LOGS_FOLDER/TrailsArchiveLogs.log
LOG_CONTENT="starting TrailsArchiveLogs script\n"
RETURN_CODE=0;


cd $TEMP_FOLDER
tar -zcvf $ARCHIVE_FILE_NAME $LOGSFOLDER/* >/dev/null 2>tar.error

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

lcd $TEMP_FOLDER
put $ARCHIVE_FILE_NAME

close
bye
!


if [ test -s ftp.error ] then 
	LOG_CONTENT.="Error during 'ftping' logs transaction\n" 
	RETURN_CODE=1
else
	LOG_CONTENT.="Succesfully 'ftped' the logs\n" 
fi

cd $LOGS_FOLDER
rm -f *
rm -f $TEMP_FOLDER/$ARCHIVE_FILE_NAME

LOG_CONTENT="Removed logs file\n"
LOG_CONTENT="Ending TrailsArchiveLogs script\n"
return RETURN_CODE