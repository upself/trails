#!/bin/sh
HOST=lexbz181197.cloud.dst.ibm.com
USER=tap
PASSWD=tap123

cd /opt/staging/v2/t/

lftp<<END_SCRIPT
set xfer:clobber on
open sftp://$HOST
user $USER $PASSWD
put output.tap
chmod 777 output.tap
bye