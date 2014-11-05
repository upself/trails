package Recon::License;

use strict;
use Base::Utils;
use Carp qw( croak );
use CNDB::Delegate::CNDBDelegate;
use BRAVO::OM::License;
use BRAVO::OM::Software;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::LicenseSoftwareMap;
use Recon::OM::ReconLicense;
use Recon::OM::Reconcile;
use Recon::Queue;
use Recon::OM::LicenseAllocationView;
use Recon::OM::AlertExpiredMaint;
use Recon::OM::AlertExpiredMaintHistory;
use Recon::Delegate::ReconLicenseValidation;
use CNDB::Delegate::CNDBDelegate;

sub new {
    my ( $class, $connection, $license ) = @_;
    my $self = {
                 _connection            => $connection,
                 _license               => $license,
                 _licenseAllocationData => undef,
                 _accountPoolChildren   => undef,
                 _licSwMap              => undef
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
        unless defined $self->connection;

    croak 'License is undefined'
        unless defined $self->license;
}

sub recon {
    my $self = shift;

    my $customer = new BRAVO::OM::Customer();
    $customer->id( $self->license->customerId );
    $customer->getById( $self->connection );
    $self->customer($customer);

    ###Alert expired maint.
    $self->alertLogicExpiredMaint;

    ###Get necessary data
    $self->getLicenseAllocationsData;
    $self->accountPoolChildren(
                  CNDB::Delegate::CNDBDelegate->getAccountPoolChildren( $self->connection, $self->customer->id ) );

    my $licSwMap = new BRAVO::OM::LicenseSoftwareMap();
    $licSwMap->licenseId( $self->license->id );
    $licSwMap->getByBizKey( $self->connection );
    $self->licSwMap($licSwMap);
    dlog( "licSwMap=" . $licSwMap->toString() );

    my $validation = new Recon::Delegate::ReconLicenseValidation();
    $validation->customer( $self->customer );
    $validation->license( $self->license );
    $validation->licenseAllocationData( $self->licenseAllocationData );
    $validation->licSwMap($licSwMap);
    $validation->accountPoolChildren( $self->accountPoolChildren );
    $validation->connection( $self->connection );
    $validation->validate;

    if ( defined $validation->deleteQueue ) {
        foreach my $licenseId ( keys %{ $validation->deleteQueue } ) {
            my $recon = new Recon::OM::ReconLicense();
            $recon->licenseId( $self->license->id );
            $recon->action('UPDATE');
            $recon->getByBizKey( $self->connection );
            $recon->delete( $self->connection );
        }
    }

    if ( defined $validation->reconcilesToBreak ) {
        foreach my $reconcileId ( keys %{ $validation->reconcilesToBreak } ) {
            dlog("reconcileId=$reconcileId");
            Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection, $reconcileId );
        }
    }

    if ( $validation->isValid == 0 ) {
        dlog("License is not valid, returning");
        return 1;
    }

    $self->queuePotentialInstalledSoftware;

    dlog("end recon");
    return;
}

sub queuePotentialInstalledSoftware {
    my $self = shift;
    dlog("begin attemptAllocations");

    ###We don't auto reconcile anything unless its in this list
    if (    $self->license->capType ne '2'
         && $self->license->capType ne '13'
         && $self->license->capType ne '14'
         && $self->license->capType ne '17'
         && $self->license->capType ne '34'
         && $self->license->capType ne '48'
         && $self->license->capType ne '70' )
    {
        return;
    }

    ###List of inst sw to attempt recon.
    my @instSwsToAttemptAllocation = ();

    foreach my $priority ( sort keys %{ $self->accountPoolChildren } ) {
        foreach my $customerId ( keys %{ $self->accountPoolChildren->{$priority} } ) {
            ###Get hw specific inst sw if lic has hw serial specified.
            if ( defined $self->license->cpuSerial ) {
                my @tempInstSwsHwSpecific = $self->getPotentialInstalledSoftwaresHwSpecific($customerId);
                push @instSwsToAttemptAllocation, @tempInstSwsHwSpecific;
            }

            ###Get non hw specific inst sw unless license is hardware cap type. 34 - Physical cpu
            unless ( $self->license->capType eq '34' ) {
                my @tempInstSws = $self->getPotentialInstalledSoftwares($customerId);
                push @instSwsToAttemptAllocation, @tempInstSws;
            }
        }
    }

    ###Attempt allocations until free capacity is utilized.
    foreach my $isId (@instSwsToAttemptAllocation) {

        ###Instantiate inst sw object and recon.
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($isId);
        $installedSoftware->getById( $self->connection );
        dlog( "installedSoftware=" . $installedSoftware->toString() );

        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id($installedSoftware->softwareLparId);
        $softwareLpar->getById( $self->connection );
        dlog( "softwareLpar=" . $softwareLpar->toString() );

        ###Call recon
        my $queue = Recon::Queue->new( $self->connection, $installedSoftware, $softwareLpar );
        $queue->add;
    }

    dlog("end attemptAllocations");
}

