#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Base::Utils;
use Base::ConfigManager;
use Tap::NewPerl;
use Database::Connection;
use BRAVO::Archive::Archive;
use BRAVO::OM::Customer;

$| = 1;

our ( $opt_b, $opt_l, $opt_c, $opt_t );
getopts("b:l:c:t:");
usage()
  unless (    defined $opt_b
           && defined $opt_l
           && defined $opt_c
           && defined $opt_t );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";
                        
my $ageDaysArchive = 365;
my $ageDaysDelete  = $ageDaysArchive + 1;

my $connection = Database::Connection->new('trails');
my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
my $today = sprintf( "%04d-%02d-%02d", ( $year + 1900 ), ( $mon + 1 ), $mday );

eval {

    my $cfgMgr = Base::ConfigManager->instance($opt_c);

    logfile($opt_l);
    logging_level( $cfgMgr->debugLevel );

    my $customer = new BRAVO::OM::Customer();
    $customer->id($opt_b);
    $customer->getById($connection);
    dlog( $customer->toString );
    

    dlog('Creating new archive object');
    my $archive = new BRAVO::Archive::Archive(
                                               $connection,  $cfgMgr->testMode, $customer,
                                               $ageDaysDelete
                                            
    );
    dlog('Archive object created');

    dlog('Calling the archive method');
    $archive->archive;
    dlog('Archive method complete');
};
if ($@) {
    elog($@);
    $connection->disconnect();
    die $@;
}

$connection->disconnect();

exit 0;

sub usage {
    print "bravoArchivalChild.pl -b <customerId>  -l <logfile> -c <configFile> -t <testMode>\n";
    exit 0;
}
