#!/usr/local/bin/perl -w
  use DBI;
  use strict;  
# Open a connection 
  my $dbh = DBI->connect("dbi:DB2:traherp", "dbryson", "jan03new", {RaiseError => 1});
# use VALUES to retrieve value from special register
  my $dbhStage = DBI->connect("dbi:DB2:staging", "eaadmin", "apr03db2", {RaiseError => 1});
  my $stmt = "select id,name from eaadmin.bank_account where type = 'TADZ' with ur";
  my $sth = $dbh->prepare($stmt);
  $sth->execute();
# associate variables with output columns...
  my $bankAccount;
  my $bankName;
  $sth->bind_col(1,\$bankAccount);
  $sth->bind_col(2,\$bankName);
  while ($sth->fetch) { 
	my $stmt3 = "select count(*) from scan_record where bank_account_id = $bankAccount with ur";
	my $sth3 = $dbhStage->prepare($stmt3);
	$sth3->execute();
	my $scanCount;
	$sth3->bind_col(1, \$scanCount);	
	$sth3->fetch;
	print "\n\nBank Account ID: $bankAccount -- $bankName -- All Scans in Bank Account: $scanCount\n" .
	"---------------------------------------------------\n"; 
	my $stmt2 = "select action,name,bios_serial from software_lpar 
where id in 
(select software_lpar_id from software_lpar_map where scan_record_id in 
(select id from scan_record where bank_account_id = $bankAccount)) with ur
";
  	my $sth2 = $dbhStage->prepare($stmt2);
	$sth2->execute();
  	my $action;
  	my $name;
  	my $serial;
  	$sth2->bind_col(1, \$action);
  	$sth2->bind_col(2, \$name);
  	$sth2->bind_col(3, \$serial);
	while ( $sth2->fetch) {
		my $serial5 = substr($serial, -5, 5);
		my $serial4 = substr($serial, -4, 4);
		my $stmt4;
		$stmt4 = "select match_method,software_lpar_id, hardware_lpar_id from eaadmin.hw_sw_composite where software_lpar_id in (select id from eaadmin.software_lpar where name = \'$name\' and bios_serial = \'$serial\')";
		my $sth4 = $dbh->prepare($stmt4);
		$sth4->execute();
		my $matchMethod;
		my $softwareLparId;
		my $hardwareLparId;
		$sth4->bind_col(1, \$matchMethod);
		$sth4->bind_col(2, \$softwareLparId);
		$sth4->bind_col(3, \$hardwareLparId);
		print " * STAGING LPAR ACTION:$action -- NAME: $name -- SERIAL: $serial5 \n";
		if ( $sth4->fetch ) {
			my $stmt5 = "select account_number from eaadmin.customer,eaadmin.software_lpar where eaadmin.software_lpar.id = $softwareLparId and eaadmin.software_lpar.customer_id = customer.id with ur";
			my $sth5 = $dbh->prepare($stmt5);
			$sth5->execute();
			my $accountNumber;
			$sth5->bind_col(1, \$accountNumber);	
			$sth5->fetch;
			
			print "    ------ $name $serial5 HW/SW Composite matched by $matchMethod Account Number: $accountNumber \n";
			$sth5->finish();
		} else {
			print "    ------ $name $serial5 HW/SW Composite NOT Created \n";
		}
		$sth4->finish();	
	}
	$sth3->finish();
	$sth2->finish();
}
  $sth->finish();
  $dbh->disconnect();
  $dbhStage->disconnect();
