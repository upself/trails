#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Staging::SoftwareFilterLoader;
use Base::ConfigManager;
use Tap::NewPerl; 

$| = 1;

our ( $opt_b, $opt_f, $opt_t, $opt_d, $opt_a, $opt_l, $opt_c );
getopts("b:f:t:d:a:l:c:");
usage()
  unless ( defined $opt_b
	&& defined $opt_f
	&& defined $opt_t
	&& defined $opt_d
	&& defined $opt_a
	&& defined $opt_l 
	&& defined $opt_c
	);    

###Close handles to avoid console output.
#open( STDIN, "/dev/null" )
#  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
#open( STDOUT, "/dev/null" )
#  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
#open( STDERR, "/dev/null" )
#  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {

    my $cfgMgr =  Base::ConfigManager->instance($opt_c);    

	logfile($opt_l);
	logging_level($cfgMgr->debugLevel);

	dlog('Creating new software filter loader');
	my $loader = new Staging::SoftwareFilterLoader($opt_b);
	dlog('software filter loader created');

	dlog('Calling the software filter load method');
	$loader->load(
		TestMode            => $opt_t,
		LoadDeltaOnly       => $opt_d,
		ApplyChanges        => $opt_a,
		FullLoadPeriodHours => $opt_f
	);
	dlog('software filter load method complete');
};
if ($@) {
	elog($@);
	die $@;
}

exit 0;

sub usage {
	print
	  "softwareFilterToStaging.pl -b <bankaccount> -f <full-load-period-hours>"
	  . " -t <test-mode> -d <load-deltas-only> -a <apply-changes> -l <logfile> -c <configFile>\n";
	exit 0;
}
