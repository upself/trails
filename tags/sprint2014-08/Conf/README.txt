The properties files is been referenced by, 
-fullRecon 
-emeaAsset

deployment to tap2.raleigh.ibm.com /tap3.raleigh.ibm.com
copy the whole files folder to /opt/report/bin/Conf.

execute following command after deployed into linux server. 
[root@tap2 Conf]# dos2unix tap2.report.properties
dos2unix: converting file tap2.report.properties to UNIX format ...
[root@tap2 Conf]# dos2unix tap3.report.properties
dos2unix: converting file tap3.report.properties to UNIX format ..