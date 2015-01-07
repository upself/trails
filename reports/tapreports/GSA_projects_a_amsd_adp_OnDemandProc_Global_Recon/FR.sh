#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project    : Global fullRecon
# Ticket     : GAMTPR Kris Faler
# Deployment : 2012-05-02
# Author     : KFaler@US.IBM.com
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="TRAHERP"
dbUser="gamdsa"
pw=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/ktra`
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#
. /home/db2inst1/sqllib/db2profile

db2 connect to ${dbName} user ${dbUser} using ${pw}

db2 set current schema eaadmin

WLOC="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/Global/Recon"
UTIL="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util"
deliveryDir="/gsa/pokgsa/projects/a/amsd/adp/global/recon"
Archive1Name="$(date +'%Y')-$(date +'%m' --date='1 month ago')_US_IMT_Blue_fullRecon"

cd $WLOC

db2 -tf 3fr.sql | $UTIL/sql2tsv 1>> $Archive1Name.txt

zip -m $Archive1Name.zip $Archive1Name.txt

scp $Archive1Name.zip $deliveryDir

chmod 0664 $deliveryDir/*.*

rm $Archive1Name.zip

echo "United States (US IMT) Last Month Blue fullRecon - Global Entitlement Management - Global Endpoint Measurements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" > memo
mail -s "US IMT Blue fullRecon data archived
https://pokgsa.ibm.com/projects/a/amsd/adp/global/recon
" -c KFaler@US.IBM.com -r IBM_AMTSE -R KFaler@US.IBM.com CCoplen@US.IBM.com,JMegali@US.IBM.com < memo

#=-=-=-=-=
