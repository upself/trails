#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTSTAGING=$TMPDIR/$BASESTR.staging
DIFFSTAGING=$TMPDIR/scanRecordsNoCustomer.txt

# export bravo data
set -x
db2 connect to $DBSTAGING user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTSTAGING of del \
    modified by nochardel coldel\| \
    "select \
         sr.name \
         ,sr.serial_number \
         ,sr.os_name \
         ,sr.scan_time \
         ,sr.bank_account_id \
     from \
         scan_record sr \
     where \
         not exists ( \
             select \
                 1 \
             from \
                 software_lpar_map slm \
             where \
                 slm.scan_record_id = sr.id \
         ) \
     with ur"
db2 disconnect $DBSTAGING
set +x

# generate diff
set -x
sort -n $EXPORTSTAGING >$DIFFSTAGING
chmod 644 $DIFFSTAGING
mv $DIFFSTAGING $LOGDIR
rm -f $EXPORTSTAGING
set +x

exit 0
