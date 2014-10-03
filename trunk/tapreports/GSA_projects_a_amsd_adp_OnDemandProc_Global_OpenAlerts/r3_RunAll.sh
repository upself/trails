#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project    : Global Alerts by Geography
# Ticket     : GAMTPR U/I Ellen Shi, Alex Moise, Adam Dilling
# Deployment : 2010-10-28, TAPReports weekly sched set 2010-12-20
# Revisions  : R3 2014-02-04, new Region breakdown
# Service    : KFaler@US.IBM.com
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="TRAHERP"
dbUser="gamdsa"
pw=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/ktra`
rts=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/PerfMonLogs/TRPSynchDate`
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#1 HW w/o HW LPAR alert
#2 HW LPAR w/o SW LPAR alert
#3 SW LPAR w/o HW LPAR alert
#4 Outdated SW LPAR alert
#5 Unlicensed IBM SW alert
#6 Unlicensed ISV SW alert

AP1="AP1_HW_No_LPAR_alert"
AP2="AP2_HW_LPAR_No_SW_LPAR_alert"
AP3="AP3_SW_LPAR_No_HW_LPAR_alert"
AP4="AP4_Outdated_SW_LPAR_alert"
AP5="AP5_Unlicensed_IBM_SW_alert"
AP6="AP6_Unlicensed_ISV_SW_alert"

EUROPE1="EUROPE1_HW_No_LPAR_alert"
EUROPE2="EUROPE2_HW_LPAR_No_SW_LPAR_alert"
EUROPE3="EUROPE3_SW_LPAR_No_HW_LPAR_alert"
EUROPE4="EUROPE4_Outdated_SW_LPAR_alert"
EUROPE5="EUROPE5_Unlicensed_IBM_SW_alert"
EUROPE6="EUROPE6_Unlicensed_ISV_SW_alert"

GCG1="GCG1_HW_No_LPAR_alert"
GCG2="GCG2_HW_LPAR_No_SW_LPAR_alert"
GCG3="GCG3_SW_LPAR_No_HW_LPAR_alert"
GCG4="GCG4_Outdated_SW_LPAR_alert"
GCG5="GCG5_Unlicensed_IBM_SW_alert"
GCG6="GCG6_Unlicensed_ISV_SW_alert"

NA1="NA1_HW_No_LPAR_alert"
NA2="NA2_HW_LPAR_No_SW_LPAR_alert"
NA3="NA3_SW_LPAR_No_HW_LPAR_alert"
NA4="NA4_Outdated_SW_LPAR_alert"
NA5="NA5_Unlicensed_IBM_SW_alert"
NA6="NA6_Unlicensed_ISV_SW_alert"

LA1="LA1_HW_No_LPAR_alert"
LA2="LA2_HW_LPAR_No_SW_LPAR_alert"
LA3="LA3_SW_LPAR_No_HW_LPAR_alert"
LA4="LA4_Outdated_SW_LPAR_alert"
LA5="LA5_Unlicensed_IBM_SW_alert"
LA6="LA6_Unlicensed_ISV_SW_alert"

MEA1="MEA1_HW_No_LPAR_alert"
MEA2="MEA2_HW_LPAR_No_SW_LPAR_alert"
MEA3="MEA3_SW_LPAR_No_HW_LPAR_alert"
MEA4="MEA4_Outdated_SW_LPAR_alert"
MEA5="MEA5_Unlicensed_IBM_SW_alert"
MEA6="MEA6_Unlicensed_ISV_SW_alert"

UNKNOWN1="UNKNOWN1_HW_No_LPAR_alert"
UNKNOWN2="UNKNOWN2_HW_LPAR_No_SW_LPAR_alert"
UNKNOWN3="UNKNOWN3_SW_LPAR_No_HW_LPAR_alert"
UNKNOWN4="UNKNOWN4_Outdated_SW_LPAR_alert"
UNKNOWN5="UNKNOWN5_Unlicensed_IBM_SW_alert"
UNKNOWN6="UNKNOWN6_Unlicensed_ISV_SW_alert"

JAPAN1="JAPAN1_HW_No_LPAR_alert"
JAPAN2="JAPAN2_HW_LPAR_No_SW_LPAR_alert"
JAPAN3="JAPAN3_SW_LPAR_No_HW_LPAR_alert"
JAPAN4="JAPAN4_Outdated_SW_LPAR_alert"
JAPAN5="JAPAN5_Unlicensed_IBM_SW_alert"
JAPAN6="JAPAN6_Unlicensed_ISV_SW_alert"

#tapreports
. /home/db2inst1/sqllib/db2profile
#tap3
#. /home/eaadmin/sqllib/db2profile

db2 connect to ${dbName} user ${dbUser} using ${pw}
db2 set schema eaadmin
cd /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/Global/OpenAlerts

