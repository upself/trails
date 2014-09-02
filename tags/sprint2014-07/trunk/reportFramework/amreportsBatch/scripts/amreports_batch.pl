#!/usr/local/bin/perl -w

#
# Change Log:
# Date, Action, By, Email
# ----, ------, --, -----
# 2007/08/25, created, brent lamm, lamm@us.ibm.com
#

#
# TODO:
# - enhance methodology for preventing multiple copies
#   of this script running concurrently
#

#
# configuarble params
#
use vars qw( $cndb_db $cndb_schema $reports_dir $batch_dir $report_tmp_file );
my $conf_file = "/opt/amreports/conf/amreports.ph";
require "$conf_file";

#
# modules
#
use strict; 
use DBI;
use TAP::DBConnection;
use MIME::Lite;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

#
# globals
#
my $lock = "/tmp/amreports_batch.lck";
my $log = "/var/amreports/logs/amreports_batch.log";

#
# main
#
$| = 1;
umask 0133;
exit 0 if -e "$lock";
open(LOCK, ">$lock") or die "ERROR: Unable to write lock file $lock: $!";
close(LOCK);
open(LOG, ">$log") or die "ERROR: Unable to write log file $log: $!";
print LOG "### starting\n";
opendir(REPORTS, $batch_dir)
    or die "ERROR: Unable to read batch dir $batch_dir: $!";
while (defined(my $file = readdir(REPORTS))) {
    next unless $file =~ m/\.batch$/;
    print LOG "found batch: $file\n";
    my ($email, $report, $acct_id, $time) = split(/\~/, $file);
    require "$reports_dir/$report.pm";
    my $db = AMReport::database();
    my $schema = AMReport::schema();
    my $sql;
    if (AMReport::report_type() eq "customer") {
        my $cndb = new DBConnection();
        $cndb->setDatabase($cndb_db);
        $cndb->connect();
        $cndb->getDbh->do("set current schema $cndb_schema");
        my @rs = exec_sql_rs($cndb->getDbh,
            "select
                c.customer_id
                ,ct.customer_type_name
            from customer c
            join customer_type ct on ct.customer_type_id = c.customer_type_id
            where account_number = $acct_id");
        $cndb->disconnect();
        $sql = AMReport::sql($rs[1][0], $rs[1][1]);
        $sql =~ s/\?/$rs[1][0]/g;
    }
    print LOG "db=$db, schema=$schema, sql=$sql\n";
    open(TMP, ">$report_tmp_file")
        or die "ERROR: Unable to write file $report_tmp_file: $!";
    my $cnct = new DBConnection();
    $cnct->setDatabase($db);
    $cnct->connect();
    $cnct->getDbh->do("set current schema $schema");
    foreach my $row (exec_sql_rs($cnct->getDbh, $sql)) {
        for my $col (0 .. $#{$row}) {
            my $s = (defined $row->[$col]) ? $row->[$col] : '';
            print TMP "\t" if $col > 0;
            print TMP $s;
        }
        print TMP "\r\n";
    }
    $cnct->disconnect();
    close(TMP);
    my $zip = Archive::Zip->new();
    my $file_member = $zip->addFile("$report_tmp_file", "$report.$acct_id.tsv");
    unless ( $zip->writeToFileNamed("$report_tmp_file.zip") == AZ_OK ) {
        die 'ERROR: Failed to zip to file: $report_tmp_file.zip !!';
    }
    my $msg = MIME::Lite->new(
        From     => "assetmgmt\@tap.raleigh.ibm.com",
        To       => "$email",
        Subject  => "$report for CNDB Account Id: $acct_id",
        Type     => "multipart/mixed",
    );
    $msg->attach(
        Type     => "application/zip",
        Path     => "$report_tmp_file.zip",
        Filename => "$report.$acct_id.zip",
        Disposition => "attachment"
    );
    $msg->send();
    unlink "$report_tmp_file" or die "ERROR: Unable to remove file $report_tmp_file: $!";
    unlink "$batch_dir/$file" or die "ERROR: Unable to remove file $batch_dir/$file: $!";
    print LOG "completed batch: $file\n";
}
closedir(REPORTS);

unlink "$lock" if -e "$lock";
close(LOG);

exit 0;

#
# subroutines
#

# sql helper
sub exec_sql_rs {
    my $dbh = shift;
    my $sql = shift;
    my @rs = ();
    eval {
        my $sth = $dbh->prepare($sql);
        $sth->execute();
        push @rs, [ @{ $sth->{NAME} } ];
        while (my @row = $sth->fetchrow_array()) {
            push @rs, [ @row ];
        }
        $sth->finish();
    };
    if ($@) {
        $dbh->rollback();
        die "Unable to execute sql command ($sql): $@\n";
    }
    return @rs;
}
