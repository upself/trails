#!/bin/bash
user=trails
password=D27fdd09
path=/opt/IBMIHS/recon-summary

cd $path
rm -rf *.txt

ftp -n<<!
close
open bejgsa.ibm.com
user $user $password
binary
prompt

cd /gsa/bejgsa/projects/s/swtools/health-status/

get reconInventoryThreadQty.txt
get reconLicensingThreadQty.txt
get swToBravoThreadQty.txt
close
bye
!

cd $path
./threadQty.sh reconEngineInventory>> reconInventoryThreadQty.txt
./threadQty.sh reconEngineLicensing>> reconLicensingThreadQty.txt
./threadQty.sh softwareToBravo>> swToBravoThreadQty.txt

ftp -n<<!
close
open bejgsa.ibm.com
user $user $password
binary
prompt

cd /gsa/bejgsa/projects/s/swtools/health-status/

put reconInventoryThreadQty.txt
put reconLicensingThreadQty.txt
put swToBravoThreadQty.txt

close
bye
!

cd $path
rm -rf *.txt