#!/usr/local/bin/perl -w

use DBI;
use Config::Properties::Simple;
use Getopt::Std;

use strict;  

our ( $opt_u );
getopts("u:");
usage() unless ( defined $opt_u );


my $cfg = Config::Properties::Simple->new(file => $opt_u .  ".ini"); 

my $stageDatabase = $cfg->getProperty('stageDatabase');
my $stageDatabaseUser = $cfg->getProperty('stageDatabaseUser');
my $stageDatabasePassword = $cfg->getProperty('stageDatabasePassword');

my $reportDatabase = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

# Open a connections 
my $dbhReporting = DBI->connect("dbi:DB2:$reportDatabase", "$reportDatabaseUser", "$reportDatabasePassword", {RaiseError => 1});

my $stmt = "Select id, name,database_name,database_user,database_password,database_schema from eaadmin.bank_account where type = 'TADZ' and status = 'ACTIVE' with ur";
my $sth = $dbhReporting->prepare($stmt);
$sth->execute();
my $bankAccountId;
my $bankName;
my $databaseName;
my $databaseUser;
my $databasePassword;
my $databaseSchema;

$sth->bind_col(1, \$bankAccountId);
$sth->bind_col(2, \$bankName);
$sth->bind_col(3, \$databaseName);
$sth->bind_col(4, \$databaseUser);
$sth->bind_col(5, \$databasePassword);
$sth->bind_col(6, \$databaseSchema);

my %bankAccounts;

while ( $sth->fetch ) {
	$bankAccounts{$bankAccountId} = {
		 bankName => "$bankName",
		 databaseName => "$databaseName",
		 databaseUser => "$databaseUser",
		 databasePassword => "$databasePassword",
		 databaseSchema => "$databaseSchema",
	};
}

$sth->finish;

$dbhReporting->disconnect();

open REPORT, ">$0" . ".txt";
print REPORT "bNum\tbName\tlpar_name\tnode_key\tsid\tsysplex\thw_model\thw_serial\n";

while ( my ($bNum, $bAccount) = each %bankAccounts ) {

	my $bName =  $bankAccounts{$bNum}{bankName};
	my $bDatabaseName = $bankAccounts{$bNum}{databaseName};
	my $bDatabaseUser =  $bankAccounts{$bNum}{databaseUser};
	my $bDatabasePassword = $bankAccounts{$bNum}{databasePassword};
	my $bDatabaseSchema =  $bankAccounts{$bNum}{databaseSchema};
	my $dbhToCheck = DBI->connect("dbi:DB2:$bName", "$bDatabaseUser", "$bDatabasePassword", {RaiseError => 1});
	my $prepStmnt = "set schema $bDatabaseSchema";
	print "Setting Schema $bDatabaseSchema\n";
	my $prepSth = $dbhToCheck->prepare($prepStmnt);
	$prepSth->execute();
	
	my $query = "select distinct node.node_key, sid, lpar_name, sysplex,hw_model,hw_serial
	 from system, system_node, node where 
	system.system_key = system_node.system_key and node.node_key = system_node.node_key and node_type = \'LPAR\'
	order by lpar_name WITH ur";
	my $query = "with mapping (node_key, last_update_time) as (select node_key, max(last_update_time) from
	system_node group by node_key)
	select node.node_key, sid, lpar_name, sysplex,hw_model,hw_serial
	 from system, node, system_node, mapping
	where system.system_key = system_node.system_key 
	and node.node_key = system_node.node_key 
	and system_node.last_update_time = mapping.last_update_time
	and system_node.node_key = mapping.node_key
	and node_type = \'LPAR\'
	order by lpar_name WITH ur";
  	my $queryHandle = $dbhToCheck->prepare($query);
  	$queryHandle->execute();
  
  	my $node_key;
  	my $sid;
  	my $lpar_name;
 	my $sysplex;
 	my $hw_model;
 	my $hw_serial;
 	
	$queryHandle->bind_col(1, \$node_key);
	$queryHandle->bind_col(2, \$sid);
	$queryHandle->bind_col(3, \$lpar_name);
	$queryHandle->bind_col(4, \$sysplex);
	$queryHandle->bind_col(5, \$hw_model);
	$queryHandle->bind_col(6, \$hw_serial);
	
	while ( $queryHandle->fetch ) {
		my $upperKey = uc($node_key);
		print REPORT "$bNum\t$bName\t$lpar_name\t$upperKey\t$sid\t$sysplex\t$hw_model\t$hw_serial\n";
	}
	$queryHandle->finish;
	$prepSth->finish;
	$dbhToCheck->disconnect();
}
close REPORT;

sub usage {
	print "$0 -u <userId>\n";
	exit 0;
}


