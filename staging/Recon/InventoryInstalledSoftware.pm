package Recon::InventoryInstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
# use BRAVO::OM::License;
use BRAVO::OM::Software;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconInstalledSoftwareData;
# use Recon::OM::Reconcile;
use Recon::OM::AlertUnlicensedSoftware;
use Recon::OM::AlertUnlicensedSoftwareHistory;
# use Recon::OM::LicenseView;
# use Recon::OM::UsedLicense;
# use Recon::OM::ReconcileUsedLicense;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use Recon::Delegate::ReconDelegate;
# use Recon::License;
use Recon::Delegate::ReconInstalledSoftwareValidation;
# use Recon::OM::PvuMap;
# use Recon::OM::PvuInfo;
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
	$validation->validate;

	if ( $validation->validationCode == 0 ) {
		dlog("Installed software is invalid");
		$self->closeAlertUnlicensedSoftware(0);
		Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection,
			$self->installedSoftwareReconData->rId )
		  if defined $self->installedSoftwareReconData->rId;
		$self->queueSoftwareCategory( $self->installedSoftware->id );
		return 0;
	}
	
	dlog("InstalledSoftware object is valid, returning to caller");
	return 2;

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
#		$installedSoftwareReconData->hProcCount( $rec{hProcCount} );
		$installedSoftwareReconData->hHwStatus( $rec{hHwStatus} );
#		$installedSoftwareReconData->hSerial( $rec{hSerial} );
#		$installedSoftwareReconData->hChips( $rec{hChips} );
#		$installedSoftwareReconData->hNbrCoresPerChip ( $rec{hNbrCoresPerChip} );
#		$installedSoftwareReconData->hProcessorBrand( $rec{hProcessorBrand} );
#		$installedSoftwareReconData->hProcessorModel( $rec{hProcessorModel} );
#		$installedSoftwareReconData->hMachineTypeId( $rec{hMachineTypeId} );
#		$installedSoftwareReconData->hServerType( $rec{hServerType} );
#		$installedSoftwareReconData->hCpuMIPS( $rec{hCpuMIPS} );
#		$installedSoftwareReconData->hCpuGartnerMIPS ( $rec{hCpuGartnerMIPS} );
#		$installedSoftwareReconData->hCpuMSU( $rec{hCpuMSU} );
#		$installedSoftwareReconData->hCpuIFL( $rec{hCpuIFL} );
#		$installedSoftwareReconData->hOwner( $rec{hOwner} );
#		$installedSoftwareReconData->mtType( $rec{mtType} );
		$installedSoftwareReconData->hlId( $rec{hlId} );
		$installedSoftwareReconData->hlStatus( $rec{hlStatus} );
		$installedSoftwareReconData->hlName( $rec{hlName} );
#		$installedSoftwareReconData->hlPartMIPS( $rec{hlPartMIPS} );
#		$installedSoftwareReconData->hlPartGartnerMIPS ( $rec{hlPartGartnerMIPS} );
#		$installedSoftwareReconData->hlPartMSU( $rec{hlPartMSU} );
		$installedSoftwareReconData->slId( $rec{slId} );
		$installedSoftwareReconData->cId( $rec{cId} );
#		$installedSoftwareReconData->slName( $rec{slName} );
		$installedSoftwareReconData->slStatus( $rec{slStatus} );
		$installedSoftwareReconData->sId ( $rec{sId} );
		$installedSoftwareReconData->sName ( $rec{sName} );
		$installedSoftwareReconData->sStatus( $rec{sStatus} );
#		$installedSoftwareReconData->sPriority( $rec{sPriority} );
		$installedSoftwareReconData->sLevel( $rec{sLevel} );
#		$installedSoftwareReconData->sVendorMgd( $rec{sVendorMgd} );
		$installedSoftwareReconData->sMfg( $rec{sMfg} );
#		$installedSoftwareReconData->scName( $rec{scName} );
		$installedSoftwareReconData->rId( $rec{rId} );
#		$installedSoftwareReconData->rTypeId( $rec{rTypeId} );
#		$installedSoftwareReconData->rParentInstSwId( $rec{rParentInstSwId} );
#		$installedSoftwareReconData->rMachineLevel( $rec{rMachineLevel} );
##		$installedSoftwareReconData->scopeName( $rec{scopeName} );
#		$installedSoftwareReconData->rIsManual ( $rec{rIsManual} );


#		$installedSoftwareReconData->processorCount( $rec{slProcCount} );

	}

	dlog("end getInstalledSoftwareReconData - Inventory");

	$self->installedSoftwareReconData($installedSoftwareReconData);
}

sub queryReconInstalledSoftwareBaseData {
	my @fields = qw(
	  hId
	  hStatus
	  hHwStatus
	  hlId
	  hlStatus
	  hlName
	  slId
	  cId
	  slStatus
	  sId
	  sName
	  sStatus
	  sLevel
	  sMfg
	  rId
	);
	my $query = '
        select
            h.id
            ,h.status
            ,h.hardware_status
            ,hl.id
            ,hl.lpar_status
            ,hl.name
            ,sl.id
            ,sl.customer_id
            ,sl.status
            ,s.software_id
            ,s.software_name
            ,s.status
            ,s.level
            ,m.name
            ,r.id
        from
            installed_software is
            join software_lpar sl on 
                sl.id = is.software_lpar_id
            join software s on 
                s.software_id = is.software_id
            join manufacturer m on 
                m.id = s.manufacturer_id
            left outer join hw_sw_composite hsc on 
                hsc.software_lpar_id = sl.id
            left outer join hardware_lpar hl on 
                hl.id = hsc.hardware_lpar_id
            left outer join hardware h on 
                h.id = hl.hardware_id
            left outer join reconcile r on
				r.installed_software_id = is.id
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
		Recon::CauseCode::updateCCtable ( $alert->id, "NOLIC", $self->connection);
	}
	elsif ( $createNew == 1 ) {
		$alert->creationTime( currentTimeStamp() );
		$alert->save( $self->connection );
		Recon::CauseCode::updateCCtable ( $alert->id, "NOLIC", $self->connection);
	}	

	dlog("end closeAlertUnlicensedSoftware");
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
	
	Recon::CauseCode::updateCCtable ( $alert->id, "NOLIC", $self->connection);

	dlog("end openAlertUnlicensedSoftware");
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


