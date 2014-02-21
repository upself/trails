package Recon::Recover::Recovery;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::HardwareSoftwareComposite;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::Software;
use Recon::OM::ReconcileH;
use Recon::OM::Reconcile;
use Recon::OM::ReconcileType;
use Recon::Queue;
use Recon::OM::UsedLicense;
use Recon::OM::ReconcileUsedLicense;
use BRAVO::OM::DiscrepancyType;
use BRAVO::OM::HardwareLpar;
use BRAVO::OM::Hardware;
use BRAVO::OM::License;

sub new {
	my ( $class, $connection, $applyChanges, $restoreManual, $customer,
		$reportFile )
	  = @_;
	my $self = {
		_connection        => $connection,
		_applyChanges      => $applyChanges,
		_restoreManual     => $restoreManual,
		_customer          => $customer,
		_reportFile        => $reportFile,
		_softwareLparNames => undef,
		_installedSoftwareIds => undef
	};
	bless $self, $class;

	$self->validate;

	return $self;
}

sub run {
	my $self = shift;
	my $startTime = shift;
	my $endTime = shift;

    if ($self->customer ne ''){
	if ( $self->isValidCustomer == 0 ) {
		$self->report( 'Account Number:'
			  . $self->customer->accountNumber
			  . ':Customer is invalid' );
		return;
	}

	$self->loadSoftwareLparNames if ( !defined $self->softwareLparNames );
    }
	foreach my $name ( sort @{ $self->softwareLparNames } ) {
		my $softwareLpar ;
		my @installedSoftwareIds;
		if ($name ne '') {
	    $softwareLpar = new BRAVO::OM::SoftwareLpar();
		$softwareLpar->customerId( $self->customer->id );
		$softwareLpar->name($name);
		$softwareLpar->getByBizKey( $self->connection );
		dlog( $softwareLpar->toString );
		if ( $self->isValidSoftwareLpar($softwareLpar) == 0 ) {
			$self->report( 'Account Number:'
				  . $self->customer->accountNumber . ':'
				  . 'Software Lpar:'
				  . $softwareLpar->name
				  . ':Software Lpar is invalid' );
			next;
		 }
		
		 @installedSoftwareIds =
		  $self->getInstalledSoftwareIds($softwareLpar,$startTime,$endTime);
		} else {
			$softwareLpar = '';
			@installedSoftwareIds = @{$self->installedSoftwareIds};
		}
		foreach my $installedSoftwareId (@installedSoftwareIds) {
		#	printf "the insw id is ".$installedSoftwareId ."\n";
			my $installedSoftware = new BRAVO::OM::InstalledSoftware();
			$installedSoftware->id($installedSoftwareId);
			$installedSoftware->getById( $self->connection );
			dlog( $installedSoftware->toString );
            
            if($softwareLpar eq ''){
            $softwareLpar = new BRAVO::OM::SoftwareLpar();
		    $softwareLpar->id( $installedSoftware->softwareLparId );
		    $softwareLpar->getById( $self->connection );
	        }
			my $software = new BRAVO::OM::Software();
			$software->id( $installedSoftware->softwareId );
			$software->getById( $self->connection );
			dlog( $software->toString );

			if (
				$self->isValidInstalledSoftware(
					$installedSoftware, $software
				) == 0
			  )
			{
				if ($self->customer ne ''){
				$self->report( 'Account Number:'
					  . $self->customer->accountNumber . ':'
					  . 'Software Lpar:'
					  . $softwareLpar->name
					  . ':Software:'
					  . $software->name
					  . ':Installed software is invalid' );
				} else {
			    $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Installed software is invalid' );
				}
				next;
			}

			my $reconcileH = new Recon::OM::ReconcileH();
			$reconcileH->installedSoftwareId( $installedSoftware->id );
			$reconcileH->getByBizKey( $self->connection );
			dlog( $reconcileH->toString );

			if ( !defined $reconcileH->id ) {
			 if ($self->customer ne ''){
				$self->report( 'Account Number:'
					  . $self->customer->accountNumber
					  . ':Software Lpar:'
					  . $softwareLpar->name
					  . ':Software:'
					  . $software->name
					  . ':No reconcile history' );
			  } else {
			    $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':No reconcile history' );
				}
				next;
			}
			if ( $reconcileH->machineLevel == 1 ) {
			   if ($self->customer ne ''){
				$self->report( 'Account Number:'
					  . $self->customer->accountNumber
					  . ':Software Lpar:'
					  . $softwareLpar->name
					  . ':Software:'
					  . $software->name
					  . ':Reconciled on the machine level' );
				 } else {
			    $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Reconciled on the machine level' );
				}

				#				next;
			}

			if ( $self->restoreManual == 0 ) {
				if ( $reconcileH->manualBreak == 1 ) {
				   if ($self->customer ne ''){
					$self->report( 'Account Number:'
						  . $self->customer->accountNumber
						  . ':Software Lpar:'
						  . $softwareLpar->name
						  . ':Software:'
						  . $software->name
						  . ':Reconcile manually broken' );
					  } else {
			         $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Reconcile manually broken' );
				    }
					my $queue =
					  Recon::Queue->new( $self->connection, $installedSoftware,
						$softwareLpar );
					$queue->add;
					next;
				}
			}

			my $reconcile = new Recon::OM::Reconcile();
			$reconcile->installedSoftwareId( $installedSoftware->id );
			$reconcile->getByBizKey( $self->connection );
			dlog( $reconcile->toString );

			if ( defined $reconcile->id ) {
				my $reconcileType = new Recon::OM::ReconcileType();
				$reconcileType->id( $reconcile->reconcileTypeId );
				$reconcileType->getById( $self->connection );
				dlog( $reconcileType->toString );

				if ( $reconcileType->isManual == 1 ) {
					if ($self->customer ne ''){
					$self->report( 'Account Number:'
						  . $self->customer->accountNumber
						  . ':Software Lpar:'
						  . $softwareLpar->name
						  . ':Software:'
						  . $software->name
						  . ':Current reconcile is manual' );
					  } else {
			         $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Current reconcile is manual' );
				     }
					next;
				}
				if ( $reconcileH->machineLevel == 0 ) {
					$self->breakReconcile( $reconcile->id );
				} else {
					if ($self->customer ne ''){
					$self->report( 'Account Number:'
						  . $self->customer->accountNumber
						  . ':Software Lpar:'
						  . $softwareLpar->name
						  . ':Software:'
						  . $software->name
						  . ':Not breaking reconcile because at machine level' );
				      } else {
			          $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Not breaking reconcile because at machine level' );
				     }					
				}

			}

			$reconcile->reconcileTypeId( $reconcileH->reconcileTypeId );
			$reconcile->allocationMethodologyId( $reconcileH->allocationMethodologyId );
			$reconcile->parentInstalledSoftwareId(
				$reconcileH->parentInstalledSoftwareId );
			$reconcile->comments( $reconcileH->comments );
			$reconcile->remoteUser( $reconcileH->remoteUser );
			$reconcile->recordTime( $reconcileH->recordTime );
			$reconcile->machineLevel( $reconcileH->machineLevel );
			dlog( $reconcile->toString );
			$reconcile->save( $self->connection );

			$self->recoverMapsByReconcileH( $reconcileH->id, $reconcile->id );

			my $queue =
			  Recon::Queue->new( $self->connection, $installedSoftware,
				$softwareLpar );
			$queue->add;
            if ($self->customer ne ''){
			$self->report( 'Account Number:'
				  . $self->customer->accountNumber
				  . ':Software Lpar:'
				  . $softwareLpar->name
				  . ':Software:'
				  . $software->name
				  . ':Recovered' );
		      } else {
			          $self->report( 'installedSoftwareId:'
					  . $installedSoftware->id
					  . ':Recovered' );
		    }		
		}
	}

	if ( defined $self->licenseIds ) {
		foreach my $id ( keys %{ $self->licenseIds } ) {
			my $license = new BRAVO::OM::License();
			$license->id($id);
			$license->getById( $self->connection );
			dlog( $license->toString );

			my $queue = Recon::Queue->new( $self->connection, $license );
			$queue->add;
		}
	}

}

