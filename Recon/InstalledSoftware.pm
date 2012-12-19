package Recon::InstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::License;
use BRAVO::OM::Software;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconInstalledSoftwareData;
use Recon::OM::Reconcile;
use Recon::OM::AlertUnlicensedSoftware;
use Recon::OM::AlertUnlicensedSoftwareHistory;
use Recon::OM::LicenseView;
use Recon::OM::UsedLicense;
use Recon::OM::ReconcileUsedLicense;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use Recon::Delegate::ReconDelegate;
use Recon::License;
use Recon::Delegate::ReconInstalledSoftwareValidation;
use Recon::OM::PvuMap;
use Recon::OM::PvuInfo;
use Recon::SoftwareLpar;

sub new {
	my ( $class, $connection, $installedSoftware, $poolRunning ) = @_;
	my $self = {
		_connection                 => $connection,
		_installedSoftware          => $installedSoftware,
		_poolParentCustomers        => undef,
		_customer                   => undef,
		_installedSoftwareReconData => undef,
		_poolRunning => $poolRunning
		
	};
	bless $self, $class;

	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Connection is undefined'
	  unless defined $self->connection;

	croak 'Installed software is undefined'
	  unless defined $self->installedSoftware;

	dlog( "installed software=" . $self->installedSoftware->toString() );
}

sub setUp {
	my $self = shift;

	###Get recon inst sw data object.
	$self->getInstalledSoftwareReconData;
	dlog( "installedSoftwareReconData="
		  . $self->installedSoftwareReconData->toString() );

	my $customer = new BRAVO::OM::Customer();
	$customer->id( $self->installedSoftwareReconData->cId );
	$customer->getById( $self->connection );
	$self->customer($customer);

	my $poolParentCustomers =
	  CNDB::Delegate::CNDBDelegate->getAccountPoolParents( $self->connection,
		$customer->id );
	if ( keys( %{$poolParentCustomers} ) == 0 ) {
		$poolParentCustomers->{-1} = 0;
	}
	$self->poolParentCustomers($poolParentCustomers);

	#Get correspond pvu value under specific processor brand/model.
	my $processorCount = 0;
	if ( $self->installedSoftwareReconData->hProcCount > 0 ) {
		$processorCount = $self->installedSoftwareReconData->hProcCount;
	}
	else {
		$processorCount = $self->installedSoftwareReconData->processorCount;
	}

	my $chipCount = $self->installedSoftwareReconData->hChips;

	my $valueUnitsPerCore =
	  $self->getValueUnitsPerProcessor( $chipCount, $processorCount );
	$self->pvuValue($valueUnitsPerCore);

	###fetch the hw server type, if its lpar is mix
	### partitioning (some LPARs are production and some are development) 'PRODUCTON' will return.
	my $hwServerType = $self->fetchMechineLevelServerType(
		$self->installedSoftwareReconData->hId,
		$self->installedSoftwareReconData->hServerType
	);
	$self->mechineLevelServerType($hwServerType);
}

sub recon {
	my $self = shift;

	dlog("begin recon");
	$self->setUp;

	###0 --> Installed Software Object is invalid
	###1 --> Installed Software is not reconciled
	###2 --> Installed Software Reconcile Object is invalid
	###3 --> Installed Software Reconcile Object is valid
	my $validation = new Recon::Delegate::ReconInstalledSoftwareValidation();
	$validation->customer( $self->customer );
	$validation->connection( $self->connection );
	$validation->installedSoftware( $self->installedSoftware );
	$validation->installedSoftwareReconData(
		$self->installedSoftwareReconData );
	$validation->discrepancyTypeMap(
		BRAVO::Delegate::BRAVODelegate->getDiscrepancyTypeMap() );
	$validation->reconcileTypeMap(
		Recon::Delegate::ReconDelegate->getReconcileTypeMap() );
	$validation->poolParentCustomers( $self->poolParentCustomers );
	$validation->valueUnitsPerCore( $self->pvuValue );
	$validation->validate;

	if ( $validation->isValid == 1 ) {
		dlog("Installed software is reconciled and valid, closing alert");
		$self->closeAlertUnlicensedSoftware(1);
		dlog("returning to caller");
		return 1;
	}

	if ( $validation->validationCode == 0 ) {
		dlog("Installed software is invalid");
		$self->closeAlertUnlicensedSoftware(0);
		Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
			$self->installedSoftwareReconData->rId )
		  if defined $self->installedSoftwareReconData->rId;
	}
	elsif ( $validation->validationCode == 1 ) {
		dlog("Installed software is not reconciled");
		my $returnCode = $self->reconcile;
		if ( $returnCode == 1 ) {
			$self->closeAlertUnlicensedSoftware(1);
		}
		elsif ($returnCode == 2) {
		    return $returnCode;
		}
		else {
			$self->openAlertUnlicensedSoftware;
		}
	}
	elsif ( $validation->validationCode == 2 ) {
		dlog("Installed software is reconciled, reconcile is invalid");
		$self->openAlertUnlicensedSoftware;
		my $recon = new Recon::OM::ReconInstalledSoftware();
		$recon->installedSoftwareId( $self->installedSoftware->id );
		$recon->action('UPDATE');
		$recon->getByBizKey( $self->connection );
		$recon->delete( $self->connection );
		Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
			$self->installedSoftwareReconData->rId );
	}

	$self->addChildrenToQueue;

	my $swLpar = $self->getSoftwareLpar;
	if ( $swLpar->status eq 'ACTIVE' ) {
		my $recon =
		  Recon::SoftwareLpar->new( $self->connection, $swLpar, undef );
		if ( $self->isCategoryOS ) {
			$recon->action('OS');
			$recon->recon;
		}
		$recon->action('SW');
		$recon->recon;
		$recon->action('LICENSABLE');
		$recon->recon;
	}
	dlog("returning to caller");
	return 1;
}

sub isCategoryOS {
	my $self = shift;

	my $softwareCategoryName = $self->getSoftwareCategoryName;

	if ( defined $softwareCategoryName
		&& $softwareCategoryName eq "Operating Systems" )
	{
		return 1;
	}
	return 0;
}

sub getSoftwareCategoryName {
	my $self = shift;

	return undef
	  if ( !defined $self->installedSoftware->softwareId );
	my $scName;
	$self->connection->prepareSqlQuery( $self->querySCNameBySoftwareId() );
	my $sth = $self->connection->sql->{scNameBySoftwareId};
	$sth->bind_columns( \$scName );
	$sth->execute( $self->installedSoftware->softwareId );
	$sth->fetchrow_arrayref;
	$sth->finish;

	return $scName;
}

sub querySCNameBySoftwareId {
	my $query = '
        select 
                     sc.SOFTWARE_CATEGORY_NAME 
                from 
                     software sw 
                     ,software_category sc  
                where sw.SOFTWARE_ID=?
                      and  sw.SOFTWARE_CATEGORY_ID = sc.SOFTWARE_CATEGORY_ID 
    ';
	dlog("querySCNameBySoftwareId=$query");
	return ( 'scNameBySoftwareId', $query );
}

sub getSoftwareLpar {
	my $self = shift;

	my $softwareLpar = new BRAVO::OM::SoftwareLpar();
	$softwareLpar->id( $self->installedSoftware->softwareLparId );
	$softwareLpar->getById( $self->connection );
	return $softwareLpar;
}

sub reconcile {
	my $self = shift;

	return 1 if $self->attemptVendorManaged == 1;
	return 1 if $self->attemptSoftwareCategory == 1;
	return 1 if $self->attemptBundled == 1;
	return 1 if $self->attemptCustomerOwnedAndManaged == 1;
	if($self->poolRunning == 1) {
	    return 2;
	}

	my $licsToAllocate;
	my $reconcileTypeId;
	my $machineLevel;
	my $reconcileIdForMachineLevel;

	(
		$licsToAllocate, $reconcileTypeId,
		$machineLevel,   $reconcileIdForMachineLevel
	  )
	  = $self->attemptLicenseAllocation;

	dlog( "reconcileTypeId=" . $reconcileTypeId );
	dlog( "machineLevel=" . $machineLevel );

	if ( defined $licsToAllocate ) {

		###Create reconcile and set id in data.
		my $rId =
		  $self->createReconcile( $reconcileTypeId, $machineLevel,
			$self->installedSoftware->id );

		foreach my $lId ( keys %{$licsToAllocate} ) {
			dlog( "allocating license id=$lId, using quantity="
				  . $licsToAllocate->{$lId} );

			###Create lic recon map.
			my $rul =
			  $self->createReconcileUsedLicense( $lId, $rId,
				$licsToAllocate->{$lId},
				$machineLevel, $reconcileIdForMachineLevel );
		}

		dlog("end attemptReconcile");

		return 1;
	}
	elsif ( defined $self->customer->swComplianceMgmt
		&& $self->customer->swComplianceMgmt eq 'YES' )
	{
		if ( defined $self->installedSoftwareReconData->scopeName ) {
			if ( $self->installedSoftwareReconData->scopeName eq 'CUSTOIBMM' ) {
				###Create reconcile and set id in data.
				my $reconcileTypeMap =
				  Recon::Delegate::ReconDelegate->getReconcileTypeMap();
				my $rId =
				  $self->createReconcile(
					$reconcileTypeMap->{'Pending customer decision'},
					0, $self->installedSoftware->id );
				return 1;
			}
		}
	}

	return 0;
}