db2 -tf AP1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP1.txt
db2 -tf AP2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP2.txt
db2 -tf AP3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP3.txt
db2 -tf AP4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP4.txt
db2 -tf AP5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP5.txt
db2 -tf AP6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $AP6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $AP6.txt
zip -m $AP1.zip $AP1.txt
zip -m $AP2.zip $AP2.txt
zip -m $AP3.zip $AP3.txt
zip -m $AP4.zip $AP4.txt
zip -m $AP5.zip $AP5.txt
zip -m $AP6.zip $AP6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf EUROPE1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE1.txt
db2 -tf EUROPE2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE2.txt
db2 -tf EUROPE3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE3.txt
db2 -tf EUROPE4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE4.txt
db2 -tf EUROPE5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE5.txt
db2 -tf EUROPE6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $EUROPE6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $EUROPE6.txt
zip -m $EUROPE1.zip $EUROPE1.txt
zip -m $EUROPE2.zip $EUROPE2.txt
zip -m $EUROPE3.zip $EUROPE3.txt
zip -m $EUROPE4.zip $EUROPE4.txt
zip -m $EUROPE5.zip $EUROPE5.txt
zip -m $EUROPE6.zip $EUROPE6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf GCG1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG1.txt
db2 -tf GCG2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG2.txt
db2 -tf GCG3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG3.txt
db2 -tf GCG4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG4.txt
db2 -tf GCG5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG5.txt
db2 -tf GCG6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $GCG6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $GCG6.txt
zip -m $GCG1.zip $GCG1.txt
zip -m $GCG2.zip $GCG2.txt
zip -m $GCG3.zip $GCG3.txt
zip -m $GCG4.zip $GCG4.txt
zip -m $GCG5.zip $GCG5.txt
zip -m $GCG6.zip $GCG6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf NA1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA1.txt
db2 -tf NA2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA2.txt
db2 -tf NA3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA3.txt
db2 -tf NA4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA4.txt
db2 -tf NA5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA5.txt
db2 -tf NA6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $NA6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $NA6.txt
zip -m $NA1.zip $NA1.txt
zip -m $NA2.zip $NA2.txt
zip -m $NA3.zip $NA3.txt
zip -m $NA4.zip $NA4.txt
zip -m $NA5.zip $NA5.txt
zip -m $NA6.zip $NA6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf LA1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA1.txt
db2 -tf LA2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA2.txt
db2 -tf LA3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA3.txt
db2 -tf LA4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA4.txt
db2 -tf LA5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA5.txt
db2 -tf LA6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $LA6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $LA6.txt
zip -m $LA1.zip $LA1.txt
zip -m $LA2.zip $LA2.txt
zip -m $LA3.zip $LA3.txt
zip -m $LA4.zip $LA4.txt
zip -m $LA5.zip $LA5.txt
zip -m $LA6.zip $LA6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf MEA1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA1.txt
db2 -tf MEA2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA2.txt
db2 -tf MEA3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA3.txt
db2 -tf MEA4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA4.txt
db2 -tf MEA5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA5.txt
db2 -tf MEA6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $MEA6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $MEA6.txt
zip -m $MEA1.zip $MEA1.txt
zip -m $MEA2.zip $MEA2.txt
zip -m $MEA3.zip $MEA3.txt
zip -m $MEA4.zip $MEA4.txt
zip -m $MEA5.zip $MEA5.txt
zip -m $MEA6.zip $MEA6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf UNKNOWN1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN1.txt
db2 -tf UNKNOWN2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN2.txt
db2 -tf UNKNOWN3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN3.txt
db2 -tf UNKNOWN4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN4.txt
db2 -tf UNKNOWN5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN5.txt
db2 -tf UNKNOWN6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $UNKNOWN6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $UNKNOWN6.txt
zip -m $UNKNOWN1.zip $UNKNOWN1.txt
zip -m $UNKNOWN2.zip $UNKNOWN2.txt
zip -m $UNKNOWN3.zip $UNKNOWN3.txt
zip -m $UNKNOWN4.zip $UNKNOWN4.txt
zip -m $UNKNOWN5.zip $UNKNOWN5.txt
zip -m $UNKNOWN6.zip $UNKNOWN6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*

db2 -tf JAPAN1.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN1.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN1.txt
db2 -tf JAPAN2.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN2.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN2.txt
db2 -tf JAPAN3.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN3.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN3.txt
db2 -tf JAPAN4.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN4.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN4.txt
db2 -tf JAPAN5.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN5.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN5.txt
db2 -tf JAPAN6.sql | /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/sql2tsv 1> $JAPAN6.txt;
echo "IBM Confidential: Report Created $(date), $rts" >> $JAPAN6.txt
zip -m $JAPAN1.zip $JAPAN1.txt
zip -m $JAPAN2.zip $JAPAN2.txt
zip -m $JAPAN3.zip $JAPAN3.txt
zip -m $JAPAN4.zip $JAPAN4.txt
zip -m $JAPAN5.zip $JAPAN5.txt
zip -m $JAPAN6.zip $JAPAN6.txt
scp *.zip /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts
rm *.zip
chmod 0664 /gsa/pokgsa/projects/a/amsd/adp/accounts/e/alerts/*.*
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
