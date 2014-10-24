:

/opt/reports/bin/assetDriver.pl
if [ 12000000 -lt `ls -l /home/dbryson/asset_emea/emea_asset.tsv | awk '{print $5}'` ] 
then cp /gsa/pokgsa/projects/e/emea_assets/emea_asset.tsv /gsa/pokgsa/projects/e/emea_assets/emea_asset_old.tsv
cp /opt/reports/bin/emea_asset.tsv /gsa/pokgsa/projects/e/emea_assets/emea_asset.tsv
rm /opt/reports/bin/emea_asset.tsv
else echo "File was smaller than 12000000 so it was not mounted into GSA"
fi
/opt/reports/bin/emea_bank.pl
cp /opt/reports/bin/asset_bank.tsv /gsa/pokgsa/projects/e/emea_assets/asset_bank.tsv
rm /opt/reports/bin/asset_bank.tsv