sub attemptVendorManaged {
	my $self = shift;
	dlog("attempting vendor managed");

	###Get reconcile type map.
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	###Vendor managed.
	if ( $self->installedSoftwareReconData->sVendorMgd == 1 ) {
		dlog("reconciling as vendor managed");

		###Create reconcile and set id in data.
		$self->createReconcile( $reconcileTypeMap->{'Vendor managed product'},
			0, $self->installedSoftware->id );
		dlog("end attemptReconcile");
		return 1;
	}

	dlog("Did not reconcile as vendor managed");
	return 0;
}

sub attemptSoftwareCategory {
	my $self = shift;
	dlog("attempt software category");

	###Get reconcile type map.
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	###Software category.
	if ( defined $self->installedSoftwareReconData->scParent ) {
		dlog("reconciling as software category");

		###Create reconcile and set id in data.
		$self->createReconcile(
			$reconcileTypeMap->{'Covered by software category'},
			0, $self->installedSoftwareReconData->scParent );
		dlog("end attemptReconcile");
		return 1;
	}

	dlog("Did not reconcile as software category");
	return 0;
}

sub attemptBundled {
	my $self = shift;
	dlog("attempt bundled");

	###Get reconcile type map.
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	###Bundled software.
	if ( defined $self->installedSoftwareReconData->bParent ) {
		dlog("reconciling as bundled software");

		###Create reconcile and set id in data.
		$self->createReconcile( $reconcileTypeMap->{'Bundled software product'},
			0, $self->installedSoftwareReconData->bParent );
		dlog("end attemptReconcile");
		return 1;
	}

	dlog("Did not reconcile as bundle");
	return 0;
}

