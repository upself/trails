#!/usr/bin/perl -w
#
# IBM Confidential -- INTERNAL USE ONLY
# programmer: zhysz@cn.ibm.com
# ========================================================

#describe table eaadmin.manual_queue

#                                Data type                     Column
#Column name                     schema    Data type name      Length     Scale Nulls
#------------------------------- --------- ------------------- ---------- ----- ------
#ID                              SYSIBM    BIGINT                       8     0 No    
#SOFTWARE_ID                     SYSIBM    BIGINT                       8     0 No    
#SOFTWARE_LPAR_ID                SYSIBM    BIGINT                       8     0 No    
#CUSTOMER_ID                     SYSIBM    BIGINT                       8     0 No    
#HOSTNAME                        SYSIBM    VARCHAR                    255     0 No    
#RECORD_TIME                     SYSIBM    TIMESTAMP                   10     0 Yes   
#REMOTE_USER                     SYSIBM    VARCHAR                     64     0 Yes   
#DELETED                         SYSIBM    SMALLINT                     2     0 No    
#COMMENTS                        SYSIBM    VARCHAR                    255     0 Yes   





$| = 1;
#use strict;
use Getopt::Std;

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
    $opt_f
    $opt_u
);

getopt("ifu");
my $test_flag = "PRODUCTION";
my $discrepancyFile = "Discrepancy_deletion.tsv";
my $logFile = "/var/staging/logs/discreapancyDeletion/discrepancyDeletion.log";
my ($swlparId,$swlparName,$installedswId,$swId,	$swName,$customerId,$actNumber,$hostAndsw)=@_;
my ($swlparIdf,$swlparNamef,$installedswIdf,$swIdf,	$swNamef,$customerIdf,$actNumberf,$hostAndswf)=@_;

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
	$trails_password = "apr03db2";
}

open LOG, ">>$logFile"; 

# Connect to the softaudit database
$dbh = DBI->connect( "$trails_db", "$trails_user", "$trails_password" );
$dbh->{AutoCommit} = 0;    # enable transactions

# No DB2, then why do anymore? -- simple exit -- no DB2 then we should already know it
if ( !defined($dbh) ) { exit; }
print LOG "Have handle\n";

