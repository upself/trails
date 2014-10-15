#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
DIFFBRAVO=$TMPDIR/swLparInactiveOpenOutdatedAlert.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        c.customer_id \
        ,sl.id \
        ,c.account_number \
        ,c.customer_name \
        ,c.status \
        ,sl.name \
        ,sl.status \
     from \
        customer c \
        ,software_lpar sl \
        ,alert_expired_scan aes \
     where \
        c.customer_id = sl.customer_id \
        and sl.status = 'INACTIVE' \
        and sl.id = aes.software_lpar_id \
        and aes.open = 1 \
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