sub attemptCustomerOwnedAndManaged {
	my $self = shift;

	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	if ( defined $self->installedSoftwareReconData->scopeName
		&& $self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM' )
	{
		dlog("reconciling as Customer owned and customer managed");
		###Create reconcile and set id in data.
		$self->createReconcile(
			$reconcileTypeMap->{'Customer owned and customer managed'},
			0, $self->installedSoftware->id );
		dlog("end attemptReconcile");
		return 1;
	}
	
	dlog("Did not reconcile as customer owned and managed");
	return 0;
}

sub attemptExistingMachineLevel {
	my $self = shift;
	dlog("attempt existing machine level");

	my %licsToAllocate;
	my $reconciles = $self->getExistingMachineLevelRecon;

	my $reconcileTypeId;
	my $reconcileIdForUsedLicense;

	foreach my $reconcileId ( sort keys %{$reconciles} ) {
		dlog( "reconcileId=" . $reconcileId );

		my $reconcile = new Recon::OM::Reconcile();
		$reconcile->id($reconcileId);
		$reconcile->getById( $self->connection );
		dlog( $reconcile->toString );

		my $installedSoftware = new BRAVO::OM::InstalledSoftware();
		$installedSoftware->id( $reconcile->installedSoftwareId );
		$installedSoftware->getById( $self->connection );
		dlog( $installedSoftware->toString );

		my $recon =
		  Recon::InstalledSoftware->new( $self->connection,
			$installedSoftware );
		$recon->setUp;

		my $validation =
		  new Recon::Delegate::ReconInstalledSoftwareValidation();
		$validation->customer( $recon->customer );
		$validation->connection( $recon->connection );
		$validation->installedSoftware( $recon->installedSoftware );
		$validation->installedSoftwareReconData(
			$recon->installedSoftwareReconData );
		$validation->discrepancyTypeMap(
			BRAVO::Delegate::BRAVODelegate->getDiscrepancyTypeMap() );
		$validation->reconcileTypeMap(
			Recon::Delegate::ReconDelegate->getReconcileTypeMap() );
		$validation->poolParentCustomers( $recon->poolParentCustomers );
		$validation->valueUnitsPerCore( $self->pvuValue );
		$validation->validate;

		next if ( $validation->isValid != 1 );

		foreach my $licenseId ( keys %{ $reconciles->{$reconcileId} } ) {
			dlog( "licenseId=" . $licenseId );

			$licsToAllocate{$licenseId} =
			  $reconciles->{$reconcileId}->{$licenseId}->{'usedQuantity'};
			dlog( "usedQuantity=" . $licsToAllocate{$licenseId} );

			$reconcileTypeId =
			  $reconciles->{$reconcileId}->{$licenseId}->{'reconcileTypeId'};
			dlog( "reconcileTypeId=" . $reconcileTypeId );

		}
		$reconcileIdForUsedLicense = $reconcileId;

		last;
	}

	if ( defined $reconcileTypeId && defined $reconcileIdForUsedLicense ) {
		dlog("allocated");
		return ( \%licsToAllocate, $reconcileTypeId,
			$reconcileIdForUsedLicense );
	}
	else {
		dlog("unable to allocate");
		return ( undef, undef, undef );
	}
}

sub attemptLicenseAllocation {
	my $self = shift;
	dlog("being attempt license allocation");

	###Get reconcile type map.
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();
	my $machineLevel;

	###Attempt to reconcile at machine level if one is already reconciled at machine level
	my ( $licsToAllocate, $reconcileTypeId, $reconcileId ) =
	  $self->attemptExistingMachineLevel;
	return ( $licsToAllocate, $reconcileTypeId, 1, $reconcileId )
	  if defined $licsToAllocate;

	###Get license free pool by customer id and software id.
	my $freePoolData = $self->getFreePoolData;

	###License type: hw specific MIPS, machine level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMIPS( $freePoolData, 1, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific MIPS, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMIPS( $freePoolData, 0, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific MSU, machine level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMSU( $freePoolData, 1, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific MSU, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMSU( $freePoolData, 0, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: MIPS, machine level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMIPS( $freePoolData, 1, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: MIPS, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMIPS( $freePoolData, 0, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: MSU, machine level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMSU( $freePoolData, 1, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: MSU, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMSU( $freePoolData, 0, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hardware
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationHardware($freePoolData);
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific lpar
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationLpar( $freePoolData, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific processor
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationProcessor( $freePoolData, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: hw specific pvu
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationPVU( $freePoolData, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: chip(48)
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationChip($freePoolData);
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: lpar
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationLpar( $freePoolData, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: processor
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationProcessor( $freePoolData, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	###License type: pvu
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationPVU( $freePoolData, 0 );

	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel );

}

sub getFreePoolData {
	my $self = shift;
	dlog("begin getFreePoolData");

	my %data = ();
	my %machineLevel;

	$self->connection->prepareSqlQueryAndFields( $self->queryFreePoolData() );
	my $sth = $self->connection->sql->{freePoolData};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{freePoolDataFields} } );
	$sth->execute(
		$self->installedSoftwareReconData->cId,
		$self->installedSoftwareReconData->cId,
		$self->installedSoftware->softwareId
	);

	while ( $sth->fetchrow_arrayref ) {
		dlog("lId =$rec{lId}");
		if ( defined $rec{usedQuantity} && $rec{machineLevel} == 1 ) {
			my $hwServerType = $self->mechineLevelServerType;
			dlog("it is machine level");
			###not do auto recon if hw and lic don't have the same environment.
			dlog(
				"serverType=$hwServerType,rec{lEnvironment}=$rec{lEnvironment}"
			);
			next
			  if (
				$self->isEnvironmentSame( $hwServerType, $rec{lEnvironment} ) ==
				0 );
			dlog('getFreePoolData-license and hw environment same');
		}

		###I should centralize this check
		if ( defined $self->customer->swComplianceMgmt
			&& $self->customer->swComplianceMgmt eq 'YES' )
		{
			if ( defined $self->installedSoftwareReconData->scopeName ) {

				if (
					$self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM'
					|| $self->installedSoftwareReconData->scopeName eq
					'CUSTOIBMM' )
				{
					next if $rec{ibmOwned} == 1;
				}
			}
		}

		if ( !exists $data{ $rec{lId} } ) {
			dlog("new license");

			###Instantiate new license view object.
			my $licView = new Recon::OM::LicenseView();
			$licView->lId( $rec{lId} );
			$licView->cId( $rec{cId} );
			$licView->sId( $rec{sId} );
			$licView->ibmOwned( $rec{ibmOwned} );
			$licView->cpuSerial( $rec{cpuSerial} );
			$licView->expireAge( $rec{expireAge} );
			$licView->quantity( $rec{quantity} );
			$licView->pool( $rec{pool} );
			$licView->capType( $rec{capType} );
			$licView->licenseType( $rec{licenseType} );
			$licView->lparName( $rec{lparName} );
			$licView->environment( $rec{lEnvironment} );
			dlog( $licView->toString );

			if ( defined $rec{usedQuantity} ) {
				dlog( 'Used qty: ' . $rec{usedQuantity} );
				$licView->quantity( $licView->quantity - $rec{usedQuantity} );
				dlog( 'Remaining qty: ' . $licView->quantity );
				if ( $rec{machineLevel} == 1 ) {
					dlog('This is machine level');
					$machineLevel{ $rec{ulId} } = 1;
				}
			}

			###Add to data hash.
			$data{ $rec{lId} } = $licView;
		}
		else {
			###Subsequent row for license view object.
			if ( defined $rec{usedQuantity} ) {
				dlog( $rec{usedQuantity} );
				if ( $rec{machineLevel} == 1 ) {
					if (
						exists $machineLevel{ $rec{ulId}} )
					{
						next;
					}
					else {
						$machineLevel{ $rec{ulId} } = 1;
					}
				}

				$data{ $rec{lId} }->quantity(
					$data{ $rec{lId} }->quantity - $rec{usedQuantity} );
				dlog( $data{ $rec{lId} }->quantity );
			}
		}
	}
	$sth->finish;

	###Remove any lics from the hash that need to be removed
	foreach my $lId ( keys %data ) {
		my $licView = $data{$lId};

		my $validation = new Recon::Delegate::ReconLicenseValidation();
		$validation->validationCode(1);

		###Validate license in scope
		$validation->isLicInFinRespScope(
			$self->customer->swFinancialResponsibility,
			$licView->ibmOwned, undef );
		$validation->validateMaintenanceExpiration(
			$self->installedSoftwareReconData->mtType,
			0, $licView->expireAge, undef, undef );
		$validation->validatePhysicalCpuSerialMatch( $licView->capType,
			$licView->licenseType, $self->installedSoftwareReconData->hSerial,
			$licView->cpuSerial, undef, undef, 0 );
		$validation->validateLparNameMatch(
			$licView->capType,
			$licView->licenseType,
			$licView->lparName,
			$self->installedSoftwareReconData->slName,
			$self->installedSoftwareReconData->hlName,
			undef,
			undef,
			0
		);
		$validation->validateProcessorChip(0,$licView->capType,$self->installedSoftwareReconData->mtType,1,undef);

		###Check pool
		if ( $licView->pool == 0 ) {
			###License is not poolable, must equal customer
			if ( $licView->cId != $self->customer->id ) {
				dlog(
					"License is not poolable and does not equal the customer id"
				);
				$validation->validationCode(0);
			}
		}

		if ( $licView->quantity <= 0 ) {
			dlog( "lic fully allocated, removing from free pool hash: id="
				  . $lId );
			$validation->validationCode(0);
		}

		delete $data{$lId} if $validation->validationCode == 0;
	}

	dlog("end getFreePoolData");
	return \%data;
}

sub isEnvironmentSame {
	my ( $self, $hwEnv, $licEnv ) = @_;
	$hwEnv = 'PRODUCTION'
	  if !defined $hwEnv || $hwEnv eq '';
	$licEnv = 'PRODUCTION'
	  if !defined $licEnv || $licEnv eq '';

	dlog("isEnvironmentSame, hw enviroment=$hwEnv,sw enviroment=$licEnv");
	return 0
	  if $hwEnv ne $licEnv;
	return 1;
}

sub attemptLicenseAllocationHardware {
	my ( $self, $freePoolData ) = @_;
	dlog("begin attemptLicenseAllocationHardware");

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel = 1;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation for just this customer.
	foreach my $lId ( keys %{$freePoolData} ) {
		my $lEnv = $freePoolData->{$lId}->environment;

		my $licView = $freePoolData->{$lId};
		next unless $licView->capType eq '34';
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		next unless defined $licView->cpuSerial;
		next
		  unless $licView->cpuSerial eq
		  $self->installedSoftwareReconData->hSerial;
		dlog("license environment=$lEnv");
		next
		  if (
			$self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv ) ==
			0 );
		dlog("found matching license");
		$licsToAllocate{$lId} = 1;
		$isFullyAllocated = 1;
		last;
	}

	if ( $isFullyAllocated == 0 ) {
		###Iterate over free pool for the parent
		foreach my $lId ( keys %{$freePoolData} ) {
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType eq '34';
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("found matching license");
			$licsToAllocate{$lId} = 1;
			$isFullyAllocated = 1;
			last;
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationHardware");
}

sub attemptLicenseAllocationLpar {
	my ( $self, $freePoolData, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationLpar");
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel = 0;

	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.
	foreach my $lId ( keys %{$freePoolData} ) {
		my $licView = $freePoolData->{$lId};
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		### next unless these are lpar capacity types
		next
		  unless $licView->capType eq '13' || $licView->capType eq '14';
		next unless defined $licView->cpuSerial;
		next
		  unless $licView->cpuSerial eq
		  $self->installedSoftwareReconData->hSerial;
		dlog("found matching license - hw specific");
		$licsToAllocate{$lId}  = 1;
		$tempQuantityAllocated = 1;
		$isFullyAllocated      = 1;
		last;
	}

	if ( $isFullyAllocated == 0 ) {
		###Iterate over free pool and attempt allocation - hw specific.
		foreach my $lId ( keys %{$freePoolData} ) {
			my $licView = $freePoolData->{$lId};
			### next unless these are lpar capacity types
			next
			  unless $licView->capType eq '13'
			  || $licView->capType     eq '14';
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			dlog("found matching license - hw specific");
			$licsToAllocate{$lId}  = 1;
			$tempQuantityAllocated = 1;
			$isFullyAllocated      = 1;
			last;
		}
	}

	if ( $hwSpecificOnly == 0 && $isFullyAllocated == 0 ) {

		###Iterate over free pool and attempt allocation - non hw specific.
		foreach my $lId ( keys %{$freePoolData} ) {
			my $licView = $freePoolData->{$lId};
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next
			  unless $licView->capType eq '13'
			  || $licView->capType     eq '14';
			dlog("found matching license - non hw specific");
			$licsToAllocate{$lId}  = 1;
			$tempQuantityAllocated = 1;
			$isFullyAllocated      = 1;
			last;
		}

		if ( $isFullyAllocated == 0 ) {
			###Iterate over free pool and attempt allocation - non hw specific.
			foreach my $lId ( keys %{$freePoolData} ) {
				my $licView = $freePoolData->{$lId};
				next
				  unless $licView->capType eq '13'
				  || $licView->capType     eq '14';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("found matching license - non hw specific");
				$licsToAllocate{$lId}  = 1;
				$tempQuantityAllocated = 1;
				$isFullyAllocated      = 1;
				last;
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationLpar");
}

sub attemptLicenseAllocationProcessor {
	my ( $self, $freePoolData, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationProcessor");
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel;
	my $processorCount = 0;

	if ( $self->installedSoftwareReconData->hProcCount > 0 ) {
		$machineLevel   = 1;
		$processorCount = $self->installedSoftwareReconData->hProcCount;
	}
	else {
		$machineLevel   = 0;
		$processorCount = $self->installedSoftwareReconData->processorCount;
	}

	return undef if $processorCount == 0;

	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.
	foreach my $lId ( keys %{$freePoolData} ) {
		my $lEnv = $freePoolData->{$lId}->environment;

		my $licView = $freePoolData->{$lId};
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		next unless $licView->capType eq '2';
		next unless defined $licView->cpuSerial;
		next
		  unless $licView->cpuSerial eq
		  $self->installedSoftwareReconData->hSerial;
		dlog("attemptLicenseAllocationProcessor license environment=$lEnv");
		next
		  if ( $machineLevel == 1
			&& $self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv )
			== 0 );
		dlog("found matching license - hw specific");
		my $neededQuantity = $processorCount - $tempQuantityAllocated;
		dlog( "neededQuantity=" . $neededQuantity );

		if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
			$licsToAllocate{$lId}  = $neededQuantity;
			$tempQuantityAllocated = $tempQuantityAllocated + $neededQuantity;
			$isFullyAllocated      = 1;
			last;
		}
		else {
			$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
			$tempQuantityAllocated =
			  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
			$freePoolData->{$lId}->quantity(0);
		}
	}

	###Iterate over free pool and attempt allocation - hw specific.
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType eq '2';
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("attemptLicenseAllocationProcessor license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - hw specific");
			my $neededQuantity = $processorCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}

	if ( $hwSpecificOnly == 0 && $isFullyAllocated == 0 ) {

		###Iterate over free pool and attempt allocation - non hw specific.
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless $licView->capType eq '2';
			dlog("attemptLicenseAllocationProcessor license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - non hw specific");
			my $neededQuantity = $processorCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}

		###Iterate over free pool and attempt allocation - non hw specific.
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				next unless $licView->capType eq '2';
				dlog(
"attemptLicenseAllocationProcessor license environment=$lEnv"
				);
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );
				dlog("found matching license - non hw specific");
				my $neededQuantity = $processorCount - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationProcessor");
}

sub attemptLicenseAllocationMIPS {
	my ( $self, $freePoolData, $machineLevel, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationMIPS");
	dlog( "machineLevel=" . $machineLevel );
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	return undef
	  if $self->installedSoftwareReconData->mtType eq ' MAINFRAME ';

	###Hash to return.
	my %licsToAllocate;
	my $mipsCount = 0;

	if ( $machineLevel == 1 && $self->installedSoftwareReconData->hCpuMIPS > 0 )
	{
		$mipsCount = $self->installedSoftwareReconData->hCpuMIPS;
	}
	elsif ($machineLevel == 0
		&& $self->installedSoftwareReconData->hlPartMIPS > 0 )
	{
		$mipsCount = $self->installedSoftwareReconData->hlPartMIPS;
	}
	return undef if $mipsCount == 0;
	dlog( "mipsCount=" . $mipsCount );
	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.

	###Named CPU
	foreach my $lId ( keys %{$freePoolData} ) {
		my $licView = $freePoolData->{$lId};
		my $lEnv    = $freePoolData->{$lId}->environment;
		next unless $licView->capType     eq '5';
		next unless $licView->licenseType eq 'NAMED CPU';
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		dlog("license environment=$lEnv");
		next
		  if ( $machineLevel == 1
			&& $self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv )
			== 0 );

		my $neededQuantity = $mipsCount - $tempQuantityAllocated;
		dlog( "neededQuantity=" . $neededQuantity );
		dlog( "freeQuantity=" . $freePoolData->{$lId}->quantity );

		if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
			$licsToAllocate{$lId}  = $neededQuantity;
			$tempQuantityAllocated = $tempQuantityAllocated + $neededQuantity;
			$isFullyAllocated      = 1;
			last;
		}
		else {
			$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
			$tempQuantityAllocated =
			  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
			$freePoolData->{$lId}->quantity(0);
		}
	}
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'NAMED CPU';
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $mipsCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );
			dlog( "freeQuantity=" . $freePoolData->{$lId}->quantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}

	###Named LPAR
	if ( $isFullyAllocated == 0 && $machineLevel == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'NAMED LPAR';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $mipsCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );
			dlog( "freeQuantity=" . $freePoolData->{$lId}->quantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq '5';
				next unless $licView->licenseType eq 'NAMED LPAR';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );

				my $neededQuantity = $mipsCount - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );
				dlog( "freeQuantity=" . $freePoolData->{$lId}->quantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}
	###FC
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $mipsCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {

				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $mipsCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}
	if ( $isFullyAllocated == 0 && $hwSpecificOnly == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $mipsCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq '5';
				next unless $licView->licenseType eq 'FC';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );

				my $neededQuantity = $mipsCount - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationMIPS");
}

sub attemptLicenseAllocationMSU {
	my ( $self, $freePoolData, $machineLevel, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationMSU");
	dlog( "machineLevel=" . $machineLevel );
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	return undef
	  if $self->installedSoftwareReconData->mtType eq ' MAINFRAME ';

	###Hash to return.
	my %licsToAllocate;
	my $msuCount = 0;

	if ( $machineLevel == 1 && $self->installedSoftwareReconData->hCpuMSU > 0 )
	{
		$msuCount = $self->installedSoftwareReconData->hCpuMSU;
	}
	elsif ($machineLevel == 0
		&& $self->installedSoftwareReconData->hlPartMSU > 0 )
	{
		$msuCount = $self->installedSoftwareReconData->hlPartMSU;
	}
	return undef if $msuCount == 0;
	dlog( "msuCount=" . $msuCount );
	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.

	###Named CPU
	foreach my $lId ( keys %{$freePoolData} ) {
		my $lEnv    = $freePoolData->{$lId}->environment;
		my $licView = $freePoolData->{$lId};
		next unless $licView->capType     eq '9';
		next unless $licView->licenseType eq 'NAMED CPU';
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;

		#        next unless defined $licView->cpuSerial;
		#        next
		#             unless $licView->cpuSerial eq
		#                $self->installedSoftwareReconData->hSerial;
		dlog("license environment=$lEnv");
		next
		  if ( $machineLevel == 1
			&& $self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv )
			== 0 );

		my $neededQuantity = $msuCount - $tempQuantityAllocated;
		dlog( "neededQuantity=" . $neededQuantity );

		if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
			$licsToAllocate{$lId}  = $neededQuantity;
			$tempQuantityAllocated = $tempQuantityAllocated + $neededQuantity;
			$isFullyAllocated      = 1;
			last;
		}
		else {
			$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
			$tempQuantityAllocated =
			  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
			$freePoolData->{$lId}->quantity(0);
		}
	}
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '5';
			next unless $licView->licenseType eq 'NAMED CPU';
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			#            next unless defined $licView->cpuSerial;
			#            next
			#                 unless $licView->cpuSerial eq
			#                    $self->installedSoftwareReconData->hSerial;

			my $neededQuantity = $msuCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}

	###Named LPAR
	if ( $isFullyAllocated == 0 && $machineLevel == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '9';
			next unless $licView->licenseType eq 'NAMED LPAR';

#            next unless defined $licView->lparName;
#            next
#                unless ($licView->lparName eq
#                $self->installedSoftwareReconData->slName || $licView->lparName eq
#                $self->installedSoftwareReconData->hlName);
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			my $neededQuantity = $msuCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq '9';
				next unless $licView->licenseType eq 'NAMED LPAR';

#                next unless defined $licView->lparName;
#                next
#                    unless ($licView->lparName eq
#                    $self->installedSoftwareReconData->slName || $licView->lparName eq
#                $self->installedSoftwareReconData->hlName);
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );
				my $neededQuantity = $msuCount - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}
	###FC
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '9';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $msuCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {

				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '9';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $msuCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}
	if ( $isFullyAllocated == 0 && $hwSpecificOnly == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq '9';
			next unless $licView->licenseType eq 'FC';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );

			my $neededQuantity = $msuCount - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq '9';
				next unless $licView->licenseType eq 'FC';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );
				my $neededQuantity = $msuCount - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationMSU");
}

