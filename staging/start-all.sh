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
elif [ "$SHOST" = "lexbz2250" ]
then
	. /db2/staging/sqllib/db2profile
elif [ "$SHOST" = "tap3" ]
then
    . /home/eaadmin/sqllib/db2profile
elif [ "$SHOST" = "tapmf" ]
then
	. /db2/cndb/sqllib/db2profile
elif [ "$SHOST" = "ralbz2088" ]
then
       . /home/trails/sqllib/db2profile
elif [ "$SHOST" = "ralbz001063" ]
then
       . /home/trails/sqllib/db2profile
elif [ "$SHOST" = "b03cxnp15029" ]
then
       . /home/db2inst2/sqllib/db2profile
else
    echo "ERROR: Unable to execute on this host: $SHOST"
    exit 1
fi

SLEEP=2
set -x
./hdiskToStaging.pl start
sleep $SLEEP
./ipAddressToStaging.pl start
sleep $SLEEP
./manualToSwasset.pl start
sleep $SLEEP
./memModToStaging.pl start
sleep $SLEEP
./processorToStaging.pl start
sleep $SLEEP
./scanRecordToStaging.pl start
sleep $SLEEP
./softwareFilterToStaging.pl start
sleep $SLEEP
./softwareManualToStaging.pl start
sleep $SLEEP
./softwareSignatureToStaging.pl start
sleep $SLEEP
./softwareTlcmzToStaging.pl start
sleep $SLEEP
./swassetDataManager.pl start
sleep $SLEEP
./tlcmzToSwasset.pl start
sleep $SLEEP
./capTypeToBravo.pl start
sleep $SLEEP
./cndbReplication.pl start
sleep $SLEEP
./expiredMaintManager.pl start
sleep $SLEEP
./expiredScansManager.pl start
sleep $SLEEP
./licenseToBravo.pl start
sleep $SLEEP
./licTypeToBravo.pl start
sleep $SLEEP
./scanRecordToLpar.pl start
sleep $SLEEP
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
./reconEngineInventory.pl start
sleep $SLEEP
./reconEngineLicensing.pl start
sleep $SLEEP
./softwareToBravo.pl start
sleep $SLEEP
./scanSoftwareItemToStaging.pl start
sleep $SLEEP
./reconEnginePriorityISVSoftware.pl start
sleep $SLEEP
exit 0
