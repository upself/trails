Generate report with installed production, lpar, account and bank account information.  

*********************
*DPENDENCY
*********************
-Conf



*********************
*DEPLOYMENT         
*********************

1. copy the whole folder to target server, current it supports
-tap2.raleigh.ibm.com (testing)
-tap3.raleigh.ibm.com (production)

2. ensure an crontab had been added. 
08 02 * * 1 sh /opt/reports/bin/emeaAsset/emeaAssetDriver.sh

3. The target place of generated report is indicated in *.report.properties file
under Conf, under property item emeaAsset, 
* vary according to the server the script located on. 

4. if want to launch the script by separately beside crontab trigger, 
switch to the script folder and issue command 'perl emeaAssetDriver.pl'.




