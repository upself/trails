#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global Mainframe reporting with Bob McCormack and John Gardner
# Comments    : Run from TAP3 zLin native (Perl auth module)
# Ticket      : GAMTPR - Automated TAP3 Reporting
# Deployment  : 2014-03-31
# Service     : Global Asset Management Tools Team c/o Kris Faler
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
Delivery="/gsa/pokgsa/projects/a/amsd/adp/global/mainframe"
Rpt1="BT_MF"
Archive1="$(date +'%Y')-$(date +'%m')-$(date +'%d')_BT_MF"
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`

echo "Geo	Region	Country	CustomerType	CustomerName	AccountNumber	Sector	Industry	ScanDate	HostName	lparStatus	BAName	BADesc	BAType	BAStatus	HWMachTyp	MaxOS" > /tmp/$Rpt1.header
echo "export to /tmp/BT_MF of del modified by nochardel coldelx09

SELECT GEOGRAPHY.NAME AS Geo, REGION.NAME AS Region, COUNTRY_CODE.NAME AS Country, CUSTOMER_TYPE.CUSTOMER_TYPE_NAME AS CustomerType, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, SECTOR.SECTOR_NAME, INDUSTRY.INDUSTRY_NAME, substr(char(scantime),1,10) AS ScanDate, SOFTWARE_LPAR.NAME AS HostName, SOFTWARE_LPAR.STATUS AS LPAR_STATUS, BANK_ACCOUNT.NAME AS BAName, BANK_ACCOUNT.DESCRIPTION AS BADesc, BANK_ACCOUNT.TYPE AS BAType, BANK_ACCOUNT.STATUS AS BAStatus, MACHINE_TYPE.TYPE AS HWMachTyp, OIS2.Max_OSs AS MaxOS
FROM ((((((V_LPAR_BANK_ACCOUNT INNER JOIN ((((((GEOGRAPHY INNER JOIN REGION ON GEOGRAPHY.ID = REGION.GEOGRAPHY_ID) INNER JOIN COUNTRY_CODE ON REGION.ID = COUNTRY_CODE.REGION_ID) RIGHT JOIN CUSTOMER ON COUNTRY_CODE.ID = CUSTOMER.COUNTRY_CODE_ID) INNER JOIN SOFTWARE_LPAR ON CUSTOMER.CUSTOMER_ID = SOFTWARE_LPAR.CUSTOMER_ID) LEFT JOIN INDUSTRY ON CUSTOMER.INDUSTRY_ID = INDUSTRY.INDUSTRY_ID) INNER JOIN SECTOR ON INDUSTRY.SECTOR_ID = SECTOR.SECTOR_ID) ON V_LPAR_BANK_ACCOUNT.SOFTWARE_LPAR_ID = SOFTWARE_LPAR.ID) INNER JOIN BANK_ACCOUNT ON V_LPAR_BANK_ACCOUNT.BANK_ACCOUNT_ID = BANK_ACCOUNT.ID) LEFT JOIN HW_SW_COMPOSITE ON SOFTWARE_LPAR.ID = HW_SW_COMPOSITE.SOFTWARE_LPAR_ID) LEFT JOIN HARDWARE_LPAR ON HW_SW_COMPOSITE.HARDWARE_LPAR_ID = HARDWARE_LPAR.ID) LEFT JOIN (HARDWARE LEFT JOIN MACHINE_TYPE ON HARDWARE.MACHINE_TYPE_ID = MACHINE_TYPE.ID) ON HARDWARE_LPAR.HARDWARE_ID = HARDWARE.ID) INNER JOIN CUSTOMER_TYPE ON CUSTOMER.CUSTOMER_TYPE_ID = CUSTOMER_TYPE.CUSTOMER_TYPE_ID) LEFT JOIN (SELECT INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID, SOFTWARE.TYPE, INSTALLED_SOFTWARE.STATUS, Max(SOFTWARE.SOFTWARE_NAME) AS Max_OSs
FROM INSTALLED_SOFTWARE INNER JOIN SOFTWARE ON INSTALLED_SOFTWARE.SOFTWARE_ID = SOFTWARE.SOFTWARE_ID
GROUP BY INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID, SOFTWARE.TYPE, INSTALLED_SOFTWARE.STATUS
HAVING (((SOFTWARE.TYPE)='O') AND ((INSTALLED_SOFTWARE.STATUS)='ACTIVE'))) as OIS2 ON SOFTWARE_LPAR.ID = OIS2.SOFTWARE_LPAR_ID
GROUP BY GEOGRAPHY.NAME, REGION.NAME, COUNTRY_CODE.NAME, CUSTOMER_TYPE.CUSTOMER_TYPE_NAME, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, SECTOR.SECTOR_NAME, INDUSTRY.INDUSTRY_NAME, substr(char(scantime),1,10), SOFTWARE_LPAR.NAME, SOFTWARE_LPAR.STATUS, BANK_ACCOUNT.NAME, BANK_ACCOUNT.DESCRIPTION, BANK_ACCOUNT.TYPE, BANK_ACCOUNT.STATUS, MACHINE_TYPE.TYPE, OIS2.Max_OSs
HAVING (((MACHINE_TYPE.TYPE)='MAINFRAME')) OR (((BANK_ACCOUNT.TYPE)='TADZ') AND ((MACHINE_TYPE.TYPE)='MAINFRAME' Or (MACHINE_TYPE.TYPE) Is Null))

--fetch first 678 row only
for fetch only
with ur
;" > $WLOC/$Rpt1.sql

chmod 0744 $WLOC/$Rpt1.sql

. /home/db2inst2/sqllib/db2profile
$WLOC/executeSQL.pl -s $WLOC/$Rpt1.sql -d reporting

cd /tmp
mv $Rpt1 $Archive1
cat $Rpt1.header $Archive1 > $Archive1.txt
rm $Rpt1.header
rm -f $Archive1
rm $WLOC/$Rpt1.sql

echo "TRAILS Replica Output Created $(date), $rts" >> $Archive1.txt

zip -m $Archive1.zip $Archive1.txt

scp $Archive1.zip $Delivery/$Archive1.zip
rm $Archive1.zip

chmod 0664 $Delivery/$Archive1.zip

echo "Global Mainframe info delivered to https://pokgsa.ibm.com/projects/a/amsd/adp/global/mainframe
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" > $Rpt1.memo
ls -lth /gsa/pokgsa/projects/a/amsd/adp/global/mainframe >> $Rpt1.memo
#mail -s "Global MF capture" -c KFaler@US.IBM.com KFaler@US.IBM.com -- -f IBM_AMTSE < $Rpt1.memo
mail -s "Global MF capture" -c Petr_Soufek@CZ.IBM.com,StammelW@US.IBM.com,KFaler@US.IBM.com BobMcC@Au1.IBM.com,NhuTran@Au1.IBM.com,sdBradC@US.IBM.com,GardnerJ@US.IBM.com -- -f IBM_AMTSE < $Rpt1.memo

rm $Rpt1.memo
#=-=-=-=-=