sub getPotentialInstalledSoftwaresHwSpecific {
    my ( $self, $customerId ) = @_;
    dlog("begin getPotentialInstalledSoftwaresHwSpecific");

    my @ids = ();

    $self->connection->prepareSqlQueryAndFields( $self->queryPotentialInstalledSoftwaresHwSpecific() );
    my $sth = $self->connection->sql->{potentialInstalledSoftwaresHwSpecific};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
                        @{ $self->connection->sql->{potentialInstalledSoftwaresHwSpecificFields} } );
    $sth->execute( $customerId, $self->licSwMap->softwareId, $self->license->cpuSerial );

    while ( $sth->fetchrow_arrayref ) {
        logRec( 'dlog', \%rec );

        ###Add inst sw id to list.
        push @ids, $rec{isId};
    }
    $sth->finish;

    dlog("end getPotentialInstalledSoftwaresHwSpecific");
    return @ids;
}

sub queryPotentialInstalledSoftwaresHwSpecific {
    my @fields = qw(
        isId
    );
    my $query = '
        select
            is.id
        from
        	software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
            join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
            join hardware h on h.id = hl.hardware_id
            left outer join alert_unlicensed_sw aus on
                aus.installed_software_id = is.id
        where
            sl.customer_id = ?
            and sl.status = \'ACTIVE\'
            and is.software_id = ?
            and is.status = \'ACTIVE\'
            and hl.status = \'ACTIVE\'
            and h.serial = substr(?,1,32)
            and h.status = \'ACTIVE\'
          	and h.hardware_status = \'ACTIVE\'
            and not exists (select 1 from reconcile r where r.installed_software_id = is.id)
        order by
            aus.creation_time
    ';
    return ( 'potentialInstalledSoftwaresHwSpecific', $query, \@fields );
}

sub getPotentialInstalledSoftwares {
    my ( $self, $customerId ) = @_;
    dlog("begin getPotentialInstalledSoftwares");

    my @ids = ();

    $self->connection->prepareSqlQueryAndFields( $self->queryPotentialInstalledSoftwares() );
    my $sth = $self->connection->sql->{potentialInstalledSoftwares};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{potentialInstalledSoftwaresFields} } );
    $sth->execute( $customerId, $self->licSwMap->softwareId );
    while ( $sth->fetchrow_arrayref ) {
        logRec( 'dlog', \%rec );
        dlog( $rec{isId} );
        ###Add inst sw id to list.
        push @ids, $rec{isId};
    }
    $sth->finish;

    dlog("end getPotentialInstalledSoftwares");
    return @ids;
}

sub queryPotentialInstalledSoftwares {
    my @fields = qw(
        isId
    );
    my $query = '
        select
            is.id
        from
        	software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
            join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
            join hardware h on h.id = hl.hardware_id
            left outer join alert_unlicensed_sw aus on
                aus.installed_software_id = is.id
        where
            sl.customer_id = ?
            and sl.status = \'ACTIVE\'
            and is.software_id = ?
            and is.status = \'ACTIVE\'
            and hl.status = \'ACTIVE\'
            and h.status = \'ACTIVE\'
          	and h.hardware_status = \'ACTIVE\'
            and not exists (select 1 from reconcile r where r.installed_software_id = is.id)
        order by
            aus.creation_time
    ';
    return ( 'potentialInstalledSoftwares', $query, \@fields );
}

