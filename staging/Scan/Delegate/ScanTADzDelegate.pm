package ScanTADzDelegate;

use strict;
use Base::Utils;
use Staging::OM::ScanRecord;

my %infrastructure = (
	"P0DDB2C", "AG",
	"EGN0DBS0", "EMEA",
	"AAZDDBEP", "ANZ",
		
);

my %techImgIdMap = ();

sub insertTechImgId {
	my ($self, $techImgId, $lparName, $customerId) = @_;
    $techImgIdMap{ $techImgId } = [ $lparName , $customerId];
	
}

#sql updated by GAM #TI40620-50622 and TRAC #471
#
# 2 July 2014 Ticket 471 Bob McCormack Bravo extract on TADz HW is changed to start with the system
#                                      table rather than the system_node to avoid duplicated hardware
#
my $sqlAG = "   select
  	       node.node_key
	      ,lpar_name
	      ,'' as objectId
	      ,hw_model
	      ,hw_serial
	      ,case when scan_table.myfostype is null then node.last_update_time
	      when scan_table.myfoslastbootdate >= scan_table.myfiqdate then scan_table.myfoslastbootdate
	      when scan_table.myfiqdate > scan_table.myfoslastbootdate then scan_table.myfiqdate
	      else node.last_update_time
	        end as effective_scanTime
	      ,0 as users
	      ,2 as authenticated
	      ,0 as isManual
	      ,0 as authProc
	      ,0 as processor
	      ,system.sid as osName
	      ,hw_type as osType
	      ,'' as osMajorVers
	      ,'' as osMinorVers
	      ,'' as osSubVers
	      ,node.last_update_time as osInstDate
	      ,'' as userName
	      ,'' as biosManufacturer
	      ,'' as biosModel
	      ,'' as computerAlias
	      ,'' as physicalTotalKb
	      ,'' as virtTotalKb
	      ,'' as physicalFreeKb
	      ,'' as virtFreeKb
              ,'' as biosDate
 	      ,'' as biosSerial
	      ,'' as sysUuid
	      ,system.sysplex as boardSerNum
	      ,'' as caseSerNum
	      ,system.smfid as caseAssetTag
	      , '' as extId
              , SCAN_TABLE.TSID as techImgId
	from system
        JOIN (                                                       
              SELECT SYSTEM_KEY, MAX(LAST_UPDATE_TIME)               
              AS MY_TIME FROM SYSTEM_NODE           
              GROUP BY SYSTEM_KEY )                                  
              AS M ON M.SYSTEM_KEY = SYSTEM.SYSTEM_KEY                    
        JOIN SYSTEM_NODE  AS SN                     
             ON SN.SYSTEM_KEY   = M.SYSTEM_KEY    
             AND M.MY_TIME = SN.LAST_UPDATE_TIME  
        JOIN NODE                             
             ON NODE.NODE_KEY       = SN.NODE_KEY 
	     left outer join (
	SELECT  LP.FOSNAME as sid,
	        MAX(LP.FOSTYPE) as myfostype,
	        MAX(LP.FOSLASTBOOTDATE) as myfoslastbootdate,
	        MAX(LP.FIQDATE) as myfiqdate,
	        LP.FOSVERSION AS TSID
	       FROM TIQHISTORY AS LP
	       WHERE LP.FINVID = 1 AND LP.FOSNAME <> \'\' AND LP.FOSTYPE <> \'\'
	       GROUP BY LP.FOSNAME, LP.FINVID, LP.FOSVERSION
	       ORDER BY SID, myfoslastbootdate
	    ) as scan_table on scan_table.sid = system.sid
	where node_type = \'LPAR\' "; 

