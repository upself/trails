#!/usr/bin/perl -w

###TODO: log this given batch if failed.

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use BRAVO::SoftwareLoader;
use Tap::NewPerl; 

###Check usage.
use vars qw( $opt_t $opt_d $opt_a $opt_m $opt_b $opt_e $opt_l );
getopts("t:d:a:m:b:e:l:");
die "Usage: $0"
  . " -t <test-mode> -d <load-delta-only> -a <apply-changes> -m <max-lpars-in-mem>"
  . " -b <first-id> -e <last-id> -l <logfile>\n"
  unless ( defined $opt_t
	&& defined $opt_d
	&& defined $opt_a
	&& defined $opt_m
	&& defined $opt_b
	&& defined $opt_e
	&& defined $opt_l );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {
	###Set the logging level
	logging_level("error");

	###Set the logfile
	logfile($opt_l);

	###Roll logfile
	rollLog(10000000);

	ilog(
"starting child: testMode=$opt_t, loadDeltaOnly=$opt_d, applyChanges=$opt_a"
		  . ", maxLparsInQuery=$opt_m, firstId=$opt_b, lastId=$opt_e"
		  . ", logfile=$opt_l" );

	###Load software lpar data
	my $loader = new BRAVO::SoftwareLoader();
	$loader->load(
		TestMode        => $opt_t,
		LoadDeltaOnly   => $opt_d,
		ApplyChanges    => $opt_a,
		MaxLparsInQuery => $opt_m,
		FirstId         => $opt_b,
		LastId          => $opt_e
	);

	ilog(
"stopping child: testMode=$opt_t, loadDeltaOnly=$opt_d, applyChanges=$opt_a"
		  . ", maxLparsInQuery=$opt_m, firstId=$opt_b, lastId=$opt_e"
		  . ", logfile=$opt_l" );
};
if ($@) {
	elog($@);
	die $@;
}

exit 0;