if ( $opt_i ) {
	$discrepancyFile = $opt_i;
	open( INPUTFILE, "<", $discrepancyFile ) or die "Cannot open $discrepancyFile";
	print LOG "Opened $discrepancyFile \n";
	$insert_manual_queue = $dbh->prepare(
	"INSERT INTO EAADMIN.manual_queue
(ID,SOFTWARE_ID,SOFTWARE_LPAR_ID,CUSTOMER_ID,HOSTNAME,RECORD_TIME,REMOTE_USER,DELETED,COMMENTS) VALUES ( DEFAULT,?,?,?,?,CURRENT TIMESTAMP,?,0,NULL);"
	);
	
    $update_manual_queue = $dbh->prepare(
	"UPDATE EAADMIN.manual_queue SET remote_user=?,deleted=0,comments='Removed again' WHERE software_id=? AND software_lpar_id=? AND customer_id=? "
	);

	$get_discrepancy_software = $dbh->prepare("SELECT sl.id as swlpar_id,sl.name as sl_name,is.id as installedsw_id,pd.id as sw_id,si.name as sw_name,cs.customer_id as customer_id,cs.account_number,
sl.name||si.name as slsi_id
FROM EAADMIN.installed_software is 
JOIN EAADMIN.product pd       on is.software_id = pd.id
JOIN EAADMIN.software_item  si  on pd.id = si.id
JOIN EAADMIN.product_info  pi   on pd.id=pi.id
JOIN EAADMIN.kb_definition kbd  on pd.id=kbd.id
JOIN EAADMIN.software_lpar sl on sl.id=is.software_lpar_id
JOIN EAADMIN.customer cs on sl.customer_id=cs.customer_id
where
is.status='ACTIVE'
AND kbd.deleted<>1
AND sl.status='ACTIVE'
AND is.status='ACTIVE'
AND cs.status ='ACTIVE'
AND cs.account_number =?
AND sl.name||si.name =? 
with ur");

    $get_discrepancy_sw_lpar = $dbh->prepare("SELECT sl.id as swlpar_id,sl.name as sl_name,is.id as installedsw_id,pd.id as sw_id,si.name as sw_name,cs.customer_id as customer_id,cs.account_number,
sl.name||si.name as slsi_id
FROM EAADMIN.installed_software is 
JOIN EAADMIN.product pd       on is.software_id = pd.id
JOIN EAADMIN.software_item  si  on pd.id = si.id
JOIN EAADMIN.product_info  pi   on pd.id=pi.id
JOIN EAADMIN.kb_definition kbd  on pd.id=kbd.id
JOIN EAADMIN.software_lpar sl on sl.id=is.software_lpar_id
JOIN EAADMIN.customer cs on sl.customer_id=cs.customer_id
where
is.status='ACTIVE'
AND kbd.deleted<>1
AND sl.status='ACTIVE'
AND is.status='ACTIVE'
AND cs.status ='ACTIVE'
AND cs.account_number =?
AND sl.id=? 
with ur ");
    $get_manual_queue = $dbh->prepare("SELECT software_id,software_lpar_id,customer_id,deleted FROM EAADMIN.manual_queue 
    WHERE software_id=?
    AND software_lpar_id=?
    with ur");
	
	
LINE:	while (<INPUTFILE>) {
		$dbh->commit;
		chomp;
		$count++;
		my (@fields) = split /\t/;
		$accountNumber = $fields[0];
		$hostName   = $fields[1];
		$requester  = $fields[2];
		$softwareName   = $fields[3];

		print LOG  "$accountNumber \n" ;
		print LOG  "$hostName \n" ;
		print LOG  "$requester \n" ;
		print LOG  "$softwareName \n" ;

		if ( $accountNumber eq 'ACCOUNT' || $hostName eq 'HOSTNAME' || $softwareName eq 'OS' ) {
			print LOG "This is the title line, processing line $count \n";
			next LINE;
		}

		$combineId=$hostName.$softwareName;
		print LOG "$combineId";
		$get_discrepancy_software->execute($accountNumber,$combineId);
		if ( my @row = $get_discrepancy_software->fetchrow_array() )
		 {
  
			$swlparId = $row[0];
			$swlparName = $row[1];
			$installedswId = $row[2];
			$swId = $row[3];
			$swName = $row[4];
			$customerId = $row[5];
			$actNumber = $row[6];
			$hostAndsw = $row[7];
			print LOG "Found SoftwareLpar and SW, swlpar id: $swlparId ,software_id :$swId line $count \n";
			
			if (defined $opt_f && $opt_f eq '1' && defined $swlparId )
			{			
			 print LOG "It is full lpar deletion! \n";
     		 $get_discrepancy_sw_lpar->execute($actNumber,$swlparId);
               if ( my @frow = $get_discrepancy_sw_lpar->fetchrow_array() ) 
               {
               $swlparIdf = $frow[0];
			   $swlparNamef = $frow[1];
			   $installedswIdf = $frow[2];
			   $swIdf = $frow[3];
			   $swNamef = $frow[4];
			   $customerIdf = $frow[5];
			   $actNumberf = $frow[6];
			   $hostAndswf = $frow[7];
			     $get_manual_queue->execute($swIdf,$swlparIdf);
			     if ( my @qrow = $get_manual_queue->fetchrow_array() ) 
			     {
			     	$softwareId = $qrow[0];
			     	$softwLparId = $qrow[1];
			     	$custId = $qrow[2];
			     	$deleted = $qrow[3];
			     	if ( $deleted eq 0 ) 
			     	      {
			     	        print LOG "Discrepancy Software id : $softwareId already in queue  -- line $count .\n";
			            	next LINE;
			     	      } 
			     	      else {
			               	print LOG "Discrepancy Software id : $softwareId has been deleted before in queue , try to delete again -- line $count .\n";
			  		    
			                $rc = $update_manual_queue->execute($requester,$swIdf, $swlparIdf, $customerIdf);
		                	if ( $rc == 1 ) {
			        		print LOG "Discrepancy Software id : $swId updated into queue successfully -- line $count .\n";
			        		$dbh->commit;
			            	} else {
			          		print LOG "Attemped to update Discrepancy Software id : $swId into queue failed. aborting load at line $count \n";
			         		next LINE;
				        	# exit;
				                    }
			  
		        	       } 
			       } else {
			    
			                $rc = $insert_manual_queue->execute($swIdf, $swlparIdf, $customerIdf, $swlparNamef,$requester );
		    	     if ( $rc == 1 ) {
				        	print LOG "Discrepancy Software id : $swId added into queue successfully -- line $count .\n";
				        	$dbh->commit;
				      } else {
					     print LOG "Attemped to add Discrepancy Software id : $swId into queue failed. aborting load at line $count \n";
					     next LINE;
				     	# exit;
				       }
			        }
             }	
            
			}  
			 if ( !defined $opt_f && defined $swlparId ) 
			 {
			    	print LOG "It is only discrepancy software deletion! \n";
		            $get_manual_queue->execute($swId,$swlparId);
			      if ( my @qrow = $get_manual_queue->fetchrow_array() ) 
			      {
			     	$softwareId = $qrow[0];
			     	$softwLparId = $qrow[1];
			     	$custId = $qrow[2];
			     	$deleted = $qrow[3];
			     	    if ( defined $deleted && $deleted eq 0 )
			     	    {
			            	print LOG "Discrepancy Software id : $softwareId already in queue  -- line $count .\n";
			            	next LINE;
			          	} 
			          	else {
			            	print LOG "Discrepancy Software id : $softwareId has been deleted before in queue , try to delete again -- line $count .\n";
			  		    
			                $rc = $update_manual_queue->execute($requester,$swId, $swlparId, $customerId);
		                	if ( $rc == 1 ) {
			        		print LOG "Discrepancy Software id : $swId updated into queue successfully -- line $count .\n";
			        		$dbh->commit;
			            	} else {
			          		print LOG "Attemped to update Discrepancy Software id : $swId into queue failed. aborting load at line $count \n";
			         		next LINE;
				        	# exit;
			            	}
		        	       } 
			     } 
			     else  {
			    
			            $rc = $insert_manual_queue->execute($swId, $swlparId, $customerId, $swlparName,$requester );
		    	         if ( $rc == 1 ) {
				        	print LOG "Discrepancy Software id : $swId added into queue successfully -- line $count .\n";
				        	$dbh->commit;
				           } else {
				         	print LOG "Attemped to add Discrepancy Software id : $swId into queue failed. aborting load at line $count \n";
				        	next LINE;
				        	# exit;
				          }
			      }
			} else 
			{
				print LOG "No matching Discrepancy software found -- line $count .\n";
				next LINE;
			}
		} else {
			print LOG "Did not find Discrepancy software combineId : $hostName$softwareName not in active software table --  processing line $count\n";
			next LINE;
		}
     }
}
else {
	usage();
}

$dbh->commit;
$get_discrepancy_software->finish;
$get_discrepancy_sw_lpar->finish;
$get_manual_queue->finish;
$insert_manual_queue->finish;
$update_manual_queue->finish;
$rc = $dbh->disconnect or warn $dbh->errstr;
print LOG "Disconnected from DB with $rc\n";
close LOG;



sub usage {
    print "$0 -i <to import Discrepancy_deletion.tsv> -f <1 full lpar deletion \/0 discrepancy software deletion> \n";
    exit 0;
}

