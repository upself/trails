#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project    : Global Alerts by Geography
# Ticket     : GAMTPR U/I Ellen Shi, Alex Moise, Adam Dilling
# Deployment : 2010-10-28, TAPReports weekly sched set 2010-12-20
# Revisions  : R3 2014-02-04, new Region breakdown
# Service    : KFaler@US.IBM.com
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="TRAILSRP"
dbUser="eaadmin"
pw="may2012a"
rts=`date`
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#1 HW w/o HW LPAR alert
#2 HW LPAR w/o SW LPAR alert
#3 SW LPAR w/o HW LPAR alert
#4 Outdated SW LPAR alert
#5 Unlicensed IBM SW alert
#6 Unlicensed ISV SW alert

MEA1="MEA1_SOM1a_HW_WITH_HOSTNAME"
MEA2="MEA2_SOM2a_HW_LPAR_with_SW_LPAR"
MEA3="MEA3_SOM2b_SW_LPAR_with_HW_LPAR"
MEA4="MEA4_SOM2c_Unexpired_SW_LPAR"
MEA5="MEA5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
MEA6="MEA6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
MEA7="MEA7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
MEA8="MEA8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
MEA9="MEA9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

#tapreports
. /home/trails/sqllib/db2profile
#tap3
#. /home/trails/sqllib/db2profile

db2 connect to ${dbName} user ${dbUser} using ${pw}
db2 set schema eaadmin

db2 -tf MEA1.sql | sql2tsv 1> $MEA1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA1.txt
db2 -tf MEA2.sql | sql2tsv 1> $MEA2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA2.txt
db2 -tf MEA3.sql | sql2tsv 1> $MEA3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA3.txt
db2 -tf MEA4.sql | sql2tsv 1> $MEA4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA4.txt
db2 -tf MEA5.sql | sql2tsv 1> $MEA5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA5.txt
db2 -tf MEA6.sql | sql2tsv 1> $MEA6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA6.txt
db2 -tf MEA7.sql | sql2tsv 1> $MEA7.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA7.txt
db2 -tf MEA8.sql | sql2tsv 1> $MEA8.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA8.txt
db2 -tf MEA9.sql | sql2tsv 1> $MEA9.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA9.txt
zip -m $MEA1.zip $MEA1.txt
zip -m $MEA2.zip $MEA2.txt
zip -m $MEA3.zip $MEA3.txt
zip -m $MEA4.zip $MEA4.txt
zip -m $MEA5.zip $MEA5.txt
zip -m $MEA6.zip $MEA6.txt
zip -m $MEA7.zip $MEA7.txt
zip -m $MEA8.zip $MEA8.txt
zip -m $MEA9.zip $MEA9.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/test
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/test/*.zip

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
