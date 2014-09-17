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
reprop=$(uname -n |awk -F'.' '{print $1}').report.properties
source /opt/report/bin/Conf/$reprop
source /opt/staging/v2/config/connectionConfig.txt
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. $db2profile;

db2 connect to $ATPdb user $ATPuser using $ATPpassword;

WDIR="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/TAP"

cd $WDIR/Accounts/SQD

db2 -tf SqDBlazent.sql | $WDIR/kbin/sql2tsv 1> CON_ASSET_ATP_SCHNEIDER.txt

#db2 -tf /home/kfaler/adp/Accounts/SQD/SqDBlazent.sql

#zip -m SOT_ATPBlazent.zip SOT_ATPBlazent.xls

scp *.txt /gsa/pokgsa/projects/a/amsd/adp/accounts/schneider

rm *.txt

chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/schneider/*

#chmod 0755
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
