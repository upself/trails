#!/bin/sh

WRKDIR=`dirname $0`
. /db2/tap/sqllib/db2profile

set -x
cd $WRKDIR
###Base checks
./hwDiffStagingBravo.sh
./hwLparDiffStagingBravo.sh
./swLparDiffStagingBravo.sh
#./acctInactiveHwActive.sh
#./hwInactiveHwLparActive.sh
#./hwLparInactiveComposite.sh
#./acctInactiveSwLparActive.sh
#./swLparInactiveComposite.sh
#./swLparInactiveInstSwActive.sh
#./swInactiveInstSwActive.sh
#./acctInactiveLicenseActive.sh

###Hardware alert checks
#./hwInactiveOpenAlert.sh
#./hwActiveHwStatusNotActiveOpenAlert.sh
#./hwNoLparNoAlert.sh

###Hardware lpar alert checks
#./hwLparNoSwLparNoAlert.sh
#./hwLparInactiveOpenAlert.sh
#./hwLparActiveNoSwLparHwStatusNotActiveOpenAlert.sh

###Software lpar alert checks
#./swLparNoHwLparNoAlert.sh
#./swLparNoLicensable.sh
#./swLparInactiveOpenNoHwAlert.sh
#./swLparInactiveOpenOutdatedAlert.sh

###Installed software alert checks
#./instSwReconBaseNoReconClosedAlert.sh
#./instSwReconOpenAlert.sh
#./instSwNoCompositeOpenAlert.sh
#./instSwInReconBaseNoAlert.sh
#./instSwVendorManagedOpenAlert.sh
#./instSwUnlicensableOpenAlert.sh
#./instSwComponentOpenAlert.sh
#./instSwInactiveOpenAlert.sh
#./instSwInvalidOpenAlert.sh
#./instSwFalseHitOpenAlert.sh
#./instSwHwCountOpenAlert.sh
#./instSwHwCountRecon.sh
#./accountOutOfScopeOpenAlert.sh
#./acctOutOfScopeRecon.sh
#./instSwUnlicensableRecon.sh
#./swComponentRecon.sh
#./instSwInactiveRecon.sh
#./instSwInvalidRecon.sh
#./instSwFalseHitRecon.sh
#./manualReconNoLicenseMap.sh
#./autoReconNoLicenseMap.sh
#./manualReconUsedQtyZero.sh
#./autoReconUsedQtyZero.sh
#./reconPhyCpuNotMachineLevel.sh
#./swLparZeroProcessorCount.sh
#./stagingLicenseSwNoBravoSw.sh
#./accountInactiveOpenAlert.sh
#./instSwHwInactiveOpenAlert.sh
#./licenseInactiveRecon.sh
#./hwNotRemoved.sh
#./scanRecordsNoCustomer.sh
#./swLparNoLicensable.sh
#./swLparNullScantime.sh
#./swLparNoInstSw.sh
#./swLparNoOs.sh
#./swLparZeroProcessorCount.sh
set +x

exit 0
