#!/bin/sh

DIR=/opt/staging/v2
set -x
cd $DIR
set +x
  
SHOST=`uname -n |awk -F'.' '{print $1}'`
if [ "$SHOST" = "tap" ]
then
	. /db2/tap/sqllib/db2profile
elif [ "$SHOST" = "tap2" ]
then
	. /home/eaadmin/sqllib/db2profile
elif [ "$SHOST" = "tap3" ]
then
    . /home/eaadmin/sqllib/db2profile
elif [ "$SHOST" = "tapmf" ]
then
	. /db2/cndb/sqllib/db2profile
else
    echo "ERROR: Unable to execute on this host: $SHOST"
    exit 1
fi

set -x
SLEEP=2
./systemSupportEngine.pl start
sleep $SLEEP
exit 0