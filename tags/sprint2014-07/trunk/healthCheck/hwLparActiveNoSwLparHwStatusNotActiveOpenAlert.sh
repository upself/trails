#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/hwLparActiveNoSwLparHwStatusNotActiveOpenAlert.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,hl.id \
        ,c.account_number \
        ,c.customer_name \
        ,hl.name \
     from \
        customer c \
        ,hardware_lpar hl \
        ,hardware h \
     where \
        c.customer_id = hl.customer_id \
        and hl.hardware_id = h.id \
        and hl.status = 'ACTIVE' \
        and h.hardware_status != 'ACTIVE' \
        and not exists( select 1 from  hw_sw_composite hsc  where hl.id = hsc.hardware_lpar_id) \
        and exists( select 1 from alert_hw_lpar ahl where ahl.hardware_lpar_id = hl.id and ahl.open = 1) \
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
