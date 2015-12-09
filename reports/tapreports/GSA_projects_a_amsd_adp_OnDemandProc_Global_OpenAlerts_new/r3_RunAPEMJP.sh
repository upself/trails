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

AP1="AP1_SOM1a_HW_WITH_HOSTNAME"
AP2="AP2_SOM2a_HW_LPAR_with_SW_LPAR"
AP3="AP3_SOM2b_SW_LPAR_with_HW_LPAR"
AP4="AP4_SOM2c_Unexpired_SW_LPAR"
AP5="AP5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
AP6="AP6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
AP7="AP7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
AP8="AP8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
AP9="AP9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

EUROPE1="EUROPE1_SOM1a_HW_WITH_HOSTNAME"
EUROPE2="EUROPE2_SOM2a_HW_LPAR_with_SW_LPAR"
EUROPE3="EUROPE3_SOM2b_SW_LPAR_with_HW_LPAR"
EUROPE4="EUROPE4_SOM2c_Unexpired_SW_LPAR"
EUROPE5="EUROPE5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
EUROPE6="EUROPE6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
EUROPE7="EUROPE7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
EUROPE8="EUROPE8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
EUROPE9="EUROPE9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

GCG1="GCG1_SOM1a_HW_WITH_HOSTNAME"
GCG2="GCG2_SOM2a_HW_LPAR_with_SW_LPAR"
GCG3="GCG3_SOM2b_SW_LPAR_with_HW_LPAR"
GCG4="GCG4_SOM2c_Unexpired_SW_LPAR"
GCG5="GCG5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
GCG6="GCG6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
GCG7="GCG7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
GCG8="GCG8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
GCG9="GCG9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

NA1="NA1_SOM1a_HW_WITH_HOSTNAME"
NA2="NA2_SOM2a_HW_LPAR_with_SW_LPAR"
NA3="NA3_SOM2b_SW_LPAR_with_HW_LPAR"
NA4="NA4_SOM2c_Unexpired_SW_LPAR"
NA5="NA5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
NA6="NA6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
NA7="NA7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
NA8="NA8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
NA9="NA9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

LA1="LA1_SOM1a_HW_WITH_HOSTNAME"
LA2="LA2_SOM2a_HW_LPAR_with_SW_LPAR"
LA3="LA3_SOM2b_SW_LPAR_with_HW_LPAR"
LA4="LA4_SOM2c_Unexpired_SW_LPAR"
LA5="LA5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
LA6="LA6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
LA7="LA7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
LA8="LA8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
LA9="LA9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

MEA1="MEA1_SOM1a_HW_WITH_HOSTNAME"
MEA2="MEA2_SOM2a_HW_LPAR_with_SW_LPAR"
MEA3="MEA3_SOM2b_SW_LPAR_with_HW_LPAR"
MEA4="MEA4_SOM2c_Unexpired_SW_LPAR"
MEA5="MEA5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
MEA6="MEA6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
MEA7="MEA7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
MEA8="MEA8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
MEA9="MEA9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

UNKNOWN1="UNKNOWN1_SOM1a_HW_WITH_HOSTNAME"
UNKNOWN2="UNKNOWN2_SOM2a_HW_LPAR_with_SW_LPAR"
UNKNOWN3="UNKNOWN3_SOM2b_SW_LPAR_with_HW_LPAR"
UNKNOWN4="UNKNOWN4_SOM2c_Unexpired_SW_LPAR"
UNKNOWN5="UNKNOWN5_SOM1b_HW_BOX_CRITICAL_CONFIGURATION_DATA_POPULATED"
UNKNOWN6="UNKNOWN6_SOM3_SW_INSTANCES_WITH_DEFINED_CONTRACT_SCOPE"
UNKNOWN7="UNKNOWN7_SOM4a_IBM_SW_INSTANCES_REVIEWED"
UNKNOWN8="UNKNOWN8_SOM4b_PRIORITY_ISV_SW_INSTANCES_REVIEWED"
UNKNOWN9="UNKNOWN9_SOM4c_ISV_SW_INSTANCES_REVIEWED"

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

db2 -tf AP1.sql | sql2tsv 1> $AP1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP1.txt
db2 -tf AP2.sql | sql2tsv 1> $AP2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP2.txt
db2 -tf AP3.sql | sql2tsv 1> $AP3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP3.txt
db2 -tf AP4.sql | sql2tsv 1> $AP4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP4.txt
db2 -tf AP5.sql | sql2tsv 1> $AP5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP5.txt
db2 -tf AP6.sql | sql2tsv 1> $AP6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP6.txt
db2 -tf AP7.sql | sql2tsv 1> $AP7.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP7.txt
db2 -tf AP8.sql | sql2tsv 1> $AP8.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP8.txt
db2 -tf AP9.sql | sql2tsv 1> $AP9.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP9.txt
zip -m $AP1.zip $AP1.txt
zip -m $AP2.zip $AP2.txt
zip -m $AP3.zip $AP3.txt
zip -m $AP4.zip $AP4.txt
zip -m $AP5.zip $AP5.txt
zip -m $AP6.zip $AP6.txt
zip -m $AP7.zip $AP7.txt
zip -m $AP8.zip $AP8.txt
zip -m $AP9.zip $AP9.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/test
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/test/*.zip

db2 -tf EUROPE1.sql | sql2tsv 1> $EUROPE1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE1.txt
db2 -tf EUROPE2.sql | sql2tsv 1> $EUROPE2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE2.txt
db2 -tf EUROPE3.sql | sql2tsv 1> $EUROPE3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE3.txt
db2 -tf EUROPE4.sql | sql2tsv 1> $EUROPE4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE4.txt
db2 -tf EUROPE5.sql | sql2tsv 1> $EUROPE5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE5.txt
db2 -tf EUROPE6.sql | sql2tsv 1> $EUROPE6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE6.txt
db2 -tf EUROPE7.sql | sql2tsv 1> $EUROPE7.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE7.txt
db2 -tf EUROPE8.sql | sql2tsv 1> $EUROPE8.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE8.txt
db2 -tf EUROPE9.sql | sql2tsv 1> $EUROPE9.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE9.txt
zip -m $EUROPE1.zip $EUROPE1.txt
zip -m $EUROPE2.zip $EUROPE2.txt
zip -m $EUROPE3.zip $EUROPE3.txt
zip -m $EUROPE4.zip $EUROPE4.txt
zip -m $EUROPE5.zip $EUROPE5.txt
zip -m $EUROPE6.zip $EUROPE6.txt
zip -m $EUROPE7.zip $EUROPE7.txt
zip -m $EUROPE8.zip $EUROPE8.txt
zip -m $EUROPE9.zip $EUROPE9.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/test
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/test/*.zip

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
