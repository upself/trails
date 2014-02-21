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

use vars qw( $opt_a $opt_h $opt_f $opt_m $opt_t $opt_s $opt_e);
getopts("a:h:f:m:t:s:e:");
usage() unless ( $opt_a || $opt_f );
usage() if ( $opt_a && $opt_f );
usage() if ( $opt_a && $opt_a !~ /\d+/ );
usage() unless $opt_m == 1 || $opt_m == 0;
usage() unless ($opt_s && $opt_e)||( !defined $opt_s && !defined $opt_e );

###Set the logfile
if ($opt_f){
	my @path = split('\/',$opt_f);
    $logfile = "/var/staging/logs/manualRecovery/ ". "$path[$#path]".".log";
}
logfile($logfile);

my $data;

if ($opt_f) {
	usage() unless ( $opt_f && $opt_t );
	usage() unless ( $opt_t eq 'LPAR' || $opt_t eq 'INSWID' );
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

if ( defined $opt_f && $opt_t eq 'INSWID' ){
    my @path = split('\/',$opt_f);
    my $reportFile = $reportDir . "/$path[$#path]";
    my $customer = '';
    my $name = '';
    my $recovery
        = new Recon::Recover::Recovery( $connection, $cfgMgr->applyChanges,
                                        $opt_m, $customer, $reportFile );
	$recovery->addToSoftwareLparNames($name);
	foreach my $installedSwId ( keys %{$data} ) {
    dlog("InstalledSoftwareId: $installedSwId");
        next if ( $installedSwId eq '' || $installedSwId  !~ /\d+/  ); 
        $recovery->addToInstalledSoftwareIds($installedSwId); 
  }
   $recovery->run( $opt_s, $opt_e );
	
} else {
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
    next if $customer eq '';
    my $recovery
        = new Recon::Recover::Recovery( $connection, $cfgMgr->applyChanges,
                                        $opt_m, $customer, $reportFile );

    foreach my $name ( keys %{ $data->{$accountNumber} } ) {
        next if $name eq '';
       
        $recovery->addToSoftwareLparNames($name);
    }
    $recovery->run( $opt_s, $opt_e );
 }
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
    print "manualRecovery [-a <account> -h <hostname>] [-f <file> -t [LPAR||INSWID] ] -m 0/1  [-s startTime -e endTime] \n";
      print
        "-t recovery level , by LPAR or Installed Software Ids , INSWID \n"
        ; 
    print
        "-m 0 = will not restore manual breaks OR 1 = will resotre manaul breaks \n"
        ;   
    print
       "-s startTime -e endTime, open alerts within the time range \n"
        ;  
    exit 0;
}


