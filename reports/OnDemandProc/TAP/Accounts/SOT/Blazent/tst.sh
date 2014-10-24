#! /bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# file: SOTBlazent.sh
#
# creation: Blazent project for State of Texas
# originated: 2010-01-04
# creator: KFaler
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="ATP";
dbUser="ATPDB2M";
pw="pass6six";
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. /db2/tap/sqllib/db2profile;

db2 connect to ${dbName} user ${dbUser} using ${pw};

cd /home/kfaler/adp/Accounts/SOT/Blazent

#db2 -tf /home/kfaler/adp/Accounts/SOT/Blazent/SOTBlazent.sql | /home/kfaler/adp/kbin/sql2tsv 1> SOT_ATPBlazent.xls;
db2 -tf /home/kfaler/adp/Accounts/SOT/Blazent/SOTBlazent.sql

#zip -m SOT_ATPBlazent.zip SOT_ATPBlazent.xls

#scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/sot

#rm *.xls

#chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/sot/*

#chmod 0755
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