sub getScheduleFScope {
	my $self=shift;
	my $custId=shift;
	my $softName=shift;
	my $hwOwner=shift;
	my $hSerial=shift;
	my $hMachineTypeId=shift;
	my $slName=shift;
	
	my $prioFound=0; # temporary value with the priority of schedule F found, so we don't have to run several cycles
	my $scopeToReturn=undef;
	
	$self->connection->prepareSqlQueryAndFields(
		$self->queryScheduleFScope() );
	my $sth = $self->connection->sql->{ScheduleFScope};
	my %recc;
	$sth->bind_columns( map { \$recc{$_} }
		  @{ $self->connection->sql->{ScheduleFScopeFields} } );
	$sth->execute( $custId, $softName );
	
#	dlog("Searching for ScheduleF scope, customer=".$custId.", software=".$softName);
	
	while ( $sth->fetchrow_arrayref ) {
		if (( $recc{level} eq "HOSTNAME" ) && ( $slName eq $recc{hostname} ) && ( $prioFound == 3 )) {
			wlog("ScheduleF HOSTNAME = ".$slName." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HOSTNAME" ) && ( $slName eq $recc{hostname} ) && ( $prioFound < 3 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=3;
		}
		if (( $recc{level} eq "HWBOX" ) && ( $hSerial eq $recc{hSerial} ) && ( $hMachineTypeId eq $recc{hMachineTypeId} ) && ( $prioFound == 2 )) {
			wlog("ScheduleF HWBOX = ".$hSerial." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HWBOX" ) && ( $hSerial eq $recc{hSerial} ) && ( $hMachineTypeId eq $recc{hMachineTypeId} ) && ( $prioFound < 2 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=2;
		}
		if (( $recc{level} eq "HWOWNER" ) && ( $hwOwner eq $recc{hwOwner} ) && ( $prioFound == 1 )) {
			wlog("ScheduleF HWOWNER =".$hwOwner." for customer=".$custId." and software=".$softName." found twice!");
			return undef;
		}
		if (( $recc{level} eq "HWOWNER" ) && ( $hwOwner eq $recc{hwOwner} ) && ( $prioFound < 1 )) {
			$scopeToReturn=$recc{scopeName};
			$prioFound=1;
		}
		$scopeToReturn=$recc{scopeName} if (( $recc{level} eq "PRODUCT" ) && ( $prioFound == 0 ));
	}
	
	dlog("custId= $custId, softName=$softName, hostname=$slName, serial=$hSerial, scopeName= $scopeToReturn, prioFound = $prioFound");
	
	return ( $scopeToReturn, $prioFound );
}

sub getLicenseAllocationsData {
    my $self = shift;
    dlog("begin getLicenseAllocationsData");

    my %data = ();

    $self->connection->prepareSqlQueryAndFields( $self->queryLicenseAllocationsData() );
    my $sth = $self->connection->sql->{licenseAllocationsData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $self->connection->sql->{licenseAllocationsDataFields} } );
    $sth->execute( $self->license->id );
    while ( $sth->fetchrow_arrayref ) {
        logRec( 'dlog', \%rec );

        ###Instantiate lic allocation view object and populate.
        my $lav = new Recon::OM::LicenseAllocationView();
        $lav->expireAge( $rec{expireAge} );
        $lav->lrmCapType( $rec{lrmCapType} );
        $lav->lrmUsedQuantity( $rec{lrmUsedQuantity} );
        $lav->machineLevel( $rec{machineLevel} );
        $lav->rId( $rec{rId} );
        $lav->lrmId( $rec{lrmId} );
        $lav->rtName( $rec{rtName} );
        $lav->rtIsManual( $rec{rtIsManual} );
        $lav->isId( $rec{isId} );
        $lav->isSoftwareId( $rec{isSoftwareId} );
        $lav->slCustomerId( $rec{slCustomerId} );
        $lav->slName( $rec{slName} );
        $lav->hId( $rec{hId} );
        $lav->hSerial( $rec{hSerial} );
        $lav->hProcessorCount ( $rec{hProcessorCount} );
        $lav->hServerType ( $rec{hServerType} );
        $lav->hlName( $rec{hlName} );
        $lav->mtType( $rec{mtType} );
#        $lav->scopeName( $rec{scopeName} );
        $lav->slComplianceMgmt( $rec{slComplianceMgmt} );
        
       	my ( $scopename_temp, undef ) = getScheduleFScope( 	$self,
															$rec{slCustomerId}, # customer ID from SW LPAR
															$rec{swName}, # software name
															$rec{hOwner}, # hardware owner ID
															$rec{hSerial}, # hardware serial
															$rec{mtType}, #machine type
															$rec{slName} #hostname
															  );
															  
		$lav->scopeName ( $scopename_temp );

        ###Add lic allocation view object to data hash.
        $data{ $rec{rId} } = $lav;
    }
    $sth->finish;

    dlog("end getLicenseAllocationsData");
    $self->licenseAllocationData( \%data );
}

sub queryScheduleFScope {
	# this needs to be updated if there ever is a level other than HOSTNAME HWBOX HWOWNER PRODUCT, that does not alphabetically
	# fit into the correct priority-spot
	my @fields = qw(
	  hwOwner
	  hSerial
	  hMachineTypeId
	  hostname
	  level
	  scopeName
	);
	my $query = '
	  select
	    sf.hw_owner,
	    sf.serial,
	    mt.id,
	    sf.hostname,
	    sf.level,
	    s.name
	  from schedule_f sf
	    left outer join scope s
	      on sf.scope_id = s.id
	    left outer join machine_type mt
	      on mt.name = sf.machine_type
	  where
	    sf.customer_id = ?
	  and
	    sf.software_name = ?
	  and
	    sf.status_id = 2
	';
	return('ScheduleFScope', $query, \@fields );
	
}

sub queryLicenseAllocationsData {
    my @fields = qw(
        rId
        lrmId
        lrmCapType
        lrmUsedQuantity
        machineLevel
        expireAge
        rtName
        rtIsManual
        isId
        isSoftwareId
        slCustomerId
        slName
        swName
        hId
        hSerial
        hProcessorCount
        hCpuMIPS
        hCpuGartnerMIPS
        hCpuMSU
        hOwner
        hServerType
        hlName
        hlPartMIPS
        hlPartGartnerMIPS
        hlPartMSU
        mtType
        slComplianceMgmt
    );
    my $query = '
        select
            r.id
            ,ul.id
            ,ct.code
            ,ul.used_quantity
            ,r.machine_level
            ,days(l.expire_date) - days(current timestamp)         
            ,rt.name
            ,rt.is_manual
            ,is.id
            ,is.software_id
            ,sl.customer_id
            ,sl.name
            ,sw.software_name
            ,h.id
            ,h.serial
            ,h.processor_count
            ,h.cpu_mips
            ,h.cpu_gartner_mips
            ,h.cpu_msu
            ,h.owner
            ,h.server_type
            ,hl.name
            ,hl.part_mips
            ,hl.part_gartner_mips
            ,hl.part_msu
            ,mt.type
            ,c.sw_compliance_mgmt
        from
        	used_license ul
        	join license l on l.id = ul.license_id
        	join reconcile_used_license rul on rul.used_license_id = ul.id
        	join capacity_type ct on ct.code = ul.capacity_type_id
        	join reconcile r on r.id = rul.reconcile_id
            join reconcile_type rt on rt.id = r.reconcile_type_id
            join installed_software is on is.id = r.installed_software_id
            join software sw on sw.software_id = is.software_id
            join software_lpar sl on sl.id = is.software_lpar_id
            join customer c on sl.customer_id = c.customer_id
            join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
            join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
            join hardware h on h.id = hl.hardware_id
            join machine_type mt on mt.id = h.machine_type_id
        where
            ul.license_id = ?
    ';
    return ( 'licenseAllocationsData', $query, \@fields );
}

sub alertLogicExpiredMaint {
    my $self = shift;
    dlog("begin alertLogicExpiredMaint");

    ###Instantiate alert object and get if exists.
    my $alert = new Recon::OM::AlertExpiredMaint();
    $alert->licenseId( $self->license->id );
    $alert->getByBizKey( $self->connection );
    dlog( "alert=" . $alert->toString() );

    ###Determine if there is an open alert.
    my $isOpenAlert = 0;
    if ( defined $alert->id ) {
        if ( $alert->open == 1 ) {
            $isOpenAlert = 1;
        }
    }
    dlog( "isOpenAlert=" . $isOpenAlert );

    ###Determine if the maint for this sw lpar is expired.
    my $isMaintExpired = $self->isMaintExpired;
    dlog( "isMaintExpired" . $isMaintExpired );

    ###Perform alert logic.

    ###CUST=A
    if (    $self->customer->status eq 'ACTIVE'
         && $self->customer->swLicenseMgmt eq 'YES'
         && $self->license->status         eq 'ACTIVE'
         && $isMaintExpired == 1 )
    {
        if ( $isOpenAlert == 0 ) {
            dlog("CUST=A,SWLM=1,LIC=A,!VALID,OPEN=0");

            ###Open alert.
            $self->openAlertExpiredMaint($alert);
        }
    }
    else {
        if ( $isOpenAlert == 1 ) {
            dlog("CUST=I,OPEN=1");

            ###Close alert.
            $self->closeAlertExpiredMaint($alert);
        }
    }

    dlog("end alertLogicExpiredMaint");
}

sub openAlertExpiredMaint {
    my ( $self, $alert ) = @_;
    dlog("begin openAlertExpiredMaint");

    if ( defined $alert->id ) {
        $self->recordAlertExpiredMaintHistory($alert);
    }
    $alert->creationTime( currentTimeStamp() );
    $alert->comments('Auto Open');
    $alert->open(1);
    $alert->save( $self->connection );

    dlog("end openAlertExpiredMaint");
}

sub closeAlertExpiredMaint {
    my ( $self, $alert ) = @_;
    dlog("begin closeAlertExpiredMaint");

    if ( defined $alert->id ) {
        $self->recordAlertExpiredMaintHistory($alert);
    }
    else {
        $alert->creationTime( currentTimeStamp() );
    }
    $alert->comments('Auto Close');
    $alert->open(0);
    $alert->save( $self->connection );

    dlog("end closeAlertExpiredMaint");
}

sub recordAlertExpiredMaintHistory {
    my ( $self, $alert ) = @_;
    my $history = new Recon::OM::AlertExpiredMaintHistory();
    $history->alertExpiredMaintId( $alert->id );
    $history->creationTime( $alert->creationTime );
    $history->comments( $alert->comments );
    $history->open( $alert->open );
    $history->recordTime( $alert->recordTime );
    $history->save( $self->connection );
}

sub isMaintExpired {
    my $self = shift;
    dlog("begin isMaintExpired");

    my $diff;
    $self->connection->prepareSqlQuery( $self->queryIsMaintExpired() );
    my $sth = $self->connection->sql->{isMaintExpired};
    $sth->bind_columns( \$diff );
    $sth->execute( $self->license->id );
    $sth->fetchrow_arrayref;
    $sth->finish;

    if ( defined $diff ) {
        if ( $diff >= 0 ) {
            return 0;
        }
        else {
            return 1;
        }
    }
    else {
        return 0;
    }

    dlog("end isMaintExpired");
    return;
}

sub queryIsMaintExpired {
    my $query = '
        select
            days(l.expire_date) - days(current timestamp)
        from
            license l
        where
            l.id = ?
    ';
    return ( 'isMaintExpired', $query );
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub license {
    my $self = shift;
    $self->{_license} = shift if scalar @_ == 1;
    return $self->{_license};
}

sub customer {
    my $self = shift;
    $self->{_customer} = shift if scalar @_ == 1;
    return $self->{_customer};
}

sub licenseAllocationData {
    my $self = shift;
    $self->{_licenseAllocationData} = shift if scalar @_ == 1;
    return $self->{_licenseAllocationData};
}

sub accountPoolChildren {
    my $self = shift;
    $self->{_accountPoolChildren} = shift if scalar @_ == 1;
    return $self->{_accountPoolChildren};
}

sub licSwMap {
    my $self = shift;
    $self->{_licSwMap} = shift if scalar @_ == 1;
    return $self->{_licSwMap};
}

1;

