#!/usr/bin/perl -w
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: zhysz@cn.ibm.com
# ========================================================

#describe table eaadmin.swasset_queue

#                                Data type                     Column
#Column name                     schema    Data type name      Length     Scale Nulls
#------------------------------- --------- ------------------- ---------- ----- ------
#ID                              SYSIBM    BIGINT                       8     0 No
#SOFTWARE_LPAR_ID                SYSIBM    BIGINT                       8     0 No
#CUSTOMER_ID                     SYSIBM    BIGINT                       8     0 No
#HOSTNAME                        SYSIBM    VARCHAR                    255     0 No
#RECORD_TIME                     SYSIBM    TIMESTAMP                   10     0 Yes
#REMOTE_USER                     SYSIBM    VARCHAR                     64     0 Yes
#TYPE                            SYSIBM    VARCHAR                     16     0 No
#DELETED                         SYSIBM    SMALLINT                     2     0 No
#COMMENTS                        SYSIBM    VARCHAR                    255     0 Yes

$| = 1;

#use strict;
use Getopt::Std;
use Base::Utils;
use DBI;
use DBD::DB2::Constants;
use DBD::DB2 qw($attrib_int $attrib_char $attrib_float $attrib_date $attrib_ts);
$DBI::dbi_debug = 9;    # increase the debug output

###############################################################################
### Define Script Variables
###
###############################################################################
use vars qw (
  $opt_i
  $opt_r
  $opt_u
);

getopt("iru");
my $test_flag       = "PRODUCTION";
my $discrepancyFile = "Swasset_deletion.tsv";
my $logFile         = "/var/staging/logs/swassetDeletion/swassetDeletion.log";
my ( $swlparId, $swlparName, $customerId, $actNumber, $hostAndcn ,$timeDate) = @_;

if ( $test_flag eq "TESTING" ) {
	$SCHEMA          = "EAADMIN.";
	$trails_db       = "dbi:DB2:TEST_DB";
	$trails_user     = "donnie";
	$trails_password = "dec26new";
}
else {
	$SCHEMA          = "EAADMIN.";
	$trails_db       = "dbi:DB2:TRAILS";
	$trails_user     = "eaadmin";
	$trails_password = "Zum49tip";
}

open LOG, ">>$logFile";

# Connect to the softaudit database
$dbh = DBI->connect( "$trails_db", "$trails_user", "$trails_password" );
$dbh->{AutoCommit} = 0;    # enable transactions

# No DB2, then why do anymore? -- simple exit -- no DB2 then we should already know it
if ( !defined($dbh) ) { exit; }
print LOG "Have handle\n";

if ($opt_i) {
	$swassetFile = $opt_i;
	open( INPUTFILE, "<", $swassetFile ) or die "Cannot open $discrepancyFile";
	print LOG "Opened $discrepancyFile";
	$insert_swasset_queue = $dbh->prepare(
		"INSERT INTO EAADMIN.swasset_queue
(ID,SOFTWARE_LPAR_ID,CUSTOMER_ID,HOSTNAME,RECORD_TIME,REMOTE_USER,TYPE,DELETED,COMMENTS) VALUES ( DEFAULT,?,?,?,CURRENT TIMESTAMP,?,?,0,\'first time remove\');"
	);
	$update_swasset_queue = $dbh->prepare(
"UPDATE EAADMIN.swasset_queue SET REMOTE_USER=\'zhysz\@cn.ibm.com\',DELETED=0,COMMENTS=\'removed before\' 
	WHERE software_lpar_id=? and customer_id=? "
	);
	$select_swasset_queue = $dbh->prepare(
"SELECT ID,SOFTWARE_LPAR_ID,CUSTOMER_ID,HOSTNAME,RECORD_TIME,REMOTE_USER,TYPE,DELETED,COMMENTS from EAADMIN.swasset_queue
	WHERE software_lpar_id=? and customer_id=? with ur "
	);

	$get_swasset_software = $dbh->prepare(
		"SELECT sl.id as swlpar_id,sl.name as sl_name,
	cs.customer_id as customer_id,cs.account_number
FROM 
     EAADMIN.software_lpar sl 
JOIN EAADMIN.customer cs on sl.customer_id=cs.customer_id
where

     sl.status='ACTIVE'
AND cs.status ='ACTIVE'
AND cs.account_number=?
AND sl.name =? 
with ur"
	);

  LINE: while (<INPUTFILE>) {
		$dbh->commit;
		chomp;
		$count++;
		my (@fields) = split /\t/;
		$accountNumber    = trim( $fields[0] );
		$hostName = trim( $fields[1] );
		$requester     = trim( $fields[2] );
		$type          = trim( $fields[3] );
		$timeDate      = currentTimeStamp();

		print LOG "$timeDate \n";
		print LOG "$hostName \n";
		print LOG "$accountNumber \n";
		print LOG "$requester \n";
		print LOG "$type \n";

		 $get_swasset_software->execute( $accountNumber, $hostName );
		if ( my @row = $get_swasset_software->fetchrow_array() ) {

			$swlparId   = $row[0];
			$swlparName = trim( $row[1] );
			$customerId = $row[2];
			$actNumber  = $row[3];

			print LOG
			  "Found SoftwareLpar and  swlpar id: $swlparId  line $count \n";

			if ( defined $swlparId && defined $customerId ) {

				$select_swasset_queue->execute( $swlparId, $customerId );

				if ( my @ro = $select_swasset_queue->fetchrow_array() ) {
					print LOG
					  "******swLpar : $swlparId already in queue ******\n";
					if ( $ro[7] == 1 ) {
						print LOG
"******This lpar already was deleted before,\n Will update the deleted field in swasset queue, set deleted=0, comments=removed before,remote_user=zhysz\@cn.ibm.com ******\n";
						$rcc =
						  $update_swasset_queue->execute( $swlparId,
							$customerId );
						if ( $rcc == 1 ) {
							print LOG
"******Update swasset queue successfully! ******\n";
							$dbh->commit;

						}
						else {
							print LOG
							  "******Update swasset queue fail! ******\n";

						}
					}
					else {
						print LOG
"******swLpar : $swlparId already in queue and deleting \=0 ******\n";
					}

				}
				else {
					$rc = $insert_swasset_queue->execute(
						$swlparId,  $customerId, $swlparName,
						$requester, $type
					);

					if ( $rc == 1 ) {
						print LOG
"Swasset Software_lpar id : $swlparId added into queue successfully -- line $count .\n";
						$dbh->commit;

					}
					else {
						print LOG
"Attemped to add Swasset Software_lpar id : $swlparId into queue failed. aborting load at line $count \n";

					
					}

				}

			}

		}
		else {
			print LOG
"Did not find Swasset software combineId : $hostName$accountNumber, possibly this lpar has INACTIVEd --  processing line $count\n";

		}

        $select_swasset_queue->finish;
        $update_swasset_queue->finish;
        $insert_swasset_queue->finish;
		$get_swasset_software->finish;

		next LINE;
	}
}
else {
	usage();
}

$dbh->commit;


$rcc = $dbh->disconnect or warn $dbh->errstr;
$rc  = $dbh->disconnect or warn $dbh->errstr;
print LOG "Disconnected from DB with $rc\n";
close LOG;

sub usage {
	print "$0 -i <to import Swasset_deletion.tsv> \n";
	exit 0;
}

