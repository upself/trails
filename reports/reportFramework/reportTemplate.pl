#!/usr/bin/perl

# sample to show how to use the configuration file and basic info from the OS

use Config::Properties::Simple;
use File::Basename;

# getlogin will NOT work when ran from cron
my ($login, $pass, $uid, $gid) = getpwuid($<);

my $thisReportName = $0;
my $thisUser = $login;
my $profileFile = "/home/$thisUser" . "/report.properties";
my ($fileName, $fileDirectory) = fileparse($thisReportName, ".pl");
my $individualTempFileName = "MY_REPORT_TEMP_" . $fileName;

my $cfg = Config::Properties::Simple->new(file => $profileFile); 

my $stageDatabase = $cfg->getProperty('stageDatabase');
my $stageDatabaseUser = $cfg->getProperty('stageDatabaseUser');
my $stageDatabasePassword = $cfg->getProperty('stageDatabasePassword');

my $reportDatabase = $cfg->getProperty('reportDatabase');
my $reportDatabaseUser = $cfg->getProperty('reportDatabaseUser');
my $reportDatabasePassword = $cfg->getProperty('reportDatabasePassword');

my $db2profile = $cfg->getProperty('db2profile');
my $tmpDir = $cfg->getProperty("tmpDir");

my $gsaUser = $cfg->getProperty("gsaUser");
my $gsaPassword = $cfg->getProperty("gsaPassword");

print "My report name is $thisReportName\n";
print "Report is stored in $fileDirectory\n";
print "My user name is $thisUser\n";
print "My properties file $profileFile \n";
print "My own sample temp file would be $individualTempFileName\n";
print "My staging database name is $stageDatabase\n";
print "My staging database user is $stageDatabaseUser\n";
print "My staging database password is $stageDatabasePassword\n";
print "My report database name is $reportDatabase\n";
print "My report database user is $reportDatabaseUser\n";
print "My report database password is $reportDatabasePassword\n";
print "My DB2 profile is $db2profile\n";
print "My tmpDir is $tmpDir\n";
print "My gsaUser is $gsaUser\n";
print "my gsaPassword is $gsaPassword\n";
print "Attempting to validate GSA ID\n";
system ("echo $gsaPassword | gsa_login -c pokgsa -p $gsaUser");
print "Attempting to set DB2 profile\n";
system(". $db2profile");


