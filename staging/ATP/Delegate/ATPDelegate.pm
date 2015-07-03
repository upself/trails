package ATP::Delegate::ATPDelegate;

use strict;
use Base::Utils;
use Staging::OM::Hardware;
use Staging::OM::HardwareLpar;
use Staging::OM::HardwareLparEff;
use TRAILS::Delegate::MachineTypeDelegate;
use CNDB::Delegate::CNDBDelegate;

sub getServerType {
    my ( $self, $newServerType, $currentServerType ) = @_;

    return 'PRODUCTION'
        if ( !defined $newServerType || $newServerType eq '' );
    return 'PRODUCTION' if $newServerType ne 'DEVELOPMENT';
    return 'PRODUCTION'
        if defined $currentServerType && $currentServerType eq 'PRODUCTION';
    return 'DEVELOPMENT';
}

sub getData {
    my ( $self, $connection, $testMode, $delta, $hwDate, $lparDate ) = @_;

    dlog('In getData method of ATPDelegate');

    dlog('Acquiring customer number map');
    my ($customerNumberMap, $accountNumberMap) = CNDB::Delegate::CNDBDelegate->getCustomerNumberMap;
    dlog('Customer number map acquired');

    dlog('Acquiring machine type map');
    my $machineTypeMap = MachineTypeDelegate->getMachineTypeMap;
    dlog('Machine type map acquired');

    my %hardwareList;
    my %hardwareLparList;
    my %effProcList;

    $connection->dbh->{LongTruncOk} = 1;

    dlog('Preparing atp data query');
    if ( $delta == 1 ) {
        $connection->prepareSqlQueryAndFields( $self->queryATPDeltaData($testMode) );
    }
    else {
        $connection->prepareSqlQueryAndFields( $self->queryATPData($testMode) );
    }
    dlog('ATP data query prepared');

    dlog('Acquiring statement handle');
    my $sth = $connection->sql->{atpData};
    dlog('Statement handle acquired');

    dlog('Binding columns');

    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{atpDataFields} } );
    dlog('Columns binded');

    dlog('Executing query');
    if ( $delta == 1 ) {
        dlog( 'Executing delta query ' . "HWDATE: $hwDate LPARDATE: $lparDate" );
        $sth->execute( $hwDate, $lparDate );
        dlog('Execution complete');
    }
    else {
        dlog('Executing full query');
        $sth->execute();
        dlog('Execution complete');
    }

    dlog('Beginning to loop through results');
    while ( $sth->fetchrow_arrayref ) {

        logRec( 'dlog', \%rec );
        ###Cleaning the values
        dlog('Cleaning result set');
        cleanValues( \%rec );
        dlog('Result set cleaned');

        logRec( 'dlog', \%rec );

        dlog('Uppercasing result set');
        upperValues( \%rec );
        dlog('Result set uppercased');
        logRec( 'dlog', \%rec );

		if($self->checkRecord(\%rec) == 1 || $self->checkCustomerNumberMap($customerNumberMap,$accountNumberMap,\%rec) == 1 || $self->checkMachineTypeMap($machineTypeMap,\%rec)){
			next;
		}
		
		$rec{lparStatus}=fixLparStatus($rec{hardwareStatus},$rec{lparStatus});
        my $hwCustomerId;
        my $hwLparCustomerId;
        my $newProcessorCount;
        
        $hwCustomerId = $self->getHWCustomerId($customerNumberMap, $accountNumberMap,%rec);
        
        if($hwCustomerId == undef) {
        	next;
        }
             
        $hwLparCustomerId = $self->getHWLparCustomerId($customerNumberMap, $accountNumberMap,%rec);
        
        if($hwLparCustomerId == undef) {
        	$hwLparCustomerId = $hwCustomerId;
        }
        
        if ($rec{processorCount} - $rec{nbrFreeProcessorCores} >= 0 ) {
        	$newProcessorCount = $rec{processorCount} - $rec{nbrFreeProcessorCores} ;
        }
        else {
        	$newProcessorCount = 0 ;
        }

        ###Construct the key
        my $key = $machineTypeMap->{ $rec{machineType} } . '|' . $rec{serial} . '|' . $rec{country};
        dlog("hardware key=$key");

        ###Build our hardware object list
        my $hardware = new Staging::OM::Hardware();
        $hardware->machineTypeId( $machineTypeMap->{ $rec{machineType} } );
        $hardware->serial( $rec{serial} );
        $hardware->customerNumber( $rec{customerNumber} );
        $hardware->owner( $rec{owner} );
        $hardware->hardwareStatus( $rec{hardwareStatus} );
        $hardware->country( $rec{country} );
        $hardware->status( $rec{status} );
        $hardware->updateDate( $rec{hwDate} );
        $hardware->processorCount( $newProcessorCount );
        $hardware->customerId($hwCustomerId);
        $hardware->model( $rec{model} );
        $hardware->classification( $rec{classification} );
        $hardware->chips( $rec{chips} );
        $hardware->processorType( $rec{processorType} );
        $hardware->mastProcessorType( $rec{mastProcessorType} );
        $hardware->cpuMIPS( $rec{cpuMIPS} );
        $hardware->cpuMSU( $rec{cpuMSU} );
        $hardware->cpuGartnerMIPS( $rec{cpuGartnerMIPS} );
        $hardware->processorManufacturer( $rec{processorManufacturer} );
        $hardware->processorModel( $rec{processorModel} );
        $hardware->nbrCoresPerChip( $rec{nbrCoresPerChip} );
        $hardware->nbrOfChipsMax( $rec{nbrOfChipsMax} );
        $hardware->shared( $rec{shared} );
        $hardware->sharedProcessor( $rec{sharedProcessor} );
        $hardware->cloudName( $rec{cloudName} );
        $hardware->chassisId( $rec{chassisId} );
        $hardware->cpuIFL( $self->cpuIflLogic($rec{cpuIFL}) );
        

        
        dlog( $hardware->toString );
            
        ###Add substr to cut down processorType
#        my $temProcessorType = $rec{processorType};
#        my $temSerialNumber = $rec{serial};
#        my $string_length = length( $temProcessorType);
#        if ( $string_length > 16 ) {
#                elog("ProcessorType $temProcessorType ,serialNumber $temSerialNumber is longer than 16, cut it off !");
#                my $newProcessorType =  substr $temProcessorType, 0, 16 ;
#                elog("newProcessorType $newProcessorType ");
#                $hardware->processorType( $newProcessorType );
#        }
#        else {
#                $hardware->processorType( $rec{processorType} );
#        }


        
        ###Add the hardware to the list
        if ( !exists $hardwareList{$key} ) {
            dlog('Adding hardware to hash as does not exist');
            $hardware->serverType( $self->getServerType( $rec{serverType}, undef ) );
            $hardwareList{$key} = $hardware;
        }
        else {
            $hardwareList{$key}
                ->serverType( $self->getServerType( $rec{serverType}, $hardwareList{$key}->serverType ) );
            dlog('Hardware already exists in hash');
        }

        ###Continue if the lpar name is not defined
        if ( ( !defined $rec{name} ) || ( $rec{name} eq '' ) ) {
            dlog('Lpar name is missing');
            next;
        }

        ###Don't process if the name has a space in it
        if ( $rec{name} =~ / / ) {
            dlog('Lpar name has a space in it');
            next;
        }

        my $lparKey = $rec{name} . '|' . $hwLparCustomerId;
        dlog("hardwarelpar key=$lparKey");

        ###Build our hardware lpar object list
        my $hardwareLpar = new Staging::OM::HardwareLpar();
        $hardwareLpar->name( $rec{name} );
        $hardwareLpar->status( $rec{status} );
        $hardwareLpar->hardwareKey($key);
        $hardwareLpar->customerId($hwLparCustomerId);
        $hardwareLpar->updateDate( $rec{lparDate} );
        $hardwareLpar->extId( $rec{extId} );
        $hardwareLpar->techImageId( $rec{techImageId} );
        $hardwareLpar->serverType( $self->getServerType( $rec{serverType}, undef ) );
        $hardwareLpar->lparStatus( $rec{lparStatus} );
        $hardwareLpar->partMIPS( $rec{partMIPS} );
        $hardwareLpar->partMSU( $rec{partMSU} );
        $hardwareLpar->partGartnerMIPS( $rec{partGartnerMIPS} );
        $hardwareLpar->effectiveThreads( $rec{effectiveThreads} );
        $hardwareLpar->spla( $rec{spla} );
        $hardwareLpar->sysplex( $rec{sysplex} );
        $hardwareLpar->internetIccFlag( $rec{internetIccFlag} );
        $hardwareLpar->backupMethod( $rec{backupMethod} );
        $hardwareLpar->clusterType( $rec{clusterType} );
        $hardwareLpar->vMobilRestrict( $rec{vMobilRestrict} );
        $hardwareLpar->cappedLpar( $rec{cappedLpar} );
        $hardwareLpar->virtualFlag( $rec{virtualFlag} );
           
        dlog( $hardwareLpar->toString );

        ###Add our hardware lpar to the list
        if ( !exists $hardwareLparList{$lparKey} ) {
            dlog('lpar does not exist in hash, adding it');
            $hardwareLparList{$lparKey} = $hardwareLpar;
        }
        else {
            dlog( 'Found lpar twice ' . $hardwareLpar->toString );
        }

		my $processorCount = $self->processorCountLogic($rec{effProc});
			
		if ($processorCount == undef) {
			dlog("skipping");
			next;
		}
		


        ###Build our effective processor count list
        my $effectiveProcessor = new Staging::OM::HardwareLparEff();
        $effectiveProcessor->processorCount($processorCount);
        $effectiveProcessor->lparKey($lparKey);
        $effectiveProcessor->status( $rec{status} );
        dlog( $effectiveProcessor->toString );

        ###Add our effective processor to the list
        if ( !exists $effProcList{$lparKey} ) {
            dlog('Effective processor count does not exist in hash, adding');
            $effProcList{$lparKey} = $effectiveProcessor;
        }
        else {
            dlog('Effective processor count already exists in hash');
        }
    }
    dlog('Complete looping through results');

    dlog('Closing statement handle');
    $sth->finish;
    dlog('Statement handle closed');

