#!/bin/sh
HOST=lexbz181197.cloud.dst.ibm.com
USER=tap
PASSWD=tap123
FILE=$1
if [ -z "$FILE" ] ; then
  echo 'File not set, use output.tap as default'
  echo 'usage: ./pushResultsToCI.sh [filename]'
  FILE='output.tap'
fi

cd /opt/staging/v2/t/

ftp -n $HOST <<END_SCRIPT
quote USER $USER
quote PASS $PASSWD
put $FILE
quit
END_SCRIPT