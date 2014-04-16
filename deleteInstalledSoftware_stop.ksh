#!/bin/ksh
# source db2 env
. /home/tap/.bashrc 2> /dev/null

cd /opt/staging/v2
./deleteInstalledSoftware.pl stop > /var/staging/logs/deleteInstalledSoftware/deleteInstalledSoftware_stop.out &