# Revision 330: This SQL used to extract HW and LPAR
# information from TADz DBs. This revision changes the
# order of reading TADz Tables. It will only work against TADz # DBs which have been built or migrated at TADz V8.1 level.
# 
# Start with SYSTEM TABLE, as this has 1:1 relationship with
# real LPARs.  This points to SYSTEM_NODE TABLE (SYSTEM_KEY)
# which in turn points to the NODE TABLE (NODE_KEY) to acquire # HW information from SYSTEM TABLE also points to TLOGIQ TABLE #(SID) to obtain scan time.
#
# In addition we now supply iq.fosversion as the osMajorVer
# value. It is the VV.RR.MM of the currently running level of
# z/OS. TLOGIQ.FOSVERSION is defined a CHAR(8). This is to
# support MIPS value determination in conjunction with
# processor model and type. A MIPS value is used some ISV
# licences.
#
# For AG, we also need to populate the techImId with a TSID
# value which is held in the last 4 characters of the
#  TLOGIQ.FVERSIONGKB field.
#
my $sqlAG81 =     "select node.node_key
						,node.lpar_name
						,'' as objectId
						,node.hw_model
						,node.hw_serial
						,audit_table.foqdate as effective_scanTime
						,0 as users
						,2 as authenticated
						,0 as isManual
						,0 as authProc
						,0 as processor
						,system.sid as osName
						,node.hw_type as osType
						,audit_table.osVers as osMajorVers
						,'' as osMinorVers
						,'' as osSubVers
						,node.last_update_time as osInstDate
						,'' as userName
						,'' as biosManufacturer
						,'' as biosModel
						,'' as computerAlias
						,'' as physicalTotalKb
						,'' as virtTotalKb
						,'' as physicalFreeKb
						,'' as virtFreeKb
						,'' as biosDate
						,'' as biosSerial
						,'' as sysUuid
						,system.sysplex as boardSerNum
						,'' as caseSerNum
						,system.smfid as caseAssetTag
						,'' as extId
						, audit_table.TSID as techImgId

						from system

						join (
						select system_key, max(last_update_time) as my_time from
						system_node
						group by system_key )
						as m on m.system_key = system.system_key

						join system_node sn
						on sn.system_key=m.system_key AND m.my_time=sn.last_update_time

						join node
						on node.node_key=sn.node_key

						join ( select iq.fsid, iq.fostype, SUBSTR(iq.fversiongkb ,12 ,4) as TSID, 
						max(fiqdate) as foqdate, MAX(iq.fosversion) as OsVers
						from tlogiq as iq
						where iq.fostype = \'z/OS\'
						and SUBSTR(iq.fversiongkb ,12 ,4) <> \'\'
						group by iq.fsid, iq.fostype, iq.fversiongkb 
						order by iq.fsid, iq.fostype, iq.fversiongkb  )
						as audit_table on audit_table.fsid = system.sid";

#sql updated by GAM #TI40620-50622 and TRAC #471
#
# 2 July 2014 Ticket 471 Bob McCormack Bravo extract on TADz HW is changed to start with the system
#                                      table rather than the system_node to avoid duplicated hardware
#
my $sqlEMEA = "select
        node.node_key
	      ,lpar_name
	      ,'' as objectId
	      ,hw_model
	      ,hw_serial
	      ,case when scan_table.myfostype is null then node.last_update_time
	      when scan_table.myfoslastbootdate >= scan_table.myfiqdate then scan_table.myfoslastbootdate
	      when scan_table.myfiqdate > scan_table.myfoslastbootdate then scan_table.myfiqdate
	      else node.last_update_time
	        end as effective_scanTime
	      ,0 as users
	      ,2 as authenticated
	      ,0 as isManual
	      ,0 as authProc
	      ,0 as processor
	      ,system.sid as osName
	      ,hw_type as osType
	      ,'' as osMajorVers
	      ,'' as osMinorVers
	      ,'' as osSubVers
	      ,node.last_update_time as osInstDate
	      ,'' as userName
	      ,'' as biosManufacturer
	      ,'' as biosModel
	      ,'' as computerAlias
	      ,'' as physicalTotalKb
	      ,'' as virtTotalKb
	      ,'' as physicalFreeKb
	      ,'' as virtFreeKb
              ,'' as biosDate
 	      ,'' as biosSerial
	      ,'' as sysUuid
	      ,system.sysplex as boardSerNum
	      ,'' as caseSerNum
	      ,system.smfid as caseAssetTag
	      , '' as extId
              , SYSTEM.SID as techImgId
	from system
        JOIN (                                                       
              SELECT SYSTEM_KEY, MAX(LAST_UPDATE_TIME)               
              AS MY_TIME FROM SYSTEM_NODE           
              GROUP BY SYSTEM_KEY )                                  
              AS M ON M.SYSTEM_KEY = SYSTEM.SYSTEM_KEY                    
        JOIN SYSTEM_NODE  AS SN                     
             ON SN.SYSTEM_KEY   = M.SYSTEM_KEY    
             AND M.MY_TIME = SN.LAST_UPDATE_TIME  
        JOIN NODE                             
             ON NODE.NODE_KEY       = SN.NODE_KEY 
	     left outer join (
	SELECT  LP.FOSNAME as sid,
	        MAX(LP.FOSTYPE) as myfostype,
	        MAX(LP.FOSLASTBOOTDATE) as myfoslastbootdate,
	        MAX(LP.FIQDATE) as myfiqdate,
	        LP.FOSVERSION AS TSID
	       FROM TIQHISTORY AS LP
	       WHERE LP.FINVID = 1 AND LP.FOSNAME <> \'\' AND LP.FOSTYPE <> \'\'
	       GROUP BY LP.FOSNAME, LP.FINVID, LP.FOSVERSION
	       ORDER BY SID, myfoslastbootdate
	    ) as scan_table on scan_table.sid = system.sid
	where node_type = \'LPAR\' ";

