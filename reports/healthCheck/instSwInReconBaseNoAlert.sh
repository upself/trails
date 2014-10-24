#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/instSwInReconBaseNoAlert.txt

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
        ,hw_sw_composite hsc \
        ,hardware_lpar hl \
        ,hardware h \
        ,installed_software is \
        left outer join alert_unlicensed_sw aus on \
            aus.installed_software_id = is.id \
        ,software s \
        ,discrepancy_type d \
     where \
        c.sw_license_mgmt = 'YES' \
        and c.status = 'ACTIVE' \
        and c.customer_id = sl.customer_id \
        and sl.status = 'ACTIVE' \
        and sl.id = hsc.software_lpar_id \
        and hsc.hardware_lpar_id = hl.id \
        and hl.status = 'ACTIVE' \
        and hl.hardware_id = h.id \
        and h.status = 'ACTIVE' \
        and h.hardware_status != 'HWCOUNT' \
        and sl.id = is.software_lpar_id \
        and is.software_id = s.software_id \
        and is.discrepancy_type_id = d.id \
        and s.status = 'ACTIVE' \
        and s.level = 'LICENSABLE' \
        and is.status = 'ACTIVE' \
        and d.name != 'FALSE HIT' \
        and d.name != 'INVALID' \
        and aus.id is null \
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
