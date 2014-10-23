#!/bin/sh

LOG="/home/liuhaidl/working/scripts/bravoServerFileSystemUsedDiskInfo.txt"
hLOG="/home/liuhaidl/working/scripts/bravoServerFileSystemUsedDiskInfoHistory.txt"
HOSTNAME="BRAVO.BOULDER.IBM.COM"

df -h | grep '[0-9]%' > ${LOG}
echo "BRAVO Server '${HOSTNAME}' Disc Utilization Alerts captured $(date)" >> ${hLOG}
df -h | grep '[0-9]%' >> ${hLOG}