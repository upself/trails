#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global SUDO installed software reporting w/ Kim Shaffer
# Comments    : Run from TAP3 zLin native (Perl auth module)
# Ticket      : GAMTPR - Automated TAP3 Reporting - RCA crew
# Deployment  : 2013-10-07
# Service     : Global Asset Management Tools Team
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
TMPDIR="/tmp"
deliveryDir="/gsa/pokgsa/projects/a/amsd/adp/global/sudo"
Rpt1="InstSUDO"
Archive1="$(date +'%Y')-$(date +'%m')-$(date +'%d')_InstSUDO"
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`

echo "Geo	Region	Country	accountNumber	customerName	scanDate	hostName	swName	customerStatus	hostStatus	instSWStatus	swLicenseLevel" > $TMPDIR/inst_sudo.header
echo "export to /tmp/InstSUDO of del modified by nochardel coldelx09
SELECT GEOGRAPHY.NAME AS Geo, REGION.NAME AS Region, COUNTRY_CODE.NAME AS Country, CUSTOMER.ACCOUNT_NUMBER, CUSTOMER.CUSTOMER_NAME, substr(char(scantime),1,10) AS ScanDate, SOFTWARE_LPAR.NAME AS HostName, SOFTWARE.SOFTWARE_NAME, CUSTOMER.STATUS AS customerStatus, SOFTWARE_LPAR.STATUS AS LPAR_STATUS, INSTALLED_SOFTWARE.STATUS AS InstSWStatus, SOFTWARE.LEVEL AS SW_LICENSE_LEVEL
FROM ((((GEOGRAPHY INNER JOIN REGION ON GEOGRAPHY.ID = REGION.GEOGRAPHY_ID) INNER JOIN COUNTRY_CODE ON REGION.ID = COUNTRY_CODE.REGION_ID) INNER JOIN CUSTOMER ON COUNTRY_CODE.ID = CUSTOMER.COUNTRY_CODE_ID) INNER JOIN SOFTWARE_LPAR ON CUSTOMER.CUSTOMER_ID = SOFTWARE_LPAR.CUSTOMER_ID) INNER JOIN (INSTALLED_SOFTWARE INNER JOIN SOFTWARE ON INSTALLED_SOFTWARE.SOFTWARE_ID = SOFTWARE.SOFTWARE_ID) ON SOFTWARE_LPAR.ID = INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID
WHERE (((upper(software.SOFTWARE_NAME)) Like '%SUDO%'))
GROUP BY GEOGRAPHY.NAME, REGION.NAME, COUNTRY_CODE.NAME, CUSTOMER.ACCOUNT_NUMBER, CUSTOMER.CUSTOMER_NAME, substr(char(scantime),1,10), SOFTWARE_LPAR.NAME, SOFTWARE.SOFTWARE_NAME, CUSTOMER.STATUS, SOFTWARE_LPAR.STATUS, INSTALLED_SOFTWARE.STATUS, SOFTWARE.LEVEL
HAVING (((CUSTOMER.STATUS)='ACTIVE') AND ((SOFTWARE_LPAR.STATUS)='ACTIVE') AND ((INSTALLED_SOFTWARE.STATUS)='ACTIVE'))
for fetch only
with ur
;" > $WLOC/inst_sudo.sql

chmod 0744 $WLOC/inst_sudo.sql

. /home/db2inst2/sqllib/db2profile
$WLOC/executeSQL.pl -s $WLOC/inst_sudo.sql -d reporting

mv $TMPDIR/$Rpt1 $TMPDIR/$Archive1
cat $TMPDIR/inst_sudo.header $TMPDIR/$Archive1 > $TMPDIR/$Archive1.txt
rm $TMPDIR/inst_sudo.header
rm $WLOC/inst_sudo.sql
rm -f $TMPDIR/$Archive1

echo "TRAILS Replica Output Created $(date), $rts" >> $TMPDIR/$Archive1.txt

cd $TMPDIR
zip -m $Archive1.zip $Archive1.txt

scp $TMPDIR/$Archive1.zip $deliveryDir/$Archive1.zip
rm $TMPDIR/$Archive1.zip

chmod 0664 $deliveryDir/$Archive1.zip

echo "Global Installed SUDO - Active Known accounts only (no UNKNOWN account info) now in text format, with adjusted column header - info delivered to https://pokgsa.ibm.com/projects/a/amsd/adp/global/sudo
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" | mail -s "Global Installed SUDO info published" -c KFaler@US.IBM.com ShafferK@US.IBM.com -- -f IBM_AMTSE
#=-=-=-=-=
