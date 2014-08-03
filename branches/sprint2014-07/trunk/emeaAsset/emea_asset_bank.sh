:
db2 -tvf /home/dbryson/asset_emea/emea_asset_bank.sql 
cat /home/dbryson/asset_emea/bank_data.txt | sort > /home/dbryson/asset_emea/bank_data2.txt
/home/dbryson/asset_emea/emea_bank.pl
cp /home/dbryson/asset_emea/bank_data3.txt /gsa/pokgsa/projects/e/emea_assets/asset_bank.tsv
