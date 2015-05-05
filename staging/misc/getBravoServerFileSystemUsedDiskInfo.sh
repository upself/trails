#!/bin/sh

LOG="/var/staging/logs/HME/bravoServerFileSystemUsedDiskInfo.txt"
hLOG="/var/staging/logs/HME/bravoServerFileSystemUsedDiskInfoHistory.txt"
HOSTNAME="BRAVO.BOULDER.IBM.COM"

df -h | grep '[0-9]%' > ${LOG}
echo "BRAVO Server '${HOSTNAME}' Disc Utilization Alerts captured $(date)" >> ${hLOG}
df -h | grep '[0-9]%' >> ${hLOG}