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
use Recon::CauseCode;

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
#	else {
#		$processorCount = $self->installedSoftwareReconData->processorCount;
#	}

	my $nbrCoresPerChip = $self->installedSoftwareReconData->hNbrCoresPerChip;

	my $valueUnitsPerCore =
	  $self->getValueUnitsPerProcessor( $nbrCoresPerChip, $processorCount );
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
		$self->queueSoftwareCategory( $self->installedSoftware->id );
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
		&& $softwareCategoryName =~ /Operating Systems/ )
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
                     ( product_info pi join software_category sc on pi.software_category_id = sc.software_category_id ) 
                where pi.id = ?
        with ur
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
	
	if (( not defined $self->installedSoftwareReconData->scopeName )
			|| ( $self->installedSoftwareReconData->scopeName eq "" )) {
				ilog("No ScheduleF defined, no auto-reconciliation will be performed!");
				return 0;
			}

	return 1 if $self->attemptVendorManaged == 1;
	return 1 if $self->attemptSoftwareCategory == 1;
	return 1 if $self->attemptBundled == 1;

	return 1 if $self->attemptCustomerOwnedAndManaged == 1;
	return 1 if $self->attemptIBMOwned3rdManaged == 1;
	return 1 if $self->attemptCustomerOwned3rdManaged == 1;
	return 1 if $self->attemptIBMOwnedIBMManagedCons == 1;
	return 1 if $self->attemptCustOwnedIBMManagedCons == 1;

	if($self->poolRunning == 1) {
	    return 2;
	}

	my $licsToAllocate;
	my $reconcileTypeId;
	my $machineLevel;
	my $reconcileIdForMachineLevel;
	my $allocMethodId;

	(
		$licsToAllocate, $reconcileTypeId,
		$machineLevel,   $reconcileIdForMachineLevel, $allocMethodId
	  )
	  = $self->attemptLicenseAllocation;

	dlog( "reconcileTypeId=" . $reconcileTypeId );
	dlog( "machineLevel=" . $machineLevel );
	dlog( "allocMethodId=" . $allocMethodId ) if defined ($allocMethodId);

	if ( defined $licsToAllocate ) {

		###Create reconcile and set id in data.
		my $rId =
		  $self->createReconcile( $reconcileTypeId, $machineLevel,
			$self->installedSoftware->id, $allocMethodId );

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
		
		$self->enqueuePotentialHWboxAlloc() if ( $machineLevel == 1 );

		return 1;
	}
##	elsif ( defined $self->customer->swComplianceMgmt
##		&& $self->customer->swComplianceMgmt eq 'YES' )
##	{
##		if ( defined $self->installedSoftwareReconData->scopeName ) {
##			if ( $self->installedSoftwareReconData->scopeName eq 'CUSTOIBMM' ) {
				###Create reconcile and set id in data.
##				my $reconcileTypeMap =
##				  Recon::Delegate::ReconDelegate->getReconcileTypeMap();
##				my $rId =
##				  $self->createReconcile(
##					$reconcileTypeMap->{'Pending customer decision'},
##					0, $self->installedSoftware->id );
##				return 1;
##			}
##		}
##	}

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

sub attemptIBMOwned3rdManaged {
	my $self = shift;
	
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	if ( defined $self->installedSoftwareReconData->scopeName
		&& $self->installedSoftwareReconData->scopeName eq 'IBMO3RDM' )
	{
		dlog("reconciling as IBM owned and 3rd party managed");
		###Create reconcile and set id in data.
		$self->createReconcile(
			$reconcileTypeMap->{'IBM owned, managed by 3rd party'},
			0, $self->installedSoftware->id );
		dlog("end attemptReconcile");
		return 1;
	}
	
	dlog("Did not reconcile as IBM owned and 3rd party managed");
	return 0;
}

sub attemptCustomerOwned3rdManaged {
	my $self = shift;
	
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	if ( defined $self->installedSoftwareReconData->scopeName
		&& $self->installedSoftwareReconData->scopeName eq 'CUSTO3RDM' )
	{
		dlog("reconciling as customer owned and 3rd party managed");
		
		if ( defined $self->customer->swComplianceMgmt
			&& $self->customer->swComplianceMgmt eq 'YES' ) {
				###Create reconcile and set id in data.
				$self->createReconcile(
					$reconcileTypeMap->{'Customer owned, managed by 3rd party'},
					0, $self->installedSoftware->id );
				dlog("end attemptReconcile");
				return 1;
			} else {
				dlog("CUSTO3RDM scope, but not sw compliance - not reconciled.");
			}
	}
	
	dlog("Did not reconcile as customer owned and 3rd party managed");
	return 0;

}

