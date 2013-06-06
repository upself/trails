#!/usr/local/bin/perl -w

use DBI;
use Config::Properties::Simple;
use Getopt::Std;

use vars qw( $opt_u);

getopts("u:");
usage() unless ( defined $opt_u );

open FILE, "<tadzHealth5.pl.txt";

my %stageLpar;

my %infrLpar;

while (<FILE>) {
	chomp;
	my $line = $_;
# bNum    bName   lpar_name       node_key        sid     sysplex hw_model        hw_serial
	#	print $line;
	my @vals         = split( "\t", $line );
	my $bNum     = $vals[0];
	my $bName = $vals[1];
	my $lpar_name     = $vals[2];
	my $node_key         = $vals[3];
	my $sid        = $vals[4];
	my $sysplex        = $vals[5];
	my $hw_model        = $vals[6];
	my $hw_serial        = $vals[7];
	# strip out extra space
	$bNum     =~ tr/ //ds;
	$bName =~ tr/ //ds;
	$lpar_name     =~ tr/ //ds;
	$node_key         =~ tr/ //ds;
	$sid        =~ tr/ //ds;
	$sysplex     =~ tr/ //ds;
	$hw_model         =~ tr/ //ds;
	$hw_serial        =~ tr/ //ds;

	$infrLpar{"$node_key"} = {
		bNum     => "$bNum",
		bName => "$bName",
		lpar_name     => "$lpar_name",
		node_key         => "$node_key",
		sid        => "$sid",
		sysplex     => "$sysplex",
		hw_model         => "$hw_model",
		hw_serial        => "$hw_serial",
	};
}

close FILE;

open FILE2, "<tadzHealth7.pl.txt";

while (<FILE2>) {
	chomp;
	my $line = $_;
#S-computerId,S-id,S-name,S-serial,S-serial4,S-serial5,S-scanTime,S-bankAccountId,S-bankAccountName,S-SR-action,S-mapAction,S-SLAction
	#	print $line;
	my @vals         = split( ",", $line );
	my $computerId     = $vals[0];
	my $id = $vals[1];
	my $name     = $vals[2];
	my $serial         = $vals[3];
	my $scanTime        = $vals[6];
	my $bankAccountId        = $vals[7];
	my $bankAccountName        = $vals[8];
	my $SRAction        = $vals[9];
	my $mapAction = $vals[10];
	my $SLAction = $vals[11];
	my $customerId = $vals[12];

	$stageLpar{"$computerId"} = {
		id     => "$id",
		name => "$name",
		serial     => "$serial",
		bankAccountId         => "$bankAccountId",
		bankAccountName        => "$bankAccountName",
		SRAction     => "$SRAction",
		mapAction         => "$mapAction",
		SLAction        => "$SLAction",
		customerId => "$customerId",
	};
}

close FILE2;

open REPORT, ">$0" . ".txt";

  print REPORT
"TADzGUID,StageBankAccountId,StageBankAccountName,TADzLparName,TADzSID,TADzSysplex,TADzHwModel,TADzHwSerial,"
. "StageScanRecordId,StageLparName,StageSerial,StageScanRecordAction,StageSoftwareLparMapAction,StageSoftwareLparAction,StageCustomerId\n";

while ( my ( $key, $swLpar ) = each %infrLpar ) {
	print REPORT "$key,";
	if ( defined $infrLpar{$key}{lpar_name} ) {
		print REPORT $infrLpar{$key}{bNum} . ",";
		print REPORT $infrLpar{$key}{bName} . ",";
		print REPORT $infrLpar{$key}{lpar_name} . ",";
		print REPORT $infrLpar{$key}{sid} . ",";
		print REPORT $infrLpar{$key}{sysplex} . ",";
		print REPORT $infrLpar{$key}{hw_model} . ",";
		print REPORT $infrLpar{$key}{hw_serial} . ",";
	}
	if ( defined $stageLpar{$key}{name} ) {
		print REPORT $stageLpar{$key}{id} . ",";
		print REPORT $stageLpar{$key}{name} . ",";
		print REPORT $stageLpar{$key}{serial} . ",";
		print REPORT $stageLpar{$key}{SRAction} . ",";
		print REPORT $stageLpar{$key}{mapAction} . ",";
		print REPORT $stageLpar{$key}{SLAction} . ",";
		print REPORT $stageLpar{$key}{customerId};
	}
	print REPORT "\n";
}

close REPORT;
exit 0;

sub usage {
	print "$0 -u <userId> \n";
	exit 0;
}

