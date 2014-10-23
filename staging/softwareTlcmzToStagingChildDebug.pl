#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Staging::SoftwareTlcmzLoader;
use Tap::NewPerl; 

$| = 1;

our ( $opt_b, $opt_f, $opt_t, $opt_d, $opt_a, $opt_l );
getopts("b:f:t:d:a:l:");
usage()
  unless ( defined $opt_b
	&& defined $opt_f
	&& defined $opt_t
	&& defined $opt_d
	&& defined $opt_a
	&& defined $opt_l );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {
	###Roll logfile
	rollLog(10000000);

	logfile($opt_l);

	logging_level("error");

	dlog('Creating new software tlcmz loader');
	my $loader = new Staging::SoftwareTlcmzLoader($opt_b);
	dlog('software tlcmz loader created');

	dlog('Calling the software tlcmz load method');
	$loader->load(
		TestMode            => $opt_t,
		LoadDeltaOnly       => $opt_d,
		ApplyChanges        => $opt_a,
		FullLoadPeriodHours => $opt_f
	);
	dlog('software tlcmz load method complete');
};
if ($@) {
	elog($@);
	die $@;
}

exit 0;

sub usage {
	print
	  "softwareTlcmzToStaging.pl -b <bankaccount> -f <full-load-period-hours>"
	  . " -t <test-mode> -d <load-deltas-only> -a <apply-changes> -l <logfile>\n";
	exit 0;
}