###Return the lists
    return ( \%hardwareList, \%hardwareLparList, \%effProcList );
}
sub checkRecord{
		my ($self,$rec) = @_;
	        ###We can't have a blank serial
        if ( ( !defined $rec->{serial} ) || ( $rec->{serial} eq '' ) ) {
            dlog('Serial is missing');
            return 1;
        }

        ###We can't have a blank country
        if ( ( !defined $rec->{country} ) || ( $rec->{country} eq '' ) ) {
            dlog('Country is missing');
            return 1;
        }

        return 0;
}

sub checkCustomerNumberMap{
	my ($self,$customerNumberMap,$accountNumberMap,$rec) = @_;
    ###We don't want stuff thats not in our customer number map
    if ( (!exists $customerNumberMap->{ $rec->{customerNumber} }) && (!exists $accountNumberMap->{ $rec->{customerNumber} })) {
        dlog('Customer number does not map to cndb customer');
        return 1;
    }
}

sub checkMachineTypeMap{
	my ($self,$machineTypeMap,$rec) = @_;
    ###We don't want stuff thats not in our machine type map
    if ( !defined $machineTypeMap->{ $rec->{machineType} } ) {
        dlog('Machine type is not defined in BRAVO');
        return 1;
    }
}

sub fixLparStatus{
	
	my ($self,$hwstatus , $lparStatus) = @_;
    if ( ($hwstatus eq 'ACTIVE') && ($lparStatus ne 'ACTIVE')  && ($lparStatus ne 'HWCOUNT')){
        dlog('Lpar defined to other value than ACTIVE, INACTIVE, HWCOUNT. Fixing to ACTIVE');
        $lparStatus='ACTIVE';
    }
    return $lparStatus;
}

