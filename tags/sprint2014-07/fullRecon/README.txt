
*********************
*DPENDENCY
*********************
-Conf

*********************
*DEPLOYMENT         
*********************
1. copy the whole folder to /opt/report/bin/fullRecon

2. Ensure following items had been added into crontab.  

24 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9_fullReconDriver.pl
25 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9a_fullReconDriver.pl
26 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9b_fullReconDriver.pl
27 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9c_fullReconDriver.pl
28 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9d_fullReconDriver.pl
29 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9e_fullReconDriver.pl
30 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9f_fullReconDriver.pl
31 03 * * 1 . /home/eaadmin/sqllib/db2profile; perl /opt/reports/bin/r9g_fullReconDriver.pl


3. launch the script by separately beside crontab job issue command no matter if it's under
the script folder. 
'perl /opt/report/bin/fullRecon/fullReconDriver.pl'

NOTE: keep the full path of the script after command perl.

4. launch the script with parameters. 
There are 2 parameters for this script for optional selection 
'perl /opt/report/bin/fullRecon/fullReconDriver.pl [-r regionName] [-t accountQty]'
e.g. 
nohup perl /opt/report/bin/fullRecon/fullReconDriver.pl -r US_IMT -t 2 &


4.1 regionName 
- could be any of following string. Default regionName will be US_IMT.

ANZ_IMT 
ASEAN_IMT 
BENELUX_IMT 
CANADA_IMT 
CEE_IMT 
DACH_IMT 
FRANCE_IMT 
GREATER_CHINA 
ISA_IMT 
ITALY_IMT 
JAPAN_IMT 
KOR_IMT 
LA 
MEA 
NORDICS_IMT 
SPGI_IMT 
UKI_IMT 
UNKNOWN 
US_IMT 

4.2 accountQty 
- the amount of accounts the script run against the region.  


