#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Base::Utils;
use Base::ConfigManager;
use Tap::NewPerl;
use Database::Connection;
use BRAVO::OM::Customer;
use DBI qw(:sql_types);

$| = 1;

our ( $opt_b, $opt_a, $opt_l, $opt_c );
getopts("b:a:l:c:");
usage()
  unless (    defined $opt_b
           && defined $opt_a
           && defined $opt_l
           && defined $opt_c
            );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
  or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
  or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
  or die "ERROR: Unable to direct STDERR to /dev/null: $!";
                
my $connection = Database::Connection->new('trails');
my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
my $today = sprintf( "%04d-%02d-%02d", ( $year + 1900 ), ( $mon + 1 ), $mday );

eval {

    my $cfgMgr = Base::ConfigManager->instance($opt_c);

    logfile($opt_l);
    logging_level( $cfgMgr->debugLevel );

    my $ageDaysDelete = trim($cfgMgr->ageDaysDelete);
    if (defined $opt_a){ $ageDaysDelete = trim($opt_a)};
    my $customerId = trim($opt_b);
    dlog(" the customer id is $customerId" );
    

    dlog('Declare parameters');
    my $deleteTotal ;
    my $escapeLine ;
    my $callstmt = "CALL DELETE_INSTSW(?,?,?,?)";
    
    dlog('Prepare the procedure');  
    $connection->prepareSqlQuery('deleteInstSw', $callstmt );
    my $sth = $connection->sql->{'deleteInstSw'};
    dlog('Bind input parameter number 1 and number 2');
    $sth->bind_param_inout(1, \$customerId,30, SQL_VARCHAR);
    $sth->bind_param_inout(2, \$ageDaysDelete,5, SQL_VARCHAR);
    dlog('Bind output parameter number 1');
    $sth->bind_param_inout (3, \$deleteTotal, 16, SQL_INTEGER);
    dlog('Bind output parameter number 2');
    $sth->bind_param_inout (4, \$escapeLine, 8, SQL_INTEGER);
    dlog('Executing query');
    $sth->execute();
    dlog('Executed query');
    mlog("Deleted amount of installed softwares for $customerId is $deleteTotal");
    if ($escapeLine ne 1) {
    	elog("There must be error when the procedure was executed , the escape line is $escapeLine .");
    }
    dlog('Closing statement handle');
    $sth->finish;
    dlog('Closed statement handle');

};
if ($@) {
    elog($@);
    $connection->disconnect();
    die $@;
}

$connection->disconnect();

exit 0;

sub usage {
    print "deleteinstalledSoftwareChild.pl -b <customerId> -a <ageDayDelete> -l <logfile> -c <configFile>\n";
    exit 0;
}
