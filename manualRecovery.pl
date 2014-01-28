#!/usr/bin/perl -w

use strict;
use Tap::NewPerl;
use Base::Utils;
use Base::ConfigManager;
use Getopt::Std;
use Database::Connection;
use BRAVO::OM::Customer;
use Recon::Recover::Recovery;
use CNDB::Delegate::CNDBDelegate;

###Globals
my $logfile    = "/var/staging/logs/manualRecovery/manualRecovery.log";
my $configFile = "/opt/staging/v2/config/manualRecoveryConfig.txt";

###Initialize properties
my $cfgMgr    = Base::ConfigManager->instance($configFile);
my $reportDir = '/var/http_reports/manualRecovery';

###Validate server
die "!!! ONLY RUN THIS LOADER ON " . $cfgMgr->server . "!!!\n"
    unless validateServer( $cfgMgr->server );

###Set the logging level
logging_level( $cfgMgr->debugLevel );

###Set the logfile
logfile($logfile);

use vars qw( $opt_a $opt_h $opt_f $opt_m $opt_s $opt_e);
getopts("a:h:f:m:s:e");
usage() unless ( $opt_a || $opt_f );
usage() if ( $opt_a && $opt_f );
usage() if ( $opt_a && $opt_a !~ /\d+/ );
usage() unless $opt_m == 1 || $opt_m == 0;

my $data;

if ($opt_f) {
    $data = parseFile($opt_f);
}
else {
    $opt_h = '' if !defined $opt_h;
    $data->{$opt_a}->{$opt_h} = 1;
}

if (!defined $opt_s && !defined $opt_e) {
    $opt_s = '1970-01-01';
    $opt_e = substr currentTimeStamp(), 0, 10;
}

my $connection = Database::Connection->new('trails');

foreach my $accountNumber ( keys %{$data} ) {
    dlog("accountNumber: $accountNumber");

    my $reportFile = $reportDir . "/$accountNumber";

    my $customerId
        = CNDB::Delegate::CNDBDelegate->getCustomerIdByAccountNumber(
                                                             $connection,
                                                             $accountNumber );

    my $customer = new BRAVO::OM::Customer();
    $customer->id($customerId);
    $customer->getById($connection);
    dlog( $customer->toString );

    my $recovery
        = new Recon::Recover::Recovery( $connection, $cfgMgr->applyChanges,
                                        $opt_m, $customer, $reportFile );

    foreach my $name ( keys %{ $data->{$accountNumber} } ) {
        next if $name eq '';
        $recovery->addToSoftwareLparNames($name);
    }
    $recovery->run( $opt_s, $opt_e );
}

sub parseFile {
    my $file = shift;

    my %data;

    open( FILE, "<$file" ) or die "Unable to read file $file: $!";
    while (<FILE>) {
        s/^\s+//g;
        s/\s+$//g;
        chomp;

        my @fields = split("\t");
        $fields[1] = '' if !defined $fields[1];
        $data{ $fields[0] }{ $fields[1] } = 1;
    }

    return \%data;
}

sub usage {
    print "manualRecovery -a <account> [-h <hostname>] [-f <file> -m 0/1 ] [-s startTime -e endTime]";
    print
        "-m 0 = will not restore manual breaks OR 1 = will resotre manaul breaks"
        ;   
    print
       " -s startTime -e endTime, open alerts within the time range"
        ;  
    exit 0;
}


