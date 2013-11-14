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
from system_node
     join node on node.node_key = system_node.node_key
     join (select node_key, max(last_update_time) as my_time from system_node group by node_key) 
     as mapping on mapping.node_key = node.node_key and mapping.my_time = system_node.last_update_time
     join system on system.system_key = system_node.system_key
     left outer join (
SELECT  LP.FOSNAME as sid, 
        MAX(LP.FOSTYPE) as myfostype, 
        MAX(LP.FOSLASTBOOTDATE) as myfoslastbootdate,
        MAX(LP.FIQDATE) as myfiqdate,
        LP.FOSVERSION AS TSID
       FROM TIQHISTORY AS LP
       WHERE LP.FINVID = 1 AND LP.FOSNAME <> \'\' AND LP.FOSTYPE <> \'\' 
       GROUP BY LP.FOSNAME, LP.FINVID,LP.FOSVERSION
       ORDER BY SID, myfoslastbootdate
    ) as scan_table on scan_table.sid = system.sid
where node_type = \'LPAR\' ";

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
from system_node
     join node on node.node_key = system_node.node_key
     join (select node_key, max(last_update_time) as my_time from system_node group by node_key) 
     as mapping on mapping.node_key = node.node_key and mapping.my_time = system_node.last_update_time
     join system on system.system_key = system_node.system_key
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

my $sqlANZ = "select
     node.node_key
      ,lpar_name
      ,'' as objectId
      ,hw_model
      ,hw_serial
      ,node.last_update_time as effective_scanTime
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
from system_node
     join node on node.node_key = system_node.node_key
     join (select node_key, max(last_update_time) as my_time from system_node group by node_key) 
     as mapping on mapping.node_key = node.node_key and mapping.my_time = system_node.last_update_time
     join system on system.system_key = system_node.system_key
where node_type = \'LPAR\' ";

my $sqlLastFull = "with ur";
my $sqlLastDelta = " and node.last_update_time > ?  with ur";

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

sub getCorrectSQL {
    my ($self, $infra, $delta) = @_;
    if ( $infra eq 'AG' ) {
        return $sqlAG . (($delta == 1) ?  $sqlLastDelta : $sqlLastFull );
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

