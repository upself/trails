#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global DISCREPANCY Template Input large scale validation
# Comments    : Run from TAP3 zLin native (Perl auth module)
# Ticket      : GAMTPR - Automated TAP3 Reporting - RCA crew
# Deployment  : 2013-09-19
# Service     : Global Asset Management Tools Team
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
TMPDIR="/tmp"
deliveryDir="/gsa/pokgsa/projects/a/amsd/adp/global/dti"
Rpt1="ACTIVE_DISCREPANCY_LPARs"
#Archive1="$(date +'%Y')-$(date +'%m')-$(date +'%d')_DISCREPANCY_LPARs"
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`

echo "Geo	Region	Country	customerName	accountNumber	scanTime	lparName	lparStatus	BAType	BAName	BADesc	BAStatus" > $TMPDIR/discre.header
echo "TRAILS Replica Output Created $(date), $rts" >> $TMPDIR/$Rpt1.tsv
echo "export to /tmp/ACTIVE_DISCREPANCY_LPARs of del modified by nochardel coldelx09
SELECT GEOGRAPHY.NAME AS Geo, REGION.NAME AS Region, COUNTRY_CODE.NAME AS Country, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, V_INSTALLED_SOFTWARE.SCANTIME, V_INSTALLED_SOFTWARE.NODENAME, CUSTOMER.STATUS AS customerStatus, V_INSTALLED_SOFTWARE.SOFTWARE_LPAR_STATUS, BANK_ACCOUNT.NAME AS BAName
FROM (V_INSTALLED_SOFTWARE INNER JOIN BANK_ACCOUNT ON V_INSTALLED_SOFTWARE.BANK_ACCOUNT_ID = BANK_ACCOUNT.ID) INNER JOIN (((GEOGRAPHY INNER JOIN REGION ON GEOGRAPHY.ID = REGION.GEOGRAPHY_ID) INNER JOIN COUNTRY_CODE ON REGION.ID = COUNTRY_CODE.REGION_ID) RIGHT JOIN CUSTOMER ON COUNTRY_CODE.ID = CUSTOMER.COUNTRY_CODE_ID) ON V_INSTALLED_SOFTWARE.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID
GROUP BY GEOGRAPHY.NAME, REGION.NAME, COUNTRY_CODE.NAME, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, V_INSTALLED_SOFTWARE.SCANTIME, V_INSTALLED_SOFTWARE.NODENAME, CUSTOMER.STATUS, V_INSTALLED_SOFTWARE.SOFTWARE_LPAR_STATUS, BANK_ACCOUNT.NAME
HAVING (((V_INSTALLED_SOFTWARE.SOFTWARE_LPAR_STATUS)='ACTIVE') AND ((BANK_ACCOUNT.NAME)='DISCREPANCY'))
for fetch only
with ur
;" > $WLOC/discre.sql
chmod 0744 $WLOC/discre.sql

. /home/db2inst2/sqllib/db2profile
$WLOC/executeSQL.pl -s $WLOC/discre.sql -d reporting

echo "TRAILS Replica Output Created $(date), $rts" >> $TMPDIR/$Rpt1.tsv

cat $TMPDIR/discre.header $TMPDIR/$Rpt1 > $TMPDIR/$Rpt1.tsv
rm $TMPDIR/discre.header
rm $WLOC/discre.sql
rm -f $TMPDIR/$Rpt1
zip -m $TMPDIR/$Rpt1.zip $TMPDIR/$Rpt1.tsv

scp $TMPDIR/$Rpt1.zip $deliveryDir/$Rpt1.zip
rm $TMPDIR/$Rpt1.zip

chmod 0664 $deliveryDir/$Rpt1.zip

echo "Global DISCREPANCY Info delivered to http://pokgsa.ibm.com/projects/a/amsd/adp/global/dti
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" | mail -s "Global BRAVO Discrepancy Template Input trunk LPAR info published" -c KFaler@US.IBM.com LisantiS@AR.IBM.com -- -f IBM_AMTSE
#=-=-=-=-=
