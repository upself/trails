#!/bin/ksh

cd /opt/staging/v2
./deleteInstalledSoftware.pl stop > /var/staging/logs/deleteInstalledSoftware/deleteInstalledSoftware_stop.out &
