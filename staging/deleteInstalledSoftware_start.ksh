#!/bin/ksh
# source db2 env
. /home/tap/.bashrc 2> /dev/null

cd /opt/staging/v2
./deleteInstalledSoftware.pl start > /var/staging/logs/deleteInstalledSoftware/deleteInstalledSoftware_start.out &
