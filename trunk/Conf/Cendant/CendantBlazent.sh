#! /bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# file: CendantBlazent.sh
#
# creation: 
# originated: 2008-10-10
# creator: KFaler GAMTPR 62423   Original Template by Milburn Young
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="ATP"
dbUser="ATBRAVO"
pw=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/TAP/kbin/atppw`
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. /db2/tap/sqllib/db2profile;
db2 connect to ${dbName} user ${dbUser} using ${pw};
WDIR="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/TAP"
db2 -tf $WDIR/Cendant/CendantBlazent.sql | $WDIR/kbin/sql2tsv 1> /var/http_reports/Cendant_ATPBlazent.xls;
chmod 0664 /var/http_reports/Cendant_ATPBlazent.xls
#chmod 0755 /var/http_reports/Cendant_ATPBlazent.xls
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
