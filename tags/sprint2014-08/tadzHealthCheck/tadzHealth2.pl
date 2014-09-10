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
  my %bankAccounts = {};
  while ($sth->fetch) { 
  		$bankAccounts{$bankAccount} = $bankName;
	}
  $sth->finish();
	my $bNum;
  foreach $bNum ( keys %bankAccounts ) {
  	print $bNum . " " .  $bankAccounts{$bNum} . "\n";
  } 
	my $stmt2 = "select customer_id, customer_name, account_number from eaadmin.customer with ur";
	my $customerId;
	my $customerName;
	my $accountNumber;
	my %customers = {};
	my $sth2 = $dbh->prepare($stmt2);
	$sth2->execute();
	$sth2->bind_col(1, \$customerId);
	$sth2->bind_col(2, \$customerName);
	$sth2->bind_col(3, \$accountNumber);
	while ( $sth2->fetch) {
		$customers{$customerId} = [ $customerName, $accountNumber ];
	}
	$sth2->finish;
	my $cNum;
	foreach $cNum ( keys %customers ) {
		print $cNum . " " . $customers{$cNum}[0] . " - " . $customers{$cNum}[1] . "\n" ;
	}
	my $stmt3 = "select bank_account_id, action,name,bios_serial from software_lpar 
where id in 
(select software_lpar_id from software_lpar_map where scan_record_id in 
(select id from scan_record where bank_account_id in (  
";
  foreach $bNum ( keys %bankAccounts ) {
  	"$stmnt3," .= $bNum;
  }
  chop $stmt3; 


  	my $sth3 = $dbhStage->prepare($stmt3);
	$sth3->execute();
  	my $action;
  	my $name;
  	my $serial;
  	$sth2->bind_col(1, \$action);
  	$sth2->bind_col(2, \$name);
  	$sth2->bind_col(3, \$serial);
  	
  $dbh->disconnect();
  $dbhStage->disconnect();

