package Recon::Delegate::ReconLicenseValidation;

use strict;
use Base::Utils;
use Recon::Pvu;

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
        _deleteQueue           => undef
    };
    bless $self, $class;
    return $self;
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

    $self->validateCustomer( $self->customer->status, $self->customer->swLicenseMgmt, undef );
    $self->isLicInFinRespScope( $self->customer->swFinancialResponsibility, $self->license->ibmOwned, undef );
    $self->validateLicense( $self->license->status, undef );
    $self->validateTryAndBuy( $self->license->tryAndBuy, $self->license->capType, undef, undef );
    $self->validateSubCapacity( $self->license->licType, undef, undef );

    foreach my $rId ( keys %{ $self->licenseAllocationData } ) {
        my $licenseAllocationView = $self->licenseAllocationData->{$rId};
        dlog( $licenseAllocationView->rId );

        $self->validateCustomer( $self->customer->status, $self->customer->swLicenseMgmt, $licenseAllocationView->rId );
        $self->isLicInFinRespScope( $self->customer->swFinancialResponsibility, $self->license->ibmOwned, $licenseAllocationView->rId );
        $self->validateLicense( $self->license->status, $licenseAllocationView->rId );
        $self->validateTryAndBuy( $self->license->tryAndBuy, $licenseAllocationView->lrmCapType, $licenseAllocationView->rId, $licenseAllocationView->rtIsManual );
        $self->validateSubCapacity( $self->license->licType, $licenseAllocationView->rId, $licenseAllocationView->rtIsManual );
        $self->validateLicenseAllocationCustomer($licenseAllocationView);
        $self->validateCapacityType( $licenseAllocationView->lrmCapType, $self->license->capType, $licenseAllocationView->rId, $self->license->id );
        $self->validatePhysicalCpuSerialMatch(
            $self->license->capType,  $self->license->licType,   $licenseAllocationView->hSerial, $self->license->cpuSerial,
            $licenseAllocationView->rId, $self->license->id,              $licenseAllocationView->rtIsManual
        );
        
        $self->validateLparNameMatch( $self->license->capType, $self->license->licType, $self->license->lparName, $licenseAllocationView->slName, $licenseAllocationView->hlName, $licenseAllocationView->rId, $licenseAllocationView->rtIsManual );
        
        $self->validateLicenseSoftwareMap(
            $self->licSwMap->softwareId,          $licenseAllocationView->rtIsManual,
            $licenseAllocationView->isSoftwareId, $licenseAllocationView->rId,
            $self->license->id
        );
        $self->validateMaintenanceExpiration(
            $licenseAllocationView->mtType, $licenseAllocationView->rtIsManual, $licenseAllocationView->expireAge,
            $licenseAllocationView->rId,    $self->license->id
        );
        $self->validateScheduleF(
            $self->license->ibmOwned,    $licenseAllocationView->slComplianceMgmt, $licenseAllocationView->scopeName,
            $licenseAllocationView->rId, $licenseAllocationView->rtIsManual
        );
        $self->validateProcessorChip(
            $licenseAllocationView->rtIsManual,   $self->license->capType, $licenseAllocationView->mtType,
            $licenseAllocationView->machineLevel, $licenseAllocationView->rId
        );

		if(exists $machineLevel{$licenseAllocationView->lrmId}) {
			next;
		}
		else {
			$machineLevel{$licenseAllocationView->lrmId}++;
		}

        $tempUsedCapacity = $tempUsedCapacity + $licenseAllocationView->lrmUsedQuantity;
        dlog("temp capacity: " . $tempUsedCapacity);

        if ( $tempUsedCapacity > $self->license->quantity ) {
            $self->addToReconcilesToBreak( $licenseAllocationView->rId );
            $tempUsedCapacity = $tempUsedCapacity - $licenseAllocationView->lrmUsedQuantity;
            delete $machineLevel{$licenseAllocationView->lrmId};
        }
    }

    $self->freeCapacity( $self->license->quantity - $tempUsedCapacity );
    if (   $self->license->capType eq '17'
        && $self->freeCapacity < $self->minimumPvuValue )
    {
        ###There could be machine level opportunities here
        $self->freeCapacity(0);
        $self->machineLevelOnly(1);
    }
    elsif ( $self->freeCapacity <= 0 && 
            ($self->license->capType eq '34'
            ||$self->license->capType eq '2'
            ||$self->license->capType eq '48'
            ||$self->license->capType eq '5'
            ||$self->license->capType eq '9'
            )) {
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
    }
    ###Check if in scope for license management
    elsif ( $customerSwLicMgmt ne 'YES' ) {
        dlog("not in scope for swlm, marking as invalid");
        $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
        $self->validationCode(0);
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

    if ( $licenseStatus ne 'ACTIVE' ) {
        dlog("license is not active, adding to list to break");
        $self->addToReconcilesToBreak($reconcileId) if defined $reconcileId;
        $self->validationCode(0);
    }
    return 1;
}

