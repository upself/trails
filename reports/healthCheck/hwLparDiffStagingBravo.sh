#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
EXPORTSTAGING=$TMPDIR/$BASESTR.staging
DIFFBRAVO=$TMPDIR/stagingHwLparNotInBravo.txt
DIFFSTAGING=$TMPDIR/bravoHwLparNotInStaging.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $TRDBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        hl.customer_id \
        ,hl.name \
        ,hlc.account_number \
        ,hl.status \
        ,h.machine_type_id \
        ,h.serial \
        ,h.country \
        ,h.customer_number \
        ,h.hardware_status \
        ,h.status \
        ,h.customer_id \
        ,hc.account_number \
        from \
            customer hlc \
            ,hardware_lpar hl \
            ,customer hc \
            ,hardware h \
        where \
            hlc.customer_id = hl.customer_id \
            and hl.status = 'ACTIVE' \
            and hc.customer_id = h.customer_id \
            and h.id = hl.hardware_id \
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
        hl.customer_id \
        ,hl.name \
        ,hl.status \
        ,hl.action \
        ,h.machine_type_id \
        ,h.serial \
        ,h.country \
        ,h.customer_number \
        ,h.hardware_status \
        ,h.status \
        ,h.customer_id \
        from hardware_lpar hl \
        ,hardware h \
        where (hl.status = 'ACTIVE' or hl.action != 'COMPLETE') \
        and h.id = hl.hardware_id \
        with ur"
db2 disconnect $DBSTAGING
set +x

awk -F"|" '
NR==FNR{a[$1$2]=$1$2;next}
a[$1$2]==$1$2{next}
a[$1$2]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Bravo hardware not in staging"}
' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$1$2]=$1$2;next}
a[$1$2]==$1$2{next}
a[$1$2]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Staging hardware not in BRAVO"}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
chmod 644 $DIFFSTAGING

mv $DIFFBRAVO $LOGDIR
mv $DIFFSTAGING $LOGDIR

exit 0