sub attemptLicenseAllocationPVU {
	my ( $self, $freePoolData, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationPVU");
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel;
	my $processorCount = 0;

	if ( $self->installedSoftwareReconData->hProcCount > 0 ) {
		$machineLevel   = 1;
		$processorCount = $self->installedSoftwareReconData->hProcCount;
	}
	else {
		$machineLevel   = 0;
		$processorCount = $self->installedSoftwareReconData->processorCount;
	}

	return undef if $processorCount == 0;

	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.
	foreach my $lId ( keys %{$freePoolData} ) {
		my $lEnv    = $freePoolData->{$lId}->environment;
		my $licView = $freePoolData->{$lId};
		next unless $self->installedSoftwareReconData->hProcCount > 0;
		next unless $licView->capType eq '17';
		next unless defined $licView->cpuSerial;
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		next
		  unless $licView->cpuSerial eq
		  $self->installedSoftwareReconData->hSerial;
		dlog("license environment=$lEnv");
		next
		  if ( $machineLevel == 1
			&& $self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv )
			== 0 );
		dlog("found matching license - hw specific");
		my $valueUnitsPerProcessor = $self->pvuValue;
		my $neededQuantity         =
		  ( $processorCount * $valueUnitsPerProcessor ) -
		  $tempQuantityAllocated;
		dlog( "neededQuantity=" . $neededQuantity );

		if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
			$licsToAllocate{$lId}  = $neededQuantity;
			$tempQuantityAllocated = $tempQuantityAllocated + $neededQuantity;
			$isFullyAllocated      = 1;
			last;
		}
		else {
			$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
			$tempQuantityAllocated =
			  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
			$freePoolData->{$lId}->quantity(0);
		}
	}

	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType eq '17';
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - hw specific");
			my $valueUnitsPerProcessor = $self->pvuValue;
			my $neededQuantity         =
			  ( $processorCount * $valueUnitsPerProcessor ) -
			  $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}

	if ( $hwSpecificOnly == 0 && $isFullyAllocated == 0 ) {

		###Iterate over free pool and attempt allocation - non hw specific.
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType eq '17';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - non hw specific");
			my $valueUnitsPerProcessor = $self->pvuValue;
			my $neededQuantity         =
			  ( $processorCount * $valueUnitsPerProcessor ) -
			  $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}

		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType eq '17';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );
				dlog("found matching license - non hw specific");
				my $valueUnitsPerProcessor = $self->pvuValue;
				my $neededQuantity         =
				  ( $processorCount * $valueUnitsPerProcessor ) -
				  $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationPVU");
}

