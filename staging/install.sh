#!/bin/sh

DIR=/opt/staging/v2
SHOST=`uname -n |awk -F'.' '{print $1}'`

set -x
chmod -R 770 $DIR
chgrp -R trailsgp $DIR
cd $DIR
cp config/$SHOST/* config/
mkdir -p /var/staging/logs/adcToBravo
mkdir -p /var/staging/logs/adcToStaging
mkdir -p /var/staging/logs/atpToStaging
mkdir -p /var/staging/logs/capTypeToBravo
mkdir -p /var/staging/logs/cndbReplication
mkdir -p /var/staging/logs/doranaToSwasset
mkdir -p /var/staging/logs/expiredMaintManager
mkdir -p /var/staging/logs/expiredScansManager
mkdir -p /var/staging/logs/hardwareToBravo
mkdir -p /var/staging/logs/hdiskToBravo
mkdir -p /var/staging/logs/hdiskToStaging
mkdir -p /var/staging/logs/ipAddressToBravo
mkdir -p /var/staging/logs/ipAddressToStaging
mkdir -p /var/staging/logs/licenseToBravo
mkdir -p /var/staging/logs/licTypeToBravo
mkdir -p /var/staging/logs/manualToSwasset
mkdir -p /var/staging/logs/memModToBravo
mkdir -p /var/staging/logs/memModToStaging
mkdir -p /var/staging/logs/mipsToBravo
mkdir -p /var/staging/logs/processorToBravo
mkdir -p /var/staging/logs/processorToStaging
mkdir -p /var/staging/logs/procgrpsToBravo
mkdir -p /var/staging/logs/reconEngine
mkdir -p /var/staging/logs/scanRecordToLpar
mkdir -p /var/staging/logs/scanRecordToStaging
mkdir -p /var/staging/logs/softwareDoranaToStaging
mkdir -p /var/staging/logs/softwareFilterToStaging
mkdir -p /var/staging/logs/softwareManualToStaging
mkdir -p /var/staging/logs/softwareSignatureToStaging
mkdir -p /var/staging/logs/softwareTlcmzToStaging
mkdir -p /var/staging/logs/softwareToBravo
mkdir -p /var/staging/logs/swassetDataManager
mkdir -p /var/staging/logs/swcmToStaging
mkdir -p /var/staging/logs/tlcmzToSwasset
mkdir -p /var/staging/logs/manualRecovery
mkdir -p /var/staging/logs/bravoArchival
mkdir -p /var/staging/logs/falseHitExpire

chmod -R 770 $DIR
chgrp -R trailsgp $DIR
set +x

exit 0
