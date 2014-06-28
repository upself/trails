#!/bin/sh
BRAVOLOGS=/var/bravo/logs
TEMPFOLDER=/var/bravo/tmp
BRAVOBKUPFILE=BravoLogs`date '+%Y%m%d%H%M'`.tar.gz
MY_LOG=$LOGS_FOLDER/BravoArchiveLogs.log
LOG_CONTENT="starting BravoArchiveLogs script\n"
RETURN_CODE=0;

cd $TEMPFOLDER
tar -zcvf $BRAVOBKUPFILE $BRAVOLOGS/* 2>tar.error

if [ -s tar.error ] then 
	LOG_CONTENT.="Error during 'taring' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT.="Succesfully 'tared' the logs\n" 
fi

ftp -n<<! 2>ftp.error
close
open bejgsa.ibm.com
user trails B0sBru1n
binary
prompt

cd /gsa/bejgsa/projects/s/swtools/bravo/

lcd $TEMPFOLDER
put $BRAVOBKUPFILE 

close
bye
!

if [ -s ftp.error ] then 
	LOG_CONTENT.="Error during 'ftping' logs transaction\n" 
	RETURN_CODE=1
else 
	LOG_CONTENT.="Succesfully 'ftped' the logs\n" 
fi

cd $BRAVOLOGS
rm -f *
rm -f $TEMPFOLDER/$BRAVOBKUPFILE

LOG_CONTENT="Removed logs file\n"
LOG_CONTENT="Ending BravoArchiveLogs script\n"
return RETURN_CODE