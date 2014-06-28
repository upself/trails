#!/bin/sh
TOMCATLOGS=/var/bravo/tomcat/logs
TEMPFOLDER=/var/bravo/tmp
TOMCATBKUPFILE=BravoTomcatLogs`date '+%Y%m%d%H%M'`.tar.gz
MY_LOG=$LOGS_FOLDER/BravoArchivetomcatLogs.log
LOG_CONTENT="starting BravoArchivetomcatLogs script\n"
RETURN_CODE=0;

cd $TEMPFOLDER
tar -zcvf $TOMCATBKUPFILE $TOMCATLOGS/* 

if [ -s tar.error ] then 
	LOG_CONTENT.="Error during 'taring' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT.="Succesfully 'tared' the logs\n" 
fi

ftp -n<<!
close
open bejgsa.ibm.com
user trails B0sBru1n
binary
prompt

cd /gsa/bejgsa/projects/s/swtools/bravo/

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
LOG_CONTENT="Ending BravoArchivetomcatLogs script\n"
return RETURN_CODE