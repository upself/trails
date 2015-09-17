#!/bin/bash

content='mail.txt'
recevier='zyizhang@cn.ibm.com'
libs=`echo /var/bravo/recon-summary/lib/* | tr ' ' ':'`

cd /var/bravo/recon-summary

rm -rf  files/threads-qty/*

gsa_login trails -c bejgsa -p <gsapwd >/dev/null 2>&1

cp /gsa/bejgsa/projects/s/swtools/health-status/reconInventoryThreadQty.txt files/threads-qty/
cp /gsa/bejgsa/projects/s/swtools/health-status/reconLicensingThreadQty.txt files/threads-qty/
cp /gsa/bejgsa/projects/s/swtools/health-status/swToBravoThreadQty.txt files/threads-qty/

cat /dev/null>/gsa/bejgsa/projects/s/swtools/health-status/reconInventoryThreadQty.txt
cat /dev/null>/gsa/bejgsa/projects/s/swtools/health-status/reconLicensingThreadQty.txt
cat /dev/null>/gsa/bejgsa/projects/s/swtools/health-status/swToBravoThreadQty.txt

/var/bravo/jdk1.5.0_22/bin/java  -cp $libs:reconsummary.jar com.ibm.cyclone.ReconSummary > $content

#echo 'Queries stopped due to AHE DB performance concerns' > $content

echo '----------------------------------------------'>> $content
echo 'NOTE: This mail is sent by tap server hourly.' >> $content
echo "Server time: `date`" >> $content
mail -s "Inscope recon hourly check-`date`" $recevier -- -f tap.raleigh.ibm.com < $content