sub attemptIBMOwnedIBMManagedCons {
	my $self = shift;
	
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	if ( defined $self->installedSoftwareReconData->scopeName
		&& $self->installedSoftwareReconData->scopeName eq 'IBMOIBMMSWCO' )
	{
		dlog("reconciling as IBM owned, IBM managed, SW consumption based");
		###Create reconcile and set id in data.
		$self->createReconcile(
			$reconcileTypeMap->{'IBM owned, IBM managed SW consumption based'},
			0, $self->installedSoftware->id );
		dlog("end attemptReconcile");
		return 1;
	}
	
	dlog("Did not reconcile as IBM owned, IBM managed, SW consumption based");
	return 0;
	
}

sub attemptCustOwnedIBMManagedCons {
	my $self = shift;
	
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();

	if ( defined $self->installedSoftwareReconData->scopeName
		&& $self->installedSoftwareReconData->scopeName eq 'CUSTOIBMMSWCO' )
	{
		dlog("reconciling as Customer owned, IBM managed SW consumption based");
		
		if ( defined $self->customer->swComplianceMgmt
			&& $self->customer->swComplianceMgmt eq 'YES' ) {
				###Create reconcile and set id in data.
				$self->createReconcile(
					$reconcileTypeMap->{'Customer owned, IBM managed SW consumption based'},
					0, $self->installedSoftware->id );
				dlog("end attemptReconcile");
				return 1;
			} else {
				dlog("CUSTOIBMMSWCO scope, but not sw compliance - not reconciled.");
			}
	}
	
	dlog("Did not reconcile as Customer owned, IBM managed SW consumption based");
	return 0;

}

sub enqueuePotentialHWboxAlloc { # upon creating a machinelevel reconcile, this will put other potential softwares with open alerts to the queue
	my $self = shift;
	
	dlog("Attempting to enqueue potential allocations on the same HW box.");
	
	my %data;
	$self->connection->prepareSqlQueryAndFields(
		$self->queryPotentialHWboxAlloc() );
	my $sth = $self->connection->sql->{potentialHWboxAlloc};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{potentialHWboxAllocFields} } );
	$sth->execute(
		$self->installedSoftwareReconData->hId,
		$self->installedSoftware->softwareId,
		$self->installedSoftware->id
	);

	while ( $sth->fetchrow_arrayref ) {
		dlog ("Enqueuing potential HW box alloc: iSW ".$rec{isId});
		
		my $InstSw = new BRAVO::OM::InstalledSoftware();
		$InstSw->id( $rec{isId} );
		$InstSw->getById( $self->connection );

		my $SwLpar = new BRAVO::OM::SoftwareLpar();
		$SwLpar->id( $rec{slId} );
		$SwLpar->getById( $self->connection );

		my $queue =
		  Recon::Queue->new( $self->connection, $InstSw,
			$SwLpar );
		$queue->add;
	}
	$sth->finish;

}

