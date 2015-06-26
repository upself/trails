package SWASSET::NewDataManager;

use strict;
use File::Find;
use File::Copy;
use File::Basename;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use Sigbank::Delegate::BankAccountDelegate;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SwassetQueue;
use BRAVO::OM::ManualQueue;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;

use Staging::OM::SoftwareLparMapNonObject;
use Staging::OM::ScanRecord;
use SWASSET::OM::Computer;
use SWASSET::OM::TLCMZComputer;
use SWASSET::OM::DoranaComputer;
use SWASSET::OM::ManualComputer;
use SWASSET::OM::InstalledManualSoftware;

###Object constructor.
sub new {
	my ($class) = @_;
	my $self = {
		_testMode          => undef,
		_applyChanges      => undef,
		_trailsConnection  => undef,
		_stagingConnection => undef,
		_swassetConnection => undef,
		_swassetQueue     => undef,
		_manualQueue      => undef
	};
	bless $self, $class;
	dlog("instantiated self");

	return $self;
}

###Primary method used by calling clients.
sub load {
	my ( $self, %args ) = @_;
	dlog("start load method");
	$self->checkArgs( \%args );
	my $job = 'SWASSET DATA MANAGER';

	my $systemScheduleStatus;
    $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);

	$self->trailsConnection( Database::Connection->new('trails') );
	$self->stagingConnection( Database::Connection->new('staging') );
	$self->swassetConnection( Database::Connection->new('swasset') );

	my $dieMsg;
	eval {
		$self->loadSwassetQueue;
 		$self->removeFromSwasset;
		$self->loadManualQueue;
		$self->removeFromManual;
	};
	if ($@) {
		elog($@);
		$dieMsg = $@;
		SystemScheduleStatusDelegate->error($systemScheduleStatus);
	}
	elsif( $self->applyChanges == 1 && !defined $dieMsg ) {
		SystemScheduleStatusDelegate->stop($systemScheduleStatus);
	}

	$self->trailsConnection->disconnect;
	$self->stagingConnection->disconnect;
	$self->swassetConnection->disconnect;

	###die if dieMsg is defined
	die $dieMsg if defined $dieMsg;

}

sub removeFromSwasset {
	my $self = shift;

	return if ( !defined $self->swassetQueue );

	foreach my $queue ( @{ $self->swassetQueue } ) {
	    ilog("Queue=" . $queue->type);
		my $softwareLpar = new BRAVO::OM::SoftwareLpar();
		$softwareLpar->id( $queue->softwareLparId );
		$softwareLpar->getById( $self->trailsConnection );
		ilog("Deleting " . $softwareLpar->toString);
		
		if(!defined $softwareLpar->name) {
		    $queue->comments("Software lpar not found in BRAVO");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    next;
		}
		my $bankAccountName = $self->getBankAccountName($queue->type);
		if(!defined $bankAccountName) {
		    $queue->comments("Bank account does not exist");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		}
		my $bankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName($bankAccountName);
		my $scanIds = $self->getScanIdsByCustomerByNameByBankAccountIdFromStaging($softwareLpar, $bankAccount->id );
		if(!defined $scanIds || keys%{$scanIds} ==0) {
		    ilog("No scans in staging for this bank account");
		    BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId($self->trailsConnection, $softwareLpar->id,$bankAccount->id );
		    $queue->comments("No scans found in staging");
		    $queue->deleted(1);
		    $queue->save($self->trailsConnection);
		    next;
		}
		$self->removeData($queue, $bankAccount, $scanIds, $softwareLpar);
	}
}

sub getBankAccountName {
    my($self,$queueType) = @_;
    my $bankAccountName;
    if ( $queueType eq 'TCM' ) {
        $bankAccountName = 'SWASSTDB';
    }
    elsif ( $queueType eq 'TLCMZ' ) {
        $bankAccountName = 'TLCMZ';
    }
    elsif ( $queueType eq 'DORANA' ) {
        $bankAccountName = 'DORANA';
    }
    return $bankAccountName;
}

