#!/bin/sh
# This script runs getRemoteServerInfo.sh for multiple servers, and populates the text files, that are used by HME for checking remote file systems
BRAVO=`cat /opt/staging/v2/config/connectionConfig.txt | grep gui.bravo.server | cut -f2 -d '=' | rev | cut -c 2- | rev | awk 'ORS=" "'`
TRAILS=`cat /opt/staging/v2/config/connectionConfig.txt | grep gui.trails.server | cut -f2 -d '=' | rev | cut -c 2- | rev | awk 'ORS=" "'`
TAP3=`cat /opt/staging/v2/config/connectionConfig.txt | grep hme.tap3 | cut -f2 -d '=' | rev | cut -c 2- | rev | awk 'ORS=" "'`

expect ./getRemoteServerInfo.sh $BRAVO | awk '{ if ( NR > 3  ) { print } }' > /opt/staging/v2/HealthCheck/info/bravoServerFileSystemUsedDiskInfo.txt
expect ./getRemoteServerInfo.sh $TRAILS | awk '{ if ( NR > 3  ) { print } }' > /opt/staging/v2/HealthCheck/info/trailsServerFileSystemUsedDiskInfo.txt
expect ./getRemoteServerInfo.sh $TAP3 | awk '{ if ( NR > 3  ) { print } }' > /opt/staging/v2/HealthCheck/info/tap3ServerFileSystemUsedDiskInfo.txt