sub getValueUnitsPerProcessor {
	my ( $self, $chipCount, $processorCount ) = @_;
	my $defaultValue      = 100;
	my $valueUnitsPerCore = 0;
	dlog(
"start caculating pvu, chipCount=$chipCount processorCount=$processorCount"
	);
	if ( $chipCount == 0 ) {
		dlog("end of caculating pvu $defaultValue returned");
		return $defaultValue;
	}

	my $pvuMap = new Recon::OM::PvuMap;
	$pvuMap->processorBrand(
		$self->installedSoftwareReconData->hProcessorBrand );
	$pvuMap->processorModel(
		$self->installedSoftwareReconData->hProcessorModel );
	$pvuMap->machineTypeId( $self->installedSoftwareReconData->hMachineTypeId );
	$pvuMap->getByBizKey( $self->connection );

	if ( defined $pvuMap->id ) {

		my $procTypeFlag = $processorCount / $chipCount;
		if ( $procTypeFlag == 0 || $procTypeFlag < 1 ) {
			return $defaultValue;
		}

		my $processorSql = '';

		if ( $procTypeFlag == 1 ) {
			$processorSql =
" (processor_type = 'SINGLE-CORE' or processor_type like \'%ONE%\') ";
		}
		elsif ( $procTypeFlag == 2 ) {
			$processorSql = " processor_type = \'DUAL-CORE\' ";
		}
		elsif ( $procTypeFlag == 4 ) {
			$processorSql = " processor_type like \'%QUAD-CORE%\' ";
		}

		if ( $processorSql != '' ) {
			$valueUnitsPerCore =
			  $self->getValueUnitsPerCore( $processorSql, $pvuMap->pvuId );
		}

		if ( $valueUnitsPerCore == 0 && $procTypeFlag > 1 ) {
			$processorSql      = " processor_type like \'%MULTI-CORE%\' ";
			$valueUnitsPerCore =
			  $self->getValueUnitsPerCore( $processorSql, $pvuMap->pvuId );
		}

		dlog("processor sql is $processorSql");

		if ( $valueUnitsPerCore != 0 ) {
			dlog("end of caculating pvu $valueUnitsPerCore returned");
			return $valueUnitsPerCore;
		}
	}
	dlog("end of caculating pvu $defaultValue returned");
	return $defaultValue;
}

sub getValueUnitsPerCore {
	my ( $self, $sql, $pvuId ) = @_;

	$self->connection->prepareSqlQueryAndFields(
		$self->queryValueUnitsPerCore($sql) );
	my $sth   = $self->connection->sql->{valueUnitsPerCore};
	my $count = 0;
	$sth->bind_columns( \$count );
	$sth->execute($pvuId);
	$sth->fetchrow_arrayref;
	$sth->finish;
	return $count;
}

sub queryValueUnitsPerCore {
	my ( $self, $sql ) = @_;

	my $query = '
        select
            value_units_per_core
        from
            pvu_info
        where
            pvu_id = ?
            and ' . $sql;

	return ( 'valueUnitsPerCore', $query );
}

sub attemptLicenseAllocationChip {
	my ( $self, $freePoolData ) = @_;
	dlog("begin attemptLicenseAllocationChip");

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel = 1;
	my $chips        = $self->installedSoftwareReconData->hChips;

	return undef if $chips == 0;
	return undef
	  if $self->installedSoftwareReconData->mtType eq ' WORKSTATION ';

	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.
	foreach my $lId ( keys %{$freePoolData} ) {
		my $lEnv    = $freePoolData->{$lId}->environment;
		my $licView = $freePoolData->{$lId};
		next
		  unless $licView->cId eq $self->installedSoftwareReconData->cId;
		next unless $licView->capType eq '48';
		next unless defined $licView->cpuSerial;
		next
		  unless $licView->cpuSerial eq
		  $self->installedSoftwareReconData->hSerial;
		dlog("license environment=$lEnv");
		next
		  if ( $machineLevel == 1
			&& $self->isEnvironmentSame( $self->mechineLevelServerType, $lEnv )
			== 0 );
		dlog("found matching license - hw specific");
		my $neededQuantity = $chips - $tempQuantityAllocated;
		dlog( "neededQuantity=" . $neededQuantity );

		if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
			$licsToAllocate{$lId}  = $neededQuantity;
			$tempQuantityAllocated = $tempQuantityAllocated + $neededQuantity;
			$isFullyAllocated      = 1;
			last;
		}
		else {
			$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
			$tempQuantityAllocated =
			  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
			$freePoolData->{$lId}->quantity(0);
		}
	}

	###Iterate over free pool and attempt allocation - hw specific.
	if ( $isFullyAllocated == 0 ) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType eq '48';
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next
			  unless $licView->cpuSerial eq
			  $self->installedSoftwareReconData->hSerial;
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - hw specific");
			my $neededQuantity = $chips - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}
	}

	if ( $isFullyAllocated == 0 ) {

		###Iterate over free pool and attempt allocation - non hw specific.
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless $licView->capType eq '48';
			dlog("license environment=$lEnv");
			next
			  if (
				$machineLevel == 1
				&& $self->isEnvironmentSame(
					$self->mechineLevelServerType, $lEnv
				) == 0
			  );
			dlog("found matching license - non hw specific");
			my $neededQuantity = $chips - $tempQuantityAllocated;
			dlog( "neededQuantity=" . $neededQuantity );

			if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
				$licsToAllocate{$lId} = $neededQuantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $neededQuantity;
				$isFullyAllocated = 1;
				last;
			}
			else {
				$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
				$tempQuantityAllocated =
				  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
				$freePoolData->{$lId}->quantity(0);
			}
		}

		###Iterate over free pool and attempt allocation - non hw specific.
		if ( $isFullyAllocated == 0 ) {
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				next unless $licView->capType eq '48';
				dlog("license environment=$lEnv");
				next
				  if (
					$machineLevel == 1
					&& $self->isEnvironmentSame( $self->mechineLevelServerType,
						$lEnv ) == 0
				  );
				dlog("found matching license - non hw specific");
				my $neededQuantity = $chips - $tempQuantityAllocated;
				dlog( "neededQuantity=" . $neededQuantity );

				if ( $freePoolData->{$lId}->quantity >= $neededQuantity ) {
					$licsToAllocate{$lId} = $neededQuantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $neededQuantity;
					$isFullyAllocated = 1;
					last;
				}
				else {
					$licsToAllocate{$lId} = $freePoolData->{$lId}->quantity;
					$tempQuantityAllocated =
					  $tempQuantityAllocated + $freePoolData->{$lId}->quantity;
					$freePoolData->{$lId}->quantity(0);
				}
			}
		}
	}

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationChip");
}

sub queryFreePoolData {
	my @fields = qw(
	  lId
	  lEnvironment
	  lparName
	  cId
	  ibmOwned
	  sId
	  cpuSerial
	  expireAge
	  quantity
	  capType
	  licenseType
	  pool
	  ulId
	  usedQuantity
	  machineLevel
	  hId
	);
	my $query = '
select
       l.id, 
       l.environment, 
       l.lpar_name, 
       l.customer_id, 
       l.ibm_owned,
       is.software_id, l.cpu_serial,
       days( l.expire_date ) - days( CURRENT TIMESTAMP ),
       l.quantity, 
       l.cap_type, 
       l.lic_type, 
       l.pool,
       ul.id,
       ul.used_quantity,
       r.machine_level,
       h.id 
from 
      license l join license_sw_map lsm 
        on lsm. license_id = l. id 
      join software s 
        on s.software_id = lsm.software_id 
      left outer join used_license ul
        on ul.license_id  =  l.id
      left outer join reconcile_used_license rul
         on rul.used_license_id  =  ul.id
      left outer join reconcile r 
         on rul . reconcile_id= r. id 
      left outer join installed_software is
         on is . id= r. installed_software_id 
      left outer join software_lpar sl 
         on sl. id = is. software_lpar_id 
      left outer join hw_sw_composite hsc 
         on hsc. software_lpar_id = sl . id 
      left outer join hardware_lpar hl 
         on hl. id = hsc. hardware_lpar_id 
      left outer join hardware h 
           on h. id = hl. hardware_id 
      where
           ( l.customer_id = ? or l.customer_id in (select master_account_id from account_pool where member_account_id = ? ))
            and ((l.cap_type in( 2, 13, 14, 17, 34, 48 ) and l.try_and_buy = 0) or l.cap_type =5 or l.cap_type =9)
            and l.lic_type != \'SC\'   
            and s.software_id = ?
            and l.status = \'ACTIVE\'
            and s.status = \'ACTIVE\'
        order by
        	l.id
    ';
	return ( 'freePoolData', $query, \@fields );
}

