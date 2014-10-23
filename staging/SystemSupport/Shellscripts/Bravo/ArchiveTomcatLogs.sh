#!/bin/sh
TOMCATLOGS=/var/bravo/tomcat/logs
TEMPFOLDER=/var/bravo/tmp
TOMCATBKUPFILE=BravoTomcatLogs`date '+%Y%m%d%H%M'`.tar.gz
PROPERTY_FILE=/opt/bravo/conf/bravo.properties
GSA_USER=`cat $PROPERTY_FILE|grep gsa.user.name|cut -d'=' -f2`
GSA_PWD=`cat $PROPERTY_FILE|grep gsa.password|cut -d'=' -f2`
MY_LOG=$TOMCATLOGS/BravoArchivetomcatLogs.log
LOG_CONTENT="===============`date '+%Y%m%d%H%M'`====================\n"
LOG_CONTENT+="starting BravoArchiveTomcatLogs script\n"
RETURN_CODE=0;

cd $TEMPFOLDER
rm tar.error
rm ftp.error
tar -Pzcvf $TOMCATBKUPFILE $TOMCATLOGS/* 2> tar.error

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
prompt

cd /gsa/bejgsa/projects/s/swtools/bravo/

lcd $TEMPFOLDER
put $TOMCATBKUPFILE 

close
bye
!

if [ -s ftp.error ]; then 
	LOG_CONTENT+="Error during 'ftping' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT+="Succesfully 'ftped' the logs\n" 
fi

cd $TOMCATLOGS
rm -f *
rm -f $TEMPFOLDER/$TOMCATBKUPFILE

LOG_CONTENT+="Removed logs file\n"
LOG_CONTENT+="Ending BravoArchivetomcatLogs script\n"
LOG_CONTENT+="=================================================\n"
echo -e $LOG_CONTENT >> $MY_LOG
exit $RETURN_CODE