sub validateLicenseAllocationCustomer {
    my ( $self, $licenseAllocationView ) = @_;

    ###If license is poolable, then check the children
    if ( $self->license->pool == 1 ) {
        dlog("License is poolable");

        foreach my $priority ( keys %{ $self->accountPoolChildren } ) {
            if ( exists $self->accountPoolChildren->{$priority}->{ $licenseAllocationView->slCustomerId } ) {
                return 1;
            }
        }
    }
    elsif ( $self->license->customerId == $licenseAllocationView->slCustomerId ) {
        return 1;
    }

    ###Validate customerId change
    dlog("customer id does not match lic, adding to list to break");
    $self->addToReconcilesToBreak( $licenseAllocationView->rId );
    $self->addToDeleteQueue( $self->license->id );
    $self->validationCode(0);

    return 1;
}

sub validateCapacityType {
    my ( $self, $lrmCapType, $licenseCapType, $reconcileId, $licenseId ) = @_;

    ###Validate capType change
    if ( $lrmCapType != $licenseCapType ) {
        dlog("cap type does not match lic, adding to list to break");
        $self->addToReconcilesToBreak($reconcileId)   if defined $reconcileId;
        $self->addToDeleteQueue( $self->license->id ) if defined $licenseId;
        $self->validationCode(0);
    }

    return 1;
}

sub validatePhysicalCpuSerialMatch {
    my ( $self, $licenseCapType, $licenseType, $hardwareSerial, $licenseSerial, $reconcileId, $licenseId, $isManual ) = @_;
    ###Validate hw serial if phy cpu license. 34 - Physical CPU, 5 - MIPS, 9 - MSU
    if ( $licenseCapType eq '34' || (($licenseCapType eq '5' || $licenseCapType eq '9') && $licenseType eq 'NAMED CPU')) {
        if ( $isManual == 0 ) {
            if ( !defined $licenseSerial ||($hardwareSerial ne $licenseSerial) ) {
                dlog("cpu serial does not match lic, adding to list to break");
                $self->addToReconcilesToBreak($reconcileId)
                  if defined $reconcileId;
                $self->addToDeleteQueue($licenseId) if defined $licenseId;
                $self->validationCode(0);
            }
        }
    }

    return 1;
}

sub validateLparNameMatch{
	my ( $self, $licenseCapType, $licenseType, $lparName, $slName, $hlName, $reconcileId, $licenseId, $isManual ) = @_;
	if( ($licenseCapType == 5 || $licenseCapType == 9) && $licenseType eq 'NAMED LPAR')
	{
        if ( $isManual == 0 ) {
            if ( !defined $lparName ||($lparName ne $slName && $lparName ne $hlName)) {
                dlog("lpar name does not match lic, adding to list to break");
                $self->addToReconcilesToBreak($reconcileId)
                  if defined $reconcileId;
                $self->addToDeleteQueue($licenseId) if defined $licenseId;
                $self->validationCode(0);
            }
        }
    }

    return 1;
}

