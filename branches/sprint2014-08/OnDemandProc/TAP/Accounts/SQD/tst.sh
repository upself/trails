#! /bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# file: SOTBlazent.sh
#
# creation: Blazent project for State of Texas
# originated: 2010-01-04
# creator: KFaler
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="ATP";
dbUser="KFaler";
pw="0okmnji9";
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
. /db2/tap/sqllib/db2profile;

db2 connect to ${dbName} user ${dbUser} using ${pw};

cd /home/kfaler/adp/Accounts/SQD

#db2 -tf /home/kfaler/adp/Accounts/SQD/SqDBlazent.sql | /home/kfaler/adp/kbin/sql2tsv 1> Schneider_ATPBlazent.xls

db2 -tf SqDBlazent.sql

#zip -m SOT_ATPBlazent.zip SOT_ATPBlazent.xls

#scp *.xls /gsa/pokgsa/projects/a/amsd/adp/accounts/schneider

#rm *.xls

#chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/sot/*

#chmod 0755
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
