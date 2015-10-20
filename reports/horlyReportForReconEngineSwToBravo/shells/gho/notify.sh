#!/bin/bash
rootPath=/opt/reports/recon-summary
threadsFilePath=$rootPath/files/threads-qty/
content='mail.txt'

cd $rootPath

libs=`echo $rootPath/lib/* | tr ' ' ':'`

recevier='zyizhang@cn.ibm.com'

export LIBPATH=/home/db2inst2/sqllib/lib32:/usr/lib:/lib
/opt/catalog/java5/jre/bin/java  -cp $libs:reconsummary.jar com.ibm.cyclone.ReconSummary > $content

#echo 'Queries stopped due to AHE DB performance concerns' > $content

echo '----------------------------------------------'>> $content
echo 'NOTE: This mail is sent by server b03acirdb022.gho.boulder.ibm.com hourly.' >> $content
echo "Server time: `date`" >> $content
mail -s "Inscope recon hourly check-`date`" $recevier < $content

cd $threadsFilePath
rm -rf *