#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global CNDB ObjectID Account > ScanData routing info
# Comments    : Run from TAP3 zLin native
# Ticket      : GAMTPR - Automated TAP3 Reporting - Integration crew
# Deployment  : 2013-10-02
# Service     : Global Asset Management Tools Team
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
TMPDIR="/tmp"
dbName="CNDBR"
dbOper="kfaler"
pw=`tail /home/kfaler/tappw`
pubA="/gsa/pokgsa/projects/a/amsd/adp/global/bai"
Rpt1="ActiveCustObjID_routeInfo"

. /home/db2inst2/sqllib/db2profile
db2 connect to ${dbName} user ${dbOper} using ${pw}
db2 set current schema eaadmin
db2 -tf $WLOC/objids.sql | $WLOC/t3sql2tsv 1>> $TMPDIR/$Rpt1.xls

echo "ObjID Account > scanData routing info captured $(date)" >> $TMPDIR/$Rpt1.xls

zip -m $TMPDIR/$Rpt1.zip $TMPDIR/$Rpt1.xls

scp $TMPDIR/$Rpt1.zip $pubA
chmod 0664 $pubA/$Rpt1.zip
rm $TMPDIR/$Rpt1.zip

echo "Global ObjID routing info updated on http://pokgsa.ibm.com/projects/a/amsd/adp/global/bai
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" | mail -s "Global ObjectID routing info published" -c KFaler@US.IBM.com LisantiS@AR.IBM.com -- -f IBM_AMTSE
#=-=-=-=-=
