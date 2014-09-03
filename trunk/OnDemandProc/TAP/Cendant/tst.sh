#! /bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# file: CendantBlazent.sh
#
# creation: 
# originated: 2008-10-10
# creator: KFaler GAMTPR 62423   Original Template by Milburn Young
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="ATP";
dbUser="KFaler";
pw="8uhbvgy7";
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. /db2/tap/sqllib/db2profile;
db2 connect to ${dbName} user ${dbUser} using ${pw};
#db2 -tf /home/kfaler/adp/Cendant/CendantBlazent.sql | /home/kfaler/adp/kbin/sql2tsv 1> /var/http_reports/Cendant_ATPBlazent.xls;
db2 -tf /home/kfaler/adp/Cendant/CendantBlazent.sql
#chmod 0664 /var/http_reports/Cendant_ATPBlazent.xls
#chmod 0755 /var/http_reports/Cendant_ATPBlazent.xls
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
