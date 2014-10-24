#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/hwActiveHwStatusNotActiveOpenAlert.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,h.id \
        ,c.account_number \
        ,c.customer_name \
        ,h.serial \
     from \
        customer c \
        ,hardware h \
     where \
        c.customer_id = h.customer_id \
        and h.status = 'ACTIVE' \
        and h.hardware_status != 'ACTIVE' \
        and exists( select 1 from alert_hardware ah where ah.hardware_id = h.id and ah.open = 1) \
    with ur"
db2 disconnect $DBBRAVO
set +x

# generate diff
set -x
sort -n $EXPORTBRAVO >$DIFFBRAVO
chmod 644 $DIFFBRAVO
mv $DIFFBRAVO $LOGDIR
rm -f $EXPORTBRAVO
set +x

exit 0
