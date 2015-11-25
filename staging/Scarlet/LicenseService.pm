package Scarlet::LicenseService;

use strict;
use Base::Utils;
use Scarlet::LicenseEndpoint;
use Database::Connection;
use BRAVO::OM::Customer;
use Recon::ScarletInstalledSoftware;

sub new {
 my $class = shift;
 my $self  = {
  _connection      => Database::Connection->new('trails'),
  _licenseEndpoint => new Scarlet::LicenseEndpoint()
 };

 bless $self, $class;
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub licenseEndpoint {
 my $self = shift;
 $self->{_licenseEndpoint} = shift if scalar @_ == 1;
 return $self->{_licenseEndpoint};
}

sub getFreePoolData {
 my $self                = shift;
 my $scopeName           = shift;
 my $customerId          = shift;
 my $installedSoftwareId = shift;

 dlog("begin scarlet.getFreePoolData");

 my %data = ();
 my %machineLevel;

 my $customer = new BRAVO::OM::Customer();
 $customer->customerId($customerId);
 $customer->getByBizKey( $self->connection );

 my $sIs  = new Recon::ScarletInstalledSoftware();
 my $guid = $sIs->getGuiIdByInstalledSoftwareId($installedSoftwareId);

 my $licenseIds =
   $self->licenseEndpoint->httpGet( $customer->accountNumber, $guid );    

 $self->connection->prepareSqlQueryAndFields(
  $self->queryFreePoolData($scopeName) );
 my $sth = $self->connection->sql->{freePoolData};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{freePoolDataFields} } );

 $sth->execute( @{$licenseIds} );

 while ( $sth->fetchrow_arrayref ) {
  dlog("lId =$rec{lId}");

  ###I should centralize this check
  if ( defined $self->customer->swComplianceMgmt
   && $self->customer->swComplianceMgmt eq 'YES' )
  {
   if ( defined $self->installedSoftwareReconData->scopeName ) {

    if ($self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM'
     || $self->installedSoftwareReconData->scopeName eq 'CUSTOIBMM' )
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
   $licView->extSrcId( $rec{extSrcId} );
   $licView->fromScarlet( $rec{fromScarlet} );
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
     if ( exists $machineLevel{ $rec{ulId} } ) {
      next;
     }
     else {
      $machineLevel{ $rec{ulId} } = 1;
     }
    }

    $data{ $rec{lId} }
      ->quantity( $data{ $rec{lId} }->quantity - $rec{usedQuantity} );
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
  $validation->isLicInFinRespScope( $self->customer->swFinancialResponsibility,
   $licView->ibmOwned, undef );
  $validation->validateMaintenanceExpiration(
   $self->installedSoftwareReconData->mtType,
   $licView->capType, 0, $licView->expireAge, undef, undef );
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
  $validation->validateProcessorChip( 0, $licView->capType,
   $self->installedSoftwareReconData->mtType,
   1, undef );

  ###Check pool
  if ( $licView->pool == 0 ) {
   ###License is not poolable, must equal customer
   if ( $licView->cId != $self->customer->id ) {
    dlog("License is not poolable and does not equal the customer id");
    $validation->validationCode(0);
   }
  }

  if ( $licView->quantity <= 0 ) {
   dlog( "lic fully allocated, removing from free pool hash: id=" . $lId );
   $validation->validationCode(0);
  }

  delete $data{$lId} if $validation->validationCode == 0;
 }

 dlog("end getFreePoolData");
 return \%data;
}

sub queryFreePoolData {
 my $self      = shift;
 my $scopeName = shift;

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
   extSrcId
   ulId
   usedQuantity
   machineLevel
   hId
   fromScarlet
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
       l.ext_src_id,
       ul.id,
       ul.used_quantity,
       r.machine_level,
       h.id,
       \'YES\' 
from 
      license l 
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
            l.ext_src_id in (?)
            and ((l.cap_type in( 2, 13, 14, 17, 34, 48, 49 ) and l.try_and_buy = 0) or ( l.cap_type in ( 5, 9, 70 ) ) )
            and l.lic_type != \'SC\'   
            and l.status = \'ACTIVE\'
            and l.environment <> \'DEVELOPMENT\'
            ';
 $query .= 'and l.ibm_owned = 0'
   if ( ( $scopeName eq 'CUSTOIBMM' )
  || ( $scopeName eq 'CUSTO3RDM' )
  || ( $scopeName eq 'CUSTOIBMMSWCO' ) );
 $query .= 'and l.ibm_owned = 1' if ( ( $scopeName eq 'IBMOIBMM' ) );
 $query .= '
        order by
        	l.id
        with ur
    ';

 dlog("Reading licenses query: $query");    # debug

 return ( 'freePoolData', $query, \@fields );
}

1;