sub removeData {
    my($self, $queue, $bankAccount, $scanIds, $softwareLpar) = @_;
    
    foreach my $softwareLparMapId ( keys %{$scanIds} ) {
        my $softwareLparMapNonObject = new Staging::OM::SoftwareLparMapNonObject();
        $softwareLparMapNonObject->id($softwareLparMapId);
        $softwareLparMapNonObject->getById($self->stagingConnection );
        dlog( $softwareLparMapNonObject->toString );
        if($softwareLparMapNonObject->action ne 'COMPLETE') {
            $queue->comments("Software lpar map not in complete");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    last;
        }

        my $stagingSoftwareLpar = new Staging::OM::SoftwareLpar();
        $stagingSoftwareLpar->id(
        $softwareLparMapNonObject->softwareLparId );
        $stagingSoftwareLpar->getById( $self->stagingConnection );
        dlog( $stagingSoftwareLpar->toString );
        if($stagingSoftwareLpar->action ne 'COMPLETE') {
            $queue->comments("Software lpar not in complete");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    last;
        }

        my $scanRecord = new Staging::OM::ScanRecord();
        $scanRecord->id( $scanIds->{$softwareLparMapId} );
        $scanRecord->getById( $self->stagingConnection );
        dlog( $scanRecord->toString );
        if($scanRecord->action ne 'COMPLETE') {
            $queue->comments("Scan record not in complete");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    last;
        }
    
        if($queue->isa("BRAVO::OM::ManualQueue")) {
            $self->removeManualSwassetData( $scanRecord->computerId,$queue->softwareId );
        }
        elsif ( $queue->type eq 'TCM' ) {
            $self->removeSwassetData($scanRecord->computerId);
        }
        elsif ( $queue->type eq 'TLCMZ' ) {
            $self->removeSwassetDataTLCMZ($scanRecord->computerId);
        }
        elsif ( $queue->type eq 'DORANA' ) {
            $self->removeSwassetDataDorana($scanRecord->computerId);
        }
        else {
            $queue->comments("Unknown queue type");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    last;
        }
        
        if($queue->isa("BRAVO::OM::ManualQueue")) {
            BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwareById($self->trailsConnection, $queue->softwareLparId,$queue->softwareId );
        }
        else {
            BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId($self->trailsConnection, $softwareLpar->id, $bankAccount->id );
        }
        $queue->comments("Data removed");
        $queue->deleted(1);
        $queue->save($self->trailsConnection);
    }
}

sub removeFromManual {
    my $self = shift;
	return if ( !defined $self->manualQueue );
	foreach my $queue ( @{ $self->manualQueue } ) {
		my $softwareLpar = new BRAVO::OM::SoftwareLpar();
		$softwareLpar->id( $queue->softwareLparId );
		$softwareLpar->getById( $self->trailsConnection );
		ilog("Deleting " . $softwareLpar->toString);
		
		if(!defined $softwareLpar->name) {
		    $queue->comments("Software lpar not found in BRAVO");
		    $queue->deleted(0);
		    $queue->save($self->trailsConnection);
		    next;
		}

		my $bankAccount = Sigbank::Delegate::BankAccountDelegate->getBankAccountByName('SWDISCRP');
		my $scanIds = $self->getScanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging($softwareLpar, $bankAccount->id, $queue->softwareId );
		if(!defined $scanIds || keys%{$scanIds} ==0) {
		    ilog("No scans in staging for this");
            BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwareById($self->trailsConnection, $queue->softwareLparId,$queue->softwareId );
		    $queue->comments("No scans found in staging");
		    $queue->deleted(1);
		    $queue->save($self->trailsConnection);
		    #next; #comment out here to remove empty lpar 
		}
		$self->removeData($queue, $bankAccount, $scanIds, $softwareLpar);
	}
}

