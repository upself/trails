#!/usr/bin/perl -w
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: dbryson@us.ibm.com
# ========================================================

# Table definitions
#describe table bundle
#Column                         Type      Type
#name                           schema    name               Length   Scale Nulls
#------------------------------ --------- ------------------ -------- ----- -----
#SOFTWARE_ID                    SYSIBM    BIGINT                    8     0 No
#NAME                           SYSIBM    VARCHAR                 254     0 No
#ID                             SYSIBM    BIGINT                    8     0 No
#REMOTE_USER                    SYSIBM    VARCHAR                  64     0 No
#RECORD_TIME                    SYSIBM    TIMESTAMP                10     0 No
#STATUS                         SYSIBM    VARCHAR                  32     0 No
#

#describe table bundle_software
#Column                         Type      Type
#name                           schema    name               Length   Scale Nulls
#------------------------------ --------- ------------------ -------- ----- -----
#SOFTWARE_ID                    SYSIBM    BIGINT                    8     0 No
#BUNDLE_ID                      SYSIBM    BIGINT                    8     0 No
#ID                             SYSIBM    BIGINT                    8     0 No

# Indexes
#describe indexes for table bundle_software show detail
#Index                           Index              Unique         Number of
#schema                          name               rule           columns
# Column names
#------------------------------- ------------------ -------------- --------------
# ------------------------------------------------------------
#EAADMIN                         PKBUNDLESOFTWARE   P                           3
# +SOFTWARE_ID+BUNDLE_ID+ID

#EAADMIN                         IF1BUNDLESOFTWARE  U                           2
# +BUNDLE_ID+SOFTWARE_ID

#EAADMIN                         IF2BUNDLESOFTWARE  U                           1
# +ID

#describe indexes for table bundle show detail
#Index                           Index              Unique         Number of
#schema                          name               rule           columns
# Column names
#------------------------------- ------------------ -------------- --------------
# ------------------------------------------------------------
#EAADMIN                         PKBUNDLE           P                           3
# +SOFTWARE_ID+NAME+ID

#EAADMIN                         IF1BUNDLE          U                           1
# +ID

#EAADMIN                         IF2BUNDLE          U                           1
# +NAME



$| = 1;
#use strict;
###Modules
use strict;
use Getopt::Std;
use Base::Utils;
use Database::Connection;


###############################################################################
### Define Script Variables
###
###############################################################################
use vars qw (
    $opt_i 
    $opt_l
    $opt_r
    $opt_u
);

getopt("ilru");
my $bundleFile = "bundle_load.tsv";
my $logFile = "/var/staging/logs/loadBundle/bundle.log";
my $reportFile = "/opt/IBMIHS/htdocs/en_US/reports/temp/SWBundles.xls";
my $timeDate      = currentTimeStamp();

if ( $opt_l ) {
	$logFile = $opt_l;
}

if ( $opt_r && $opt_r eq 1 ) {
	 $opt_r = $reportFile;
} 

open LOG, ">>$logFile"; 

###Get bravo db connection
my $trailsconnection = Database::Connection->new('trails');
if ( !defined($trailsconnection) ) { exit; }
my $user = "LOADER";

if ( $opt_u ) {
	$user = $opt_u;
}

