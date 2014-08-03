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
	my @vals      = split( "\t", $line );
	my $bNum      = $vals[0];
	my $bName     = $vals[1];
	my $lpar_name = $vals[2];
	my $node_key  = $vals[3];
	my $sid       = $vals[4];
	my $sysplex   = $vals[5];
	my $hw_model  = $vals[6];
	my $hw_serial = $vals[7];

	# strip out extra space
	$bNum      =~ tr/ //ds;
	$bName     =~ tr/ //ds;
	$lpar_name =~ tr/ //ds;
	$node_key  =~ tr/ //ds;
	$sid       =~ tr/ //ds;
	$sysplex   =~ tr/ //ds;
	$hw_model  =~ tr/ //ds;
	$hw_serial =~ tr/ //ds;

	if ( !exists $infrLpar{$node_key} ) {

		$infrLpar{"$node_key"} = {
			bNum      => "$bNum",
			bName     => "$bName",
			lpar_name => "$lpar_name",
			node_key  => "$node_key",
			sid       => "$sid",
			sysplex   => "$sysplex",
			hw_model  => "$hw_model",
			hw_serial => "$hw_serial",
			DupStatus => "FIRST",
		};
	}
	else {
		my $flag = "UNKNOWN_DUP";
		my $curSid     = $infrLpar{"$node_key"}{sid};
		my $curSysplex = $infrLpar{"$node_key"}{sysplex};
		my $curSerial  = $infrLpar{"$node_key"}{hw_serial};
		my $curModel  = $infrLpar{"$node_key"}{hw_model};
		my $curLparName  = $infrLpar{"$node_key"}{lpar_name};
		my $curBNum = $infrLpar{"$node_key"}{bNum};
		
		$infrLpar{$node_key}{DupStatus} = "DUPLICATE";
		
		if ( $curLparName ne $lpar_name ) {
			$infrLpar{"$node_key"}{lpar_name} = $curLparName . "/$lpar_name";
			$flag = "";
		}
		
		if ( $curBNum ne $bNum ) {
			$infrLpar{"$node_key"}{bNum} = $curBNum . "/$bNum";
			$infrLpar{"$node_key"}{bName} = $infrLpar{"$node_key"}{bName} . "/$bName";
			
			$flag = "";
		}
		
		if ( $curSid ne $sid ) {
			$infrLpar{"$node_key"}{sid} = $curSid . "/$sid";
			$flag = "";
		}
		if ( $curSysplex ne $sysplex ) {
			$infrLpar{"$node_key"}{sysplex} = $curSysplex . "/$sysplex";
			$flag = "";

		}
		if ( $curSerial ne $hw_serial ) {
			$infrLpar{"$node_key"}{hw_serial} = $curSerial . "/$hw_serial";
			$flag = "";
		}
		if ( $curModel ne $hw_model ) {
			$infrLpar{"$node_key"}{hw_model} = $curModel . "/$hw_model";
			$flag = "";
		}
		if ( $flag ne "" ) {
			print "$flag -- " . $node_key . "\n";
		}

	}
}

close FILE;

open FILE2, "<tadzHealth7.pl.txt";

while (<FILE2>) {
	chomp;
	my $line = $_;

#S-computerId,S-id,S-name,S-serial,S-serial4,S-serial5,S-scanTime,S-bankAccountId,S-bankAccountName,S-SR-action,S-mapAction,S-SLAction
#	print $line;
	my @vals            = split( ",", $line );
	my $computerId      = $vals[0];
	my $id              = $vals[1];
	my $name            = $vals[2];
	my $serial          = $vals[3];
	my $scanTime        = $vals[6];
	my $bankAccountId   = $vals[7];
	my $bankAccountName = $vals[8];
	my $SRAction        = $vals[9];
	my $mapAction       = $vals[10];
	my $SLAction        = $vals[11];
	my $customerId      = $vals[12];

	$stageLpar{"$computerId"} = {
		id              => "$id",
		name            => "$name",
		serial          => "$serial",
		bankAccountId   => "$bankAccountId",
		bankAccountName => "$bankAccountName",
		SRAction        => "$SRAction",
		mapAction       => "$mapAction",
		SLAction        => "$SLAction",
		customerId      => "$customerId",
	};
}

close FILE2;

open REPORT, ">$0" . ".txt";

print REPORT
"TADzGUID,StageBankAccountId,StageBankAccountName,TADzLparName,TADzSID,TADzSysplex,TADzHwModel,TADzHwSerial,TADzDupStatus,"
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
		print REPORT $infrLpar{$key}{DupStatus} . ",";
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

