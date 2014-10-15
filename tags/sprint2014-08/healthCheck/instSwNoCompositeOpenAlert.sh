#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/instSwNoCompositeOpenAlert.txt

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
        ,s.software_name \
     from \
        customer c \
        ,software_lpar sl \
        ,installed_software is \
        ,alert_unlicensed_sw aus \
        ,software s \
     where \
        c.customer_id = sl.customer_id \
        and not exists ( select 1 from hw_sw_composite hsc where hsc.software_lpar_id = sl.id ) \
        and sl.id = is.software_lpar_id \
        and aus.installed_software_id = is.id \
        and aus.open = 1 \
        and is.software_id = s.software_id \
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