sub queryATPData {
    my ( $self, $testMode ) = @_;
    my @fields = (
        qw(
            machineType
            serial
            customerNumber
            owner
            hardwareStatus
            country
            name
            effProc
            status
            hwDate
            lparDate
            processorCount
            lparCustomerNumber
            model
            extId
            techImageId
            classification
            chips
            processorType
            mastProcessorType
            serverType
            lparStatus
            cpuMIPS
            cpuMSU
            cpuGartnerMIPS
            partMIPS
            partMSU
            partGartnerMIPS
            processorManufacturer
            processorModel
            shared
            nbrCoresPerChip
            nbrOfChipsMax
            effectiveThreads
            spla
            sysplex
            internetIccFlag
            sharedProcessor
            cloudName
            chassisId
            backupMethod
            clusterType
            vMobilRestrict
            cappedLpar
            virtualFlag
            nbrFreeProcessorCores
            cpuIFL)
    );
    my $query = '
        select
            ltrim(rtrim(machtype))
            ,ltrim(rtrim(serial))
            ,ltrim(rtrim(primbill))
            ,ltrim(rtrim(type))
            ,ltrim(rtrim(hwstatus))
            ,ltrim(rtrim(isocntry))
            ,ltrim(rtrim(lpar))
            ,effproc
            ,case when( hwstatus = \'HWCOUNT\'
                or hwstatus = \'ACTIVE\'
                or hwstatus is null
                or hwstatus = \'\' ) then \'ACTIVE\'
            else \'INACTIVE\'
            end
            ,lastupdt
            ,case when( lparupdt is null
                or lparupdt = \'\' ) then \'1970-01-01\'
            else date(substr(lparupdt,1,4)|| \'-\' || substr(lparupdt,5,2) || \'-\' || substr(lparupdt,7,2))
            end as lparDate
            ,cpuprocno
            ,case when ( ltrim(rtrim(cpucustnum)) = \'\' or cpucustnum is null ) then ltrim(rtrim(primbill))
            else ltrim(rtrim(cpucustnum))
            end
            ,rtrim(ltrim(cpumodel))
            ,rtrim(ltrim(systid))
            ,rtrim(ltrim(techimgid))
            ,rtrim(ltrim(classification))
            ,processor_chip
            ,rtrim(ltrim(processor_type))
            ,rtrim(ltrim(mast_processor_type))
            ,rtrim(ltrim(server_type))
            ,rtrim(ltrim(lpar_status))
            ,CAST(cpu_mips AS INTEGER)
            ,CAST(cpu_msu AS INTEGER)
            ,CAST(cpu_gartner_mips AS DECIMAL(10,3))
            ,CAST(part_mips AS INTEGER)
            ,CAST(part_msu AS INTEGER)
            ,CAST(part_gartner_mips AS DECIMAL(10,3))
            ,ltrim(rtrim(PROCESSOR_MANUFACTURER))
			,ltrim(rtrim(PROCESSOR_MODEL))
			,ltrim(rtrim(SHARED))
			,CAST(NBR_CORES_PER_CHIP AS DECIMAL(3,0))
			,CAST(NBR_OF_CHIPS_MAX AS DECIMAL(4,0))
			,CAST(EFFECTIVE_THREADS AS DECIMAL(14,3))
			,ltrim(rtrim(SPLA))
			,ltrim(rtrim(SYSPLEX))
			,ltrim(rtrim(INTERNET_ACC_FLAG ))
			,ltrim(rtrim(SHARED_PROCESSOR))
			,ltrim(rtrim(CLOUD_NAME))
			,ltrim(rtrim(CHASSIS_ID))
			,ltrim(rtrim(BACKUPMETHOD))
			,ltrim(rtrim(CLUSTER_TYPE))
			,ltrim(rtrim(VIRTUAL_MOBILITY_RESTRICTION))
			,ltrim(rtrim(CAPPED_LPAR))
			,ltrim(rtrim(VIRTUALFLAG))
			,NBR_FREE_PROCESSOR_CORES
			,CPU_IFL		
        from
            atpprod.bravo
    ';
    if ( $testMode == 1 ) {
        $query .= '
    	where ( ltrim(rtrim(primbill)) in (\'35400XX\', \'39780XX\') 
    	or ltrim(rtrim(cpucustnum)) in (\'35400XX\', \'39780XX\'))
    	';
    }
    $query .= '
        with ur
    ';
    dlog("queryATPData=$query");
    return ( 'atpData', $query, \@fields );
}

sub queryATPDeltaData {
    my ( $self, $testMode ) = @_;
    my @fields = (
        qw(
            machineType
            serial
            customerNumber
            owner
            hardwareStatus
            country
            name
            effProc
            status
            hwDate
            lparDate
            processorCount
            lparCustomerNumber
            model
            extId
            techImageId
            classification
            chips
            processorType
            mastProcessorType
            serverType
            lparStatus
            cpuMIPS
            cpuMSU
            cpuGartnerMIPS
            partMIPS
            partMSU
            partGartnerMIPS
            processorManufacturer
            processorModel
            shared
            nbrCoresPerChip
            nbrOfChipsMax
            effectiveThreads
            spla
            sysplex
            internetIccFlag
            sharedProcessor
            cloudName
            chassisId
            backupMethod
            clusterType
            vMobilRestrict
            cappedLpar
            virtualFlag
            nbrFreeProcessorCores
            cpuIFL)
    );
    my $query = '
        select
            ltrim(rtrim(machtype))
            ,ltrim(rtrim(serial))
            ,ltrim(rtrim(primbill))
            ,ltrim(rtrim(type))
            ,ltrim(rtrim(hwstatus))
            ,ltrim(rtrim(isocntry))
            ,ltrim(rtrim(lpar))
            ,effproc
            ,case when( hwstatus = \'HWCOUNT\'
                or hwstatus = \'ACTIVE\'
                or hwstatus is null
                or hwstatus = \'\' ) then \'ACTIVE\'
            else \'INACTIVE\'
            end
            ,lastupdt
            ,case when( lparupdt is null
                or lparupdt = \'\' ) then \'1970-01-01\'
            else date(substr(lparupdt,1,4)|| \'-\' || substr(lparupdt,5,2) || \'-\' || substr(lparupdt,7,2))
            end as lparDate
            ,cpuprocno
            ,case when ( ltrim(rtrim(cpucustnum)) = \'\' or cpucustnum is null ) then ltrim(rtrim(primbill))
            else ltrim(rtrim(cpucustnum))
            end
            ,rtrim(ltrim(cpumodel))
            ,rtrim(ltrim(systid))
            ,rtrim(ltrim(techimgid))
            ,rtrim(ltrim(classification))
            ,processor_chip
            ,rtrim(ltrim(processor_type))
            ,rtrim(ltrim(mast_processor_type))
            ,rtrim(ltrim(server_type))
            ,rtrim(ltrim(lpar_status))
            ,CAST(cpu_mips AS INTEGER)
            ,CAST(cpu_msu AS INTEGER)
            ,CAST(cpu_gartner_mips AS DECIMAL(10,3))
            ,CAST(part_mips AS INTEGER)
            ,CAST(part_msu AS INTEGER)
            ,CAST(part_gartner_mips AS DECIMAL(10,3))
            ,ltrim(rtrim(PROCESSOR_MANUFACTURER))
			,ltrim(rtrim(PROCESSOR_MODEL))
			,ltrim(rtrim(SHARED))
			,CAST(NBR_CORES_PER_CHIP AS DECIMAL(3,0))
			,CAST(NBR_OF_CHIPS_MAX AS DECIMAL(4,0))
			,CAST(EFFECTIVE_THREADS AS DECIMAL(14,3))
			,ltrim(rtrim(SPLA))
			,ltrim(rtrim(SYSPLEX))
			,ltrim(rtrim(INTERNET_ACC_FLAG ))
			,ltrim(rtrim(SHARED_PROCESSOR))
			,ltrim(rtrim(CLOUD_NAME))
			,ltrim(rtrim(CHASSIS_ID))
			,ltrim(rtrim(BACKUPMETHOD))
			,ltrim(rtrim(CLUSTER_TYPE))
			,ltrim(rtrim(VIRTUAL_MOBILITY_RESTRICTION))
			,ltrim(rtrim(CAPPED_LPAR))
			,ltrim(rtrim(VIRTUALFLAG))
			,NBR_FREE_PROCESSOR_CORES
			,CPU_IFL
        from
            atpprod.bravo
        where  
            (lastupdt >= ?
             or case when( lparupdt is null
             or lparupdt = \'\' ) then \'1970-01-01\'
            else date(substr(lparupdt,1,4)|| \'-\' || substr(lparupdt,5,2) || \'-\' || substr(lparupdt,7,2))
            end  >= ?)
    ';
    if ( $testMode == 1 ) {
        $query .= '
    	    and ( ltrim(rtrim(primbill)) in (\'35400XX\', \'39780XX\') 
    	    or ltrim(rtrim(cpucustnum)) in (\'35400XX\', \'39780XX\'))
    	';
    }
    $query .= '
        with ur
    ';
    dlog("queryATPDeltaData=$query");
    return ( 'atpData', $query, \@fields );
}

sub getHWCustomerId {
	    my ( $self, $customerNumberMap, $accountNumberMap, %rec ) = @_;
	    
	    if ( $accountNumberMap->{ $rec{customerNumber} }->{'count'} == 1 ) {
            dlog('Matching account number');
            return $accountNumberMap->{ $rec{customerNumber} }->{'customerId' };
        }
        elsif ( defined $customerNumberMap->{ $rec{customerNumber} }->{ $rec{country} } ) { 
            dlog("Matching country code found; assigning customer id");
            return $customerNumberMap->{ $rec{customerNumber} }->{ $rec{country} };
        }
        else {
            dlog("No unique customer number/country code defined, skipping");
            return undef
        }
}

sub getHWLparCustomerId {
	    my ( $self, $customerNumberMap, $accountNumberMap, %rec ) = @_;
	    
	    if ( $accountNumberMap->{ $rec{lparCustomerNumber} }->{'count'} == 1 ) {
            dlog('Matching account number');
            return $accountNumberMap->{ $rec{lparCustomerNumber} }->{'customerId' };
        }
        elsif ( defined $customerNumberMap->{ $rec{lparCustomerNumber} }->{ $rec{country} } ) { 
            dlog("Matching country code found; assigning customer id");
            return $customerNumberMap->{ $rec{lparCustomerNumber} }->{ $rec{country} };
        }
        else {
            dlog("No unique customer number/country code defined, skipping");
            return undef
        }
}

sub processorCountLogic {
		my ( $self, $effProc) = @_;
		
	    ###Continue if the processor count is not defined
        if ( ( !defined $effProc ) || ( $effProc eq '' ) ) {
            dlog('Effective processor is blank');
            return undef;
        }

        my $processorCount = ( split( /\./, $effProc ) )[0];
        dlog("processorCount=$processorCount");

		if($processorCount =~ m/^-/) {
			return undef;
		}
        ###Continue if the processor count is zero
        if ( $processorCount eq '0' ) {
            dlog('processor count is 0...skipping');
            return undef;
        }
	
		return $processorCount;
}
sub cpuIflLogic {
		my ( $self, $cpuIfl) = @_;	
	
        if( defined $cpuIfl){
         my $reg1 = qr/^\d+(\.\d+)?$/;
         my $reg2 = qr/^-?0(\d+)?$/;
         if ( $cpuIfl =~ $reg1 && $cpuIfl !~ $reg2 ){
             return int($cpuIfl);
         }
        }
        return 0;
}

1;
