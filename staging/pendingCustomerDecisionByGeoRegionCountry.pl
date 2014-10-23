#!/usr/bin/perl -w

use strict;
use POSIX;
use Base::Utils;
use Report::Recon::PendingCustomerDecisionByGeoRegionCountryGen;
use Tap::NewPerl; 

### Globals
my $logfile = "/var/staging/logs/pendingCustomerDecision/pendingCustomerDecisionByGeoRegionCountry.log";
my $server = 'tap';
my $testMode = 0;

### Validate server
die "!!! ONLY RUN THIS REPORT ON $server !!!\n"
    unless validateServer($server);

### Close handles to avoid console output
open( STDIN, "/dev/null" )
    or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
    or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
    or die "ERROR: Unable to direct STDERR to /dev/null: $!";

### Set the logging level
logging_level("error");

### Set the logfile
logfile($logfile);

### Wrap everything in an eval so we can capture in logfile.
eval {
    $| = 1;
    my $pendingCustomerDecisionByGeoRegionCountry = new Report::Recon::PendingCustomerDecisionByGeoRegionCountryGen();
    dlog('Pending customer decision by geo, region and country created');

    $pendingCustomerDecisionByGeoRegionCountry->genReport();
};

if ($@) {
    elog($@);
    die $@;
}

exit 0;
