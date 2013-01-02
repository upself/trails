#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use Recon::ReconEngineCustomer;
use Base::ConfigManager;
use Tap::NewPerl;
### example: 
### nohup ./reconEngineCustomerChild.pl -t 0 -a 1 -c 504 -d 12/31/2012 -p 0 -l /var/staging/logs/reconEngine/reconEngine.log.child.504  -f /opt/staging/v2/config/reconEngineConfig.txt &
###Check usage.
use vars qw( $opt_t $opt_a $opt_c $opt_l $opt_f $opt_d $opt_p);
getopts("t:a:c:l:f:d:p:");
die "Usage: $0"
  . " -t <test-mode> -a <apply-changes> -c <customer-id>"
  . " -l <logfile> -f <configFile> -p <pool> -d <date> \n"
  unless (
    defined $opt_t
 && defined $opt_a
 && defined $opt_c
 && defined $opt_l
 && defined $opt_f 
 && defined $opt_d 
 && defined $opt_p
  );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {
 my $cfgMgr = Base::ConfigManager->instance($opt_f);

 logfile($opt_l);
 logging_level( $cfgMgr->debugLevel );

 ilog("starting customer child: testMode=$opt_t"
    . ", applyChanges=$opt_a"
    . ", customerId=$opt_c"
    . ", logfile=$opt_l"
    . ", configFile=$opt_f"
    . ", pooled=$opt_p"
    . ", date=$opt_d" );

 ###Call recon engine for this customer id.
 my $reconEngine =
   new Recon::ReconEngineCustomer( $opt_c, $opt_d, $opt_p );
 $reconEngine->recon;

 ilog("stopping customer child: testMode=$opt_t"
    . ", applyChanges=$opt_a"
    . ", customerId=$opt_c"
    . ", logfile=$opt_l"
    . ", configFile=$opt_f"
    . ", pooled=$opt_p"
    . ", date=$opt_d" );
};
if ($@) {
 elog($@);
 die $@;
}

exit 0;
