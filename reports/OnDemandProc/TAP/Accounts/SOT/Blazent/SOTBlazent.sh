#! /bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# file: SOTBlazent.sh
#
# creation: Blazent project for State of Texas
# originated: 2010-01-04
# creator: KFaler
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#dbName="ATP"
#dbUser="atbravo"
#pw=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/TAP/kbin/atppw`
source /opt/staging/v2/config/connectionConfig.txt

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. /db2/tap/sqllib/db2profile;

db2 connect to $ATPdb user $ATPuser using $ATPpassword;

WDIR="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/TAP"

cd $WDIR/Accounts/SOT/Blazent

db2 -tf $WDIR/Accounts/SOT/Blazent/SOTBlazent.sql | $WDIR/kbin/sql2tsv 1> SOT_ATPBlazent.xls

#zip -m SOT_ATPBlazent.zip SOT_ATPBlazent.xls

scp *.xls /gsa/pokgsa/projects/a/amsd/adp/accounts/sot

rm *.xls

chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/sot/*.*

#chmod 0755
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
