#!/usr/bin/perl
# dbryson@us.ibm.com -- minimal script to execute a self-contained SQL script
# it tries to make all errors fatal 

use lib "/opt/reports/bin";

use Report;
use Getopt::Std;
use strict;

my $report = new Report();
$report->initReportingSystem;


use vars qw( $opt_s $opt_d $opt_r $opt_g $opt_f );
getopts("s:d:r:g:f:");
usage() unless ( defined $opt_s && defined $opt_d );

my $Database;
my $DatabaseUser;
my $DatabasePassword;

if ( $opt_d eq "stage" ) {
	$Database = $report->stageDatabase;
	$DatabaseUser = $report->stageDatabaseUser;
	$DatabasePassword = $report->stageDatabasePassword;
} elsif ( $opt_d eq "reporting" ) {
	$Database = $report->reportDatabase;
	$DatabaseUser = $report->reportDatabaseUser;
	$DatabasePassword = $report->reportDatabasePassword;
} elsif ( $opt_d eq "production" ) {
	$Database = $report->productionDatabase;
	$DatabaseUser = $report->productionDatabaseUser;
	$DatabasePassword = $report->productionDatabasePassword;
} else {
	print "The only allowable -d options are stage, reporting, or production -- you had $opt_d\n";
	exit;
}

if ( defined $opt_r ) {
	if ( ! defined $opt_f ) {
		print "You must define a file name to rotate if you use the -r option\n";
		exit;
	} elsif ( $opt_r == 1 ) {
		my $oldFile = $opt_g . $opt_f;
		my $newBak = $opt_g . $opt_f . ".BAK";
		system("cp $oldFile $newBak");
	} else {
		print "rotate was indicated as specificatlly not wanted\n";
	}
}

system("date");
system("db2 connect to $Database user $DatabaseUser using $DatabasePassword");
system("db2 set current schema eaadmin");
system("db2 -tvf $opt_s");
system("date");

if ( defined $opt_g ) {
	if ( ! defined $opt_f ) {
		print "You must define a file name to copy into GSA\n";
		exit;
	}
	system("cp $opt_f $opt_g");
	unlink($opt_f);
}

sub usage {
	print "$0 -s <sql_file> -d <database> -r <rotate> -g <gsadir to copy into> -f <output file name> \n";
	exit 0;
}

