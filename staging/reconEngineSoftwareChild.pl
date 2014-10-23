#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Recon::ReconEngineSoftware;
use Base::ConfigManager;
use Tap::NewPerl; 

###Check usage.
use vars qw( $opt_t $opt_a $opt_s $opt_l $opt_f);
getopts("t:a:s:l:f:");
die "Usage: $0"
  . " -t <test-mode> -a <apply-changes> -s <software-id>"
  . " -l <logfile>\n -f <configFile>"
  unless ( defined $opt_t
	&& defined $opt_a
	&& defined $opt_s
	&& defined $opt_l 
	&& defined $opt_f);

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {
    my $cfgMgr =  Base::ConfigManager->instance($opt_f);    

	logfile($opt_l);
	logging_level($cfgMgr->debugLevel);

	ilog(   "starting software child: testMode=$opt_t"
		  . ", applyChanges=$opt_a"
		  . ", softwareId=$opt_s"
          . ", logfile=$opt_l" 
          . ", configFile=$opt_f");

	###Call recon engine for this software id.
	my $recon = new Recon::ReconEngineSoftware($opt_s);
	$recon->recon;

	ilog(   "stopping software child: testMode=$opt_t"
		  . ", applyChanges=$opt_a"
		  . ", softwareId=$opt_s"
          . ", logfile=$opt_l" 
          . ", configFile=$opt_f");
};
if ($@) {
	elog($@);
	die $@;
}

exit 0;
