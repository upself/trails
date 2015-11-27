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
./atpToStaging.pl stop
sleep $SLEEP
./hdiskToStaging.pl stop
sleep $SLEEP
./ipAddressToStaging.pl stop
sleep $SLEEP
./manualToSwasset.pl stop
sleep $SLEEP
./memModToStaging.pl stop
sleep $SLEEP
./processorToStaging.pl stop
sleep $SLEEP
./scanRecordToStaging.pl stop
sleep $SLEEP
./softwareFilterToStaging.pl stop
sleep $SLEEP
./softwareManualToStaging.pl stop
sleep $SLEEP
./softwareSignatureToStaging.pl stop
sleep $SLEEP
./softwareTlcmzToStaging.pl stop
sleep $SLEEP
./swassetDataManager.pl stop
sleep $SLEEP
./swcmToStaging.pl stop
sleep $SLEEP
./tlcmzToSwasset.pl stop
sleep $SLEEP
./adcToBravo.pl stop
sleep $SLEEP
./capTypeToBravo.pl stop
sleep $SLEEP
./cndbReplication.pl stop
sleep $SLEEP
./expiredMaintManager.pl stop
sleep $SLEEP
./expiredScansManager.pl stop
sleep $SLEEP
./hardwareToBravo.pl stop
sleep $SLEEP
./hdiskToBravo.pl stop
sleep $SLEEP
./ipAddressToBravo.pl stop
sleep $SLEEP
./licenseToBravo.pl stop
sleep $SLEEP
./licTypeToBravo.pl stop
sleep $SLEEP
./memModToBravo.pl stop
sleep $SLEEP
./mipsToBravo.pl stop
sleep $SLEEP
./processorToBravo.pl stop
sleep $SLEEP
./procgrpsToBravo.pl stop
sleep $SLEEP
./reconEngineInventory.pl stop
sleep $SLEEP
./reconEngineLicensing.pl stop
sleep $SLEEP
./scanRecordToLpar.pl stop
sleep $SLEEP
./softwareToBravo.pl stop
sleep $SLEEP
./scanSoftwareItemToStaging.pl stop
sleep $SLEEP
./reconEnginePriorityISVSoftware.pl stop
sleep $SLEEP
exit 0
