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

SLEEP=2
set -x
./hardwareToBravo.pl start
sleep $SLEEP
./hdiskToBravo.pl start
sleep $SLEEP
./ipAddressToBravo.pl start
sleep $SLEEP
./memModToBravo.pl start
sleep $SLEEP
./processorToBravo.pl start
sleep $SLEEP
./reconEngine.pl start
sleep $SLEEP
./softwareToBravo.pl start
sleep $SLEEP
exit 0