sub recoverMapsByReconcileH {
	my ( $self, $reconcileHId, $reconcileId ) = @_;

	$self->connection->prepareSqlQueryAndFields(
		queryLicenseIdsByReconcileH() );
	my $sth = $self->connection->sql->{licenseIdsByReconcileH};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{licenseIdsByReconcileHFields} } );
	$sth->execute($reconcileHId);
	while ( $sth->fetchrow_arrayref ) {
		$self->addToLicenseIds( $rec{licenseId} );

		$self->connection->prepareSqlQueryAndFields( queryUsedLicense() );
		my $sth = $self->connection->sql->{usedLicense};
		my $id;
		$sth->bind_columns( \$id );
		$sth->execute( $rec{licenseId}, $rec{quantity}, $rec{capType} );
		$sth->fetchrow_arrayref;
		$sth->finish;
		my $usedLicenseId;
    
		if ( defined $id ) {
	    my $RehwSerial = $self->getHwSerailNumberByReconcileId( $reconcileId );
        my $UlhwSerial = $self->getHwSerailNumberByUsedLicenseId( $id );
            if (defined $UlhwSerial && ( $RehwSerial eq $UlhwSerial ) ){
		   	    $usedLicenseId = $id;
			}
		}
		if (!defined $usedLicenseId) {
			my $usedLicense = new Recon::OM::UsedLicense();
			$usedLicense->licenseId( $rec{licenseId} );
			$usedLicense->capacityTypeId( $rec{capType} );
			$usedLicense->usedQuantity( $rec{quantity} );
			$usedLicense->save( $self->connection );
			$usedLicenseId = $usedLicense->id;
		}

		my $reconcileUsedLicense = new Recon::OM::ReconcileUsedLicense();
		$reconcileUsedLicense->reconcileId($reconcileId);
		$reconcileUsedLicense->usedLicenseId($usedLicenseId);
		$reconcileUsedLicense->save( $self->connection );

	}
	$sth->finish;
}