sub queryPotentialHWboxAlloc {
	my @fields = qw(
	  isId
	  slId
	);
	my $query = '
		select
			is.id as installed_sw_id
			,is.software_lpar_id
		from ( ( ( ( ( eaadmin.installed_software is
				   join eaadmin.software_lpar sl on sl.id = is.software_lpar_id and is.status = \'ACTIVE\' and sl.status = \'ACTIVE\' and is.discrepancy_type_id not in ( 3, 5, 6 ) )
                   join eaadmin.hw_sw_composite hsc on hsc.software_lpar_id = is.software_lpar_id )
                   join eaadmin.hardware_lpar hl on hl.id = hsc.hardware_lpar_id and hl.status = \'ACTIVE\' )
                   join eaadmin.customer c on c.customer_id = sl.customer_id and c.status = \'ACTIVE\' and c.sw_license_mgmt = \'YES\' )
                   join eaadmin.alert_unlicensed_sw aus on is.id = aus.installed_software_id and aus.open = 1 )
     where 
     		hl.hardware_id = ?
     		and is.software_id = ?
     		and is.id != ?
     with ur;
	';
	return('potentialHWboxAlloc', $query, \@fields );
}

sub attemptExistingMachineLevel {
	my $self = shift;
	my $scope = shift;
	dlog("attempt existing machine level");

	my %licsToAllocate;
	my $reconciles = $self->getExistingMachineLevelRecon($scope);

	my $reconcileTypeId;
	my $reconcileIdForUsedLicense;
	my $allocMethodId;

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
		
		next if (( $scope eq "IBMOIBMM" ) && ( $recon->installedSoftwareReconData->scopeName ne "IBMOIBMM" ));

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
		
		$allocMethodId = $reconcile->allocationMethodologyId();

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
		
#		$self->enqueuePotentialHWboxAlloc();
		
		return ( \%licsToAllocate, $reconcileTypeId,
			$reconcileIdForUsedLicense, $allocMethodId );
	}
	else {
		dlog("unable to allocate");
		return ( undef, undef, undef, undef );
	}
}

sub attemptLicenseAllocation {
	my $self = shift;
	dlog("being attempt license allocation");

	###Get reconcile type map.
	my $reconcileTypeMap =
	  Recon::Delegate::ReconDelegate->getReconcileTypeMap();
	my $machineLevel;
	my $scheduleFlevel = $self->installedSoftwareReconData->scheduleFlevel;
	my ( $licsToAllocate, $reconcileTypeId, $reconcileId, $allocMethodId );
	
	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###Attempt to reconcile at machine level if one is already reconciled at machine level
		( $licsToAllocate, $reconcileTypeId, $reconcileId, $allocMethodId ) =
			$self->attemptExistingMachineLevel($self->installedSoftwareReconData->scopeName);
		return ( $licsToAllocate, $reconcileTypeId, 1, $reconcileId, $allocMethodId )
		if defined $licsToAllocate;
	}
	
#	if (( !defined $self->installedSoftwareReconData->scopeName ) ||
#		( $self->installedSoftwareReconData->scopeName eq '' )) {
#			dlog("ScheduleF not defined, license allocation won't be performed!");
#			return ( undef, $reconcileTypeMap->{'Automatic license allocation'}, 0 );
#	}
	
	###Get license free pool by customer id and software id.
	my $freePoolData = $self->getFreePoolData ( $self->installedSoftwareReconData->scopeName );

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: GARTNER MIPS, machine level
		( $licsToAllocate, $machineLevel ) =
		$self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '70', 1 );
		return ( $licsToAllocate,
				$reconcileTypeMap->{'Automatic license allocation'},
				$machineLevel )
		if defined $licsToAllocate;
	}

	###License type: GARTNER MIPS, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '70', 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: MIPS, machine level
		( $licsToAllocate, $machineLevel ) =
		$self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '5', 1 );
		return ( $licsToAllocate,
				$reconcileTypeMap->{'Automatic license allocation'},
				$machineLevel )
		if defined $licsToAllocate;
	}

	###License type: MIPS, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '5', 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: MSU, machine level
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '9', 1 );
		return ( $licsToAllocate,
			$reconcileTypeMap->{'Automatic license allocation'},
			$machineLevel )
		if defined $licsToAllocate;
	}

	###License type: MSU, lpar level
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationMipsMsuGartner( $freePoolData, '9', 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: hardware
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationHardware($freePoolData);
		return ( $licsToAllocate,
			$reconcileTypeMap->{'Automatic license allocation'},
			$machineLevel )
			if defined $licsToAllocate;
	}

	###License type: hw specific lpar
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationLpar( $freePoolData, 1 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: hw specific processor
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationProcessorOrIFL( $freePoolData, '2', 1 );
		return ( $licsToAllocate,
			$reconcileTypeMap->{'Automatic license allocation'},
			$machineLevel )
		if defined $licsToAllocate;

		###License type: hw specific IFL (zLinux)
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationProcessorOrIFL( $freePoolData, '49', 1 );
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
	}

	###License type: lpar
	( $licsToAllocate, $machineLevel ) =
	  $self->attemptLicenseAllocationLpar( $freePoolData, 0 );
	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel )
	  if defined $licsToAllocate;

	if ( $scheduleFlevel < 3 ) { # skip for hostname-specific scheduleF
		###License type: processor
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationProcessorOrIFL( $freePoolData, '2', 0 );
		return ( $licsToAllocate,
			$reconcileTypeMap->{'Automatic license allocation'},
			$machineLevel )
		if defined $licsToAllocate;
		
		###License type: IFL processor (zLinux)
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationProcessorOrIFL( $freePoolData, '49', 0 );
		return ( $licsToAllocate,
			$reconcileTypeMap->{'Automatic license allocation'},
			$machineLevel )
		if defined $licsToAllocate;

		###License type: pvu
		( $licsToAllocate, $machineLevel ) =
			$self->attemptLicenseAllocationPVU( $freePoolData, 0 );
	}

	return ( $licsToAllocate,
		$reconcileTypeMap->{'Automatic license allocation'},
		$machineLevel );

}

