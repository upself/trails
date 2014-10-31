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
LiveFile="NA_LA_Open_fullRecon"
Archive1Name="$(date +'%Y')-$(date +'%m' --date='1 month ago')_NA_LA_Open_fullRecon"

cd $WLOC

rm $deliveryDir/AG_Open_fullRecon.zip

db2 -tf agofr.sql | $UTIL/sql2tsv 1>> $LiveFile.txt
zip $LiveFile.zip $LiveFile.txt
scp $LiveFile.zip $deliveryDir

mv $LiveFile.txt $Archive1Name.txt
zip -m $Archive1Name.zip $Archive1Name.txt
scp $Archive1Name.zip $deliveryDir

chmod 0664 $deliveryDir/*.*

rm $Archive1Name.zip
rm $LiveFile.zip

echo "AG Open fullRecon - Global Entitlement Management - Global Endpoint Measurements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" > memo
mail -s "AG Geo Open fullRecon data archived
https://pokgsa.ibm.com/projects/a/amsd/adp/global/recon
" -c KFaler@US.IBM.com -r IBM_AMTSE -R KFaler@US.IBM.com RJBlanco@US.IBM.com < memo

#=-=-=-=-=