sub getHwSerailNumberByReconcileId {
		my ( $self,  $reconcileId ) = @_;

	$self->connection->prepareSqlQueryAndFields(
		queryHwSerailNumberByReconcileId() );
	my $sth = $self->connection->sql->{hwSerailNumberByReconcileId};
	my %rec;
	my $serial;
	$sth->bind_columns( \$serial );
	$sth->execute($reconcileId);
	$sth->fetchrow_arrayref;
	return  $serial;
	$sth->finish;
}

sub queryHwSerailNumberByReconcileId {
    my $query  = '
        select
            hw.SERIAL as serial
        from
            reconcile rc
            ,installed_software is 
            ,software_lpar sl
            ,hw_sw_composite shc
            ,hardware_lpar hl
            ,hardware hw
        where
            rc.installed_software_id=is.id
        and is.software_lpar_id=sl.id
        and shc.software_lpar_id=sl.id
        and shc.hardware_lpar_id=hl.id
        and hl.hardware_id=hw.id
        and rc.machine_level = 1
        and rc.reconcile_type_id= 1
        and rc.id = ?
        with ur
    ';
    return ( 'hwSerailNumberByReconcileId', $query );
}

sub getHwSerailNumberByUsedLicenseId {
		my ( $self,  $id ) = @_;

	$self->connection->prepareSqlQueryAndFields(
		queryHwSerailNumberByUsedLicenseId() );
	my $sth = $self->connection->sql->{hwSerailNumberByUsedLicenseId};
	my %rec;
	my $serial;
	$sth->bind_columns( \$serial );
	$sth->execute($id);
	$sth->fetchrow_arrayref;
	return  $serial;
	$sth->finish;
}