sub getInstalledSoftwareReconData {
	my $self = shift;

	dlog("begin getInstalledSoftwareReconData");

	my $installedSoftwareReconData =
	  new Recon::OM::ReconInstalledSoftwareData();

	###Execute base query and populate data.
	$self->connection->prepareSqlQueryAndFields(
		$self->queryReconInstalledSoftwareBaseData() );
	my $sth = $self->connection->sql->{reconInstalledSoftwareBaseData};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{reconInstalledSoftwareBaseDataFields} } );
	$sth->execute( $self->installedSoftware->id );
	while ( $sth->fetchrow_arrayref ) {
		$installedSoftwareReconData->hId( $rec{hId} );
		$installedSoftwareReconData->hStatus( $rec{hStatus} );
		$installedSoftwareReconData->hProcCount( $rec{hProcCount} );
		$installedSoftwareReconData->hHwStatus( $rec{hHwStatus} );
		$installedSoftwareReconData->hSerial( $rec{hSerial} );
		$installedSoftwareReconData->hProcessorBrand( $rec{hProcessorBrand} );
		$installedSoftwareReconData->hProcessorModel( $rec{hProcessorModel} );
		$installedSoftwareReconData->hMachineTypeId( $rec{hMachineTypeId} );
		$installedSoftwareReconData->hServerType( $rec{hServerType} );
		$installedSoftwareReconData->hCpuMIPS( $rec{hCpuMIPS} );
		$installedSoftwareReconData->hCpuMSU( $rec{hCpuMSU} );
		$installedSoftwareReconData->mtType( $rec{mtType} );
		$installedSoftwareReconData->hlId( $rec{hlId} );
		$installedSoftwareReconData->hlStatus( $rec{hlStatus} );
		$installedSoftwareReconData->hlName( $rec{hlName} );
		$installedSoftwareReconData->hlPartMIPS( $rec{hlPartMIPS} );
		$installedSoftwareReconData->hlPartMSU( $rec{hlPartMSU} );
		$installedSoftwareReconData->slId( $rec{slId} );
		$installedSoftwareReconData->cId( $rec{cId} );
		$installedSoftwareReconData->slName( $rec{slName} );
		$installedSoftwareReconData->slStatus( $rec{slStatus} );
		$installedSoftwareReconData->sStatus( $rec{sStatus} );
		$installedSoftwareReconData->sPriority( $rec{sPriority} );
		$installedSoftwareReconData->sLevel( $rec{sLevel} );
		$installedSoftwareReconData->sVendorMgd( $rec{sVendorMgd} );
		$installedSoftwareReconData->sMfg( $rec{sMfg} );
		$installedSoftwareReconData->scName( $rec{scName} );
		$installedSoftwareReconData->rId( $rec{rId} );
		$installedSoftwareReconData->rTypeId( $rec{rTypeId} );
		$installedSoftwareReconData->rParentInstSwId( $rec{rParentInstSwId} );
		$installedSoftwareReconData->rMachineLevel( $rec{rMachineLevel} );
		$installedSoftwareReconData->scopeName( $rec{scopeName} );
		$installedSoftwareReconData->hChips( $rec{hChips} );

		###The processor logic
		if ( defined $rec{sleProcCount} ) {
			$installedSoftwareReconData->processorCount( $rec{sleProcCount} );
		}
		else {
			$installedSoftwareReconData->processorCount( $rec{slProcCount} );
		}

		###If recon is defined and it is machine level set processor count to hardware processor count
		###No matter if it is 0 or not
		if ( defined $installedSoftwareReconData->rId ) {
			if ( $installedSoftwareReconData->rMachineLevel == 1 ) {
				if ( !defined $rec{hProcCount} ) {
					$installedSoftwareReconData->processorCount(0);
				}
				else {
					$installedSoftwareReconData->processorCount(
						$rec{hProcCount} );
				}
			}
		}

		###The bundle parent logic
		if ( defined $rec{bpId} ) {

			if ( !defined $installedSoftwareReconData->bpIds ) {
				$installedSoftwareReconData->bpIds( {} );
			}
			$installedSoftwareReconData->bpIds->{ $rec{bpId} }++;
		}

		###The bundle children logic
		if ( defined $rec{bcSwId} ) {
			if ( !defined $installedSoftwareReconData->bcSwIds ) {
				$installedSoftwareReconData->bcSwIds( {} );
			}
			$installedSoftwareReconData->bcSwIds->{ $rec{bcSwId} }++;
		}
	}
	$sth->finish;

	###Execute extended query of all inst sw for this lpar if in category,
	###a parent of a bundle, or a child in a bundle.
	if (   $installedSoftwareReconData->scName ne 'UNKNOWN'
		|| defined $installedSoftwareReconData->bpIds
		|| defined $installedSoftwareReconData->bcSwIds )
	{
		dlog("getting extended data");

		$self->connection->prepareSqlQueryAndFields(
			$self->queryReconInstalledSoftwareExtendedData() );
		my $sth = $self->connection->sql->{reconInstalledSoftwareExtendedData};
		my %rec;
		$sth->bind_columns(
			map { \$rec{$_} } @{
				$self->connection->sql
				  ->{reconInstalledSoftwareExtendedDataFields}
			  }
		);
		$sth->execute(
			$self->installedSoftware->softwareLparId,
			$self->installedSoftware->softwareId
		);
		my $tempCategoryInstSwId;
		my $tempCategoryPriority;
		my $tempBundleInstSwId;

		while ( $sth->fetchrow_arrayref ) {

			###Perform category logic unless i am UNKNOWN.
			if ( $installedSoftwareReconData->scName ne 'UNKNOWN' ) {

				###Does this inst sw match my category?
				if ( $rec{scName} eq $installedSoftwareReconData->scName ) {
					dlog("matches category");

					###Is it a higher priority than me?
					if ( $rec{sPriority} <
						$installedSoftwareReconData->sPriority )
					{
						dlog("is higher priority");

						###Is it higher priority than previous found?
						if ( defined $tempCategoryInstSwId ) {
							dlog("found previous");

							if ( $rec{sPriority} < $tempCategoryPriority ) {
								dlog("higher than previous, setting parent");

								$tempCategoryInstSwId = $rec{instSwId};
								$tempCategoryPriority = $rec{sPriority};
							}
						}
						else {
							dlog("no previous, setting parent");

							$tempCategoryInstSwId = $rec{instSwId};
							$tempCategoryPriority = $rec{sPriority};
						}
					}
					else {
						dlog("it is lower priority than me");

						###Add as software category child.
						if ( !defined $installedSoftwareReconData->scChildren )
						{
							$installedSoftwareReconData->scChildren( {} );
						}
						$installedSoftwareReconData->scChildren
						  ->{ $rec{instSwId} }++;
					}
				}
			}

			###Perform bundle parent logic if i am parent of a bundle.
			if ( defined $installedSoftwareReconData->bpIds ) {

				###Is this inst sw in a bundle?
				if ( defined $rec{bSwId} ) {
					dlog("in bundle");

					###Am i parent of this inst sw's bundle?
					if ( $rec{bSwId} == $self->installedSoftware->softwareId ) {
						dlog("i am parent to this inst sw");
						if ( !defined $installedSoftwareReconData->bChildren ) {
							$installedSoftwareReconData->bChildren( {} );
						}
						$installedSoftwareReconData->bChildren
						  ->{ $rec{instSwId} }++;
					}
				}
			}

			###Perform bundle child logic if i am in a bundle.
			if ( defined $installedSoftwareReconData->bcSwIds ) {
				dlog("performing bundle child logic");

				###Is this inst sw my parent?
				foreach
				  my $bcSwId ( keys %{ $installedSoftwareReconData->bcSwIds } )
				{
					if ( $rec{sId} == $bcSwId ) {
						dlog("matches bundle, setting parent");
						$tempBundleInstSwId = $rec{instSwId};
					}
				}
			}
		}
		$sth->finish;

		###Set the category parent if found.
		$installedSoftwareReconData->scParent($tempCategoryInstSwId)
		  if defined $tempCategoryInstSwId;

		###Set the bunlde parent if found.
		$installedSoftwareReconData->bParent($tempBundleInstSwId)
		  if defined $tempBundleInstSwId;
	}

	dlog("end getInstalledSoftwareReconData");

	$self->installedSoftwareReconData($installedSoftwareReconData);
}