sub getFreePoolData {
	my $self = shift;
	my $scopeName=shift;
	dlog("begin getFreePoolData");

	my %data = ();
	my %machineLevel;

	$self->connection->prepareSqlQueryAndFields( $self->queryFreePoolData( $scopeName ) );
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
#		if ( defined $rec{usedQuantity} && $rec{machineLevel} == 1 ) {
#			my $hwServerType = $self->mechineLevelServerType;
#			dlog("it is machine level");
#			###not do auto recon if hw and lic don't have the same environment.
#			dlog(
#				"serverType=$hwServerType,rec{lEnvironment}=$rec{lEnvironment}"
#			);
#			next
#			  if (
#				$self->isEnvironmentSame( $hwServerType, $rec{lEnvironment} ) ==
#				0 );
#			dlog('getFreePoolData-license and hw environment same');
#		}

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
			$self->installedSoftwareReconData->mtType, $licView->capType,
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
	return 1;
	
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
		next
		  if ( ( $licView->capType eq '14' ) &&  ( $self->installedSoftwareReconData->mtType ne 'WORKSTATION' ) );
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
			next
				if ( ( $licView->capType eq '14' ) &&  ( $self->installedSoftwareReconData->mtType ne 'WORKSTATION' ) );
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
			next
				if ( ( $licView->capType eq '14' ) &&  ( $self->installedSoftwareReconData->mtType ne 'WORKSTATION' ) );
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
					if ( ( $licView->capType eq '14' ) &&  ( $self->installedSoftwareReconData->mtType ne 'WORKSTATION' ) );
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

sub attemptLicenseAllocationProcessorOrIFL {
	my ( $self, $freePoolData, $myCapType, $hwSpecificOnly ) = @_;
	dlog("begin attemptLicenseAllocationProcessorOrIFL");
	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	###Hash to return.
	my %licsToAllocate;
	my $machineLevel;
	my $processorCount = 0;

	if (( $self->installedSoftwareReconData->hProcCount > 0 ) && ( $myCapType eq '2' )) {
		$machineLevel   = 1;
		$processorCount = $self->installedSoftwareReconData->hProcCount;
	}
	
	if (( $self->installedSoftwareReconData->hCpuIFL > 0 ) && ( $myCapType eq '49' )) {
		$machineLevel   = 1;
		$processorCount = $self->installedSoftwareReconData->hCpuIFL;
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
		next unless $licView->capType eq $myCapType;
		next if (( ! defined $licView->cpuSerial ) && ( $licView-> licenseType eq "NAMED CPU" ));
		next if (( $licView->cpuSerial ne $self->installedSoftwareReconData->hSerial ) && ( $licView -> licenseType eq "NAMED CPU" ));
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
			next unless $licView->capType eq $myCapType;
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;
			next if (( ! defined $licView->cpuSerial ) && ( $licView-> licenseType eq "NAMED CPU" ));
			next if (( $licView->cpuSerial ne $self->installedSoftwareReconData->hSerial ) && ( $licView -> licenseType eq "NAMED CPU" ));
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
			next unless $licView->capType eq $myCapType;
			next if (( $licView->licenseType eq "NAMED CPU" ) && ( defined $licView->cpuSerial ) && ( $licView->cpuSerial ne $self->installedSoftwareReconData->hSerial ));
				# the licenses with DEFINED and different CPU than the one recon'ed are skipped
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
				next unless $licView->capType eq $myCapType;
				next if (( $licView->licenseType eq "NAMED CPU" ) && ( defined $licView->cpuSerial ) && ( $licView->cpuSerial ne $self->installedSoftwareReconData->hSerial ));
				
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

sub attemptLicenseAllocationMipsMsuGartner {
	my ( $self, $freePoolData, $myCapType, $machineLevel ) = @_;
	dlog("begin attemptLicenseAllocationMIPS");
	dlog( "machineLevel=" . $machineLevel );
#	dlog( "hwSpecificOnly=" . $hwSpecificOnly );

	return undef
	  if $self->installedSoftwareReconData->mtType ne 'MAINFRAME';

# 	only MAINFRAME

	###Hash to return.
	my %licsToAllocate;
	my $myCount = 0;
	
	if ( $myCapType eq '5' ) { # MIPS
		dlog("Allocating MIPS...");
		if ( $machineLevel == 1 && $self->installedSoftwareReconData->hCpuMIPS > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hCpuMIPS;
			}
		elsif ($machineLevel == 0 && $self->installedSoftwareReconData->hlPartMIPS > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hlPartMIPS;
			}
	} elsif ( $myCapType eq '9' ) { # MSU
		dlog("Allocating MSU...");
		if ( $machineLevel == 1 && $self->installedSoftwareReconData->hCpuMSU > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hCpuMSU;
			}
		elsif ($machineLevel == 0 && $self->installedSoftwareReconData->hlPartMSU > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hlPartMSU;
			}
	} elsif ( $myCapType eq '70' ) { # GARTNER MIPS
		dlog("Allocating Gartner MIPS...");
		if ( $machineLevel == 1 && $self->installedSoftwareReconData->hCpuGartnerMIPS > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hCpuGartnerMIPS;
			}
		elsif ($machineLevel == 0 && $self->installedSoftwareReconData->hlPartGartnerMIPS > 0 )
			{
				$myCount = $self->installedSoftwareReconData->hlPartGartnerMIPS;
			}
	}

	return undef if $myCount == 0;
	dlog( "myCount=" . $myCount );
	###Counter to keep allocation count.
	my $tempQuantityAllocated = 0;

	###Flag to indicate we have enough to fully cover.
	my $isFullyAllocated = 0;

	###Iterate over free pool and attempt allocation - hw specific.

	if ( $machineLevel == 1 ) {
		###Named CPU, customer's licenses
		foreach my $lId ( keys %{$freePoolData} ) {
			my $licView = $freePoolData->{$lId};
			my $lEnv    = $freePoolData->{$lId}->environment;
			next unless $licView->capType     eq $myCapType;
			next unless $licView->licenseType eq 'NAMED CPU';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless defined $licView->cpuSerial;
			next
			  unless $licView->cpuSerial eq $self->installedSoftwareReconData->hSerial;
	
			my $neededQuantity = $myCount - $tempQuantityAllocated;
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
		if ( $isFullyAllocated == 0 ) { # named CPU, pool master's licenses
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq $myCapType;
				next unless $licView->licenseType eq 'NAMED CPU';
				next
				  unless $licView->cId ne $self->installedSoftwareReconData->cId;
				next unless defined $licView->cpuSerial;
				next
					unless $licView->cpuSerial eq $self->installedSoftwareReconData->hSerial;
	
				my $neededQuantity = $myCount - $tempQuantityAllocated;
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
	
	###Named LPAR, customer's licenses
	if (( $isFullyAllocated == 0 ) && ( $machineLevel == 0 )) {
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq $myCapType;
			next unless $licView->licenseType eq 'NAMED LPAR';
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;
			next unless defined $licView->lparName;
			next
				unless $licView->lparName eq $self->installedSoftwareReconData->hlName;
				
			my $neededQuantity = $myCount - $tempQuantityAllocated;
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
		if ( $isFullyAllocated == 0 ) { # named LPAR, master pool's licenses
			foreach my $lId ( keys %{$freePoolData} ) {
				my $lEnv    = $freePoolData->{$lId}->environment;
				my $licView = $freePoolData->{$lId};
				next unless $licView->capType     eq $myCapType;
				next unless $licView->licenseType eq 'NAMED LPAR';
				next
				  unless $licView->cId ne
				  $self->installedSoftwareReconData->cId;
				next unless defined $licView->lparName;
				next
					unless $licView->lparName eq $self->installedSoftwareReconData->hlName;
				
				my $neededQuantity = $myCount - $tempQuantityAllocated;
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
	###other licenses
	if (( $isFullyAllocated == 0 ) && ( $machineLevel == 1 )) { # customer's own
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq $myCapType;
			next if (( $licView->licenseType eq 'NAMED CPU' ) || ( $licView->licenseType eq 'NAMED LPAR' ));
			next
			  unless $licView->cId eq $self->installedSoftwareReconData->cId;

			my $neededQuantity = $myCount - $tempQuantityAllocated;
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
	if ( $isFullyAllocated == 0 ) { # master pool
		foreach my $lId ( keys %{$freePoolData} ) {
			my $lEnv    = $freePoolData->{$lId}->environment;
			my $licView = $freePoolData->{$lId};
			next unless $licView->capType     eq $myCapType;
			next if (( $licView->licenseType eq 'NAMED CPU' ) || ( $licView->licenseType eq 'NAMED LPAR' ));
			next
			  unless $licView->cId ne $self->installedSoftwareReconData->cId;

			my $neededQuantity = $myCount - $tempQuantityAllocated;
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

	###Return lics to allocate if able to fully allocate, else undef.
	if ( $isFullyAllocated == 1 ) {
		dlog("allocated");
		return ( \%licsToAllocate, $machineLevel );
	}
	else {
		dlog("unable to allocate");
		return undef;
	}

	dlog("end attemptLicenseAllocationMipsMsuGartner");
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
#	else { no longer used, ticket 394
#		$machineLevel   = 0;
#		$processorCount = $self->installedSoftwareReconData->processorCount;
#	}

	return undef if $processorCount == 0;
	
	return undef if ( $self->pvuValue == -1 ); # for PVU not found in table, no PVU recon will be performed

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
	my ( $self, $nbrCoresPerChip, $processorCount ) = @_;
	my $defaultValue      = -1; # 100 should no longer be a default value
	my $valueUnitsPerCore = 0;
	dlog(
"start calculating PVU, coresPerChip=$nbrCoresPerChip processorCount=$processorCount"
	);
	if (( not defined $nbrCoresPerChip ) || ( $nbrCoresPerChip < 1 )) {
		dlog("undefined or 0 or less cores per chip, $defaultValue PVU returned");
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

		my $processorSql = '';

		if ( $nbrCoresPerChip == 1 ) {
			$processorSql =
" (processor_type = 'SINGLE-CORE' or processor_type like '%ONE%') ";
		}
		elsif ( $nbrCoresPerChip == 2 ) {
			$processorSql = " processor_type = 'DUAL-CORE' ";
		}
		elsif ( $nbrCoresPerChip == 4 ) {
			$processorSql = " processor_type like '%QUAD-CORE%' ";
		}

		if ( $processorSql ne '' ) {
			$valueUnitsPerCore =
			  $self->getValueUnitsPerCore( $processorSql, $pvuMap->pvuId );
		}

		if ( $valueUnitsPerCore == 0 && $nbrCoresPerChip > 1 ) {
			$processorSql      = " processor_type like '%MULTI-CORE%' ";
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
	my $self=shift;
	my $scopeName=shift;
	
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
           ( l.customer_id = ? or l.customer_id in (select master_account_id from account_pool where logical_delete_ind = 0 and member_account_id = ? ))
            and ((l.cap_type in( 2, 13, 14, 17, 34, 48, 49 ) and l.try_and_buy = 0) or ( l.cap_type in ( 5, 9, 70 ) ) )
            and l.lic_type != \'SC\'   
            and s.software_id = ?
            and l.status = \'ACTIVE\'
            and s.status = \'ACTIVE\'
            and l.environment <> \'DEVELOPMENT\'
            ';
    $query .= 'and l.ibm_owned = 0' if ( ( $scopeName eq 'CUSTOIBMM' ) || ( $scopeName eq 'CUSTO3RDM' ) || ( $scopeName eq 'CUSTOIBMMSWCO' ) );
    $query .= 'and l.ibm_owned = 1' if ( ( $scopeName eq 'IBMOIBMM' ) );
    $query.='
        order by
        	l.id
        with ur
    ';
    
    dlog("Reading licenses query: $query"); # debug
    
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
		$installedSoftwareReconData->hChips( $rec{hChips} );
		$installedSoftwareReconData->hNbrCoresPerChip ( $rec{hNbrCoresPerChip} );
		$installedSoftwareReconData->hProcessorBrand( $rec{hProcessorBrand} );
		$installedSoftwareReconData->hProcessorModel( $rec{hProcessorModel} );
		$installedSoftwareReconData->hMachineTypeId( $rec{hMachineTypeId} );
		$installedSoftwareReconData->hServerType( $rec{hServerType} );
		$installedSoftwareReconData->hCpuMIPS( $rec{hCpuMIPS} );
		$installedSoftwareReconData->hCpuGartnerMIPS ( $rec{hCpuGartnerMIPS} );
		$installedSoftwareReconData->hCpuMSU( $rec{hCpuMSU} );
		$installedSoftwareReconData->hCpuIFL( $rec{hCpuIFL} );
		$installedSoftwareReconData->hOwner( $rec{hOwner} );
		$installedSoftwareReconData->mtType( $rec{mtType} );
		$installedSoftwareReconData->hlId( $rec{hlId} );
		$installedSoftwareReconData->hlStatus( $rec{hlStatus} );
		$installedSoftwareReconData->hlName( $rec{hlName} );
		$installedSoftwareReconData->hlPartMIPS( $rec{hlPartMIPS} );
		$installedSoftwareReconData->hlPartGartnerMIPS ( $rec{hlPartGartnerMIPS} );
		$installedSoftwareReconData->hlPartMSU( $rec{hlPartMSU} );
		$installedSoftwareReconData->slId( $rec{slId} );
		$installedSoftwareReconData->cId( $rec{cId} );
		$installedSoftwareReconData->slName( $rec{slName} );
		$installedSoftwareReconData->slStatus( $rec{slStatus} );
		$installedSoftwareReconData->sId ( $rec{sId} );
		$installedSoftwareReconData->sName ( $rec{sName} );
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
##		$installedSoftwareReconData->scopeName( $rec{scopeName} );
		$installedSoftwareReconData->rIsManual ( $rec{rIsManual} );


		$installedSoftwareReconData->processorCount( $rec{slProcCount} );

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
	
	###Reading new scope from scheduleF, procedure added by Michal Gross
	
	my ( $scopename_temp, $priofound_temp ) = getScheduleFScope( $self,
																$installedSoftwareReconData->cId, # customer ID
																$installedSoftwareReconData->sName, # software name
																$installedSoftwareReconData->hOwner, # hardware owner ID
																$installedSoftwareReconData->hSerial, # hardware serial
																$installedSoftwareReconData->hMachineTypeId, #machine type
																$installedSoftwareReconData->slName #hostname
															  );
															  
    $installedSoftwareReconData->scopeName ( $scopename_temp );
    $installedSoftwareReconData->scheduleFlevel ( $priofound_temp ); # 3 = hostname, 2 = HWbox, 1 = hardware owner, 0 = software

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
	
	dlog("Searching for ScheduleF scope, customer=".$custId.", software=".$softName);
	
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

sub queryScheduleFScope {
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
	  with ur
	';
	return('ScheduleFScope', $query, \@fields );
	
}



sub queryReconInstalledSoftwareBaseData {
	my @fields = qw(
	  hId
	  hStatus
	  hHwStatus
	  hSerial
	  hProcCount
	  hChips
	  hNbrCoresPerChip
	  hProcessorBrand
	  hProcessorModel
	  hMachineTypeId
	  hServerType
	  hCpuMIPS
	  hCpuGartnerMIPS
	  hCpuMSU
	  hCpuIFL
	  hOwner
	  mtType
	  hlId
	  hlStatus
	  hlName
	  hlPartMIPS
	  hlCpuGartnerMIPS
	  hlPartMSU
	  slId
	  cId
	  slName
	  slStatus
	  slProcCount
	  sId
	  sName
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
	  rIsManual
	);
	my $query = '
        select
            h.id
            ,h.status
            ,h.hardware_status
            ,h.serial
            ,h.processor_count
            ,h.chips
            ,h.nbr_cores_per_chip
            ,h.mast_processor_type
            ,h.model
            ,h.machine_type_id
            ,h.server_type
            ,h.cpu_mips
            ,h.cpu_gartner_mips
            ,h.cpu_msu
            ,h.cpu_ifl
            ,h.owner
            ,mt.type
            ,hl.id
            ,hl.lpar_status
            ,hl.name
            ,hl.part_mips
            ,hl.part_gartner_mips
            ,hl.part_msu
            ,sl.id
            ,sl.customer_id
            ,sl.name
            ,sl.status
            ,sl.processor_count
            ,s.software_id
            ,s.software_name
            ,s.status
            ,s.priority
            ,s.level
            ,s.vendor_managed
            ,m.name
            ,sc.software_category_name
            ,bp.id
            ,bc.software_id as bc_software_id
            ,r.id
            ,r.reconcile_type_id
            ,r.parent_installed_software_id
            ,r.machine_level
            ,rt.is_manual
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
            left outer join reconcile_type rt on
                r.reconcile_type_id = rt.id
        where
            is.id = ?
        with ur
	';
	return ( 'reconInstalledSoftwareBaseData', $query, \@fields );
	
#	            left outer join schedule_f sf on
#                sf.customer_id = sl.customer_id
#                and sf.software_id = is.software_id
#                and sf.status_id = 2
#            left outer join scope scope on
#                scope.id = sf.scope_id

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
            ,pi.priority
            ,sc.software_category_name
            ,bc.software_id
        from
            installed_software is
            join product_info pi on pi.id = is.software_id
            join software_category sc on sc.software_category_id = pi.software_category_id
            left outer join bundle_software bs on bs.software_id = pi.id
            left outer join bundle bc on bc.id = bs.bundle_id
        where
            is.software_lpar_id = ?
            and is.software_id != ?
            and is.status = \'ACTIVE\'
            and is.discrepancy_type_id not in ( 3, 5 )
        with ur
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
		Recon::CauseCode::updateCCtable ( $alert->id, 17, $self->connection);
	}
	elsif ( $createNew == 1 ) {
		$alert->creationTime( currentTimeStamp() );
		$alert->save( $self->connection );
		Recon::CauseCode::updateCCtable ( $alert->id, 17, $self->connection);
	}	

	dlog("end closeAlertUnlicensedSoftware");
}

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
	my $scope = shift;
	
	dlog("Getting existing machine level recon, scope $scope.");

	my %data;
	$self->connection->prepareSqlQueryAndFields(
		$self->queryExistingMachineLevelRecon($scope) );
	my $sth;
	my %rec;
	if (( not defined $scope ) || ( $scope ne "IBMOIBMM" )) {
		$sth = $self->connection->sql->{existingMachineLevelRecon};
		$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{existingMachineLevelReconFields} } );
		$sth->execute(
			$self->installedSoftwareReconData->hId,
			$self->installedSoftware->softwareId,
			$self->customer->id, $self->customer->id );
	}
	elsif (( defined $scope ) && ( $scope eq "IBMOIBMM" )) {
		$sth = $self->connection->sql->{existingMachineLevelReconAll};
		$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->connection->sql->{existingMachineLevelReconAllFields} } );
		$sth->execute(
			$self->installedSoftwareReconData->hId,
			$self->installedSoftware->softwareId );
	}

	while ( $sth->fetchrow_arrayref ) {
		logRec( 'dlog', \%rec );

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

sub queueSoftwareCategory { # puts all the installed software, who's category parent 
							# is the software just considered invalid, into queue
	my $self=shift;
	my $swId=shift;
	
	dlog("Checking for installed SW ID $swId to be used as software category parent");
	
	 #Prepare the query.
	$self->connection->prepareSqlQueryAndFields( $self->queryInsSwByParentProduct() );

	#Acquire the statement handle.
	my $sth = $self->connection->sql->{queryInsSwByParentProduct};

 #Bind fields.
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{queryInsSwByParentProductFields} } );

 #Fetch correspond sw recon infor.
 $sth->execute( $swId );
 
 my $total = 0;
  
 while ( $sth->fetchrow_arrayref ) {
	 
  dlog("Software ID ".$rec{isId}." found.");
  
  my $childInstSw = new BRAVO::OM::InstalledSoftware();
  $childInstSw->id($rec{isId});
  $childInstSw->getById( $self->connection );

  my $childSwLpar = new BRAVO::OM::SoftwareLpar();
  $childSwLpar->id( $childInstSw->softwareLparId );
  $childSwLpar->getById( $self->connection );

  my $queue = Recon::Queue->new( $self->connection, $childInstSw, $childSwLpar );
  $queue->add;
  
  $total++;

 }

 $sth->finish;
 
 dlog("$total installed SW's added into queue.");
 
 return 0;
	
}

sub queryInsSwByParentProduct { # taking in 4 (included with), 7 (bundled), 8 (software category)
	my @fields = qw(
	  isId
	);
	
	my $query = '
    select 
      r.installed_software_id
    from
      reconcile r
    where
      r.reconcile_type_id in ( 4, 7, 8 )
         and
      r.parent_installed_software_id = ?
    with ur
    ';

	return ( 'queryInsSwByParentProduct', $query, \@fields );
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
    with ur
    ';

	return ( 'productionHwlparCount', $query, \@fields );
}

sub queryExistingMachineLevelRecon {
	my $self=shift;
	my $scope=shift;
	
	dlog("Searching for machinelevel recon accross all customers, IBMOIBMM") if (( defined $scope ) && ( $scope eq "IBMOIBMM" ));
	
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
            and is.software_id = ?';
$query.='   and (l.customer_id = ? or (l.customer_id in (select master_account_id from account_pool where member_account_id = ?) and l.pool = 1))' if (( not defined $scope ) || ( $scope ne "IBMOIBMM" ));
$query.='   and h.id = hl.hardware_id
            and hsc.software_lpar_id = sl.id
            and hsc.hardware_lpar_id = hl.id
            and sl.id = is.software_lpar_id
            and is.id = r.installed_software_id
            and r.id = rul.reconcile_id
            and r.machine_level = 1
            and ul.license_id = l.id
            and rul.used_license_id = ul.id
        with ur
    ';

	return ( 'existingMachineLevelRecon', $query, \@fields )  if (( not defined $scope ) || ( $scope ne "IBMOIBMM" ));
	return ( 'existingMachineLevelReconAll', $query, \@fields ) if (( defined $scope ) && ( $scope eq "IBMOIBMM" ));
}

sub createReconcile {
	my ( $self, $reconcileTypeId, $machineLevel, $parentInstalledSoftwareId, $allocMethodId ) =
	  @_;
	dlog("begin createReconcile");

	###Instantiate reconcile object.
	my $reconcile = new Recon::OM::Reconcile();
	$reconcile->reconcileTypeId($reconcileTypeId);
	$reconcile->installedSoftwareId( $self->installedSoftware->id );
	$reconcile->parentInstalledSoftwareId($parentInstalledSoftwareId);
	$reconcile->allocationMethodologyId($allocMethodId) if defined ($allocMethodId);
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
	with ur
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
	my $CCalertType=0;
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
		$CCalertType=7;
	}
	else {
		$alert->type('ISV');
		$CCalertType=8;
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
	
	Recon::CauseCode::updateCCtable ( $alert->id, 17, $self->connection);

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