sub queryHwSerailNumberByUsedLicenseId {
    my $query  = '
        select
            hw.SERIAL as serial
        from
            reconcile rc
            ,installed_software is 
            ,software_lpar sl
            ,hw_sw_composite shc
            ,hardware_lpar hl
            ,hardware hw
            ,reconcile_used_license rul
        where
            rc.installed_software_id=is.id
        and is.software_lpar_id=sl.id
        and shc.software_lpar_id=sl.id
        and shc.hardware_lpar_id=hl.id
        and hl.hardware_id=hw.id
        and rul.reconcile_id=rc.id
        and rc.machine_level = 1
        and rc.reconcile_type_id= 1
        and rul.USED_LICENSE_ID = ?
        with ur
    ';
    return ( 'hwSerailNumberByUsedLicenseId', $query );
}

sub queryUsedLicense {
	my $query = '
        select
            id
        from
            used_license
        where
            license_id= ?
            and used_quantity= ?
            and CAPACITY_TYPE_ID= ?
    ';
	return ( 'usedLicense', $query );
}

sub queryLicenseIdsByReconcileH {
	my @fields = qw(
	  licenseId
	  quantity
	  capType
	);
	my $query = '
        select
            hul.license_id
            ,hul.used_quantity
            ,hul.CAPACITY_TYPE_ID
        from
            h_reconcile_used_license hrul join h_used_license hul
            on hrul.h_used_license_id =  hul.id
        where
            hrul.h_reconcile_id = ?
    ';
	return ( 'licenseIdsByReconcileH', $query, \@fields );
}

sub breakReconcile {
	my ( $self, $reconcileId ) = @_;

	my %licenseIds = ();

	$self->connection->prepareSqlQueryAndFields(
		queryUsedLicenseIdByReconcileId() );
	my $sth = $self->connection->sql->{usedLicenseByReconcileId};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{usedLicenseByReconcileIdFields} } );
	$sth->execute($reconcileId);
	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );

		###Add license id to hash for recon of lic.
		$self->addToLicenseIds( $rec{licenseId} );

		$self->connection->prepareSqlQuery(
			$self->queryDeleteReconUsedLicense() );
		my $deleteRul = $self->connection->sql->{deleteReconUsedLicense};
		$deleteRul->execute( $reconcileId, $rec{ulId} );
		$deleteRul->finish;
		dlog("deleted reconcile used licnese");

		my $count;
		$self->connection->prepareSqlQuery( $self->queryReferenceCount() );
		my $deleteUL = $self->connection->sql->{referenceCount};
		$deleteUL->bind_columns( \$count );
		$deleteUL->execute( $rec{ulId} );
		$deleteUL->fetchrow_arrayref;
		$deleteUL->finish;

		if ( defined $count && $count == 0 ) {
			my $ul = new Recon::OM::UsedLicense();
			$ul->id( $rec{ulId} );
			$ul->getById( $self->connection );
			dlog( "ul=" . $ul->toString() );
			$ul->delete( $self->connection );
			dlog("deleted used licnese");
		}
	}
	$sth->finish;
	dlog("end breakReconcile");

}

sub queryReferenceCount {
	my $query = qq(
        select 
                count(*) 
            from  
                reconcile_used_license rul
            where 
                rul.used_license_id=?
             );
	return ( 'referenceCount', $query );
}

sub queryUsedLicenseIdByReconcileId {
	my @fields = qw(
	  ulId
	  licenseId
	);
	my $query = '
        select
            rul.used_license_id
            ,ul.LICENSE_ID
        from
            reconcile_used_license rul
            ,used_license ul
        where
            rul.used_license_id = ul.id
            and rul.reconcile_id = ?
    ';
	return ( 'usedLicenseByReconcileId', $query, \@fields );
}

sub queryDeleteReconUsedLicense {
	my $query = '
        delete from reconcile_used_license
        where
        	reconcile_id = ? 
        	and used_license_id = ?
    ';
	return ( 'deleteReconUsedLicense', $query );
}

