*********************
*DEPLOYMENT         
*********************
no action needed anymore

*************************************
* EXECUTE OFLINE FULL RECON REPORT  *       
*************************************

perl /opt/reports/fullRecon/fullReconDriver.pl

 - r		specify region (exapmples: US_IMT,JAPAN_IMT)
 - c		specify customer id
 - t		specify number of generated customers
 - d		debug mode
 
examples
	perl /opt/reports/fullRecon/fullReconDriver.pl
		driver generates full report for each region
		
	perl /opt/reports/fullRecon/fullReconDriver.pl -r US_IMT
		driver generates full report for one specific region (id database is name of region stored with spaces "US_IMT" => "US IMT")
		
	perl /opt/reports/fullRecon/fullReconDriver.pl -r US_IMT -c 11111
		test use - driver generates report for one specific customer from specific region
		
	perl /opt/reports/fullRecon/fullReconDriver.pl -r US_IMT -t 3
		test use - driver generates report for number of ramdoly picked customers from region
		
		
All reports are stored to GSA (even the test one) as REGION.zip  (JAPAN_IMT.zip)