#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/instSwComponentOpenAlert.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,c.account_number \
        ,c.customer_name \
        ,sl.name \
        ,is.id \
     from \
        customer c \
        ,software_lpar sl \
        ,installed_software is \
        ,software s \
        ,discrepancy_type d \
     where \
        c.customer_id = sl.customer_id \
        and sl.id = is.software_lpar_id \
        and is.software_id = s.software_id \
        and is.discrepancy_type_id = d.id \
        and is.status = 'ACTIVE' \
        and d.name != 'FALSE HIT' \
        and d.name != 'INVALID' \
        and s.level = 'COMPONENT' \
        and exists( select 1 from alert_unlicensed_sw aus where aus.installed_software_id = is.id and aus.open = 1) \
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
