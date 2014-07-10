#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/instSwReconBaseNoReconClosedAlert.txt

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
        ,d.name \
     from \
        customer c \
        ,software_lpar sl \
        ,installed_software is \
        ,alert_unlicensed_sw aus \
        ,software s \
        ,discrepancy_type d \
     where \
        c.status = 'ACTIVE' \
        and c.sw_license_mgmt = 'YES'\
        and c.customer_id = sl.customer_id \
        and sl.status = 'ACTIVE' \
        and sl.id = is.software_lpar_id \
        and is.status = 'ACTIVE' \
        and aus.installed_software_id = is.id \
        and aus.open = 0 \
        and not exists( select 1 from reconcile r where r.installed_software_id = is.id ) \
        and is.software_id = s.software_id \
        and s.level = 'LICENSABLE' \
        and s.status = 'ACTIVE' \
        and is.discrepancy_type_id = d.id \
        and d.name != 'INVALID' \
        and d.name != 'FALSE HIT' \
        and exists ( select 1 from hw_sw_composite hsc, hardware_lpar hl, hardware h where hsc.software_lpar_id = sl.id and hsc.hardware_lpar_id = hl.id and hl.status = 'ACTIVE' and hl.hardware_id = h.id and h.status = 'ACTIVE' and h.hardware_status = 'ACTIVE' ) \
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
