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
  _licenseEndpoint => new Scarlet::LicenseEndpoint()
 };

 bless $self, $class;
}

sub licenseEndpoint {
 my $self = shift;
 $self->{_licenseEndpoint} = shift if scalar @_ == 1;
 return $self->{_licenseEndpoint};
}

sub getFreePoolData {
 my $self                       = shift;
 my $connection					= shift;
 my $installedSoftwareReconData = shift;
 my $customer                   = shift;
 my $installedSoftwareId        = shift;

 dlog("begin scarlet.getFreePoolData");

 my %data = ();
 my %machineLevel;

 my $sIs  = new Recon::ScarletInstalledSoftware();
 my $guid = $sIs->getGuiIdByInstalledSoftwareId($installedSoftwareId);

 my $licenseIds =
   $self->licenseEndpoint->httpGet( $customer->accountNumber, $guid );
 if ( !defined $licenseIds ) {
  $licenseIds = [];
 }

 dlog( scalar @{$licenseIds} . ' license(s) found from scarlet.' );    

 my $foundQty = scalar @{$licenseIds};
 return \%data
   if ( $foundQty <= 0 );

 my $counter = 0;
 my $wherestmt;
 foreach my $extSrcId ( @{$licenseIds} ) {
  $counter++;
  if ( $counter < $foundQty ) {
   $wherestmt .= "'$extSrcId',";
  }
  else {
   $wherestmt .= "'$extSrcId'";
  }
 }

 $connection->prepareSqlQueryAndFields(
  $self->queryFreePoolData(
   $installedSoftwareReconData->scopeName, $wherestmt
  )
 );
 my $sth = $connection->sql->{"freePoolData".$installedSoftwareReconData->scopeName.$wherestmt};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $connection->sql->{"freePoolData".$installedSoftwareReconData->scopeName.$wherestmt."Fields"} } );

 $sth->execute();

 while ( $sth->fetchrow_arrayref ) {

  ###I should centralize this check
  if ( defined $customer->swComplianceMgmt
   && $customer->swComplianceMgmt eq 'YES' )
  {
   if ( defined $installedSoftwareReconData->scopeName ) {

    if ($installedSoftwareReconData->scopeName eq 'CUSTOCUSTM'
     || $installedSoftwareReconData->scopeName eq 'CUSTOIBMM' )
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
   $licView->from( $rec{from} );
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
  $validation->isLicInFinRespScope( $customer->swFinancialResponsibility,
   $licView->ibmOwned, undef );
  $validation->validateMaintenanceExpiration(
   $installedSoftwareReconData->mtType,
   $licView->capType, 0, $licView->expireAge, undef, undef );
  $validation->validatePhysicalCpuSerialMatch( $licView->capType,
   $licView->licenseType, $installedSoftwareReconData->hSerial,
   $licView->cpuSerial, undef, undef, 0 );
  $validation->validateLparNameMatch(
   $licView->capType,                   $licView->licenseType,
   $licView->lparName,                  $installedSoftwareReconData->slName,
   $installedSoftwareReconData->hlName, undef,
   undef,                               0
  );
  $validation->validateProcessorChip( 0, $licView->capType,
   $installedSoftwareReconData->mtType,
   1, undef );

  ###Check pool
  if ( $licView->pool == 0 ) {
   ###License is not poolable, must equal customer
   if ( $licView->cId != $customer->id ) {
    dlog("License is not poolable and does not equal the customer id");
    $validation->validationCode(0);
   }
  }

#  if ( $licView->quantity <= 0 ) {   # We need even licenses with 0 free quantity in pool, due to the new method of "machine-level" search
#   dlog( "lic fully allocated, removing from free pool hash: id=" . $lId );
#   $validation->validationCode(0);
#  }

  delete $data{$lId} if $validation->validationCode == 0;
 }

 dlog("end getFreePoolData");
 return \%data;
}

sub queryFreePoolData {
 my $self      = shift;
 my $scopeName = shift;
 my $inStmt    = shift;

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
   from
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
       \'scarlet\' 
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
            l.ext_src_id in (' . $inStmt . ')
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

 return ( 'freePoolData'.$scopeName.$inStmt, $query, \@fields );
}

1;
