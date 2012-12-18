package Recon::Delegate::ReconInstalledSoftwareValidation;

use strict;
use Base::Utils;
use Recon::Delegate::ReconLicenseValidation;

sub new {
 my ($class) = @_;
 my $self = {
  _customer                   => undef,
  _installedSoftware          => undef,
  _installedSoftwareReconData => undef,
  _connection                 => undef,
  _discrepancyTypeMap         => undef,
  _reconcileTypeMap           => undef,
  _isValid                    => undef,
  _validationCode             => undef,
  _reconcilesToBreak          => undef,
  _deleteQueue                => undef,
  _poolParentCustomers        => undef,
  _valueUnitsPerCore          => undef
 };
 bless $self, $class;
 return $self;
}

sub customer {
 my $self = shift;
 $self->{_customer} = shift if scalar @_ == 1;
 return $self->{_customer};
}

sub poolParentCustomers {
 my $self = shift;
 $self->{_poolParentCustomers} = shift if scalar @_ == 1;
 return $self->{_poolParentCustomers};
}

sub installedSoftware {
 my $self = shift;
 $self->{_installedSoftware} = shift if scalar @_ == 1;
 return $self->{_installedSoftware};
}

sub installedSoftwareReconData {
 my $self = shift;
 $self->{_installedSoftwareReconData} = shift if scalar @_ == 1;
 return $self->{_installedSoftwareReconData};
}

sub validationCode {
 my $self = shift;
 $self->{_validationCode} = shift if scalar @_ == 1;
 return $self->{_validationCode};
}