sub queryReconInstalledSoftwareBaseData {
	my @fields = qw(
	  hId
	  hStatus
	  hHwStatus
	  hSerial
	  hProcCount
	  hChips
	  hProcessorBrand
	  hProcessorModel
	  hMachineTypeId
	  hServerType
	  hCpuMIPS
	  hCpuMSU
	  mtType
	  hlId
	  hlStatus
	  hlName
	  hlPartMIPS
	  hlPartMSU
	  slId
	  cId
	  slName
	  slStatus
	  slProcCount
	  sleProcCount
	  sStatus
	  sPriority
	  sLevel
	  sVendorMgd
	  sMfg
	  scName
	  bpId
	  bcSwId
	  rId
	  rTypeId
	  rParentInstSwId
	  rMachineLevel
	  scopeName
	);
	my $query = '
        select
            h.id
            ,h.status
            ,h.hardware_status
            ,h.serial
            ,h.processor_count
            ,h.chips
            ,h.processor_type
            ,h.model
            ,h.machine_type_id
            ,h.server_type
            ,h.cpu_mips
            ,h.cpu_msu
            ,mt.type
            ,hl.id
            ,hl.status
            ,hl.name
            ,hl.part_mips
            ,hl.part_msu
            ,sl.id
            ,sl.customer_id
            ,sl.name
            ,sl.status
            ,sl.processor_count
            ,sle.processor_count
            ,s.status
            ,s.priority
            ,s.level
            ,s.vendor_managed
            ,m.name
            ,sc.software_category_name
            ,bp.id
            ,bc.software_id
            ,r.id
            ,r.reconcile_type_id
            ,r.parent_installed_software_id
            ,r.machine_level
            ,scope.name
        from
            installed_software is
            join software_lpar sl on 
                sl.id = is.software_lpar_id
            join software s on 
                s.software_id = is.software_id
            join manufacturer m on 
                m.id = s.manufacturer_id
            join software_category sc on 
                sc.software_category_id = s.software_category_id
            left outer join software_lpar_eff sle on 
                sle.software_lpar_id = sl.id
                and sle.status = \'ACTIVE\'
                and sle.processor_count != 0
            left outer join hw_sw_composite hsc on 
                hsc.software_lpar_id = sl.id
            left outer join hardware_lpar hl on 
                hl.id = hsc.hardware_lpar_id
            left outer join hardware h on 
                h.id = hl.hardware_id
            left outer join machine_type mt on 
                mt.id = h.machine_type_id
            left outer join bundle bp on 
                bp.software_id = is.software_id
            left outer join bundle_software bs on 
                bs.software_id = s.software_id
            left outer join bundle bc on 
                bc.id = bs.bundle_id
            left outer join reconcile r on 
                r.installed_software_id = is.id
            left outer join schedule_f sf on
                sf.customer_id = sl.customer_id
                and sf.software_id = is.software_id
                and sf.status_id = 2
            left outer join scope scope on
                scope.id = sf.scope_id
        where
            is.id = ?
	';
	return ( 'reconInstalledSoftwareBaseData', $query, \@fields );
}

sub queryReconInstalledSoftwareExtendedData {
	my @fields = qw(
	  instSwId
	  sId
	  sPriority
	  scName
	  bcSwId
	);
	my $query = '
        select
            is.id
            ,is.software_id
            ,s.priority
            ,sc.software_category_name
            ,bc.software_id
        from
            installed_software is
            join software s on s.software_id = is.software_id
            join software_category sc on sc.software_category_id = s.software_category_id
            left outer join bundle_software bs on bs.software_id = s.software_id
            left outer join bundle bc on bc.id = bs.bundle_id
        where
            is.software_lpar_id = ?
            and is.software_id != ?
            and is.status = \'ACTIVE\'
            and is.discrepancy_type_id != 3
            and is.discrepancy_type_id != 5
    ';
	return ( 'reconInstalledSoftwareExtendedData', $query, \@fields );
}

sub closeAlertUnlicensedSoftware {
	my ( $self, $createNew ) = @_;
	dlog("begin closeAlertUnlicensedSoftware");

	###Instantiate alert object.
	my $alert = new Recon::OM::AlertUnlicensedSoftware();

	###Retrieve alert by installed software.
	$alert->installedSoftwareId( $self->installedSoftware->id );
	$alert->getByBizKey( $self->connection );
	dlog( "alert=" . $alert->toString() );

	my $oldAlert = new Recon::OM::AlertUnlicensedSoftware();
	$oldAlert->id( $alert->id );
	$oldAlert->installedSoftwareId( $alert->installedSoftwareId );
	$oldAlert->comments( $alert->comments );
	$oldAlert->type( $alert->type );
	$oldAlert->open( $alert->open );
	$oldAlert->creationTime( $alert->creationTime );
	$oldAlert->remoteUser( $alert->remoteUser );
	$oldAlert->recordTime( $alert->recordTime );

	if ( grep { $_ eq $self->installedSoftwareReconData->sMfg }
		$self->ibmArray )
	{
		$alert->type('IBM');
	}
	else {
		$alert->type('ISV');
	}
	$alert->comments('Auto Close');
	$alert->open(0);

	if ( defined $alert->id ) {
		if ( $oldAlert->open == 1 ) {
			$alert->save( $self->connection );
			$self->recordAlertUnlicensedSoftwareHistory($oldAlert);
		}
		elsif ( $oldAlert->type ne $alert->type ) {
			$alert->save( $self->connection );
			$self->recordAlertUnlicensedSoftwareHistory($oldAlert);
		}
	}
	elsif ( $createNew == 1 ) {
		$alert->creationTime( currentTimeStamp() );
		$alert->save( $self->connection );
	}

	dlog("end closeAlertUnlicensedSoftware");
}

#TODO Fix formatting
sub ibmArray {
	my $self = shift;

	my @ibmArray = (
		'IBM',
		'IBM_ITD',
		'IBM FileNet',
		'IBM Tivoli',
		'Informix',
		'Rational Software Corporation',
		'Ascential Software',
		'IBM WebSphere',
		'Digital CandleWebSphere',
		'IBM Rational',
		'Lotus',
		'Candle',
		'Tivoli'
	);

	return @ibmArray;
}

sub addChildrenToQueue {
	my $self = shift;

	###Call recon on any software category children.
	if ( defined $self->installedSoftwareReconData->scChildren ) {
		foreach my $childId (
			keys %{ $self->installedSoftwareReconData->scChildren } )
		{
			dlog( "software category child id=" . $childId );

			my $childInstSw = new BRAVO::OM::InstalledSoftware();
			$childInstSw->id($childId);
			$childInstSw->getById( $self->connection );
			dlog( "childInstSw=" . $childInstSw->toString() );

			my $childSwLpar = new BRAVO::OM::SoftwareLpar();
			$childSwLpar->id( $childInstSw->softwareLparId );
			$childSwLpar->getById( $self->connection );
			dlog( "childSwLpar=" . $childSwLpar->toString() );

			my $queue =
			  Recon::Queue->new( $self->connection, $childInstSw,
				$childSwLpar );
			$queue->add;
		}
	}

	###Call recon on any bundle children.
	if ( defined $self->installedSoftwareReconData->bChildren ) {
		foreach
		  my $childId ( keys %{ $self->installedSoftwareReconData->bChildren } )
		{
			dlog( "software bundle child id=" . $childId );

			my $childInstSw = new BRAVO::OM::InstalledSoftware();
			$childInstSw->id($childId);
			$childInstSw->getById( $self->connection );
			dlog( "childInstSw=" . $childInstSw->toString() );

			my $childSwLpar = new BRAVO::OM::SoftwareLpar();
			$childSwLpar->id( $childInstSw->softwareLparId );
			$childSwLpar->getById( $self->connection );
			dlog( "childSwLpar=" . $childSwLpar->toString() );

			my $queue =
			  Recon::Queue->new( $self->connection, $childInstSw,
				$childSwLpar );
			$queue->add;
		}
	}
}

sub getExistingMachineLevelRecon {
	my $self = shift;

	my %data;
	$self->connection->prepareSqlQueryAndFields(
		$self->queryExistingMachineLevelRecon() );
	my $sth = $self->connection->sql->{existingMachineLevelRecon};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{existingMachineLevelReconFields} } );
	$sth->execute(
		$self->installedSoftwareReconData->hId,
		$self->installedSoftware->softwareId,
		$self->customer->id, $self->customer->id
	);

	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );

		###exclude the license that the environment is differnet with hw server type.
		next
		  if (
			$self->isEnvironmentSame( $self->mechineLevelServerType,
				$rec{licenseEnvironment} ) == 0
		  );
		dlog('getExistingMachineLevelRecon->license and hw environment same');

		$data{ $rec{reconcileId} }{ $rec{licenseId} }{'usedQuantity'} =
		  $rec{usedQuantity};
		$data{ $rec{reconcileId} }{ $rec{licenseId} }{'reconcileTypeId'} =
		  $rec{reconcileTypeId};
	}
	$sth->finish;

	return \%data;
}

