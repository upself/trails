#!/bin/sh
LOGS_FOLDER=/var/bravo/logs
TEMP_FOLDER=/var/bravo/tmp
ARCHIVE_FILE_NAME=BravoLogs`date '+%Y%m%d%H%M'`.tar.gz
PROPERTY_FILE=/opt/bravo/conf/bravo.properties
GSA_USER=`cat $PROPERTY_FILE|grep gsa.user.name|cut -d'=' -f2`
GSA_PWD=`cat $PROPERTY_FILE|grep gsa.password|cut -d'=' -f2`
MY_LOG=$LOGS_FOLDER/BravoArchiveLogs.log
LOG_CONTENT="===============`date '+%Y%m%d%H%M'`====================\n"
LOG_CONTENT+="starting BravoArchiveLogs script"
RETURN_CODE=0;

cd $TEMP_FOLDER
rm ftp.error
rm tar.error
tar -Pzcvf $ARCHIVE_FILE_NAME $LOGS_FOLDER/* >/dev/null 2>tar.error

if [ -s tar.error ]; then 
	LOG_CONTENT+="Error during 'taring' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT+="Succesfully 'tared' the logs\n" 
fi

ftp -n<<! 2> ftp.error
close
open bejgsa.ibm.com
user $GSA_USER $GSA_PWD
binary
.prompt

cd /gsa/bejgsa/projects/s/swtools/bravo/

lcd $TEMP_FOLDER
put $ARCHIVE_FILE_NAME

close
bye
!

if [ -s ftp.error ]; then 
	LOG_CONTENT+="Error during 'ftping' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT+="Succesfully 'ftped' the logs\n" 
fi

cd $LOGS_FOLDER
rm -f *
rm -f $TEMP_FOLDER/$ARCHIVE_FILE_NAME
rm -f $TEMP_FOLDER/heapdump* 
rm -f $TEMP_FOLDER/core* 
rm -f $TEMP_FOLDER/javacore* 
rm -f $TEMP_FOLDER/Snap*
rm -f /tmp/heapdump* 
rm -f /tmp/core* 
rm -f /tmp/javacore* 
rm -f /tmp/Snap*

LOG_CONTENT+="Removed logs file\n"
LOG_CONTENT+="Ending TrailsArchiveLogs script\n"
LOG_CONTENT+="=================================================\n"
echo -e $LOG_CONTENT >> $MY_LOG
exit $RETURN_CODE