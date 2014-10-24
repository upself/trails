#!/bin/sh

# setup env
. `dirname $0`/hchks.env

# globals
BASESTR=`basename $0 |awk -F'.' '{print $1}'`
EXPORTBRAVO=$TMPDIR/$BASESTR.bravo
EXPORTSTAGING=$TMPDIR/$BASESTR.staging
DIFFBRAVO=$TMPDIR/stagingLicenseSwNoBravoSw.txt

# export bravo data
set -x
db2 connect to $DBBRAVO user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTBRAVO of del \
    modified by nochardel coldel\| \
    "select \
        l.id \
        ,l.customer_id \
        ,l.ext_src_id \
        ,lsm.software_id \
        ,l.record_time \
        from license l \
        ,license_sw_map lsm \
        where \
        l.status = 'ACTIVE' \
        and l.id = lsm.license_id \
        with ur"
db2 disconnect $DBBRAVO
set +x

# export staging data
set -x
db2 connect to $DBSTAGING user $DBID using $DBPW
db2 set current schema $SCHEMA
db2 export to $EXPORTSTAGING of del \
    modified by nochardel coldel\| \
    "select \
        l.id \
        ,l.customer_id \
        ,l.ext_src_id \
        ,l.software_id \
        ,l.swcm_record_time \
        ,l.status \
        ,l.action \
        from license l \
        where l.software_id is not null \
        with ur"
db2 disconnect $DBSTAGING
set +x

#awk -F"|" '
#NR==FNR{a[$3$4]=$3$4;next}
#a[$3$4]==$3$4{next}
#a[$3$4]{print $0 " <= Corresponding records did not match"}
#{print $0 " <= Bravo software id not in staging"}
#' $EXPORTSTAGING $EXPORTBRAVO > $DIFFSTAGING

awk -F"|" '
NR==FNR{a[$3$4]=$3$4;next}
a[$3$4]==$3$4{next}
a[$3$4]{print $0 " <= Corresponding records did not match"}
{print $0 " <= Staging software id not in BRAVO"}
' $EXPORTBRAVO $EXPORTSTAGING > $DIFFBRAVO

chmod 644 $DIFFBRAVO
#chmod 644 $DIFFSTAGING

mv $DIFFBRAVO $LOGDIR
#mv $DIFFSTAGING $LOGDIR

exit 0
