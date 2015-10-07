#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global Software Bundles
# Comments    : Run from TAP3 zLin native (Perl auth module)
# Ticket      : GAMTPR - Automated TAP3 Reporting SW Titles Mgmt
# Deployment  : 2013-09-23
# Service     : Global Asset Management Tools Team
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
TMPDIR="/tmp"
deliveryDir="/gsa/pokgsa/projects/a/amsd/adp/global/bundles"
Rpt1="SWBundles"
#Archive1="$(date +'%Y')-$(date +'%m')-$(date +'%d')_SWBundles"
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`

echo "BundleName	PrimarySWName	SubSWName	BundleStatus	BundleUpdate	BundleOperator" > $TMPDIR/swbundles.header

. /home/db2inst2/sqllib/db2profile
$WLOC/executeSQL.pl -s $WLOC/bundles.sql -d reporting

cat $TMPDIR/swbundles.header $TMPDIR/$Rpt1 > $TMPDIR/$Rpt1.xls
rm $TMPDIR/swbundles.header
rm -f $TMPDIR/$Rpt1

echo "TRAILS Replica Output Created $(date), $rts" >> $TMPDIR/$Rpt1.xls

scp $TMPDIR/$Rpt1.xls $deliveryDir/$Rpt1.xls
rm $TMPDIR/$Rpt1.xls

chmod 0664 $deliveryDir/$Rpt1.xls

echo "Global SWBundles Info delivered to http://pokgsa.ibm.com/projects/a/amsd/adp/global/bundles
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" | mail -s "Global SWBundles info published to GSA" -c KFaler@US.IBM.com KFaler@US.IBM.com -- -f IBM_AMTSE
#=-=-=-=-=
