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

JAPAN1="JAPAN1_SOM1a_HW_WITH_HOSTNAME"
JAPAN2="JAPAN2_SOM2a_HW_LPAR_with_SW_LPAR"
JAPAN3="JAPAN3_SOM2b_SW_LPAR_with_HW_LPAR"
JAPAN4="JAPAN4_SOM2c_Unexpired_SW_LPAR"
JAPAN5="JAPAN5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
JAPAN6="JAPAN6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
JAPAN7="JAPAN7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
JAPAN8="JAPAN8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
JAPAN9="JAPAN9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

#tapreports
. /home/trails/sqllib/db2profile
#tap3
#. /home/trails/sqllib/db2profile

db2 connect to ${dbName} user ${dbUser} using ${pw}
db2 set schema eaadmin

db2 -tf JAPAN1.sql | sql2tsv 1> $JAPAN1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN1.txt
db2 -tf JAPAN2.sql | sql2tsv 1> $JAPAN2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN2.txt
db2 -tf JAPAN3.sql | sql2tsv 1> $JAPAN3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN3.txt
db2 -tf JAPAN4.sql | sql2tsv 1> $JAPAN4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN4.txt
db2 -tf JAPAN5.sql | sql2tsv 1> $JAPAN5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN5.txt
db2 -tf JAPAN6.sql | sql2tsv 1> $JAPAN6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN6.txt
db2 -tf JAPAN7.sql | sql2tsv 1> $JAPAN7.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN7.txt
db2 -tf JAPAN8.sql | sql2tsv 1> $JAPAN8.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN8.txt
db2 -tf JAPAN9.sql | sql2tsv 1> $JAPAN9.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN9.txt
zip -m $JAPAN1.zip $JAPAN1.txt
zip -m $JAPAN2.zip $JAPAN2.txt
zip -m $JAPAN3.zip $JAPAN3.txt
zip -m $JAPAN4.zip $JAPAN4.txt
zip -m $JAPAN5.zip $JAPAN5.txt
zip -m $JAPAN6.zip $JAPAN6.txt
zip -m $JAPAN7.zip $JAPAN7.txt
zip -m $JAPAN8.zip $JAPAN8.txt
zip -m $JAPAN9.zip $JAPAN9.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/test
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/test/*.zip
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
