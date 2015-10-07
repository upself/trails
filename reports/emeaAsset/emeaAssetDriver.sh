:
cp /gsa/pokgsa/projects/e/emea_assets/emea_asset.tsv /gsa/pokgsa/projects/e/emea_assets/emea_asset_old.tsv

/opt/reports/bin/emeaAsset/emeaAssetDriver.pl;
/opt/reports/bin/emeaAsset/emea_bank.pl;

cp /opt/reports/bin/asset_bank.tsv /gsa/pokgsa/projects/e/emea_assets/asset_bank.tsv
