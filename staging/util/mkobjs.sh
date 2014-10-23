#!/bin/sh

BASEDIR=/opt/staging/v2
OBJGEN=$BASEDIR/util/objgen.pl

for file in `find $BASEDIR -name \*.pm.xml`
do
    dir=`dirname $file`
    pm=`basename $file |sed 's/\.xml$//'`
    set -x
    $OBJGEN $file >$dir/../$pm
    set +x
done

exit 0
