package Recon::Delegate::ReconLicenseValidation;

use strict;
use Base::Utils;
use Recon::Delegate::ReconDelegate;
use Recon::Pvu;
use Recon::ScarletReconcile;

sub new {
 my ($class) = @_;
 my $self = {
  _customer              => undef,
  _license               => undef,
  _licenseAllocationData => undef,
  _connection            => undef,
  _licSwMap              => undef,
  _accountPoolChildren   => undef,
  _reconcilesToBreak     => undef,
  _isValid               => undef,
  _validationCode        => undef,
  _freeCapacity          => undef,
  _machineLevelOnly      => undef,
  _deleteQueue           => undef,
  _scarletAllocation     => 'UNKNOW'
 };
 bless $self, $class;
 return $self;
}

sub scarletAllocation {
 my $self = shift;
 $self->{_scarletAllocation} = shift if scalar @_ == 1;
 return $self->{_scarletAllocation};
}

sub customer {
 my $self = shift;
 $self->{_customer} = shift if scalar @_ == 1;
 return $self->{_customer};
}

sub isValid {
 my $self = shift;
 $self->{_isValid} = shift if scalar @_ == 1;
 return $self->{_isValid};
}

sub license {
 my $self = shift;
 $self->{_license} = shift if scalar @_ == 1;
 return $self->{_license};
}

sub licenseAllocationData {
 my $self = shift;
 $self->{_licenseAllocationData} = shift if scalar @_ == 1;
 return $self->{_licenseAllocationData};
}

sub licSwMap {
 my $self = shift;
 $self->{_licSwMap} = shift if scalar @_ == 1;
 return $self->{_licSwMap};
}