sub getScanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging {
	my ( $self, $softwareLpar, $bankAccountId, $softwareId ) = @_;

	my %data;

	$self->stagingConnection->prepareSqlQueryAndFields(
		$self->queryScanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging() );
	my $sth = $self->stagingConnection->sql
	  ->{scanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging};
	my %rec;
	$sth->bind_columns(
		map { \$rec{$_} } @{
			$self->stagingConnection->sql
			  ->{scanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStagingFields}
		  }
	);
	$sth->execute( $softwareLpar->customerId, $softwareLpar->name,
		$bankAccountId, $softwareId );
	while ( $sth->fetchrow_arrayref ) {
		$data{ $rec{softwareLparMapId} } = $rec{scanRecordId};
	}
	$sth->finish;

	return \%data;
}

sub queryScanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging {
	my $self = shift;

	my @fields = qw(
	  softwareLparMapId
	  scanRecordId
	);

	my $query = '
        select
            b.id
            ,b.scan_record_id
        from
            software_lpar a
            ,software_lpar_map b
            ,scan_record c
            ,software_manual d
        where
            a.customer_id = ?
            and a.name = ?
            and c.bank_account_id = ?
            and a.id = b.software_lpar_id
            and b.scan_record_id = c.id
            and d.software_id = ?
            and d.scan_record_id = b.scan_record_id
    ';

	return ( 'scanIdsByCustomerByNameByBankAccountIdBySoftwareIdFromStaging', $query,
		\@fields );
}

sub getScanIdsByCustomerByNameByBankAccountIdFromStaging {
	my ( $self, $softwareLpar, $bankAccountId ) = @_;

	my %data;

	$self->stagingConnection->prepareSqlQueryAndFields(
		$self->queryScanIdsByCustomerByNameByBankAccountIdFromStaging() );
	my $sth = $self->stagingConnection->sql
	  ->{scanIdsByCustomerByNameByBankAccountIdFromStaging};
	my %rec;
	$sth->bind_columns(
		map { \$rec{$_} } @{
			$self->stagingConnection->sql
			  ->{scanIdsByCustomerByNameByBankAccountIdFromStagingFields}
		  }
	);
	$sth->execute( $softwareLpar->customerId, $softwareLpar->name,
		$bankAccountId );
	while ( $sth->fetchrow_arrayref ) {
		$data{ $rec{softwareLparMapId} } = $rec{scanRecordId};
	}
	###Close the statement handle
	$sth->finish;

	return \%data;
}

sub queryScanIdsByCustomerByNameByBankAccountIdFromStaging {
	my $self = shift;

	my @fields = qw(
	  softwareLparMapId
	  scanRecordId
	);

	my $query = '
        select
            b.id
            ,b.scan_record_id
        from
            software_lpar a
            ,software_lpar_map b
            ,scan_record c
        where
            a.customer_id = ?
            and a.name = ?
            and c.bank_account_id = ?
            and a.id = b.software_lpar_id
            and b.scan_record_id = c.id
    ';

	return ( 'scanIdsByCustomerByNameByBankAccountIdFromStaging', $query,
		\@fields );
}

sub removeSwassetData {
	my ( $self, $computerId ) = @_;

	$self->removeWinAuth($computerId);
	$self->removeStorageDev($computerId);
	$self->removeMatchedSware($computerId);
	$self->removeIpAddress($computerId);
	$self->removeInstProcessor($computerId);
	$self->removeInstPartition($computerId);
	$self->removeInstNativSware($computerId);
	$self->removeInstHeaderInfo($computerId);
	$self->removeCpuCount($computerId);
	$self->removeComputerSysMem($computerId);
	$self->removeComputer($computerId);
}

### deletes from TLCMZ
sub removeSwassetDataTLCMZ {

	#	my ( $self, $computer ) = @_;
	my ( $self, $computerId ) = @_;

	$self->removeTLCMZSware($computerId);
	$self->removeTLCMZComputer($computerId);
}

sub removeTLCMZComputer {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveTLCMZComputer() );
	my $sth = $self->swassetConnection->sql->{removeTLCMZComputer};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveTLCMZComputer {
	my $self = shift;

	my $query = '
        delete from tlcmz_computer
        where upper(computer_sys_id) = ?    ';

	return ( 'removeTLCMZComputer', $query );
}