if ( $opt_i ) {
	$bundleFile = $opt_i;
	open( INPUTFILE, "<", $bundleFile ) or die "Cannot open $bundleFile";
	print LOG "*** $timeDate ***\n";
	print LOG "*** Opened $bundleFile *** \n";
	 $trailsconnection->prepareSqlQuery('insertBDsw',
	"INSERT INTO EAADMIN.bundle_software 
	( bundle_id, software_id ) 
	VALUES (?, ?);"
	);
	my $insert_bundle_software = $trailsconnection->sql->{insertBDsw};
#	$remove_bundle_software = $trailsconnection->prepare("delete from eaadmin.bundle_software where id = ?");
#	$inactivate_bundle = $trailsconnection->prepare("update eaadmin.bundle set (status, remote_user, record_time) = 
#	('INACTIVE', $user, CURRENT TIMESTAMP) where id = ?)");
	$trailsconnection->prepareSqlQuery('selectBDsw',"select eaadmin.bundle_software.id from eaadmin.bundle_software where software_id = ?
	and eaadmin.bundle_software.bundle_id = ?");
	my $select_bundle_software = $trailsconnection->sql->{selectBDsw};

	 $trailsconnection->prepareSqlQuery('insertBD',
	"INSERT INTO EAADMIN.bundle 
	( id, software_id, name, remote_user, record_time, status ) 
	VALUES (?, ?, ?, ?, CURRENT TIMESTAMP, 'ACTIVE');");
	my $insert_bundle = $trailsconnection->sql->{insertBD};
	
	$trailsconnection->prepareSqlQuery('getSWid',"select p.id from product_info pi, product p, software_item si, kb_definition kb where pi.id=p.id and p.id=si.id and si.id=kb.id and kb.deleted!=1 and pi.licensable=1 and ucase(si.name) = ? order by si.product_role desc");
    my $getSoftwareId = $trailsconnection->sql->{getSWid};
    
	my $max = 0;
	my $sqlCmd = "SELECT MAX(id) + 1 from EAADMIN.bundle";

	 $trailsconnection->prepareSqlQuery('sqlcmd',$sqlCmd);
	 my $sth = $trailsconnection->sql->{sqlcmd};
	 $sth->execute();

	while ( my @row = $sth->fetchrow_array() ) {
		if ( !defined( $row[0] ) ) {
			$max = 1;
		}
		else {
			$max = $row[0];
		}
	}
	$sth->finish;
	print LOG "Bundle $max \n";
	my $bundle_id = $max;

#	$max = 0;
#	my $sqlCmd2 = "SELECT MAX(id) + 1 from EAADMIN.bundle_software";
#
#	$sth = $trailsconnection->prepare($sqlCmd2);
#	$sth->execute();
#
#	while ( my @row = $sth->fetchrow_array() ) {
#		if ( !defined( $row[0] ) ) {
#			$max = 1;
#		}
#		else {
#			$max = $row[0];
#		}
#	}
#	$sth->finish;
#	print "Next bundle_software id " . $max . "\n";
#	$bundle_software_id = $max;
#	#exit;
	my $count = 0;
				$trailsconnection->prepareSqlQuery('selectBD',
		"select id from eaadmin.bundle where eaadmin.bundle.software_id = ?;" );
		my $select_bundle = $trailsconnection->sql->{selectBD};
		  	    $trailsconnection->prepareSqlQuery('selectBDname',
		"select id from eaadmin.bundle where eaadmin.bundle.name = ?;" );
		my $select_bundleByName = $trailsconnection->sql->{selectBDname};
LINE:	while (<INPUTFILE>) {
		# $trailsconnection->commit;
		chomp;
		$count++;
		my (@fields) = split /\t/;
		my $parentName = uc($fields[0]);
		my $childName   = uc($fields[1]);
		# not going to do any deletes right now
#		$deleteFlag    = $fields[2];
		my $deleteFlag = "";
		my $parentId = 0;
		my $childId = 0;
		
		if ( $parentName eq $childName ) {
			print LOG "Parent Name: $parentName == $childName -- not processing line $count \n";
			next LINE;
		}
		
		 $getSoftwareId->execute($parentName);
		if ( my @row = $getSoftwareId->fetchrow_array() ) {
			$parentId = $row[0];
			print LOG "Found Parent: $parentName software_id $parentId line $count \n";
		} else {
			print LOG "Did not find Parent: $parentName in active software table -- not processing line $count\n";
			$getSoftwareId->finish;
			next LINE;
		}
		$getSoftwareId->finish;
		$getSoftwareId->execute($childName);
		if ( my @row = $getSoftwareId->fetchrow_array() ) {
			$childId = $row[0];
			print LOG "Found Child: $childName software_id $childId line $count \n";
		} else {
			print LOG "Did not find Child: $childName in active software table -- not processing line $count\n";
			$getSoftwareId->finish;
			next LINE;
		}
		$getSoftwareId->finish;

		$select_bundle->execute($parentId);
		my $bundleId = 0;
		if ( my @row = $select_bundle->fetchrow_array() ) {
			$bundleId = $row[0];
			print LOG "Using existing bundle $bundleId at line $count -- found by software_id\n";
			$select_bundle->finish;
		} else {
			$select_bundle->finish;
			# check to see if it is in there by name
			$select_bundleByName->execute($parentName);
			if ( my @row = $select_bundleByName->fetchrow_array() ) {
				$bundleId = $row[0];
				print LOG "Using existing bundle $bundleId at line $count -- found by name\n";
			} else {
				print LOG "We will need to add this bundle at line $count.\n"
			}
			$select_bundleByName->finish;
			
		}
		
		# if deleteFlag is blank then this is an add
		if ( ! defined($deleteFlag) || $deleteFlag eq "" ) {
			if ( $bundleId == 0 ) {
				my $rc = $insert_bundle->execute($bundle_id, $parentId, $parentName, $user );
				#$trailsconnection->commit;
				if ( $rc == 1 ) {
					print LOG "Parent: $parentName not in system -- added -- line $count .\n";
					$bundleId = $bundle_id;
					$bundle_id++;
					#$trailsconnection->commit;
					$insert_bundle->finish;			
				} else {
					print LOG "Attemped to add Parent: $parentName but failed. aborting load at line $count \n";
					$insert_bundle->finish;
					next LINE;
					# exit;
				}
			}
			print LOG "Attempting add for child $childName line $count \n";
			# check to make sure this bundled software doesn't already exist
			$select_bundle_software->execute($childId, $bundleId);
			if ( my @row = $select_bundle_software->fetchrow_array() ) {
				print LOG "Parent: $parentName Child: $childName Line: $count already exists in database.\n";
				$select_bundle_software->finish;
			} else {
				$select_bundle_software->finish;
				my $rc = $insert_bundle_software->execute($bundleId, $childId);
				if ( $rc == 1 ) {
					print LOG "Added $parentName / $childName line $count \n";
					#$trailsconnection->commit;
					$insert_bundle_software->finish;									
				} else {
					print LOG "Fatal error attempted to add child: $childName failure.\n";
					#exit;
					$insert_bundle_software->finish;									
					next LINE;
				}
			}
			
			
		} else {
			print LOG "This is a delete/INACTIVATE.\n";
			if ( $deleteFlag eq "D" ) {
				print LOG "Deleting the child record.\n";
			} elsif ( $deleteFlag eq "I" ) {
				print LOG "Inactivating the entire bundle.\n";
			} else {
				print LOG "Invalid Delete/INACTIVATE flag. $deleteFlag \n";
			}
		}
		
	}
}
elsif ( $opt_r ) {
	print "Reporting all the defined bundles \n";
	my $bundleSql = "select eaadmin.bundle.name as bundle_name, bs.NAME as parent_name, s.name as child_name, 
	eaadmin.bundle.status, eaadmin.bundle.record_time, eaadmin.bundle.remote_user
	from software_item s, software_item bs, EAADMIN.BUNDLE, EAADMIN.BUNDLE_SOFTWARE
	where eaadmin.bundle_software.bundle_id = eaadmin.bundle.id
	and eaadmin.bundle.software_id = bs.ID
	and eaadmin.bundle_software.software_id = s.id";
	$trailsconnection->prepareSqlQuery('bundlesql',$bundleSql);
	my $sth = $trailsconnection->sql->{bundlesql};
	$sth->execute();
	open REPORT, ">$opt_r"; 
	
	print REPORT "Report created at $timeDate \n";
	print REPORT "Bundle Name\tParent Software\tChild Name\tStatus\tLast Update\tUser\n";

	while ( my @row = $sth->fetchrow_array() ) {
		print REPORT $row[0] . "\t" . $row[1] . "\t" . $row[2] . "\t" . $row[3] . "\t" . $row[4] . "\t" . $row[5] ."\n";
	}
	$sth->finish();
	close REPORT;
}
else {
	usage();
}

#$trailsconnection->commit;
my $rc = $trailsconnection->disconnect or warn $trailsconnection->dbh->errstr;
print LOG "Disconnected from DB with $rc\n";
close LOG;



sub usage {
    print "$0 -i <to import load_bundle.tsv> -r <create active_bundles.tsv> \n";
    exit 0;
}