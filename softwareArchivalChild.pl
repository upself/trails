#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use Base::Utils;
use Base::ConfigManager;
use Tap::NewPerl;
use Database::Connection;
use BRAVO::OM::Software;
use BRAVO::Archive::ArchiveSoftware;

$| = 1;

our ( $opt_s, $opt_l, $opt_c, $opt_t );
getopts("s:l:c:t:");
usage()
    unless ( defined $opt_l
    && defined $opt_c
    && defined $opt_t
    && defined $opt_s );

###Close handles to avoid console output.
open( STDIN, "/dev/null" )
    or die "ERROR: Unable to direct STDIN to /dev/null: $!";
open( STDOUT, "/dev/null" )
    or die "ERROR: Unable to direct STDOUT to /dev/null: $!";
open( STDERR, "/dev/null" )
    or die "ERROR: Unable to direct STDERR to /dev/null: $!";

my $tmpDir    = "/var/bravo/archive";
my $gsaHost   = "pokgsa.ibm.com";
my $gsaUser   = "eaadmin";
my $gsaPasswd = "may11db2";
my $gsaDir    = "gsa/pokgsa/projects/a/amdata-archive/bravo";

my $connection = Database::Connection->new('trails');
my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday ) = localtime();
my $today
    = sprintf( "%04d-%02d-%02d", ( $year + 1900 ), ( $mon + 1 ), $mday );

eval {

    my $cfgMgr = Base::ConfigManager->instance($opt_c);

    logfile($opt_l);
    logging_level( $cfgMgr->debugLevel );

    my $software = new BRAVO::OM::Software();
    $software->id($opt_s);
    $software->getById($connection);
    dlog( $software->toString );

    my $archiveFile = "$tmpDir/" . $software->id . "_" . "$today.txt";

    dlog('Creating new archive object');
    my $archive = new BRAVO::Archive::ArchiveSoftware(
        $connection, $cfgMgr->testMode,
        $software, $archiveFile, $gsaHost,
        $gsaDir,   $gsaUser,     $gsaPasswd
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
    print
        "softwareArchivalChild.pl -s <softwareId> -l <logfile> -c <configFile> -t <testMode>\n";
    exit 0;
}