sub isValid {
 my $self = shift;
 $self->{_isValid} = shift if scalar @_ == 1;
 return $self->{_isValid};
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub discrepancyTypeMap {
 my $self = shift;
 $self->{_discrepancyTypeMap} = shift if scalar @_ == 1;
 return $self->{_discrepancyTypeMap};
}

sub reconcileTypeMap {
 my $self = shift;
 $self->{_reconcileTypeMap} = shift if scalar @_ == 1;
 return $self->{_reconcileTypeMap};
}

sub reconcilesToBreak {
 my $self = shift;
 $self->{_reconcilesToBreak} = shift if scalar @_ == 1;
 return $self->{_reconcilesToBreak};
}

sub addToReconcilesToBreak {
 my ( $self, $reconcileId ) = shift;

 my $reconcilesToBreak = $self->reconcilesToBreak;
 $reconcilesToBreak->{$reconcileId}++;
 $self->reconcilesToBreak($reconcilesToBreak);
 return;
}

sub deleteQueue {
 my $self = shift;
 $self->{_deleteQueue} = shift if scalar @_ == 1;
 return $self->{_deleteQueue};
}

sub addToDeleteQueue {
 my ( $self, $licenseId ) = shift;

 my $deleteQueue = $self->deleteQueue;
 $deleteQueue->{$licenseId}++;
 $self->deleteQueue($deleteQueue);
 return;
}

sub valueUnitsPerCore {
 my $self = shift;
 $self->{_valueUnitsPerCore} = shift if scalar @_ == 1;
 if ( !defined $self->{_valueUnitsPerCore} ) {
  $self->{_valueUnitsPerCore} = 100;
 }
 return $self->{_valueUnitsPerCore};
}

sub validate {
 my $self = shift;

	if (   $self->validateCustomer == 0
		|| $self->validateInstalledSoftware == 0
		|| $self->validateSoftwareLpar == 0
		|| $self->validateComposite == 0
		|| $self->validateHardwareLpar == 0
		|| $self->validateHardware == 0
		|| $self->validateSoftware == 0 )
	{
		$self->validationCode(0);
	}
	elsif ( $self->isInstalledSoftwareReconciled == 0 ) {
		$self->validationCode(1);
	}
	elsif ($self->validateVendorManaged == 0
		|| $self->validateSoftwareCategory == 0
		|| $self->validateBundle == 0
		|| $self->validateCustomerOwnedAndManaged == 0
		|| $self->validateCustomerPendingDecision == 0
		|| $self->validateLicenseAllocation == 0 )
	{
		$self->validationCode(2);
	}

	if ( defined $self->validationCode ) {
		$self->isValid(0);
	}
	else {
		$self->isValid(1);
	}
}

sub validateCustomer {
 my $self = shift;

 ###Check status
 if ( $self->customer->status eq 'INACTIVE' ) {
  dlog("Customer is inactive");
  return 0;
 }
 ###Check if in scope for license management
 elsif ( $self->customer->swLicenseMgmt ne 'YES' ) {
  dlog("not in scope for swlm, marking as invalid");
  return 0;
 }

 return 1;
}

sub validateInstalledSoftware {
 my $self = shift;
 dlog("begin isValidInstalledSoftware");

 ###Check status.
 if ( $self->installedSoftware->status ne 'ACTIVE' ) {
  dlog("inactive, not in recon base");
  return 0;
 }
 ###Check discrepancy type.
 elsif ( $self->installedSoftware->discrepancyTypeId ==
     $self->discrepancyTypeMap->{'FALSE HIT'}
  || $self->installedSoftware->discrepancyTypeId ==
  $self->discrepancyTypeMap->{'INVALID'} || $self->installedSoftware->discrepancyTypeId ==
  $self->discrepancyTypeMap->{'TADZ'} )
 {
  dlog("discrepancy type not valid for recon base");
  return 0;
 }

 return 1;
}

sub validateSoftwareLpar {
 my $self = shift;

 ###Check status.
 if ( $self->installedSoftwareReconData->slStatus ne 'ACTIVE' ) {
  dlog("sw lpar not active, not in recon base");
  return 0;
 }

 return 1;
}

sub validateComposite {
 my $self = shift;

 ###Check sw lpar is in composite.
 if ( !defined $self->installedSoftwareReconData->hlStatus ) {
  dlog("sw lpar not in composite, not in recon base");
  return 0;
 }

 return 1;
}

sub validateHardwareLpar {
 my $self = shift;

 ###Check hw lpar status.
 if ( $self->installedSoftwareReconData->hlStatus ne 'ACTIVE' ) {
  dlog("hw lpar not active, not in recon base");
  return 0;
 }

 return 1;
}

sub validateHardware {
 my $self = shift;
 ###Check hw status.
 if ( $self->installedSoftwareReconData->hStatus ne 'ACTIVE' ) {
  dlog("hw not active, not in recon base");
  return 0;
 }
 ###Check hw hardware status.
 elsif ( $self->installedSoftwareReconData->hHwStatus ne 'ACTIVE' ) {
  dlog("hw hardware status not active, not in recon base");
  return 0;
 }

 return 1;
}

sub validateSoftware {
 my $self = shift;

 ###Check software status.
 if ( $self->installedSoftwareReconData->sStatus ne 'ACTIVE' ) {
  dlog("software not active, not in recon base");
  return 0;
 }

 ###Check software level.
 if ( $self->installedSoftwareReconData->sLevel ne 'LICENSABLE' ) {
  dlog("software level not licensable, not in recon base");
  return 0;
 }

 return 1;
}

sub isInstalledSoftwareReconciled {
 my $self = shift;

 if ( !defined $self->installedSoftwareReconData->rId ) {
  dlog("No reconcile, so valid");
  return 0;
 }

 return 1;
}

sub validateVendorManaged {
 my $self = shift;

 if ( $self->installedSoftwareReconData->rTypeId ==
  $self->reconcileTypeMap->{'Vendor managed product'} )
 {
  dlog("reconciled as vendor managed");

  ###Validate software id is still vendor managed.
  if ( $self->installedSoftwareReconData->sVendorMgd == 1 ) {
   dlog("reconcile validated");
   return 1;
  }
  else {
   dlog("software id not vendor managed, invalid reconcile");
   return 0;
  }
 }

 return 1;
}

sub validateSoftwareCategory {
 my $self = shift;

 if ( $self->installedSoftwareReconData->rTypeId ==
  $self->reconcileTypeMap->{'Covered by software category'} )
 {
  dlog("reconciled as software category");

  ###Validate still have category parent.
  if ( defined $self->installedSoftwareReconData->scParent ) {
   if ( $self->installedSoftwareReconData->rParentInstSwId ==
    $self->installedSoftwareReconData->scParent )
   {
    dlog("reconcile validated");
    return 1;
   }
   else {
    dlog("reconcile parent different, invalid reconcile");
    return 0;
   }
  }
  else {
   dlog("reconcile parent missing, invalid reconcile");
   return 0;
  }
 }

 return 1;
}

sub validateBundle {
 my $self = shift;

 if ( $self->installedSoftwareReconData->rTypeId ==
  $self->reconcileTypeMap->{'Bundled software product'} )
 {
  dlog("reconciled as software bundle");

  ###Validate still have bundle parent.
  if ( defined $self->installedSoftwareReconData->bParent ) {
   if ( $self->installedSoftwareReconData->rParentInstSwId ==
    $self->installedSoftwareReconData->bParent )
   {
    dlog("reconcile validated");
    return 1;
   }
   else {
    dlog("reconcile parent different, invalid reconcile");
    return 0;
   }
  }
  else {
   dlog("reconcile parent missing, invalid reconcile");
   return 0;
  }
 }

 return 1;
}

sub validateCustomerPendingDecision {
	my $self = shift;
	if ( $self->installedSoftwareReconData->rTypeId ==
		$self->reconcileTypeMap->{'Pending customer decision'} )
	{
		dlog('reconciled as pending customer decision');
		if ( defined $self->customer->swComplianceMgmt
			&& $self->customer->swComplianceMgmt eq 'YES' )
		{
			if (   $self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM'
				|| $self->installedSoftwareReconData->scopeName eq
				'CUSTOIBMM' )
			{
				dlog("reconcile validated");
				return 1;
			}

		}
		dlog("reconciled as pending customer decision but does not pass validation");
		return 0;
	}
	return 1;
}

sub validateCustomerOwnedAndManaged {
 my $self = shift;
 dlog("begin validateCustomerOwnedAndManaged");
 dlog("reconcile type id".$self->installedSoftwareReconData->rTypeId);
 dlog("reconcile map id".$self->reconcileTypeMap->{'Customer owned and customer managed'});
 if ( $self->installedSoftwareReconData->rTypeId ==
  $self->reconcileTypeMap->{'Customer owned and customer managed'} )
 {
  dlog("reconciled as customer owned and customer managed");
  if ( defined $self->customer->swComplianceMgmt ) {
   if ( $self->customer->swComplianceMgmt eq 'NO' ) {
    if ( $self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM' ) {
     dlog("reconcile validated");
     return 1;
    }
   }
  }

  dlog("reconciled as custocustm but does not pass validation");
  return 0;
 }

 return 1;
}

sub validateScheduleF {
 my ( $self, $ibmOwned ) = @_;

 if ( defined $self->customer->swComplianceMgmt ) {
  if ( $self->customer->swComplianceMgmt eq 'YES' ) {
   if ($self->installedSoftwareReconData->scopeName eq 'CUSTOCUSTM'
    || $self->installedSoftwareReconData->scopeName eq 'CUSTOIBMM' )
   {
    if ( $ibmOwned == 1 ) {
     return 0;
    }
   }
  }
 }

 return 1;
}

sub validateLicenseAllocation {
 my $self = shift;

 if ( $self->installedSoftwareReconData->rTypeId ==
  $self->reconcileTypeMap->{'Automatic license allocation'} )
 {
  dlog("reconciled as auto license allocation");

  my $licCount     = 0;
  my $isValid      = 1;
  my $usedQuantity = 0;
  my $licCapType;
  my $machineLevel;
  my $validation = new Recon::Delegate::ReconLicenseValidation();
  $validation->validationCode(1);

  $self->connection->prepareSqlQueryAndFields(
   $self->queryValidateLicenseAllocation() );
  my $sth = $self->connection->sql->{validateLicenseAllocation};
  my %rec;
  $sth->bind_columns( map { \$rec{$_} }
     @{ $self->connection->sql->{validateLicenseAllocationFields} } );
  $sth->execute( $self->installedSoftware->id );

  while ( $sth->fetchrow_arrayref ) {
   logRec( 'dlog', \%rec );

   if ( $self->validateScheduleF( $rec{ibmOwned} ) == 0 ) {
    $validation->validationCode(0);
   }

   ###Add used quantity.
   $usedQuantity = $usedQuantity + $rec{lrmUsedQuantity};

   ###Validate license in scope
   $validation->isLicInFinRespScope( $self->customer->swFinancialResponsibility,
    $rec{ibmOwned}, undef );

   ###Validate license status
   $validation->validateLicense( $rec{licenseStatus}, undef );

   ###Validate capType change
   $validation->validateCapacityType( $rec{lrmCapType}, $rec{capType}, undef,
    undef );

   ###Validate cap_type 34, 5, 9 serial match
   $validation->validatePhysicalCpuSerialMatch( $rec{capType}, $rec{licenseType},
    $self->installedSoftwareReconData->hSerial,
    $rec{cpuSerial}, undef, undef, 0 );
    
   ###Validate cap_type 5, 9 lpar name match   
   $validation->validateLparNameMatch( $rec{capType}, $rec{licenseType}, $rec{lparName}, 
    $self->installedSoftwareReconData->slName, 
    $self->installedSoftwareReconData->hlName,
    undef, undef, 0 );

   ###Validate license software map
   $validation->validateLicenseSoftwareMap( $rec{sId}, 0,
    $self->installedSoftware->softwareId,
    undef, undef );

   ###Validate try and buy
   $validation->validateTryAndBuy( $rec{tryAndBuy}, $rec{capType}, undef, 0 );

   ###Validate subcapacity
   $validation->validateSubCapacity( $rec{licenseType}, undef, 0 );

   ###Validate expire date based on mt type if recon was auto.
   $validation->validateMaintenanceExpiration(
    $self->installedSoftwareReconData->mtType,
    0, $rec{expireAge}, undef, undef );

   $validation->validateProcessorChip(
    0, $rec{capType},
    $self->installedSoftwareReconData->mtType,
    $self->installedSoftwareReconData->rMachineLevel
   );

   #TODO check poolable
   if ( $rec{pool} == 1 ) {
    ###Validate customerId change
    if ($rec{cId} != $self->installedSoftwareReconData->cId
     && $self->isInParentPool( $rec{cId} ) != 1 )
    {
     dlog( "customer id does not match lic, adding to list to break" );
     $validation->validationCode(0);
    }
   }
   elsif ( $rec{cId} != $self->installedSoftwareReconData->cId ) {
    dlog( "customer id does not match lic, adding to list to break" );
    $validation->validationCode(0);
   }

   ###Validate quantity.
   if ( $rec{lrmUsedQuantity} > $rec{quantity} ) {
    dlog("lrm used quantity greater than license quantity");
    $validation->validationCode(0);
   }

   $licCount++;
   $licCapType = $rec{lrmCapType};
  }
  $sth->finish;

  ###Validate lic count.
  if ( $licCount == 0 ) {
   dlog("$licCount is 0");
   $validation->validationCode(0);
  }

  ###Go ahead and return if this is not valid
  if ( $validation->validationCode == 0 ) {
   dlog("validation code is 0");
   return 0;
  }

  ###If Number processors or PVU and machine level is 0 then if hardware processor count is greater than 0
  ###We can break the recon and allocate it at machine level
  if ( $licCapType eq '2' || $licCapType eq '17' ) {
   if ( $self->installedSoftwareReconData->rMachineLevel == 0 ) {
    if ( $self->installedSoftwareReconData->hProcCount > 0 ) {
     dlog("can allocate at the machine level");
     return 0;
    }
   }
  }

  ###Validate used quantity.
  ###Number of processors
  if ( $licCapType eq '2' ) {
   if ( $self->installedSoftwareReconData->processorCount != $usedQuantity ) {
    dlog("Processor count greater than used quantity");
    return 0;
   }
  }
  ###PVU
  elsif ( $licCapType eq '17' ) {
   if (
    (
     $self->installedSoftwareReconData->processorCount *
     $self->valueUnitsPerCore
    ) != $usedQuantity
     )
   {
    dlog("PVU needed greater than current used");
    return 0;
   }
  }
  elsif ( $licCapType eq '48' ) {
   if ( $self->installedSoftwareReconData->hChips != $usedQuantity ) {
    dlog("Chips needed greater than current used");
    return 0;
   }
  }
  elsif($licCapType eq '5' || $licCapType eq '9'){
  	if($self->installedSoftwareReconData->mtType ne 'MAINFRAME')
  	{
    	dlog("Machine Type needed MAINFRAME");
    	return 0;
  	}
    if ($licCapType eq '5') {
        if ( $self->installedSoftwareReconData->rMachineLevel == 0 ){		
            if($self->installedSoftwareReconData->hCpuMIPS > 0){             
                dlog("can allocate at the machine level");
                return 0;
            }
            elsif($self->installedSoftwareReconData->hlPartMIPS != $usedQuantity){
                dlog("Part MIPS not equal to used quantity");
                return 0;               
            }  
    	}	
    	elsif($self->installedSoftwareReconData->hCpuMIPS != $usedQuantity){
    		dlog("CPU MIPS not equal to used quantity");
            return 0;
    	}		
    }	
    else{  	##$licCapType eq '9'
    	 if ( $self->installedSoftwareReconData->rMachineLevel == 0 ){      
            if($self->installedSoftwareReconData->hCpuMSU > 0){             
                dlog("can allocate at the machine level");
                return 0;
            }
            elsif($self->installedSoftwareReconData->hlPartMSU != $usedQuantity){
                dlog("Part MSU not equal to used quantity");
                return 0;               
            }  
        }   
        elsif($self->installedSoftwareReconData->hCpuMSU != $usedQuantity){
            dlog("CPU MSU not equal to used quantity");
            return 0;
        }	
    }
    	
  }  	
 }
 return 1;
}

sub queryValidateLicenseAllocation {
 my @fields = qw(
   lrmUsedQuantity
   lrmCapType
   cId
   ibmOwned
   cpuSerial
   lparName
   expireAge
   quantity
   capType
   licenseType
   tryAndBuy
   expireDate
   pool
   ibmOwned
   licenseStatus
   sId
 );
 my $query = '
        select
            ul.used_quantity
            ,ct.code
            ,l.customer_id
            ,l.ibm_owned
            ,l.cpu_serial
            ,l.lpar_name
            ,days(l.expire_date) - days(CURRENT TIMESTAMP)
            ,l.quantity
            ,l.cap_type
            ,l.lic_type
            ,l.try_and_buy
            ,l.expire_date
            ,l.pool
            ,l.ibm_owned
            ,l.status
            ,lsm.software_id
        from
            reconcile r
            join reconcile_used_license rul on
              r.id =  rul.reconcile_id
            join used_license ul on
              ul.id = rul.used_license_id
            join capacity_type ct on
              ct.code = ul.capacity_type_id
            join license l on 
                l.id = ul.license_id
            join license_sw_map lsm on 
                lsm.license_id = l.id
        where
            r.installed_software_id = ?
    ';
 return ( 'validateLicenseAllocation', $query, \@fields );
}

sub isInParentPool {
 my ( $self, $customerId ) = @_;

 my $isInParentPool = 0;

 foreach my $parentId ( keys %{ $self->poolParentCustomers } ) {
  if ( $parentId == $customerId ) {
   $isInParentPool = 1;
  }
 }

 return $isInParentPool;
}
1;