sub fetchMechineLevelServerType {
	my ( $self, $hwId, $hwServerType ) = @_;

	if ( defined $hwServerType && $hwServerType eq 'PRODUCTION' ) {
		dlog('hw server type is already production');
		return 'PRODUCTION';
	}

	my %data;
	$self->connection->prepareSqlQueryAndFields(
		$self->queryProductionHwlparCount() );
	my $sth = $self->connection->sql->{productionHwlparCount};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{productionHwlparCountFields} } );
	$sth->execute($hwId);
	$sth->fetchrow_arrayref;
	my $prodHwlparCount = $rec{prodHwlparCount};
	$sth->finish;
	dlog("mix partitioning with $prodHwlparCount hw lpar");

	return 'PRODUCTION'
	  if ( $prodHwlparCount > 0 );

	return 'DEVELOPMENT';
}

sub queryProductionHwlparCount {
	my @fields = qw(
	  prodHwlparCount
	);
	my $query = '
    select 
      count(*)
    from
      hardware h,
      hardware_lpar hl
    where
     hl.hardware_id = h.id
     and hardware_id = ?
     and hl.server_type = \'PRODUCTION\'
     and hl.status = \'ACTIVE\'
    ';

	return ( 'productionHwlparCount', $query, \@fields );
}

sub queryExistingMachineLevelRecon {
	my @fields = qw(
	  reconcileId
	  reconcileTypeId
	  licenseId
	  licenseEnvironment
	  usedQuantity
	);
	my $query = '
        select
            r.id
            ,r.reconcile_type_id
            ,l.id
            ,l.environment
            ,ul.used_quantity
        from
            hardware h
            ,hardware_lpar hl
            ,hw_sw_composite hsc
            ,software_lpar sl
            ,installed_software is
            ,reconcile r
            ,reconcile_used_license rul
            ,used_license ul
            ,license l
        where
            h.id = ?
            and hl.status = \'ACTIVE\'
            and sl.status = \'ACTIVE\'
            and is.status = \'ACTIVE\'
            and l.status = \'ACTIVE\'
            and is.software_id = ?
            and (l.customer_id = ? or (l.customer_id in (select master_account_id from account_pool where member_account_id = ?) and l.pool = 1))
            and h.id = hl.hardware_id
            and hsc.software_lpar_id = sl.id
            and hsc.hardware_lpar_id = hl.id
            and sl.id = is.software_lpar_id
            and is.id = r.installed_software_id
            and r.id = rul.reconcile_id
            and r.machine_level = 1
            and ul.license_id = l.id
            and rul.used_license_id = ul.id
    ';

	return ( 'existingMachineLevelRecon', $query, \@fields );
}

sub createReconcile {
	my ( $self, $reconcileTypeId, $machineLevel, $parentInstalledSoftwareId ) =
	  @_;
	dlog("begin createReconcile");

	###Instantiate reconcile object.
	my $reconcile = new Recon::OM::Reconcile();
	$reconcile->reconcileTypeId($reconcileTypeId);
	$reconcile->installedSoftwareId( $self->installedSoftware->id );
	$reconcile->parentInstalledSoftwareId($parentInstalledSoftwareId);
	$reconcile->machineLevel($machineLevel);
	$reconcile->comments('AUTO RECON');
	$reconcile->save( $self->connection );
	dlog( "reconcile=" . $reconcile->toString() );

	dlog("end createReconcile");
	return $reconcile->id;
}

sub createReconcileUsedLicense {
	my ( $self, $licenseId, $reconcileId, $usedQuantity, $machineLevel,
		$reconcileIdForMachineLevel )
	  = @_;
	dlog("begin createReconcileUsedLicense");

	###Get license object.
	my $license = new BRAVO::OM::License();
	$license->id($licenseId);
	$license->getById( $self->connection );
	dlog( "license=" . $license->toString() );
	my $ulId = undef;
	if ( $machineLevel && defined $reconcileIdForMachineLevel ) {

		dlog("machine level allocation, retrieve the exist used license id.");
		dlog($reconcileIdForMachineLevel);
		$self->connection->prepareSqlQuery( $self->queryUsedLicenseId() );
		my $sth = $self->connection->sql->{getUsedLicenseId};
		my $usedLicenseid;
		$sth->bind_columns( \$usedLicenseid );
		$sth->execute( $reconcileIdForMachineLevel, $licenseId );
		$sth->fetchrow_arrayref;
		$sth->finish;

		if ( defined $usedLicenseid ) {
			$ulId = $usedLicenseid;
			dlog("Used license exist, no need to creating a new one");
		}

	}

	if ( !defined $ulId ) {

		my $ul = new Recon::OM::UsedLicense();
		$ul->licenseId($licenseId);
		$ul->usedQuantity($usedQuantity);
		$ul->capacityTypeId( $license->capType );
		$ul->save( $self->connection );

		$ulId = $ul->id;
		dlog(
"create used license,it's none machine level or newly machine level license allocatoin."
		);
	}

	###Instantiate reconcile used lincese object.
	my $rul = new Recon::OM::ReconcileUsedLicense();
	$rul->reconcileId($reconcileId);
	$rul->usedLicenseId($ulId);

	$rul->save( $self->connection );
	dlog( "rul=" . $rul->toString() );
	dlog("end createReconcileUsedLicense");
	return $rul;
}

sub queryUsedLicenseId {
	my $query = '
	select 
	     ul.id 
	 from 
	     reconcile_used_license rul
	     ,used_license ul
	where 
	    rul.reconcile_id = ?
	    and ul.license_id = ?
	    and rul.used_license_id = ul.id
	';

	return ( 'getUsedLicenseId', $query );

}

sub recordAlertUnlicensedSoftwareHistory {
	my ( $self, $alert ) = @_;
	my $history = new Recon::OM::AlertUnlicensedSoftwareHistory();
	$history->alertUnlicensedSoftwareId( $alert->id );
	dlog( "history=" . $history->toString() );
	$history->creationTime( $alert->creationTime );
	$history->comments( $alert->comments );
	$history->open( $alert->open );
	$history->recordTime( $alert->recordTime );
	$history->save( $self->connection );
}

sub openAlertUnlicensedSoftware {
	my $self = shift;
	dlog("begin openAlertUnlicensedSoftware");

	###Instantiate alert object.
	my $alert = new Recon::OM::AlertUnlicensedSoftware();

	###Retrieve alert by installed software.
	$alert->installedSoftwareId( $self->installedSoftware->id );
	$alert->getByBizKey( $self->connection );
	dlog( "alert=" . $alert->toString() );

	my $oldAlert = new Recon::OM::AlertUnlicensedSoftware();
	$oldAlert->id( $alert->id );
	$oldAlert->installedSoftwareId( $alert->installedSoftwareId );
	$oldAlert->comments( $alert->comments );
	$oldAlert->type( $alert->type );
	$oldAlert->open( $alert->open );
	$oldAlert->creationTime( $alert->creationTime );
	$oldAlert->remoteUser( $alert->remoteUser );
	$oldAlert->recordTime( $alert->recordTime );

	if ( grep { $_ eq $self->installedSoftwareReconData->sMfg }
		$self->ibmArray )
	{
		$alert->type('IBM');
	}
	else {
		$alert->type('ISV');
	}
	$alert->comments('Auto Open');
	$alert->open(1);

	if ( defined $alert->id ) {
		if ( $oldAlert->open == 0 ) {
			$alert->creationTime( currentTimeStamp() );
			$alert->save( $self->connection );
			$self->recordAlertUnlicensedSoftwareHistory($oldAlert);
		}
		elsif ( $oldAlert->type ne $alert->type ) {
			$alert->save( $self->connection );
			$self->recordAlertUnlicensedSoftwareHistory($oldAlert);
		}
	}
	else {
		$alert->creationTime( currentTimeStamp() );
		$alert->save( $self->connection );
	}

	dlog("end openAlertUnlicensedSoftware");
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

sub installedSoftware {
	my $self = shift;
	$self->{_installedSoftware} = shift if scalar @_ == 1;
	return $self->{_installedSoftware};
}

sub poolParentCustomers {
	my $self = shift;
	$self->{_poolParentCustomers} = shift if scalar @_ == 1;
	return $self->{_poolParentCustomers};
}

sub customer {
	my $self = shift;
	$self->{_customer} = shift if scalar @_ == 1;
	return $self->{_customer};
}

sub installedSoftwareReconData {
	my $self = shift;
	$self->{_installedSoftwareReconData} = shift
	  if scalar @_ == 1;
	return $self->{_installedSoftwareReconData};
}

sub pvuValue {
	my $self = shift;
	$self->{_pvuValue} = shift if scalar @_ == 1;
	return $self->{_pvuValue};
}

sub mechineLevelServerType {
	my $self = shift;
	$self->{_mechineLevelServerType} = shift
	  if scalar @_ == 1;
	return $self->{_mechineLevelServerType};
}

sub poolRunning {
    my $self = shift;
    $self->{_poolRunning} = shift
      if scalar @_ == 1;
    return $self->{_poolRunning};
}
1;