sub removeTLCMZSware {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveTLCMZSware() );
	my $sth = $self->swassetConnection->sql->{removeTLCMZSware};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveTLCMZSware {
	my $self = shift;

	my $query = '
        delete from inst_tlcmz_sware
        where upper(computer_sys_id) = ?    ';

	return ( 'removeTLCMZSware', $query );
}

sub removeSwassetDataDorana {

	#	my ( $self, $computer ) = @_;
	my ( $self, $computerId ) = @_;

        $self->removeDoranaSware($computerId);
	$self->removeDoranaComputer($computerId);
}

sub removeDoranaComputer {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveDoranaComputer() );
	my $sth = $self->swassetConnection->sql->{removeDoranaComputer};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveDoranaComputer {
	my $self = shift;

	my $query = '
        delete from dorana_computer
        where upper(computer_sys_id) = ?    ';

	return ( 'removeDoranaComputer', $query );
}

sub removeDoranaSware {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveDoranaSware() );
	my $sth = $self->swassetConnection->sql->{removeDoranaSware};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveDoranaSware {
	my $self = shift;

	my $query = '
        delete from inst_dorana_sware
        where upper(computer_sys_id) = ?    ';

	return ( 'removeDoranaSware', $query );
}

sub removeComputer {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveComputer() );
	my $sth = $self->swassetConnection->sql->{removeComputer};
	dlog( "Removing " . $computerId );
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveComputer {
	my $self = shift;

	my $query = '
        delete from computer
        where upper(computer_sys_id) = ?    ';

	return ( 'removeComputer', $query );
}

sub removeWinAuth {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveWinAuth() );
	my $sth = $self->swassetConnection->sql->{removeWinAuth};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveWinAuth {
	my $self = shift;

	my $query = '
        delete from win_auth
        where upper(computer_sys_id) = ?    ';

	return ( 'removeWinAuth', $query );
}

sub removeStorageDev {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveStorageDev() );
	my $sth = $self->swassetConnection->sql->{removeStorageDev};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveStorageDev {
	my $self = shift;

	my $query = '
        delete from storage_dev
        where upper(computer_sys_id) = ?    ';

	return ( 'removeStorageDev', $query );
}

sub removeMatchedSware {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveMatchedSware() );
	my $sth = $self->swassetConnection->sql->{removeMatchedSware};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveMatchedSware {
	my $self = shift;

	my $query = '
        delete from matched_sware
        where upper(computer_sys_id) = ?    ';

	return ( 'removeMatchedSware', $query );
}

sub removeIpAddress {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveIpAddress() );
	my $sth = $self->swassetConnection->sql->{removeIpAddress};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveIpAddress {
	my $self = shift;

	my $query = '
        delete from ip_addr
        where upper(computer_sys_id) = ?    ';

	return ( 'removeIpAddress', $query );
}

sub removeInstProcessor {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveInstProcessor() );
	my $sth = $self->swassetConnection->sql->{removeInstProcessor};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveInstProcessor {
	my $self = shift;

	my $query = '
        delete from inst_processor
        where upper(computer_sys_id) = ?    ';

	return ( 'removeInstProcessor', $query );
}

sub removeInstPartition {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveInstPartition() );
	my $sth = $self->swassetConnection->sql->{removeInstPartition};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveInstPartition {
	my $self = shift;

	my $query = '
        delete from inst_partition
        where upper(computer_sys_id) = ?    ';

	return ( 'removeInstPartition', $query );
}

sub removeInstNativSware {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveInstNativSware() );
	my $sth = $self->swassetConnection->sql->{removeInstNativSware};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveInstNativSware {
	my $self = shift;

	my $query = '
        delete from inst_nativ_sware
        where upper(computer_sys_id) = ?    ';

	return ( 'removeInstNativSware', $query );
}

