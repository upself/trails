:

if [ -f /db2/tap/sqllib/db2profile ]; then
	. /db2/tap/sqllib/db2profile
fi
/home/dbryson/gsa_web.sh
cd /home/dbryson/asset_emea
/usr/bin/perl assetDriver.pl
if [ 12000000 -lt `ls -l /home/dbryson/asset_emea/emea_asset.tsv | awk '{print $5}'` ] 
then /home/dbryson/gsa_web.sh 
cp /gsa/pokgsa/projects/e/emea_assets/emea_asset.tsv /gsa/pokgsa/projects/e/emea_assets/emea_asset_old.tsv
cp /home/dbryson/asset_emea/emea_asset.tsv /gsa/pokgsa/projects/e/emea_assets/emea_asset.tsv
rm /home/dbryson/asset_emea/emea_asset.tsv
else echo "File was smaller than 12000000 so it was not mounted into GSA"
fi
#db2 -tvf emea_asset_bank.sql > /gsa/pokgsa/projects/e/emea_assets/asset_emea/asset_bank.txt
#cat /gsa/pokgsa/projects/e/emea_assets/asset_bank.txt | /usr/local/bin/sql2tsv > /home/dbryson/asset_emea/asset_bank.tsv

#db2 -tvf emea_asset_bank.sql > /gsa/pokgsa/projects/e/emea_assets/asset_bank.txt
#cat /gsa/pokgsa/projects/e/emea_assets/asset_bank.txt | /usr/local/bin/sql2tsv > /gsa/pokgsa/projects/e/emea_assets/asset_bank.tsv
./emea_asset_bank.sh
cat run_err.log >> /gsa/pokgsa/projects/e/emea_assets/run_err.log
#db2 -tvf emea_asset_bank.sql > /home/dbryson/asset_emea/asset_bank.txt
#cat /home/dbryson/asset_emea/asset_bank.txt | /usr/local/bin/sql2tsv > /home/dbryson/asset_emea/asset_bank.tsv
#cp /home/dbryson/asset_emea/asset_bank.tsv /gsa/pokgsa/projects/e/emea_assets/asset_bank.tsv
#rm /home/dbryson/asset_emea/asset_bank.txt
#rm /home/dbryson/asset_emea/asset_bank.tsv