# Revision 330: This SQL used to extract HW and LPAR
# information from TADz DBs. This revision changes the
# order of reading TADz Tables. It will only work against TADz # DBs which have been built or migrated at TADz V8.1 level.
# 
# Start with SYSTEM TABLE, as this has 1:1 relationship with
# real LPARs.  This points to SYSTEM_NODE TABLE (SYSTEM_KEY)
# which in turn points to the NODE TABLE (NODE_KEY) to acquire # HW information from SYSTEM TABLE also points to TLOGIQ TABLE #(SID) to obtain scan time.
#
# In addition we now supply iq.fosversion as the osMajorVer
# value. It is the VV.RR.MM of the currently running level of
# z/OS. TLOGIQ.FOSVERSION is defined a CHAR(8). This is to
# support MIPS value determination in conjunction with
# processor model and type. A MIPS value is used some ISV
# licences.
#
my $sqlEMEA81 = "select 
          		 node.node_key
 		       ,node.lpar_name
 		       ,'' as objectId
 		       ,node.hw_model
 		       ,node.hw_serial
 		       ,audit_table.fiqdate as effective_scanTime
 		       ,0 as users
 		       ,2 as authenticated
 		       ,0 as isManual
 		       ,0 as authProc
 		       ,0 as processor
 		       ,system.sid as osName
 		       ,node.hw_type as osType
 		       ,audit_table.fosversion as osMajorVers
 		       ,'' as osMinorVers
 		       ,'' as osSubVers
 		       ,node.last_update_time as osInstDate
 		       ,'' as userName
 		       ,'' as biosManufacturer
 		       ,'' as biosModel
 		       ,'' as computerAlias
 		       ,'' as physicalTotalKb
 		       ,'' as virtTotalKb
 		       ,'' as physicalFreeKb
 		       ,'' as virtFreeKb
 		       ,'' as biosDate
 		       ,'' as biosSerial
 		       ,'' as sysUuid
 		       ,system.sysplex as boardSerNum
 		       ,'' as caseSerNum
 		       ,system.smfid as caseAssetTag
 		       ,'' as extId
 		       , system.sid as techImgId
 		 from system 
 
 join (
  
 select system_key, max(last_update_time) as my_time from system_node
 group by system_key )
 
 as m on m.system_key =  system.system_key  
 
 join system_node sn 
 on sn.system_key=m.system_key AND m.my_time=sn.last_update_time 
 
 join node 
 on node.node_key=sn.node_key      
 
 left outer join ( select iq.fsid, iq.fostype, iq.fosversion, 
                          max(fiqdate) as fiqdate
                   from tlogiq as iq
                   where iq.fostype = 'z/OS'
                   group by iq.fsid, iq.fostype, iq.fosversion
                   order by iq.fsid, iq.fostype, iq.fosversion )
                   as audit_table on audit_table.fsid = system.sid
 where substr(YEAR(audit_table.fiqdate), 1, 2) = 20 ";

