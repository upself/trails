#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project     : Global Tivoli Monitoring installed software including sources and OS info w/ Jean-Charles Bastiani
# Comments    : Run from TAP3 zLin native (Perl auth module)
# Ticket      : GAMTPR - Automated TAP3 Reporting 74256
# Deployment  : 2013-10-08
# Service     : Global Asset Management Tools Team
# Revisions   : r2 included removal of bankAccount info, MaxOS, and removal of OSVer to dedupe the feed at initial export per cust pref
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
WLOC="/opt/reports/bin"
Delivery="/gsa/pokgsa/projects/a/amsd/adp/global/tivmon"
Rpt1="TivMonHosts"
Archive1="$(date +'%Y')-$(date +'%m')-$(date +'%d')_TivMonHosts"
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`

echo "Geo	Region	CNDB_Country	customerName	accountNumber	scanDate	lparName	lparProcCount	hwCountry	hwAssetType	hwModel	hwSerial	hwProcCount	swName	swLicLevel	instProcCount	customerStatus	lparStatus	instSWStatus	hwStatus	lparID	MaxOs" > /tmp/$Rpt1.header
echo "export to /tmp/TivMonHosts of del modified by nochardel coldelx09
SELECT GEOGRAPHY.NAME AS Geo, REGION.NAME AS Region, COUNTRY_CODE.NAME AS CNDB_Country, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, substr(char(eaadmin.software_lpar.SCANTIME),1,10) AS ScanDate, SOFTWARE_LPAR.NAME AS lparName, SOFTWARE_LPAR.PROCESSOR_COUNT AS LPAR_PROCESSOR_COUNT, HARDWARE.COUNTRY AS HW_COUNTRY, MACHINE_TYPE.TYPE AS HW_ASSET_TYPE, MACHINE_TYPE.DEFINITION AS HW_MODEL, HARDWARE.SERIAL AS HW_SERIAL, HARDWARE.PROCESSOR_COUNT AS HW_PROCESSOR_COUNT, SOFTWARE.SOFTWARE_NAME, SOFTWARE.LEVEL AS SW_LICENSE_LEVEL, V_INSTALLED_SOFTWARE.INST_PROCESSOR_COUNT, CUSTOMER.STATUS AS customerStatus, SOFTWARE_LPAR.STATUS AS lparStatus, V_INSTALLED_SOFTWARE.INST_STATUS AS InstSW_Status, HARDWARE.STATUS AS hwStatus, SOFTWARE_LPAR.ID AS SWLPAR_ID, OIS2.Max_OSs AS Max_OS
FROM (((((((((((GEOGRAPHY INNER JOIN REGION ON GEOGRAPHY.ID = REGION.GEOGRAPHY_ID) INNER JOIN COUNTRY_CODE ON REGION.ID = COUNTRY_CODE.REGION_ID) RIGHT JOIN CUSTOMER ON COUNTRY_CODE.ID = CUSTOMER.COUNTRY_CODE_ID) INNER JOIN SOFTWARE_LPAR ON CUSTOMER.CUSTOMER_ID = SOFTWARE_LPAR.CUSTOMER_ID) LEFT JOIN ((HW_SW_COMPOSITE LEFT JOIN HARDWARE_LPAR ON HW_SW_COMPOSITE.HARDWARE_LPAR_ID = HARDWARE_LPAR.ID) LEFT JOIN HARDWARE ON HARDWARE_LPAR.HARDWARE_ID = HARDWARE.ID) ON SOFTWARE_LPAR.ID = HW_SW_COMPOSITE.SOFTWARE_LPAR_ID) LEFT JOIN INDUSTRY ON CUSTOMER.INDUSTRY_ID = INDUSTRY.INDUSTRY_ID) INNER JOIN SECTOR ON INDUSTRY.SECTOR_ID = SECTOR.SECTOR_ID) LEFT JOIN MACHINE_TYPE ON HARDWARE.MACHINE_TYPE_ID = MACHINE_TYPE.ID) INNER JOIN V_INSTALLED_SOFTWARE ON SOFTWARE_LPAR.ID = V_INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID) INNER JOIN SOFTWARE ON V_INSTALLED_SOFTWARE.SOFTWARE_ID = SOFTWARE.SOFTWARE_ID) LEFT JOIN CUSTOMER_TYPE ON CUSTOMER.CUSTOMER_TYPE_ID = CUSTOMER_TYPE.CUSTOMER_TYPE_ID) LEFT JOIN (SELECT INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID, SOFTWARE.TYPE, INSTALLED_SOFTWARE.STATUS, Max(SOFTWARE.SOFTWARE_NAME) AS Max_OSs
FROM INSTALLED_SOFTWARE INNER JOIN SOFTWARE ON INSTALLED_SOFTWARE.SOFTWARE_ID = SOFTWARE.SOFTWARE_ID
GROUP BY INSTALLED_SOFTWARE.SOFTWARE_LPAR_ID, SOFTWARE.TYPE, INSTALLED_SOFTWARE.STATUS
HAVING (((SOFTWARE.TYPE)='O') AND ((INSTALLED_SOFTWARE.STATUS)='ACTIVE'))) as OIS2 ON SOFTWARE_LPAR.ID = OIS2.SOFTWARE_LPAR_ID
GROUP BY GEOGRAPHY.NAME, REGION.NAME, COUNTRY_CODE.NAME, CUSTOMER.CUSTOMER_NAME, CUSTOMER.ACCOUNT_NUMBER, substr(char(eaadmin.software_lpar.SCANTIME),1,10), SOFTWARE_LPAR.NAME, SOFTWARE_LPAR.PROCESSOR_COUNT, HARDWARE.COUNTRY, MACHINE_TYPE.TYPE, MACHINE_TYPE.DEFINITION, HARDWARE.SERIAL, HARDWARE.PROCESSOR_COUNT, SOFTWARE.SOFTWARE_NAME, SOFTWARE.LEVEL, V_INSTALLED_SOFTWARE.INST_PROCESSOR_COUNT, CUSTOMER.STATUS, SOFTWARE_LPAR.STATUS, V_INSTALLED_SOFTWARE.INST_STATUS, HARDWARE.STATUS, SOFTWARE_LPAR.ID, OIS2.Max_OSs
HAVING (((SOFTWARE.SOFTWARE_NAME) In 
(
'IBM TIVOLI MONITORING AGENT FOR WINDOWS OS AGENT',
'IBM Tivoli Monitoring',
'IBM Tivoli Monitoring - CEC Base Agent',
'IBM Tivoli Monitoring - Linux OS Agent',
'IBM TIVOLI MONITORING - UNIX LOGS AGENT',
'IBM Tivoli Monitoring - UNIX OS Agent',
'IBM Tivoli Monitoring - VMware VI Agent',
'IBM Tivoli Monitoring - Windows OS Agent',
'IBM Tivoli Monitoring Endpoint',
'IBM Tivoli Monitoring for Applications - mySAP Agent',
'IBM Tivoli Monitoring for Business Integration',
'IBM Tivoli Monitoring for Databases',
'IBM Tivoli Monitoring for Databases - DB2 Agent',
'IBM Tivoli Monitoring for Databases - MS SQL Agent',
'IBM Tivoli Monitoring for Messaging & Collaboration',
'IBM Tivoli Monitoring for Virtual Environments',
'IBM Tivoli Monitoring for Web Infrastructure',
'IBM TEMA AIX OS MONITORING AGENT',
'IBM TEMA RED HAT LINUX X86 OS MONITORING AGENT',
'IBM TEMA WINDOWS OS MONITORING AGENT',
'IBM Tivoli Monitoring Active Directory Option - Active Directory Agent',
'IBM Tivoli Monitoring for Databases - Oracle Agent',
'IBM TIVOLI MONITORING FOR MICROSOFT APPLICATIONS',
'IBM Tivoli Monitoring for Microsoft Applications - MS Exchange Server Agent',
'IBM Tivoli Monitoring for Virtual Environments for Citrix XenApp'
)) AND ((SOFTWARE_LPAR.STATUS)='ACTIVE') AND ((V_INSTALLED_SOFTWARE.INST_STATUS)='ACTIVE'))
for fetch only
with ur
;" > $WLOC/$Rpt1.sql

chmod 0744 $WLOC/$Rpt1.sql

. /home/db2inst2/sqllib/db2profile
$WLOC/executeSQL.pl -s $WLOC/$Rpt1.sql -d reporting

cd /tmp
cp $Rpt1 $Archive1
cat $Rpt1.header $Archive1 > $Archive1.xls
rm $Rpt1
rm $Rpt1.header
#rm -f $Archive1
rm $WLOC/$Rpt1.sql

echo "TRAILS Replica Output Created $(date), $rts" >> $Archive1.xls

zip -m $Archive1.zip $Archive1.xls

scp $Archive1.zip $Delivery/$Archive1.zip
rm $Archive1.zip

chmod 0664 $Delivery/$Archive1.zip

echo "Global Installed TivMon info delivered to https://pokgsa.ibm.com/projects/a/amsd/adp/global/tivmon
swName = 'IBM TIVOLI MONITORING AGENT FOR WINDOWS OS AGENT',
or 'IBM Tivoli Monitoring',
or 'IBM Tivoli Monitoring - CEC Base Agent',
or 'IBM Tivoli Monitoring - Linux OS Agent',
or 'IBM TIVOLI MONITORING - UNIX LOGS AGENT',
or 'IBM Tivoli Monitoring - UNIX OS Agent',
or 'IBM Tivoli Monitoring - VMware VI Agent',
or 'IBM Tivoli Monitoring - Windows OS Agent',
or 'IBM Tivoli Monitoring Endpoint',
or 'IBM Tivoli Monitoring for Applications - mySAP Agent',
or 'IBM Tivoli Monitoring for Business Integration',
or 'IBM Tivoli Monitoring for Databases',
or 'IBM Tivoli Monitoring for Databases - DB2 Agent',
or 'IBM Tivoli Monitoring for Databases - MS SQL Agent',
or 'IBM Tivoli Monitoring for Messaging & Collaboration',
or 'IBM Tivoli Monitoring for Virtual Environments',
or 'IBM Tivoli Monitoring for Web Infrastructure',
or 'IBM TEMA AIX OS MONITORING AGENT',
or 'IBM TEMA RED HAT LINUX X86 OS MONITORING AGENT',
or 'IBM TEMA WINDOWS OS MONITORING AGENT',
or 'IBM Tivoli Monitoring Active Directory Option - Active Directory Agent',
or 'IBM Tivoli Monitoring for Databases - Oracle Agent',
or 'IBM TIVOLI MONITORING FOR MICROSOFT APPLICATIONS',
or 'IBM Tivoli Monitoring for Microsoft Applications - MS Exchange Server Agent',
or 'IBM Tivoli Monitoring for Virtual Environments for Citrix XenApp'

Actively installed sw on Active lpars, including single OS info from sub (os info is not directly from sometimes unparsable swLpar entry)
In this version 2 the OSVer, and inputSource info has been removed in order better uniquely represent the installed software baseline
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IBM Technical Solutions Engineering, Asset Management
" > $Rpt1.memo
ls -lth /gsa/pokgsa/projects/a/amsd/adp/global/tivmon >> $Rpt1.memo
mail -s "Global TivMon capture" -c AMTS@CZ.IBM.com JCBastiani@FR.IBM.com -- -f IBM_AMTSE < $Rpt1.memo

rm $Rpt1.memo
#=-=-=-=-=