sub validateLicenseSoftwareMap {
    my ( $self, $swMapSoftwareId, $isManual, $isSoftwareId, $reconcileId, $licenseId ) = @_;

    ###Validate software id if mapped and recon was auto.
    if ( defined $swMapSoftwareId ) {
        if ( $isManual == 0 ) {
            if ( $isSoftwareId != $swMapSoftwareId ) {
                dlog("isSoftwareId=$isSoftwareId");
                dlog("swMapSoftwareId=$swMapSoftwareId");
                dlog("software id does not match, adding to list to break");
                $self->addToReconcilesToBreak($reconcileId)
                  if defined $reconcileId;
                $self->addToDeleteQueue($licenseId) if defined $licenseId;
                $self->validationCode(0);
            }
        }
    }

    return 1;
}

sub validateMaintenanceExpiration {
    my ( $self, $machineType, $isManual, $expireAge, $reconcileId, $licenseId ) = @_;

    ###Validate expire date based on mt type if recon was auto.
    if ( $machineType ne 'WORKSTATION' ) {
        if ( $isManual == 0 ) {
            if (!defined $expireAge || $expireAge < 0 ) {
                dlog("license is expired, adding to list to break");
                $self->addToReconcilesToBreak($reconcileId)
                  if defined $reconcileId;
                $self->addToDeleteQueue($licenseId) if defined $licenseId;
                $self->validationCode(0);
            }
        }
    }

    return 1;
}

sub validateTryAndBuy {
    my ( $self, $tryAndBuy, $capType, $reconcileId, $isManual ) = @_;

    ###Validate try and buy
    if ( $tryAndBuy == 1 ) {
    	if($capType == 5 || $capType == 9){    
             dlog("License is try and buy, capType is 5 or 9");
             return 1;    		
    	}
        if ( defined $reconcileId ) {
            if ( $isManual == 0 ) {
                dlog("License is try and buy, adding to list to break");
                $self->addToReconcilesToBreak($reconcileId);
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
            }
        }

        dlog("license is subcapacity");
        $self->validationCode(0);
    }

    return 1;
}

sub validateScheduleF {
    my ( $self, $ibmOwned, $swComplianceMgmt, $scopeName, $reconcileId, $isManual ) = @_;

    if ( $isManual == 0 ) {
        ###Automatic reconciliation
        if ( defined $scopeName ) {
            ###Schedule f defined
            if ( $scopeName eq 'CUSTOCUSTM' || $scopeName eq 'IBMO3RDM' || $scopeName eq 'IBMOIBMMSWCO' )
				{ # these license reconciles for licenses should be broken everytime
					 $self->addToReconcilesToBreak($reconcileId);
                     $self->validationCode(0);
				 }
			if ( $scopeName eq 'CUSTOIBMM' || $scopeName eq 'CUSTO3RDM' || $scopeName eq 'CUSTOIBMMSWCO' )
				{ # these license reconciles depend on various flags
					if (( defined $swComplianceMgmt ) && ( $swComplianceMgmt eq 'NO' ))
						{
							if ( $ibmOwned == 1 ) {
								# This license is IBM owned
								$self->addToReconcilesToBreak($reconcileId);
								$self->validationCode(0);
							}
						}
					if (( defined $swComplianceMgmt ) && ( $swComplianceMgmt eq 'YES' ))
						{
							$self->addToReconcilesToBreak($reconcileId);
							$self->validationCode(0);
						}
				}
        }
    }

    return 1;
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

sub validateProcessorChip {
    my ( $self, $isManual, $capType, $machineType, $isMachineLevel, $reconcileId ) = @_;

    if ( $isManual == 0 ) {
        if ( $capType eq '48' ) {
            if ( $machineType eq 'WORKSTATION' ) {
                $self->validationCode(0);
                $self->addToReconcilesToBreak($reconcileId);
            }
            elsif ( $isMachineLevel == 0 ) {
                $self->validationCode(0);
                $self->addToReconcilesToBreak($reconcileId);
            }
        }
    }
}
1;
