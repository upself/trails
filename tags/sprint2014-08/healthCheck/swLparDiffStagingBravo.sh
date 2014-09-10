#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
EXPORTSTAGING=$TMPDIR/$BASESTR.staging
DIFFBRAVO=$TMPDIR/stagingSwLparNotInBravo.txt
DIFFSTAGING=$TMPDIR/bravoSwLparNotInStaging.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $TRDBPW
db2 set current schema $SCHEMA

db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        sl.customer_id \
        ,sl.name \
        ,c.account_number \
        ,sl.status \
        ,sl.scantime \
        ,sl.computer_id \
        from software_lpar sl \
        ,customer c \
        where sl.customer_id = c.customer_id and \
        sl.status = 'ACTIVE' \
        with ur"
db2 disconnect $DBBRAVO
set +x

# export staging data
set -x
db2 connect to $DBSTAGING user $DBID using $STDBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTSTAGING of del \
    modified by nochardel coldel\| \
    "select \
        sl.customer_id \
        ,sl.name \
        ,sl.id \
        ,sl.status \
        ,sl.action \
        from software_lpar sl \
        with ur"
db2 disconnect $DBSTAGING
set +x

awk -F"|" '
NR==FNR{a[$1$2]=$1$2;next}
a[$1$2]==$1$2{next}
a[$1$2]{print $0 " <= Corresponding records did not match"}
{print $0}
' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$1$2]=$1$2;next}
a[$1$2]==$1$2{next}
a[$1$2]{print $0 " <= Corresponding records did not match"}
{print $0}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
chmod 644 $DIFFSTAGING

mv $DIFFBRAVO $LOGDIR
mv $DIFFSTAGING $LOGDIR

exit 0
