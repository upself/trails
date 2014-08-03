#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=/dbbkup/$BASESTR.bravo
EXPORTSTAGING=/dbbkup/$BASESTR.staging
DIFFBRAVO=/dbbkup/stagingSwFilterNotInBravo.txt
DIFFSTAGING=/dbbkup/bravoSwFilterNotInStaging.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $TRDBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
         sl.customer_id \
         ,sl.name \
         ,if.software_filter_id \
         ,if.bank_account_id \
     from \
         software_lpar sl \
         ,installed_software is \
         ,installed_filter if \
     where \
        is.software_lpar_id = sl.id \
	and is.id = if.installed_software_id \
	with ur"
db2 disconnect $DBBRAVO
set +x

# export staging data
set -x
db2 connect to $DBSTAGING user $DBID using $STDBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTSTAGING of del \
    modified by nochardel coldel\| \
    "select \
        sl.customer_id \
        ,sl.name \
        ,sf.software_filter_id \
        ,sr.bank_account_id \
        ,sl.action \
        ,sr.action \
        ,slm.action \
        ,sf.action \
        ,sf.id \
     from \
         software_lpar sl \
         ,software_lpar_map slm \
         ,scan_record sr \
         ,software_filter sf \
     where \
         slm.software_lpar_id = sl.id \
         and slm.scan_record_id = sr.id \
         and sf.scan_record_id = sr.id \
    with ur"
db2 disconnect $DBSTAGING
set +x

awk -F"|" '
NR==FNR{a[$1$2$3$4]=$1$2$3$4;next}
a[$1$2$3$4]==$1$2$3$4{next}
a[$1$2$3$4]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Bravo software lpar / software not in staging"}
' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$1$2$3$4]=$1$2$3$4;next}
a[$1$2$3$4]==$1$2$3$4{next}
a[$1$2$3$4]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Staging software lpar / software not in BRAVO"}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
chmod 644 $DIFFSTAGING

#mv $DIFFBRAVO $LOGDIR
#mv $DIFFSTAGING $LOGDIR

exit 0