sub validationCode {
 my $self = shift;
 $self->{_validationCode} = shift if scalar @_ == 1;
 return $self->{_validationCode};
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub accountPoolChildren {
 my $self = shift;
 $self->{_accountPoolChildren} = shift if scalar @_ == 1;
 return $self->{_accountPoolChildren};
}

sub reconcilesToBreak {
 my $self = shift;
 $self->{_reconcilesToBreak} = shift if scalar @_ == 1;
 return $self->{_reconcilesToBreak};
}

sub addToReconcilesToBreak {
 my ( $self, $reconcileId ) = @_;
 dlog("reconcileId=$reconcileId");

 my $reconcilesToBreak = $self->reconcilesToBreak;
 $reconcilesToBreak->{$reconcileId}++;
 $self->reconcilesToBreak($reconcilesToBreak);
 return;
}

sub freeCapacity {
 my $self = shift;
 $self->{_freeCapacity} = shift if scalar @_ == 1;
 return $self->{_freeCapacity};
}

sub machineLevelOnly {
 my $self = shift;
 $self->{_machineLevelOnly} = shift if scalar @_ == 1;
 return $self->{_machineLevelOnly};
}

sub deleteQueue {
 my $self = shift;
 $self->{_deleteQueue} = shift if scalar @_ == 1;
 return $self->{_deleteQueue};
}

sub addToDeleteQueue {
 my ( $self, $licenseId ) = @_;

 my $deleteQueue = $self->deleteQueue;
 $deleteQueue->{$licenseId}++;
 $self->deleteQueue($deleteQueue);
 return;
}

sub minimumPvuValue {
 my $self = shift;
 $self->{_minimumPvuValue} = shift if scalar @_ == 1;
 if ( !defined $self->{_minimumPvuValue} ) {
  my $pvuInfo = new Recon::Pvu( $self->connection );
  $self->{_minimumPvuValue} = $pvuInfo->getMinimumPvuValue;
 }
 return $self->{_minimumPvuValue};
}

sub validate {
 my $self = shift;

 my $freeCapacity     = 0;
 my $tempUsedCapacity = 0;
 my %machineLevel;
 $self->machineLevelOnly(0);
 $self->validationCode(1);

 $self->validateCustomer( $self->customer->status,
  $self->customer->swLicenseMgmt, undef );
 $self->isLicInFinRespScope( $self->customer->swFinancialResponsibility,
  $self->license->ibmOwned, undef );
 $self->validateLicense( $self->license->status, undef );
 $self->validateTryAndBuy( $self->license->tryAndBuy, $self->license->capType,
  undef, undef );
 $self->validateSubCapacity( $self->license->licType, undef, undef );

 foreach my $rId ( keys %{ $self->licenseAllocationData } ) {
  my $rValid = 1
    ; # starts as 1 and gets multiplied by each validation... if it gets zero, stays zero, otherwise is 1 at the end

  my $licenseAllocationView = $self->licenseAllocationData->{$rId};
  dlog( $licenseAllocationView->rId );

  $rValid *=
    $self->validateCustomer( $self->customer->status,
   $self->customer->swLicenseMgmt,
   $licenseAllocationView->rId );
  $rValid *=
    $self->isLicInFinRespScope( $self->customer->swFinancialResponsibility,
   $self->license->ibmOwned, $licenseAllocationView->rId );
  $rValid *=
    $self->validateLicense( $self->license->status,
   $licenseAllocationView->rId );
  $rValid *= $self->validateTryAndBuy(
   $self->license->tryAndBuy,   $licenseAllocationView->lrmCapType,
   $licenseAllocationView->rId, $licenseAllocationView->rtIsManual
  );
  $rValid *=
    $self->validateSubCapacity( $self->license->licType,
   $licenseAllocationView->rId, $licenseAllocationView->rtIsManual );
  $rValid *= $self->validateLicenseAllocationCustomer($licenseAllocationView);
  $rValid *= $self->validateCapacityType(
   $licenseAllocationView->lrmCapType, $self->license->capType,
   $licenseAllocationView->rId,        $self->license->id,
   $licenseAllocationView->rtIsManual
  );
  $rValid *= $self->validateProcCount(
   $licenseAllocationView->hProcessorCount, $self->license->capType,
   $licenseAllocationView->rId,             $self->license->id,
   $licenseAllocationView->rtIsManual, $licenseAllocationView->rAllocMethodology
  );
  $rValid *= $self->validatePhysicalCpuSerialMatch(
   $self->license->capType,         $self->license->licType,
   $licenseAllocationView->hSerial, $self->license->cpuSerial,
   $licenseAllocationView->rId,     $self->license->id,
   $licenseAllocationView->rtIsManual
  );

  $rValid *= $self->validateLparNameMatch(
   $self->license->capType,        $self->license->licType,
   $self->license->lparName,       $licenseAllocationView->slName,
   $licenseAllocationView->hlName, $licenseAllocationView->rId,
   $licenseAllocationView->rtIsManual
  );
  $rValid *= $self->validateMachineTypeMatch(
   $self->license->capType,
   $licenseAllocationView->rtIsManual,
   $licenseAllocationView->mtType,
   $licenseAllocationView->rId, $self->license->id
  );
  $rValid *= $self->validateEnvironmentMatch(
   $self->license->environment,        $licenseAllocationView->hServerType,
   $licenseAllocationView->rtIsManual, $licenseAllocationView->rId
  );

  $rValid *= $self->validateLicenseSoftwareMap(
   $self->licSwMap->softwareId,          $licenseAllocationView->rtIsManual,
   $licenseAllocationView->isSoftwareId, $licenseAllocationView->rId,
   $self->license->id,                   $licenseAllocationView->isId
  );
  $rValid *= $self->validateMaintenanceExpiration(
   $licenseAllocationView->mtType,     $self->license->capType,
   $licenseAllocationView->rtIsManual, $licenseAllocationView->expireAge,
   $licenseAllocationView->rId,        $self->license->id
  );
  $rValid *= $self->validateScheduleF(
   $self->license->ibmOwned,
   $licenseAllocationView->slComplianceMgmt,
   $licenseAllocationView->scopeName,
   $licenseAllocationView->rId,
   $licenseAllocationView->rtIsManual
  );
  $rValid *= $self->validateProcessorChip(
   $licenseAllocationView->rtIsManual, $self->license->capType,
   $licenseAllocationView->mtType,     $licenseAllocationView->machineLevel,
   $licenseAllocationView->rId
  );
  $rValid *= $self->validateMipsGartnerMsu(
   $licenseAllocationView->rtIsManual,
   $self->license->capType,
   $self->license->licType,
   $licenseAllocationView->mtType,
   $licenseAllocationView->machineLevel,
   $licenseAllocationView->rId,
   $licenseAllocationView->hCpuMIPS,
   $licenseAllocationView->hCpuGartnerMIPS,
   $licenseAllocationView->hCpuMSU,
   $licenseAllocationView->hlPartMIPS,
   $licenseAllocationView->hlPartGartnerMIPS,
   $licenseAllocationView->hlPartMSU
  );

  if ( exists $machineLevel{ $licenseAllocationView->lrmId } ) {
   next;
  }
  else {
   $machineLevel{ $licenseAllocationView->lrmId }++;
  }

  if ($rValid) {
   $tempUsedCapacity =
     $tempUsedCapacity + $licenseAllocationView->lrmUsedQuantity;
   dlog( "temp capacity: " . $tempUsedCapacity );

   if ( $tempUsedCapacity > $self->license->quantity ) {
    $self->addToReconcilesToBreak( $licenseAllocationView->rId );
    $tempUsedCapacity =
      $tempUsedCapacity - $licenseAllocationView->lrmUsedQuantity;
    delete $machineLevel{ $licenseAllocationView->lrmId };
   }
  }
 }

 $self->freeCapacity( $self->license->quantity - $tempUsedCapacity );
 if ($self->license->capType eq '17'
  && $self->freeCapacity < $self->minimumPvuValue )
 {
  ###There could be machine level opportunities here
  $self->freeCapacity(0);
  $self->machineLevelOnly(1);
 }
 elsif (
  $self->freeCapacity <= 0
  && ($self->license->capType eq '34'
   || $self->license->capType eq '2'
   || $self->license->capType eq '48'
   || $self->license->capType eq '49'
   || $self->license->capType eq '5'
   || $self->license->capType eq '9' )
   )
 {
  $self->freeCapacity(0);
  $self->machineLevelOnly(1);
 }

 $self->isLicenseSoftwareMapValidToReconcile;
 if ( $self->freeCapacity <= 0 && $self->machineLevelOnly == 0 ) {
  $self->validationCode(0);
  dlog("Free capacity is less than 0 and this is not machine level only");
 }

 if ( $self->validationCode == 1 ) {
  dlog("validation code is 1");
  $self->isValid(1);
 }
 else {
  dlog("validation code is 0");
  $self->validationCode(0);
  $self->isValid(0);
 }
}

sub validateCustomer {
 my ( $self, $customerStatus, $customerSwLicMgmt, $reconcileId ) = @_;

 ###Check status
 if ( $customerStatus eq 'INACTIVE' ) {
  dlog("Customer is inactive");
  $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
  $self->validationCode(0);
  return 0;
 }
 ###Check if in scope for license management
 elsif ( $customerSwLicMgmt ne 'YES' ) {
  dlog("not in scope for swlm, marking as invalid");
  $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
  $self->validationCode(0);
  return 0;
 }

 return 1;
}

sub isLicInFinRespScope {
 my ( $self, $customerSwFinResp, $licenseOwner, $reconcileId ) = @_;
 dlog("begin isLicInFinRespScope");

 my $swFinResp = 'BOTH';
 if ( defined $customerSwFinResp ) {
  if ( $customerSwFinResp eq 'IBM' ) {
   $swFinResp = 'IBM';
  }
  elsif ( $customerSwFinResp eq 'CUSTOMER' ) {
   $swFinResp = 'CUSTOMER';
  }
 }
 dlog("swFinResp=$swFinResp");

 my $licOwner = 'IBM';
 if ( defined $licenseOwner ) {
  if ( $licenseOwner == 0 ) {
   $licOwner = 'CUSTOMER';
  }
 }
 dlog("licOwner=$licOwner");

 my $inScope = 1;
 if ( $swFinResp eq 'IBM' ) {
  if ( $licOwner eq 'CUSTOMER' ) {
   dlog("license is not in scope");
   $self->addToReconcilesToBreak($reconcileId)
     if defined $reconcileId;
   $inScope = 0;
   $self->validationCode(0);
  }
 }
 if ( $swFinResp eq 'CUSTOMER' ) {
  if ( $licOwner eq 'IBM' ) {
   dlog("license is not in scope");
   $self->addToReconcilesToBreak($reconcileId)
     if defined $reconcileId;
   $inScope = 0;
   $self->validationCode(0);
  }
 }

 dlog("inScope=$inScope");
 return $inScope;
}

sub validateLicense {
 my ( $self, $licenseStatus, $reconcileId ) = @_;
 dlog("begin validateLicense");

 if (( not defined $licenseStatus ) || ( $licenseStatus ne 'ACTIVE' )) {
  dlog("license is not active, adding to list to break");
  $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
  $self->validationCode(0);
  return 0;
 }
 return 1;
}

sub validateLicenseAllocationCustomer {
 my ( $self, $licenseAllocationView ) = @_;

 ###If license is poolable, then check the children
 if ( $self->license->pool == 1 ) {
  dlog("License is poolable");

  foreach my $priority ( keys %{ $self->accountPoolChildren } ) {
   if (
    exists $self->accountPoolChildren->{$priority}
    ->{ $licenseAllocationView->slCustomerId } )
   {
    return 1;
   }
  }
 }
 elsif ( $self->license->customerId == $licenseAllocationView->slCustomerId ) {
  return 1;
 }
 elsif ( ( $licenseAllocationView->scopeName eq "IBMOIBMM" )
  && ( $licenseAllocationView->machineLevel == 1 )
  && ( $self->license->ibmOwned == 1 ) )
 {
  return 1;
 }

 ###Validate customerId change
 dlog("customer id does not match lic, adding to list to break");
 $self->addToReconcilesToBreak( $licenseAllocationView->rId );
 $self->addToDeleteQueue( $self->license->id );
 $self->validationCode(0);

 return 0;
}

sub validateCapacityType {
 my ( $self, $lrmCapType, $licenseCapType, $reconcileId, $licenseId, $isManual )
   = @_;

 ###Validate capType change
 if ( ( $lrmCapType != $licenseCapType ) && ( $isManual == 0 ) ) {
  dlog("cap type does not match lic, adding to list to break");
  $self->addToReconcilesToBreak($reconcileId)   if defined $reconcileId;
  $self->addToDeleteQueue( $self->license->id ) if defined $licenseId;
  $self->validationCode(0);
  return 0;
 }

 return 1;
}

sub validateProcCount {
 my ( $self, $hProcessorCount, $licenseCapType, $reconcileId, $licenseId, $rtIsManual, $allocMethodology ) = @_;

 ## for license type 17 (PVU), validate proc count > 0
 
 my $allocMethodologyMap = Recon::Delegate::ReconDelegate::getAllocationMethodologyMap();

 if ( (( $licenseCapType eq '17' ) && ( $rtIsManual == 0 )) ||
	 (( $allocMethodology eq $allocMethodologyMap->{'Per PVU'} ) && ( $rtIsManual == 1 )) ) {
  if (( defined $hProcessorCount )
   && ( ( $hProcessorCount == 0 ) || ( $hProcessorCount < 0 ) ) )
  {
   dlog("license ID $licenseId, lic type PVU, hProcessorCount == 0");
   $self->addToReconcilesToBreak($reconcileId)   if defined $reconcileId;
   $self->addToDeleteQueue( $self->license->id ) if defined $licenseId;
   $self->validationCode(0);
   return 0;
  }
 }

 return 1;
}

sub validateEnvironmentMatch {
 my ( $self, $licEnvironment, $serverType, $isManual, $reconcileId ) = @_;
 ### Validate if HW server type is the same as the license environment

#	$serverType = 'PRODUCTION' if ((!defined $serverType) || ($serverType eq ""));
#	$licEnvironment = 'PRODUCTION' if ((!defined $licEnvironment ) || ( $licEnvironment eq "" ));

 if ( $licEnvironment eq 'DEVELOPMENT' ) {
  if ( $isManual == 0 ) {

   #			dlog("License environment DEVELOPMENT or different from server type!");
   dlog("License environment DEVELOPMENT used for auto-recon!");
   $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
   $self->validationCode(0);
   return 0;
  }
  dlog("License envir. DEVELOPMENT, but recon is manual.");
 }

 return 1;
}

sub validatePhysicalCpuSerialMatch {
 my ( $self, $licenseCapType, $licenseType, $hardwareSerial, $licenseSerial,
  $reconcileId, $licenseId, $isManual )
   = @_;
 ###Validate hw serial if phy cpu license. 34 - Physical CPU, 5 - MIPS, 9 - MSU
 if (
  $licenseCapType eq '34'
  || (
   (
    $licenseCapType eq '5' || $licenseCapType eq '9' || $licenseCapType eq '70'
   )
   && $licenseType eq 'NAMED CPU'
  )
   )
 {
  if ( $isManual == 0 ) {
   if ( !defined $licenseSerial
    || ( $hardwareSerial ne $licenseSerial ) )
   {
    dlog("cpu serial does not match lic, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId)
      if defined $reconcileId;
    $self->addToDeleteQueue($licenseId) if defined $licenseId;
    $self->validationCode(0);
    return 0;
   }
  }
 }

 if ( $licenseCapType eq '2' ) {
  if ( $isManual == 0 ) {
   if (defined $licenseSerial
    && ( $hardwareSerial ne $licenseSerial )
    && ( $licenseType eq 'NAMED CPU' ) )
   {
    dlog("cpu serial does not match lic, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId)
      if defined $reconcileId;
    $self->addToDeleteQueue($licenseId) if defined $licenseId;
    $self->validationCode(0);
    return 0;
   }
  }
 }

 return 1;
}

sub validateLparNameMatch {
 my (
  $self,        $licenseCapType, $licenseType,
  $lparName,    $slName,         $hlName,
  $reconcileId, $licenseId,      $isManual
   )
   = @_;
 if ( ( $licenseCapType == 5 || $licenseCapType == 9 || $licenseCapType == 70 )
  && $licenseType eq 'NAMED LPAR' )
 {
  if ( $isManual == 0 ) {
   if ( !defined $lparName
    || ( $lparName ne $slName && $lparName ne $hlName ) )
   {
    dlog("lpar name does not match lic, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId)
      if defined $reconcileId;
    $self->addToDeleteQueue($licenseId) if defined $licenseId;
    $self->validationCode(0);
    return 0;
   }
  }
 }

 return 1;
}

sub validateMachineTypeMatch {
 my ( $self, $licenseCapType, $isManual, $mtType, $reconcileId, $licenseId ) =
   @_;
 if ( ( $licenseCapType == 14 ) && ( $mtType ne 'WORKSTATION' ) ) {
  if ( $isManual == 0 ) {
   dlog("license captype 14 used on non-workstation, adding to list to break");
   $self->addToReconcilesToBreak($reconcileId)
     if defined $reconcileId;
   $self->addToDeleteQueue($licenseId) if defined $licenseId;
   $self->validationCode(0);
   return 0;
  }
 }

 if (
  (
      ( $licenseCapType == 5 )
   || ( $licenseCapType == 9 )
   || ( $licenseCapType == 70 )
  )
  && ( $mtType ne 'MAINFRAME' )
   )
 {
  if ( $isManual == 0 ) {
   dlog(
    "license captype 5,9,70 used on non-mainframe, adding to list to break");
   $self->addToReconcilesToBreak($reconcileId)
     if defined $reconcileId;
   $self->addToDeleteQueue($licenseId) if defined $licenseId;
   $self->validationCode(0);
   return 0;
  }
 }

 return 1;
}

sub validateLicenseSoftwareMap {
 my ( $self, $swMapSoftwareId, $isManual, $isSoftwareId, $reconcileId,
  $licenseId, $isId )
   = @_;
  dlog('begin validateLicenseSoftwareMap');
  dlog('$swMapSoftwareId='.$swMapSoftwareId.' $isManual='.$isManual.
  ' $isSoftwareId='.$isSoftwareId.' $swMapSoftwareId='.$swMapSoftwareId);
 
 ###Validate software id if mapped and recon was auto.
 if (defined $swMapSoftwareId
  && $isManual == 0
  && $isSoftwareId != $swMapSoftwareId )
 {

  my $scarletReconcile = new Recon::ScarletReconcile();
  
  if ( not ($scarletReconcile->contains($reconcileId)) )    
  {
   dlog("software not match and not in scarlet reconcile, add to break");
   dlog("isSoftwareId=$isSoftwareId");
   dlog("swMapSoftwareId=$swMapSoftwareId");
  
   $self->addToReconcilesToBreak($reconcileId)
     if defined $reconcileId;
   $self->addToDeleteQueue($licenseId) if defined $licenseId;
   $self->validationCode(0);
   $self->scarletAllocation('NO');
   return 0;
  }
  else {
   dlog("software not match but in scarlet reconcile");
   $self->scarletAllocation('YES');
  }
 }elsif(defined $swMapSoftwareId
  && $isManual == 0
  && $isSoftwareId == $swMapSoftwareId ){
   $self->scarletAllocation('NO');
  }

 return 1;
}

sub validateMaintenanceExpiration {
 my (
  $self,      $machineType, $capType, $isManual,
  $expireAge, $reconcileId, $licenseId
   )
   = @_;

 ###Validate expire date based on mt type if recon was auto.
 if (( $machineType ne 'WORKSTATION' )
  && ( $capType ne '9' )
  && ( $capType ne '49' ) )
 {
  if ( $isManual == 0 ) {
   if ( !defined $expireAge || $expireAge < 0 ) {
    dlog("license is expired, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId)
      if defined $reconcileId;
    $self->addToDeleteQueue($licenseId) if defined $licenseId;
    $self->validationCode(0);
    return 0;
   }
  }
 }

 return 1;
}

sub validateTryAndBuy {
 my ( $self, $tryAndBuy, $capType, $reconcileId, $isManual ) = @_;

 ###Validate try and buy
 if ( $tryAndBuy == 1 ) {
  if ( $capType == 5 || $capType == 9 || $capType == 70 ) {
   dlog("License is try and buy, capType is 5 or 9 or 70");
   return 1;
  }
  if ( defined $reconcileId ) {
   if ( $isManual == 0 ) {
    dlog("License is try and buy, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId);
    return 0;
   }
  }

  dlog("tryandbuy is 1");
  $self->validationCode(0);
 }

 return 1;

}

sub validateSubCapacity {
 my ( $self, $licenseType, $reconcileId, $isManual ) = @_;

 ###Validate subcapacity
 if ( $licenseType eq 'SC' ) {
  if ( defined $reconcileId ) {
   if ( $isManual == 0 ) {
    dlog("License is subcapacity, adding to list to break");
    $self->addToReconcilesToBreak($reconcileId);
    $self->validationCode(0);
    return 0;
   }
  }

  dlog("license is subcapacity");
  $self->validationCode(0);
 }

 return 1;
}

sub validateScheduleF {
 my ( $self, $ibmOwned, $swComplianceMgmt, $scopeName, $reconcileId, $isManual )
   = @_;

 if ( defined $scopeName ) {
  ###Schedule f defined
  if ( $scopeName eq 'IBMOIBMM'
    )   # This must be IBM owned license, regardless whether manual or automatic
  {
   if ( $ibmOwned == 0 ) {

    # This license is not IBM owned
    $self->addToReconcilesToBreak($reconcileId)
      if defined($reconcileId);
    $self->validationCode(0);
    return 0;
   }
   return 1;
  }

  if ( ( $scopeName eq 'IBMO3RDM' ) || ( $scopeName eq 'IBMOIBMMSWCO' ) )
  { # these two scopes should never exist for automatic allocation and only IBM-owned licenses for manual
   if ( ( $isManual == 0 ) || ( $ibmOwned == 0 ) ) {

    # This license is not IBM owned
    $self->addToReconcilesToBreak($reconcileId)
      if defined($reconcileId);
    $self->validationCode(0);
    return 0;
   }
   return 1;
  }
  if ( $scopeName eq 'CUSTOCUSTM' )
  { # these reconciles for licenses should be broken for automatic alloc. or for manual when lic. is IBM owned
   if ( ( $isManual == 0 ) || ( $ibmOwned == 1 ) ) {
    $self->addToReconcilesToBreak($reconcileId)
      if defined($reconcileId);
    $self->validationCode(0);
    return 0;
   }
   return 1;
  }
  if ( $scopeName eq 'CUSTOIBMM' ) {
   if ( $ibmOwned == 1 )
   {    # these recociles should be broken if license is IBM owned
    $self->addToReconcilesToBreak($reconcileId)
      if defined($reconcileId);
    $self->validationCode(0);
    return 0;
   }
   return 1;
  }
  if ( $scopeName eq 'CUSTO3RDM' || $scopeName eq 'CUSTOIBMMSWCO' )
  {     # these license reconciles depend on various flags
   if (( defined $swComplianceMgmt )
    && ( $swComplianceMgmt eq 'NO' ) )
   {
    if ( $ibmOwned == 1 ) {

     # This license is IBM owned
     $self->addToReconcilesToBreak($reconcileId)
       if defined($reconcileId);
     $self->validationCode(0);
     return 0;
    }
   }
   if (( defined $swComplianceMgmt )
    && ( $swComplianceMgmt eq 'YES' ) )
   {
    $self->addToReconcilesToBreak($reconcileId)
      if defined($reconcileId);
    $self->validationCode(0);
    return 0;
   }
   return 1;
  }
 }

 dlog(
  "ScopeName not defined or not recognized, the license reconcile is invalid!"
 );

 $self->addToReconcilesToBreak($reconcileId) if defined($reconcileId);
 $self->validationCode(0);

 return 0;
}

sub isLicenseSoftwareMapValidToReconcile {
 my $self = shift;

 if ( !defined $self->licSwMap->id ) {
  dlog("license software map does not exist");
  $self->validationCode(0);
 }
 else {
  ###Get software object.
  my $software = new BRAVO::OM::Software();
  $software->id( $self->licSwMap->softwareId );
  $software->getById( $self->connection );
  dlog( "software=" . $software->toString() );

  if ( $software->status ne 'ACTIVE' ) {
   dlog("software is not active");
   $self->validationCode(0);
  }
  elsif ( $software->level ne 'LICENSABLE' ) {
   dlog("software is not licensable");
   $self->validationCode(0);
  }
 }
}

sub validateMipsGartnerMsu {
 my (
  $self,            $isManual,       $capType,     $licType,
  $machineType,     $isMachineLevel, $reconcileId, $hCpuMIPS,
  $hCpuGartnerMIPS, $hCpuMSU,        $hlPartMIPS,  $hlPartGartnerMIPS,
  $hlPartMSU
   )
   = @_;

 my $isValid = 1;

 return 1
   if (
  ( $isManual == 1 )
  || (( $capType ne '5' )
   && ( $capType ne '9' )
   && ( $capType ne '70' ) )
   );

 dlog("Validating Gartner/MIPS/MSU");

 $isValid = 0 if ( $machineType ne 'MAINFRAME' );

 $isValid = 0
   if ( ( $capType eq '5' )
  && ( $isMachineLevel == 1 )
  && ( !defined $hCpuMIPS ) );
 $isValid = 0
   if ( ( $capType eq '5' )
  && ( $isMachineLevel == 1 )
  && ( defined $hCpuMIPS )
  && ( $hCpuMIPS <= 0 ) );

 $isValid = 0
   if ( ( $capType eq '70' )
  && ( $isMachineLevel == 1 )
  && ( !defined $hCpuGartnerMIPS ) );
 $isValid = 0
   if ( ( $capType eq '70' )
  && ( $isMachineLevel == 1 )
  && ( defined $hCpuGartnerMIPS )
  && ( $hCpuGartnerMIPS <= 0 ) );

 $isValid = 0
   if ( ( $capType eq '9' )
  && ( $isMachineLevel == 1 )
  && ( !defined $hCpuMSU ) );
 $isValid = 0
   if ( ( $capType eq '9' )
  && ( $isMachineLevel == 1 )
  && ( defined $hCpuMSU )
  && ( $hCpuMSU <= 0 ) );

 $isValid = 0
   if ( ( $capType eq '5' )
  && ( $isMachineLevel == 0 )
  && ( !defined $hlPartMIPS ) );
 $isValid = 0
   if ( ( $capType eq '5' )
  && ( $isMachineLevel == 0 )
  && ( defined $hlPartMIPS )
  && ( $hlPartMIPS <= 0 ) );

 $isValid = 0
   if ( ( $capType eq '70' )
  && ( $isMachineLevel == 0 )
  && ( !defined $hlPartGartnerMIPS ) );
 $isValid = 0
   if ( ( $capType eq '70' )
  && ( $isMachineLevel == 0 )
  && ( defined $hlPartGartnerMIPS )
  && ( $hlPartGartnerMIPS <= 0 ) );

 $isValid = 0
   if ( ( $capType eq '9' )
  && ( $isMachineLevel == 0 )
  && ( !defined $hlPartMSU ) );
 $isValid = 0
   if ( ( $capType eq '9' )
  && ( $isMachineLevel == 0 )
  && ( defined $hlPartMSU )
  && ( $hlPartMSU <= 0 ) );

 $isValid = 0
   if ( ( $licType ne 'NAMED LPAR' ) && ( $isMachineLevel == 0 ) );

 if ( $isValid == 0 ) {
  dlog("Reconcile not validated, Gartner/MIPS/MSU");

  $self->validationCode(0);
  $self->addToReconcilesToBreak($reconcileId) if defined($reconcileId);
 }

 return $isValid;
}

sub validateProcessorChip {
 my ( $self, $isManual, $capType, $machineType, $isMachineLevel, $reconcileId )
   = @_;

 if ( $isManual == 0 ) {
  if ( $capType eq '48' ) {
   if ( $machineType eq 'WORKSTATION' ) {
    $self->validationCode(0);
    $self->addToReconcilesToBreak($reconcileId);
    return 0;
   }
   elsif ( $isMachineLevel == 0 ) {
    $self->validationCode(0);
    $self->addToReconcilesToBreak($reconcileId);
    return 0;
   }
  }
 }

 return 1;
}
1;