# Revision 330: This SQL used to extract HW and LPAR
# information from TADz DBs. This revision changes the
# order of reading TADz Tables. It will only work against TADz # DBs which have been built or migrated at TADz V8.1 level.
# 
# Start with SYSTEM TABLE, as this has 1:1 relationship with
# real LPARs.  This points to SYSTEM_NODE TABLE (SYSTEM_KEY)
# which in turn points to the NODE TABLE (NODE_KEY) to acquire # HW information from SYSTEM TABLE also points to TLOGIQ TABLE #(SID) to obtain scan time.
#
# In addition we now supply iq.fosversion as the osMajorVer
# value. It is the VV.RR.MM of the currently running level of
# z/OS. TLOGIQ.FOSVERSION is defined a CHAR(8). This is to
# support MIPS value determination in conjunction with
# processor model and type. A MIPS value is used some ISV
# licences.
#
my $sqlANZ = "select 
          		 node.node_key
 		       ,node.lpar_name
 		       ,'' as objectId
 		       ,node.hw_model
 		       ,node.hw_serial
 		       ,audit_table.fiqdate as effective_scanTime
 		       ,0 as users
 		       ,2 as authenticated
 		       ,0 as isManual
 		       ,0 as authProc
 		       ,0 as processor
 		       ,system.sid as osName
 		       ,node.hw_type as osType
 		       ,audit_table.fosversion as osMajorVers
 		       ,'' as osMinorVers
 		       ,'' as osSubVers
 		       ,node.last_update_time as osInstDate
 		       ,'' as userName
 		       ,'' as biosManufacturer
 		       ,'' as biosModel
 		       ,'' as computerAlias
 		       ,'' as physicalTotalKb
 		       ,'' as virtTotalKb
 		       ,'' as physicalFreeKb
 		       ,'' as virtFreeKb
 		       ,'' as biosDate
 		       ,'' as biosSerial
 		       ,'' as sysUuid
 		       ,system.sysplex as boardSerNum
 		       ,'' as caseSerNum
 		       ,system.smfid as caseAssetTag
 		       ,'' as extId
 		       , system.sid as techImgId
 		 from system 
 
 join (
  
 select system_key, max(last_update_time) as my_time from system_node
 group by system_key )
 
 as m on m.system_key =  system.system_key  
 
 join system_node sn 
 on sn.system_key=m.system_key AND m.my_time=sn.last_update_time 
 
 join node 
 on node.node_key=sn.node_key      
 
 left outer join ( select iq.fsid, iq.fostype, iq.fosversion, 
                          max(fiqdate) as fiqdate
                   from tlogiq as iq
                   where iq.fostype = 'z/OS'
                   group by iq.fsid, iq.fostype, iq.fosversion
                   order by iq.fsid, iq.fostype, iq.fosversion )
                   as audit_table on audit_table.fsid = system.sid
 where substr(YEAR(audit_table.fiqdate), 1, 2) = 20 ";

my $sqlLastFull = "with ur";
my $sqlLastDelta = " and node.last_update_time > ?  with ur";
my $sqlLastDeltaAG81 = " where node.last_update_time > ?  with ur";

sub getTADzInfrastructure {
    my ($self, $bankAccount) = @_;
    
    if ( ! defined $bankAccount ) {
    	dlog ("Not passed bank account to getTAzInfrastructure");
    	return "ERROR";
    } 
    if ( (defined $bankAccount->databaseName) && ($bankAccount->databaseName gt "") ) {
    	if ( defined $infrastructure{$bankAccount->databaseName} ) {
    		return $infrastructure{$bankAccount->databaseName};
    	} else {
    		return "ERROR";
    	}
    }  
}
# Revision 330: This selection logic to determine which 
# SQL string to use for extracting DB2 data from TADz
# is enhanced to cater for both DBs at V7.5 and V8.1 levels
# The value of the VERSION field in the account's bank account
# will determine choice of V7.5 or V8.1 SQL.
# 
# We need this distinction as table TIQHISTORY in V7.5 is
# replaced with table TLOGIQ in V8.1
#  
sub getCorrectSQL {
	my ($self, $infra, $delta, $bankAccount) = @_;
	if ( ( $infra eq 'AG' ) && ( $bankAccount->version eq '8.1' )) {
		return $sqlAG81 . (($delta == 1) ?  $sqlLastDeltaAG81 : $sqlLastFull );
       } elsif ( $infra eq 'AG' ) {
		return $sqlAG . (($delta == 1) ?  $sqlLastDelta : $sqlLastFull );
	} elsif ( ( $infra eq 'EMEA' ) && ( $bankAccount->version eq '8.1' ) ) {
		return $sqlEMEA81 . (($delta == 1) ?  $sqlLastDelta : $sqlLastFull );
       } elsif ( $infra eq 'EMEA' ) {
		return $sqlEMEA . (($delta == 1) ?  $sqlLastDelta : $sqlLastFull );
	} elsif ( $infra eq 'ANZ' ) {
		return $sqlANZ . (($delta == 1) ?  $sqlLastDelta : $sqlLastFull );
	} else {
		return "ERROR";
	}
}


