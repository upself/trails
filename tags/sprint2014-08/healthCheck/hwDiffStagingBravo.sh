#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
EXPORTSTAGING=$TMPDIR/$BASESTR.staging
DIFFBRAVO=$TMPDIR/stagingHwNotInBravo.txt
DIFFSTAGING=$TMPDIR/bravoHwNotInStaging.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $TRDBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        h.machine_type_id \
        ,h.serial \
        ,h.country \
        ,h.owner \
        ,h.customer_number \
        ,h.hardware_status \
        ,h.status \
        ,h.customer_id \
        ,c.account_number \
        ,h.id \
        from hardware h \
        ,customer c \
        where h.customer_id = c.customer_id and \
        h.hardware_status != 'REMOVED' \
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
        h.machine_type_id \
        ,h.serial \
        ,h.country \
        ,h.owner \
        ,h.customer_number \
        ,h.hardware_status \
        ,h.status \
        ,h.action \
        ,h.update_date \
        ,h.customer_id \
        ,h.id \
        from hardware h \
        with ur"
db2 disconnect $DBSTAGING
set +x

awk -F"|" '
NR==FNR{a[$1$2$3]=$1$2$3;next}
a[$1$2$3]==$1$2$3{next}
a[$1$2$3]{print $0 " <= Corresponding records did not match"}
{print $0}
' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$1$2$3]=$1$2$3;next}
a[$1$2$3]==$1$2$3{next}
a[$1$2$3]{print $0 " <= Corresponding records did not match"}
{print $0}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
chmod 644 $DIFFSTAGING

mv $DIFFBRAVO $LOGDIR
mv $DIFFSTAGING $LOGDIR

exit 0