sub removeInstHeaderInfo {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveInstHeaderInfo() );
	my $sth = $self->swassetConnection->sql->{removeInstHeaderInfo};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveInstHeaderInfo {
	my $self = shift;

	my $query = '
        delete from inst_header_info
        where upper(computer_sys_id) = ?    ';

	return ( 'removeInstHeaderInfo', $query );
}

sub removeCpuCount {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery( $self->queryRemoveCpuCount() );
	my $sth = $self->swassetConnection->sql->{removeCpuCount};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveCpuCount {
	my $self = shift;

	my $query = '
        delete from cpu_count
        where upper(computer_sys_id) = ?    ';

	return ( 'removeCpuCount', $query );
}

sub removeComputerSysMem {
	my ( $self, $computerId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveComputerSysMem() );
	my $sth = $self->swassetConnection->sql->{removeComputerSysMem};
	$sth->execute( $computerId );
	$sth->finish;
}

sub queryRemoveComputerSysMem {
	my $self = shift;

	my $query = '
        delete from computer_sys_mem
        where upper(computer_sys_id) = ?    ';

	return ( 'removeComputerSysMem', $query );
}

sub removeManualSwassetData {
	my ( $self, $computerId, $softwareId ) = @_;
	$self->removeInstManualSware( $computerId, $softwareId );
	$self->removeManualComputer($computerId);
}

sub removeManualComputer {
	my ( $self, $computerId ) = @_;
	my $count =
	  $self->getInstalledManualSoftwareCountById( $self->swassetConnection,
		$computerId );
	if ( $count == 0 ) {
		$self->swassetConnection->prepareSqlQuery(
			$self->queryRemoveManualComputer() );
		my $sth = $self->swassetConnection->sql->{removeManualComputer};
		$sth->execute( $computerId );
		$sth->finish;
	}
}

sub queryRemoveManualComputer {
	my $self = shift;

	my $query = '
        delete from manual_computer
        where
            upper(computer_sys_id) = ?'
	  ;

	return ( 'removeManualComputer', $query );
}

sub removeInstManualSware {
	my ( $self, $computerId, $softwareId ) = @_;

	$self->swassetConnection->prepareSqlQuery(
		$self->queryRemoveInstManualSware() );
	my $sth = $self->swassetConnection->sql->{removeInstManualSware};
	$sth->execute( $computerId, $softwareId );
	$sth->finish;
}

sub queryRemoveInstManualSware {
	my $self = shift;

	my $query = '
        delete from inst_manual_sware
        where
            upper(computer_sys_id) = ?
            and software_id = ?
        ';

	return ( 'removeInstManualSware', $query );
}

sub getInstalledManualSoftwareCountById {
	my ( $self, $connection, $id ) = @_;

	my $count = undef;

	###Prepare and execute the necessary sql
	$connection->prepareSqlQueryAndFields(
		$self->queryInstalledManualSoftwareCountById() );
	my $sth = $connection->sql->{installedManualSoftwareCountById};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{installedManualSoftwareCountByIdFields} } );
	$sth->execute($id);
	while ( $sth->fetchrow_arrayref ) {

		$count = $rec{count};
	}
	$sth->finish;

	return $count;
}

sub queryInstalledManualSoftwareCountById {
	my @fields = (qw( count ));
	my $query  = '
        select count(*)
        from inst_manual_sware
        where upper(computer_sys_id) = ?
    ';

	return ( 'installedManualSoftwareCountById', $query, \@fields );
}

sub loadSwassetQueue {
	my $self = shift;
	my @data;

	$self->trailsConnection->prepareSqlQueryAndFields(
		$self->querySwassetQueue() );
	my $sth = $self->trailsConnection->sql->{swassetQueue};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->trailsConnection->sql->{swassetQueueFields} } );
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {
		my $queue = new BRAVO::OM::SwassetQueue();
		$queue->id( $rec{id} );
		$queue->customerId( $rec{customerId} );
		$queue->softwareLparId( $rec{softwareLparId} );
		$queue->type( $rec{type} );
                $queue->hostname( $rec{hostname} );

		push @data, $queue;
	}
	###Close the statement handle
	$sth->finish;

	$self->swassetQueue( \@data );
}