# final version of the code will load the hardware_lpar name/tech_img_id into the hash
# remember to pull ONLY unique ones that are 4 characters and hardware_lpar is valid
# and this needs to be an array with both lpar name and customer id
sub loadTechImgId {
	my ($self, $connection) = @_;
	
    $connection->prepareSqlQuery( $self->queryTechImgIdData() );
	
    my @fields = (qw(techImgId lparName customerId ));


    ###Get the statement handle
    my $sth = $connection->sql->{techImgIdData};

    ###Bind the columns
    my %rec = ();
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    dlog('Retrieving valid hardware tech_img_id map');
    $sth->execute();
    my $counter = 0;
    while ( $sth->fetchrow_arrayref ) {
    	$techImgIdMap{ $rec{techImgId} } = [ $rec{lparName} , $rec{customerId}];
    	++$counter;

    }
    
    $sth->finish;
    dlog("Loaded techImgId records: " . $counter);
    
	return $counter;

}

sub queryTechImgIdData {
    my $query = '
 select hardware_lpar.tech_image_id, hardware_lpar.name, hardware_lpar.customer_id
from hardware_lpar, hardware where hardware_lpar.hardware_id = hardware.id
and hardware.status = \'ACTIVE\' and hardware_lpar.status = \'ACTIVE\' and
hardware.hardware_status != \'HWCOUNT\' and hardware_lpar.lpar_status != \'HWCOUNT\'
and length(hardware_lpar.tech_image_id) = 4 and hardware_lpar.tech_image_id not in (
select tech_image_id from hardware_lpar group by tech_image_id having count(*) > 1) with ur;
    ';

    return ( 'techImgIdData', $query );
}

# check to see if the customer_id has been stored into the objectId and return it if it has else 0
sub getTSIDCustomerId {
	my ($self, $sr ) = @_;
	if ( defined $sr ) {
		if ( $sr->objectId =~ /CUSTOMER_ID/ ) {
			my $tmpVal = $sr->objectId;
			$tmpVal =~ s/CUSTOMER_ID//;
			return $tmpVal;
		} else {
			return 0;
		}
	} else {
		return 0;
	}
}

# accept a scanRecord and set lpar name based on the tsid
sub mapTSID {
	my ($self, $sr, $bankAccount ) = @_;
	# we shouldn't see this but let caller know if we do and log it
	if (! (defined $sr || defined $bankAccount) ) {
		dlog ("Passed empty TADz record or bankAccount to mapTSID function ");
		return "ERROR";
	} elsif ( (defined $sr->techImgId) && ($sr->techImgId gt "") ) {
		if ( length $sr->techImgId != 4 ) {
			dlog("Invalid techImgId -- not 4 characters");
			$sr->objectId($bankAccount->name);
			return "INVALID";
		}
		if ( defined $techImgIdMap{$sr->techImgId} ) {
			$sr->objectId("CUSTOMER_ID" . $techImgIdMap{$sr->techImgId}[1]);
			return $techImgIdMap{$sr->techImgId}[0];
		} else {
			dlog ("No match found for TSID " . $sr->techImgId );
			$sr->objectId($bankAccount->name);
			return "NO_MATCH";
		}
		
	} else {
			dlog ("Nothing to match ScanTADzDelegate::mapTSID");
			$sr->objectId($bankAccount->name);
		return "BLANK_TSID";
	}
}

1;
