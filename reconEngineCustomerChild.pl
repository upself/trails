#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Recon::ReconEngineCustomer;
use Base::ConfigManager;
use Tap::NewPerl; 

###Check usage.
use vars qw( $opt_t $opt_a $opt_c $opt_l $opt_f );
getopts("t:a:c:l:f:");
die "Usage: $0" . " -t <test-mode> -a <apply-changes> -c <customer-id>" . " -l <logfile> -f <configFile>\n"    
  unless (    defined $opt_t
           && defined $opt_a
           && defined $opt_c
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

    ilog(   "starting customer child: testMode=$opt_t"
          . ", applyChanges=$opt_a"
          . ", customerId=$opt_c"
          . ", logfile=$opt_l" 
          . ", configFile=$opt_f");

    ###Call recon engine for this customer id.
    my $reconEngine = new Recon::ReconEngineCustomer($opt_c);
    $reconEngine->recon;

    ilog(   "stopping customer child: testMode=$opt_t"
          . ", applyChanges=$opt_a"
          . ", customerId=$opt_c"
          . ", logfile=$opt_l" 
          . ", configFile=$opt_f");
};
if ($@) {
    elog($@);
    die $@;
}

exit 0;