sub querySwassetQueue {
	my $self = shift;

	my @fields = qw(
	  id
	  customerId
	  softwareLparId
	  type
	  hostname
	);

	my $query = '
        select
            a.id
            ,a.customer_id
            ,a.software_lpar_id
            ,a.type
            ,a.hostname
        from
            swasset_queue a
        where
            a.deleted = 0
        order by
            a.record_time
    ';

	return ( 'swassetQueue', $query, \@fields );
}

sub loadManualQueue {
	my $self = shift;

	my @data;

	$self->trailsConnection->prepareSqlQueryAndFields(
		$self->queryManualQueue() );
	my $sth = $self->trailsConnection->sql->{manualQueue};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->trailsConnection->sql->{manualQueueFields} } );
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {
		my $queue = new BRAVO::OM::ManualQueue();
		$queue->id( $rec{id} );
		$queue->customerId( $rec{customerId} );
		$queue->softwareLparId( $rec{softwareLparId} );
		$queue->softwareId( $rec{softwareId} );
        $queue->hostname( $rec{hostname} );
        $queue->remoteUser( $rec{remoteuser} );
        
		push @data, $queue;
	}
	###Close the statement handle
	$sth->finish;

	$self->manualQueue( \@data );
}

sub queryManualQueue {
	my $self = shift;

	my @fields = qw(
	  id
	  customerId
	  softwareLparId
	  softwareId
	  hostname
	  remoteuser
	);

	my $query = '
        select
            a.id
            ,a.customer_id
            ,a.software_lpar_id
            ,a.software_id
            ,a.hostname
            ,a.remote_user
        from
            manual_queue a
        where
            a.deleted = 0
        order by
	    a.record_time
    ';

	return ( 'manualQueue', $query, \@fields );
}

sub testMode {
	my ( $self, $value ) = @_;
	$self->{_testMode} = $value if defined($value);
	return ( $self->{_testMode} );
}

sub applyChanges {
	my ( $self, $value ) = @_;
	$self->{_applyChanges} = $value if defined($value);
	return ( $self->{_applyChanges} );
}

sub trailsConnection {
	my ( $self, $value ) = @_;
	$self->{_trailsConnection} = $value if defined($value);
	return ( $self->{_trailsConnection} );
}

sub stagingConnection {
	my ( $self, $value ) = @_;
	$self->{_stagingConnection} = $value if defined($value);
	return ( $self->{_stagingConnection} );
}

sub swassetConnection {
	my ( $self, $value ) = @_;
	$self->{_swassetConnection} = $value if defined($value);
	return ( $self->{_swassetConnection} );
}

sub swassetQueue {
	my ( $self, $value ) = @_;
	$self->{_swassetQueue} = $value if defined($value);
	return ( $self->{_swassetQueue} );
}

sub manualQueue {
	my ( $self, $value ) = @_;
	$self->{_manualQueue} = $value if defined($value);
	return ( $self->{_manualQueue} );
}

###Checks arguments passed to load method.
sub checkArgs {
	my ( $self, $args ) = @_;

	###Check TestMode arg is passed correctly
	unless ( exists $args->{'TestMode'} ) {
		elog("Must specify TestMode sub argument!");
		die;
	}
	unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 ) {
		elog("Invalid value passed for TestMode param!");
		die;
	}
	$self->testMode( $args->{'TestMode'} );
	ilog( "testMode=" . $self->testMode );

	###Check ApplyChanges arg is passed correctly
	unless ( exists $args->{'ApplyChanges'} ) {
		elog("Must specify ApplyChanges sub argument!");
		die;
	}
	unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 ) {
		elog("Invalid value passed for ApplyChanges param!");
		die;
	}
	$self->applyChanges( $args->{'ApplyChanges'} );
	ilog( "applyChanges=" . $self->applyChanges );
}
1;