sub isValidInstalledSoftware {
	my ( $self, $installedSoftware, $software ) = @_;

	return 0 if ( $installedSoftware->status ne 'ACTIVE' );

	my $discrepancyType = new BRAVO::OM::DiscrepancyType();
	$discrepancyType->id( $installedSoftware->discrepancyTypeId );
	$discrepancyType->getById( $self->connection );
	dlog( $discrepancyType->toString );

	return 0 if ( $discrepancyType->name eq 'INVALID' );
	return 0 if ( $discrepancyType->name eq 'FALSE HIT' );
	return 0 if ( $software->status      eq 'INACTIVE' );
	return 0 if ( $software->level ne 'LICENSABLE' );

	return 1;
}

sub getInstalledSoftwareIds {
	my ( $self, $softwareLpar, $startTime, $endTime ) = @_;

	my @ids;

	$self->connection->prepareSqlQueryAndFields(
		$self->queryInstalledSoftwareIds );
	my $sth = $self->connection->sql->{installedSoftwareIds};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{installedSoftwareIdsFields} } );
	$sth->execute( $softwareLpar->id, $startTime, $endTime );
	push @ids, $rec{id} while ( $sth->fetchrow_arrayref );
	$sth->finish;

	return @ids;
}

sub queryInstalledSoftwareIds {
	my $self = shift;

	my @fields = qw(
	  id
	);

	my $query = qq{
        select
            is.id
        from
            installed_software is
            ,software s
            ,alert_unlicensed_Sw asw
        where
            is.software_lpar_id = ?
            and date(asw.record_time) >=? 
            and date(asw.record_time) <=?
            and asw.installed_software_id=is.id
            and is.software_id = s.software_id
            and s.level = 'LICENSABLE'
            and is.discrepancy_type_id != 3
            and is.discrepancy_type_id != 5 
            and is.status = 'ACTIVE'  
            and asw.open=1           
            and not exists(select 1 from reconcile r, reconcile_type rt where r.installed_software_id = is.id and r.reconcile_type_id = rt.id and rt.is_manual = 1) 
            and not exists(select 1 from reconcile_h rh where rh.installed_software_id = is.id and rh.manual_break = 1) 
            and exists(select 1 from reconcile_h rh where rh.installed_software_id = is.id) 
    };

	dlog("installedSoftwareIds=$query");
	return ( 'installedSoftwareIds', $query, \@fields );
}

sub loadSoftwareLparNames {
	my $self = shift;

	my @names;

	$self->connection->prepareSqlQueryAndFields(
		$self->querySoftwareLparNames );
	my $sth = $self->connection->sql->{softwareLparNames};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{softwareLparNamesFields} } );
	$sth->execute( $self->customer->id );
	push @names, $rec{name} while ( $sth->fetchrow_arrayref );
	$sth->finish;

	$self->softwareLparNames( \@names );
}

sub querySoftwareLparNames {
	my $self = shift;

	my @fields = qw(
	  name
	);

	my $query = qq{
        select
            name
        from
            software_lpar
        where
            customer_id = ?
            and status = 'ACTIVE'
    };

	dlog("querySoftwareLparNames=$query");
	return ( 'softwareLparNames', $query, \@fields );
}

sub isValidSoftwareLpar {
	my ( $self, $softwareLpar ) = @_;

	return 0 if ( !defined $softwareLpar->id );

	return 0 if ( $softwareLpar->status ne 'ACTIVE' );

	my $hwSwComposite = $self->getHwSwComposite($softwareLpar);

	return 0 if ( !defined $hwSwComposite->id );

	my $hardwareLpar = new BRAVO::OM::HardwareLpar();
	$hardwareLpar->id( $hwSwComposite->hardwareLparId );
	$hardwareLpar->getById( $self->connection );
	dlog( $hardwareLpar->toString );

	return 0 if ( $hardwareLpar->status ne 'ACTIVE' );

	my $hardware = new BRAVO::OM::Hardware();
	$hardware->id( $hardwareLpar->hardwareId );
	$hardware->getById( $self->connection );
	dlog( $hardware->toString );

	return 0 if ( $hardware->status         ne 'ACTIVE' );
	return 0 if ( $hardware->hardwareStatus ne 'ACTIVE' );

	return 1;
}

