#!/bin/sh
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
# Project    : OSP_ESD
# Ticket     : GAMTPR 64115 Pankaj Walia U/I
# Deployment : 2012-02-01
# Author     : KFaler@US.IBM.com
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
dbName="TRAHERP"
dbUser="gamdsa"
pw=`tail /gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util/ktra`

#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=#
#
. /home/db2inst1/sqllib/db2profile

db2 connect to ${dbName} user ${dbUser} using ${pw}

WLOC="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/Accounts/OSP_ESD"
DeliveryDir="/gsa/pokgsa/projects/a/amsd/adp/accounts/osp_esd"
UTIL="/gsa/pokgsa/projects/a/amsd/adp/OnDemandProc/util"
ReportName="$(date +'%Y')-$(date +'%m')-$(date +'%d')_osp_esd_details"

cd $WLOC

db2 set current schema eaadmin

db2 -tf oe.sql | $UTIL/sql2tsv 1>> $ReportName.txt
#db2 -tf oe.sql

zip -m $ReportName.zip $ReportName.txt

scp $ReportName.zip $DeliveryDir

chmod 0664 $DeliveryDir/*.*

rm *.zip

echo "OSP_ESD details ready for analysis at the delivery extension below
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Current criteria for extract is:
inst_sw.STATUS = 'ACTIVE'
and mf.status = 'ACTIVE'
and sw_lpar.STATUS = 'ACTIVE'
and sig.STATUS = 'ACTIVE'
and cust.STATUS = 'ACTIVE'
and (upper(sig.file_name) like 'ESD.%-CSP%' or upper(sig.file_name) like '%_IPLNO.SIG' or upper(sig.file_name) like '%_IPLNO.EXE')
and bank_account.status != 'INACTIVE' and bank_account.type != 'TLM') 

IBM Technical Solutions Engineering, Asset Management
" > memo
mail -s "OSP_ESD data archived
https://pokgsa.ibm.com/projects/a/amsd/adp/accounts/osp_esd
" -c KFaler@US.IBM.com -r IBM_AMTSE -R KFaler@US.IBM.com pwalia@us.ibm.com,shafferk@us.ibm.com,smguy@us.ibm.com,lklaus@us.ibm.com,tjforshe@us.ibm.com < memo

#=-=-=-=-=
