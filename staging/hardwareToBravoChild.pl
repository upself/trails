#!/usr/bin/perl -w

###TODO: log this given batch if failed.

use strict;
use Getopt::Std;
use File::Copy;
use Base::Utils;
use BRAVO::HardwareLoader();
use Base::ConfigManager;
use Tap::NewPerl;

###Check usage.
use vars qw( $opt_t $opt_d $opt_a $opt_i $opt_l $opt_c );
getopts("t:d:a:i:l:c:");
die "Usage: $0"
    . " -d <load-delta-only> -a <apply-changes> "
    . " -i <customer-id> -l <logfile> -c <configFile>\n"
    unless ( defined $opt_d
             && defined $opt_a
             && defined $opt_i
             && defined $opt_l
             && defined $opt_c );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
    or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
    or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
    or die "ERROR: Unable to direct STDERR to /dev/null: $!";

eval {
    my $cfgMgr = Base::ConfigManager->instance($opt_c);

    logfile($opt_l);
    logging_level( $cfgMgr->debugLevel );

    ilog(   "starting child:loadDeltaOnly=$opt_d, applyChanges=$opt_a"
          . ", customerId=$opt_i"
          . ", logfile=$opt_l, configFile=$opt_c" );

    ###Load software lpar data
    my $loader = new BRAVO::HardwareLoader( $opt_d, $opt_a, $opt_i );
    $loader->load;

    ilog(   "stopping child: loadDeltaOnly=$opt_d, applyChanges=$opt_a"
          . ", customerId=$opt_i"
          . ", logfile=$opt_l, configFile=$opt_c" );
};
if ($@) {
    elog($@);
    die $@;
}

exit 0;