sub getHwSwComposite {
	my ( $self, $softwareLpar ) = @_;

	$self->connection->prepareSqlQueryAndFields( $self->queryHwSwComposite );
	my $sth = $self->connection->sql->{hwSwComposite};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{hwSwCompositeFields} } );
	$sth->execute( $softwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;

	my $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
	$hwSwComposite->softwareLparId( $softwareLpar->id );
	$hwSwComposite->id( $rec{id} );
	$hwSwComposite->hardwareLparId( $rec{hardwareLparId} );
	dlog( $hwSwComposite->toString );

	return $hwSwComposite;
}

sub queryHwSwComposite {
	my $self = shift;

	my @fields = qw(
	  id
	  hardwareLparId
	);

	my $query = qq{
        select
            id
            ,hardware_lpar_id
        from
            hw_sw_composite
        where
            software_lpar_id = ?      
    };

	dlog("queryHwSwComposite=$query");
	return ( 'hwSwComposite', $query, \@fields );
}

sub isValidCustomer {
	my $self = shift;

	return 0 if ( $self->customer->status        ne 'ACTIVE' );
	return 0 if ( $self->customer->swLicenseMgmt ne 'YES' );

	return 1;
}

sub validate {
	my $self = shift;

	croak 'Apply changes is undefined'
	  unless defined $self->applyChanges;

	croak 'Invalid value for apply changes'
	  unless $self->applyChanges == 1 || $self->applyChanges == 0;

	croak 'Connection is undefined'
	  unless defined $self->connection;

	croak 'Customer is undefined'
	  unless defined $self->customer;

	croak 'Invalid report file'
	  unless defined $self->reportFile;
}

sub applyChanges {
	my $self = shift;
	$self->{_applyChanges} = shift if scalar @_ == 1;
	return $self->{_applyChanges};
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

sub customer {
	my $self = shift;
	$self->{_customer} = shift if scalar @_ == 1;
	return $self->{_customer};
}

sub restoreManual {
	my $self = shift;
	$self->{_restoreManual} = shift if scalar @_ == 1;
	return $self->{_restoreManual};
}

sub softwareLparNames {
	my $self = shift;
	$self->{_softwareLparNames} = shift if scalar @_ == 1;
	return $self->{_softwareLparNames};
}

sub installedSoftwareIds {
	my $self = shift;
	$self->{_installedSoftwareIds} = shift if scalar @_ == 1;
	return $self->{_installedSoftwareIds};
}

sub reportFile {
	my $self = shift;
	$self->{_reportFile} = shift if scalar @_ == 1;
	return $self->{_reportFile};
}

sub licenseIds {
	my $self = shift;
	$self->{_licenseIds} = shift if scalar @_ == 1;
	return $self->{_licenseIds};
}

sub addToLicenseIds {
	my ( $self, $id ) = @_;

	my $hash = $self->licenseIds;
	$hash->{$id}++;
	$self->licenseIds($hash);
}

sub addToSoftwareLparNames {
	my ( $self, $name ) = @_;

	my $names = $self->softwareLparNames;
	push( @{$names}, $name );
	$self->softwareLparNames($names);
}

sub addToInstalledSoftwareIds {
	my ( $self, $installedSwId ) = @_;

	my $installedSwIds = $self->installedSoftwareIds;
	push( @{$installedSwIds}, $installedSwId );
	$self->installedSoftwareIds($installedSwIds);
}

sub report {
	my ( $self, $comment ) = @_;

	open( REPORT, ">>" . $self->reportFile )
	  || die "Cannot open report file: $!";
	print REPORT $comment . "\n";
	close REPORT;
}

1;
