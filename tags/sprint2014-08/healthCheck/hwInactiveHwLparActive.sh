#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/hwInactiveHwLparActive.txt

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
        ,c.status \
        ,hl.name \
        ,hl.status \
        ,h.serial \
        ,h.status \
     from \
        customer c \
        ,hardware h \
        ,hardware_lpar hl \
     where \
        c.customer_id = h.customer_id \
        and h.status = 'INACTIVE' \
        and h.id = hl.hardware_id \
        and hl.status = 'ACTIVE' \
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
