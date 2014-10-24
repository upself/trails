#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/licenseInactiveRecon.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,r.installed_software_id \
        ,l.id \
        ,c.account_number \
        ,c.customer_name \
     from \
        customer c \
        ,license l \
        ,license_recon_map lrm \
        ,reconcile r \
     where \
        c.customer_id = l.customer_id \
        and l.status = 'INACTIVE' \
        and l.id = lrm.license_id \
        and lrm.reconcile_id = r.id \
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
