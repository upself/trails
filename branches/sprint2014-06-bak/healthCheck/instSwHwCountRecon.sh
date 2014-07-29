#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/instSwHwCountRecon.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,is.id \
        ,c.account_number \
        ,c.customer_name \
        ,sl.name \
     from \
        customer c \
        ,software_lpar sl \
        ,hw_sw_composite hsc \
        ,hardware_lpar hl \
        ,hardware h \
        ,installed_software is \
        ,reconcile r \
     where \
        c.customer_id = sl.customer_id \
        and sl.id = hsc.software_lpar_id \
        and hsc.hardware_lpar_id = hl.id \
        and hl.hardware_id = h.id \
        and h.hardware_status = 'HWCOUNT' \
        and sl.id = is.software_lpar_id \
        and is.id = r.installed_software_id \
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
