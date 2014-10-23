#!/usr/bin/perl -w

use strict;
use POSIX;
use Base::Utils;
use Report::Recon::PendingCustomerDecisionByGeoRegionCountryAccountGen;
use Tap::NewPerl; 

### Globals
my $logfile = "/var/staging/logs/pendingCustomerDecision/pendingCustomerDecisionByGeoRegionCountryAccount.log";
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
    my $pendingCustomerDecisionByGeoRegionCountryAccount = new Report::Recon::PendingCustomerDecisionByGeoRegionCountryAccountGen();
    dlog('Pending customer decision by geo, region, country and account created');

    $pendingCustomerDecisionByGeoRegionCountryAccount->genReport();
};

if ($@) {
    elog($@);
    die $@;
}

exit 0;
