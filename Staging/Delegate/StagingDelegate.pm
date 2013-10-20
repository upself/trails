package Staging::Delegate::StagingDelegate;

###Modules
use strict;
use Base::Utils;
use CNDB::Delegate::CNDBDelegate;
use Base::ConfigManager;
use Staging::OM::LoaderStatus;

sub insertCount {
    my ( $self, $connection, $countRef ) = @_;
    foreach my $db ( keys %{$countRef} ) {
        foreach my $object ( keys %{ $countRef->{$db} } ) {
            foreach my $action ( keys %{ $countRef->{$db}->{$object} } ) {
                my $count = $countRef->{$db}->{$object}->{$action};
                if ( $count > 0 ) {
                    my $loaderStatus = new Staging::OM::LoaderStatus();
                    $loaderStatus->database($db);
                    $loaderStatus->objectType($object);
                    $loaderStatus->action($action);
                    $loaderStatus->count($count);
                    $loaderStatus->save($connection);
                    dlog( $loaderStatus->toString );
                }
            }
        }
    }
}

sub getHardwareLparMap {
    my ($self) = @_;

    ###Hash to return
    my %data;

    ###Get cndb customer id map
    my $customerIdMap = CNDB::Delegate::CNDBDelegate->getCustomerIdMap('ACTIVE');

    ###Get a staging connection
    my $connection = Database::Connection->new('staging');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryHardwareLparMap() );

    my $sth = $connection->sql->{hardwareLparMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{hardwareLparMapFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        $data{ $rec{hardwareLparId} }->{"customerId"}       = $rec{customerId};
        $data{ $rec{hardwareLparId} }->{"accountNumber"}    = $customerIdMap->{ $rec{customerId} };
        $data{ $rec{hardwareLparId} }->{"hardwareLparName"} = $rec{hardwareLparName};
        $data{ $rec{hardwareLparId} }->{"hardwareSerial"}   = $rec{hardwareSerial};
    }
    $sth->finish;

    ###Close our staging connection
    $connection->disconnect;

    return \%data;
}

sub queryHardwareLparMap {
    my @fields = (qw(hardwareLparId customerId hardwareLparName hardwareSerial));
    my $query  = '
        select
            a.id
            ,a.customer_id
            ,a.name
            ,b.serial
        from
            hardware_lpar a
            ,hardware b
        where
            a.status = \'ACTIVE\'
            and b.status = \'ACTIVE\'
            and a.hardware_id = b.id
        with ur
    ';
    return ( 'hardwareLparMap', $query, \@fields );
}

# Added for the Mainframe Serial(4) match only for same machine type
sub getMachineTypeByHardwareId {
    my ( $self, $lpar, $serial ) = @_;

    ###Get a staging connection
    my $connection = Database::Connection->new('trails');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryGetMachineTypeByHardwareId() );

    my $sth = $connection->sql->{getMachineTypeByHardwareId};
    my $MachineType;
    $sth->bind_columns( undef, \$MachineType );
    dlog("looking up machine type for $lpar $serial");
    $sth->execute( $lpar, $serial );
    my $found = $sth->fetch();
    dlog("machine type is $MachineType");
    $sth->finish;

    if ( !defined $MachineType ) {
        return "UNKNOWN";
    }
    else {
        return $MachineType;
    }
}

sub queryGetMachineTypeByHardwareId {
    my $query = '
	select type from machine_type, hardware, hardware_lpar 
	where 
	hardware_id = hardware.id 
	and hardware.machine_type_id = machine_type.id 
	and hardware_lpar.name = ? and right(hardware.serial, 4) = ?
    ';
    return ( 'getMachineTypeByHardwareId', $query );
}

sub getSoftwareLparIpBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging for Ip addresses
    dlog("preparing software lpar ids for ip addresses query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparIpIds( $testMode, $loadDeltaOnly ) );
    dlog("prepared software lpar ids for ip addresses query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids for ip addresses query");
    my $sth = $connection->sql->{softwareLparIpIds};
    dlog("got sth for software lpar ids for ip addresses query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids for ip addresses query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparIpIdsFields} } );
    dlog("binded columns for software lpar ids for ip addresses query");

    ###Excute the query
    ilog("executing software lpar ids for ip addresses query");
    $sth->execute();
    ilog("executed software lpar ids for ip addresses query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparIpIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            distinct a.id
        from 
            software_lpar a
            join software_lpar_map b on b.software_lpar_id = a.id
            join scan_record c on c.id = b.scan_record_id
            join ip_address d on d.scan_record_id = c.id
        where
            a.action = \'COMPLETE\'
            and b.action = \'COMPLETE\'
            and c.action = \'COMPLETE\'
    ';
    my $clause = 'and';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . ' (
            d.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparIpIds=$query");
    return ( 'softwareLparIpIds', $query, \@fields );
}

sub getSoftwareLparHdiskBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging for Ip addresses
    dlog("preparing software lpar ids for hdisk query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparHdiskIds( $testMode, $loadDeltaOnly ) );
    dlog("prepared software lpar ids for hdisk query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids for hdisk query");
    my $sth = $connection->sql->{softwareLparHdiskIds};
    dlog("got sth for software lpar ids for hdisk query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids for hdisk query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparHdiskIdsFields} } );
    dlog("binded columns for software lpar ids for hdisk query");

    ###Excute the query
    ilog("executing software lpar ids for hdisk query");
    $sth->execute();
    ilog("executed software lpar ids for hdisk query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparHdiskIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from 
            software_lpar a
            join software_lpar_map b on b.software_lpar_id = a.id
            join scan_record c on c.id = b.scan_record_id
            join hdisk d on d.scan_record_id = c.id
        where
            a.action = \'COMPLETE\'
            and b.action = \'COMPLETE\'
            and c.action = \'COMPLETE\'
    ';
    my $clause = 'and';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . ' (
            d.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparHdiskIds=$query");
    return ( 'softwareLparHdiskIds', $query, \@fields );
}

sub getSoftwareLparMemModBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging for Ip addresses
    dlog("preparing software lpar ids for memmod query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparMemModIds( $testMode, $loadDeltaOnly ) );
    dlog("prepared software lpar ids for memmod query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids for memmod query");
    my $sth = $connection->sql->{softwareLparMemModIds};
    dlog("got sth for software lpar ids for memmod query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids for memmod query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparMemModIdsFields} } );
    dlog("binded columns for software lpar ids for memmod query");

    ###Excute the query
    ilog("executing software lpar ids for memmod query");
    $sth->execute();
    ilog("executed software lpar ids for memmod query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparMemModIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            distinct a.id
        from 
            software_lpar a
            join software_lpar_map b on b.software_lpar_id = a.id
            join scan_record c on c.id = b.scan_record_id
            join mem_mod d on d.scan_record_id = c.id
        where
            a.action = \'COMPLETE\'
            and b.action = \'COMPLETE\'
            and c.action = \'COMPLETE\'
    ';
    my $clause = 'and';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . ' (
            d.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparMemModIds=$query");
    return ( 'softwareLparMemModIds', $query, \@fields );
}

sub getSoftwareLparProcessorBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging for Ip addresses
    dlog("preparing software lpar ids for processors query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparProcessorIds( $testMode, $loadDeltaOnly ) );
    dlog("prepared software lpar ids for processors query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids for processors query");
    my $sth = $connection->sql->{softwareLparProcessorIds};
    dlog("got sth for software lpar ids for processors query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids for processors query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparProcessorIdsFields} } );
    dlog("binded columns for software lpar ids for processors query");

    ###Excute the query
    ilog("executing software lpar ids for processors query");
    $sth->execute();
    ilog("executed software lpar ids for processors query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparProcessorIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from 
            software_lpar a
            join software_lpar_map b on b.software_lpar_id = a.id
            join scan_record c on c.id = b.scan_record_id
            join processor d on d.scan_record_id = c.id
        where
            a.action = \'COMPLETE\'
            and b.action = \'COMPLETE\'
            and c.action = \'COMPLETE\'
    ';
    my $clause = 'and';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . ' (
            d.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparProcessorIds=$query");
    return ( 'softwareLparProcessorIds', $query, \@fields );
}

sub getSoftwareLparAdcBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging for Ip addresses
    dlog("preparing software lpar ids for adc query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparAdcIds( $testMode, $loadDeltaOnly ) );
    dlog("prepared software lpar ids for adc query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids for adc query");
    my $sth = $connection->sql->{softwareLparAdcIds};
    dlog("got sth for software lpar ids for adc query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids for adc query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparAdcIdsFields} } );
    dlog("binded columns for software lpar ids for adc query");

    ###Excute the query
    ilog("executing software lpar ids for adc query");
    $sth->execute();
    ilog("executed software lpar ids for adc query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparAdcIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            distinct a.id
        from 
            software_lpar a
            join software_lpar_map b on b.software_lpar_id = a.id
            join scan_record c on c.id = b.scan_record_id
            join adc d on d.scan_record_id = c.id
        where
            a.action = \'COMPLETE\'
            and b.action = \'COMPLETE\'
            and c.action = \'COMPLETE\'
    ';
    my $clause = 'and';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . ' (
            d.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparAdcIds=$query");
    return ( 'softwareLparAdcIds', $query, \@fields );
}

#############################################################################
sub queryHardwareData {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (
        qw(
            id
            machineTypeId
            serial
            country
            owner
            customerNumber
            hardwareStatus
            status
            action
            hwDate
            processorCount
            model
            customerId
            classification
            chips
            processorType
            mastProcessorType
            cpuMIPS
            cpuMSU
            processorManufacturer
            processorModel
            shared
            nbrCoresPerChip
            nbrOfChipsMax
            lparId
            name
            lparCustomerId
            hlStatus
            lparStatus
            lparAction
            lparDate
            extId
            techImageId
            partMIPS
            partMSU
            spla
            sysplex
            internetIccFlag
            effId
            effProcessorCount
            effStatus
            effAction
            serverType)
    );
    my $query = '
        select
            a.id
            ,a.machine_type_id
            ,a.serial
            ,a.country
            ,a.owner
            ,a.customer_number
            ,a.hardware_status
            ,a.status
            ,a.action
            ,a.update_date
            ,a.processor_count
            ,a.model
            ,a.customer_id
            ,a.classification
            ,a.chips
            ,a.processor_type
            ,a.mast_processor_type
            ,a.cpu_mips
            ,a.cpu_msu
            ,a.processor_manufacturer
            ,a.processor_model
            ,a.shared
            ,a.nbr_cores_per_chip
            ,a.nbr_of_chips_max
            ,b.id
            ,b.name
            ,b.customer_id
            ,b.status
            ,b.lpar_status
            ,b.action
            ,b.update_date
            ,b.ext_id
            ,b.tech_image_id
            ,b.part_mips
            ,b.part_msu
            ,b.spla
            ,b.sysplex
            ,b.internet_icc_flag
            ,c.id
            ,c.processor_count
            ,c.status
            ,c.action
            ,a.server_type
        from
            hardware a
            left outer join hardware_lpar b on
                a.id = b.hardware_id
            left outer join effective_processor c on
                b.id = c.hardware_lpar_id
    ';
    my $clause = 'where';
    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . '
            (a.action != \'COMPLETE\'
                or b.action != \'COMPLETE\'
                or c.action != \'COMPLETE\')
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
        ' . $clause . '
            a.customer_number in (\'35400XX\', \'39780XX\')
        ';
        $clause = 'and';
    }
    $query .= '
        order by
            a.id
        with ur
    ';
    dlog("queryHardwareData=$query");
    return ( 'hardwareData', $query, \@fields );
}

sub queryScanRecordData {
    my @fields = (
        qw(
            id
            computerId
            name
            objectId
            model
            serialNumber
            scanTime
            osName
            osType
            osMajor
            osMinor
            osSub
            osInst
            userName
            manufacturer
            biosModel
            serverType
            techImageId
            extId
            memory
            disk
            dedicatedProcessors
            totalProcessors
            sharedProcessors
            processorType
            sharedProcByCores
            dedicatedProcByCores
            totalProcByCores
            alias
            physicalTotalKb
            virtualMemory
            physicalFreeMemory
            virtualFreeMemory
            nodeCapacity
            lparCapacity
            biosDate
            biosSerialNumber
            biosUniqueId
            boardSerial
            caseSerial
            caseAssetTag
            powerOnPassword
            users
            processorCount
            authenticated
            isManual
            action)
    );

    my $query = '
        select
            a.id
            ,a.computer_id
            ,a.name
            ,a.object_id
            ,a.model
            ,a.serial_number
            ,a.scan_time
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,a.user_name
            ,a.bios_manufacturer
            ,a.bios_model
            ,a.server_type
            ,a.tech_img_id
            ,a.ext_id
            ,a.memory
            ,a.disk
            ,a.dedicated_processors
            ,a.total_processors
            ,a.shared_processors
            ,a.processor_type
            ,a.shared_proc_by_cores
            ,a.dedicated_proc_by_cores
            ,a.total_proc_by_cores
            ,a.alias
            ,a.physical_total_kb
            ,a.virtual_memory
            ,a.physical_free_memory
            ,a.virtual_free_memory
            ,a.node_capacity
            ,a.lpar_capacity
            ,a.bios_date
            ,a.bios_serial_number
            ,a.bios_unique_id
            ,a.board_serial
            ,a.case_serial
            ,a.case_asset_tag
            ,a.power_on_password
            ,a.users
            ,a.processor_count
            ,a.authenticated
            ,a.is_manual
            ,a.action
        from
            scan_record a
        where
            a.bank_account_id = ?
        with ur
    ';

    return ( 'scanRecordData', $query, \@fields );
}

sub queryHdiskData {
    my $query = '
        select
            a.id
            ,a.model
            ,a.size
            ,a.manufacturer
            ,a.serial_number
            ,a.storage_type
            ,a.action
            ,b.id
            ,b.action
        from
            hdisk a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'hdiskData', $query );
}

sub queryMemoryData {
    my $query = '
        select
            a.id
            ,a.size
            ,a.action
            ,b.id
        from
            memory a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'memoryData', $query );
}

sub queryMemModData {
    my $query = '
        select
            a.id
            ,a.inst_mem_id
            ,a.module_size_mb
            ,a.max_module_size_mb
            ,a.socket_name
            ,a.packaging
            ,a.mem_type
            ,a.action
            ,b.id
        from
            mem_mod a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'memModData', $query );
}

sub queryMemModDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (
        qw(
            customerId
            name
            memModId
            scanRecordId
            instMemId
            moduleSizeMb
            maxModuleSizeMb
            socketName
            packaging
            memType
            action
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.customer_id
                ,a.name
                ,d.id as mem_mod_id
                ,d.scan_record_id                                
                ,d.inst_mem_id    
                ,d.module_size_mb
                ,d.max_module_size_mb
                ,d.socket_name   
                ,d.packaging
                ,d.mem_type
                ,d.action 
            from 
                software_lpar a
                ,software_lpar_map b
                ,scan_record c
                ,mem_mod d
            where
                a.id >= ?
                and a.id <= ?
                and a.action = \'COMPLETE\'
                and b.action = \'COMPLETE\'
                and c.action = \'COMPLETE\'
                and a.id = b.software_lpar_id
                and c.id = b.scan_record_id
                and d.scan_record_id = c.id
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and d.action != \'COMPLETE\'
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x. customer_id
            ,x.mem_mod_id
        with ur
    ';
    dlog("queryMemModIds=$query");
    return ( 'memModDataByMinMaxIds', $query, \@fields );

}

sub queryOsData {
    my $query = '
        select
        	a.id
        	,a.name
        	,a.os_type
        	,a.major_vers
        	,a.minor_vers
        	,a.sub_vers
        	,a.inst_date
        	,a.action
        	,b.id
        from
            os a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
	
    ';

    return ( 'osData', $query );
}

sub queryProcessorData {
    my $query = '
        select
        	a.id
        	,a.processor_num
        	,a.manufacturer
        	,a.model
        	,a.max_speed
        	,a.bus_speed
        	,a.is_active
        	,a.serial_number
        	,a.num_boards
        	,a.num_modules
        	,a.pvu
        	,a.cache
        	,a.current_speed
        	,a.action
        	,b.id
        from
            processor a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
	
    ';

    return ( 'processorData', $query );
}

sub queryProcessorDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;

    my @fields = (
        qw(
            customerId
            name
            processorId
            scanRecordId
            processorNum
            manufacturer
            model
            maxSpeed
            busSpeed
            isActive
            serialNumber
            numBoards
            numModules
            pvu
            cache
            currentSpeed
            processorAction
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.customer_id
                ,a.name
                ,d.id as processor_id
                ,d.scan_record_id                                
        	    ,d.processor_num
        	    ,d.manufacturer
        	    ,d.model
        	    ,d.max_speed
        	    ,d.bus_speed
        	    ,d.is_active
        	    ,d.serial_number
        	    ,d.num_boards
        	    ,d.num_modules
        	    ,d.pvu
        	    ,d.cache
        	    ,d.current_speed
                ,d.action  
            from 
                software_lpar a
                ,software_lpar_map b
                ,scan_record c
                ,processor d
            where
                a.id >= ?
                and a.id <= ?
                and a.action = \'COMPLETE\'
                and b.action = \'COMPLETE\'
                and c.action = \'COMPLETE\'
                and a.id = b.software_lpar_id
                and c.id = b.scan_record_id
                and d.scan_record_id = c.id

    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and d.action != \'COMPLETE\'
        ';
    }

    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x.customer_id
            ,x.processor_id
        with ur
    ';

    dlog("queryProcessorIds=$query");
    return ( 'processorDataByMinMaxIds', $query, \@fields );
}

sub queryAdcData {

    my $query = '
        select
            a.id
            ,a.ep_Name
            ,a.ep_Oid
            ,a.ip_address
            ,a.cust
            ,a.loc
            ,a.gu
            ,a.server_type
            ,a.sesdr_location
            ,a.sesdr_bp_using
            ,a.sesdr_systid
            ,a.action
            ,b.id
            ,b.action
        from
            adc a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'adcData', $query );
}

sub queryAdcDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;

    my @fields = (
        qw(
            customerId
            name
            adcId
            scanRecordId
            epName
            epOid
            ipAddress
            cust
            loc
            gu
            serverType
            sesdrLocation
            serdrBpUsing
            sesdrSystid
            adcAction
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.customer_id
                ,a.name
                ,d.id as adc_id
                ,d.scan_record_id                                
                ,d.ep_name   
                ,d.ep_oid
                ,d.ip_address
                ,d.cust    
                ,d.loc
                ,d.gu
                ,d.server_type   
                ,d.sesdr_location
                ,d.sesdr_bp_location  
                ,d.sesdr_systid              
                ,d.action  
            from 
                software_lpar a
                ,software_lpar_map b
                ,scan_record c
                ,adc d
            where
                a.id >= ?
                and a.id <= ?
                and a.action = \'COMPLETE\'
                and b.action = \'COMPLETE\'
                and c.action = \'COMPLETE\'
                and a.id = b.software_lpar_id
                and c.id = b.scan_record_id
                and d.scan_record_id = c.id

    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and d.action != \'COMPLETE\'
        ';
    }

    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x.customer_id
            ,x.adc_id
        with ur
    ';

    dlog("queryAdcIds=$query");
    return ( 'adcDataByMinMaxIds', $query, \@fields );
}

sub queryIpAddressData {
    my $query = '
        select
            a.id
            ,a.ip_address
            ,a.hostname
            ,a.domain
            ,a.subnet
            ,a.action
            ,a.instance_id
            ,a.gateway
            ,a.primary_dns
            ,a.secondary_dns
            ,a.is_dhcp
            ,a.perm_mac_address
            ,a.ipv6_address
            ,b.id
            ,b.action
        from
            ip_address a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'ipAddressData', $query );
}

sub querySoftwareFilterData {
    my $query = '
        select
            a.id
            ,a.software_filter_id
            ,a.software_id
            ,a.action
            ,b.id
            ,b.action
        from
            software_filter a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'softwareFilterData', $query );
}

sub querySoftwareSignatureData {
    my $query = '
        select
            a.id
            ,a.software_signature_id
            ,a.software_id
            ,a.action
            ,a.path
            ,b.id
            ,b.action
        from
            software_signature a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'softwareSignatureData', $query );
}

sub querySoftwareManualData {
    my $query = '
        select
            a.id
            ,a.software_id
            ,a.version
            ,a.users
            ,a.action
            ,b.id
        from
            software_manual a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'softwareManualData', $query );
}

sub querySoftwareTlcmzData {
    my $query = '
        select
            a.id
            ,a.sa_product_id
            ,a.software_id
            ,a.action
            ,b.id
        from
            software_tlcmz a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'softwareTlcmzData', $query );
}

sub querySoftwareDoranaData {
    my $query = '
        select
            a.id
            ,a.dorana_product_id
            ,a.software_id
            ,a.action
            ,b.id
        from
            software_dorana a
            ,scan_record b
        where
            a.scan_record_id = b.id
            and b.bank_account_id = ?
        with ur
    ';

    return ( 'softwareDoranaData', $query );
}

sub getSoftwareLparBatches {
    my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery, $count ) = @_;

    my @softwareLparIds = ();

    ###Prepare query to pull software lpar ids from staging
    dlog("preparing software lpar ids query");
    $connection->prepareSqlQueryAndFields( $self->querySoftwareLparIds( $testMode, $loadDeltaOnly, $count ) );
    dlog("prepared software lpar ids query");

    ###Get the statement handle
    dlog("getting sth for software lpar ids query");
    my $sth = $connection->sql->{softwareLparIds};
    dlog("got sth for software lpar ids query");

    ###Bind our columns
    my %rec;
    dlog("binding columns for software lpar ids query");
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{softwareLparIdsFields} } );
    dlog("binded columns for software lpar ids query");

    ###Excute the query
    ilog("executing software lpar ids query");
    $sth->execute();
    ilog("executed software lpar ids query");

    while ( $sth->fetchrow_arrayref ) {

        ###Clean record values
        cleanValues( \%rec );

        push( @softwareLparIds, $rec{id} );
    }
    ilog( "got sw lpar ids, count: " . scalar(@softwareLparIds) );
    ilog( "min id=" . $softwareLparIds[0] );
    ilog( "max id=" . $softwareLparIds[$#softwareLparIds] );

    ###
    ###Calculate the batches of MaxLparsInQuery.
    ###
    my @idBatches = ();
    my $firstIndex;
    my $lastIndex;
    for ( my $i = 0; $i <= $#softwareLparIds; $i++ ) {
        if ( $i == 0 ) {
            $firstIndex = 0;
        }
        elsif ( $firstIndex < $i && $i < $lastIndex ) {
            next;
        }
        elsif ( $lastIndex == $#softwareLparIds ) {
            last;
        }
        else {
            $firstIndex = $lastIndex + 1;
        }
        $lastIndex = $firstIndex + $maxLparsInQuery - 1;
        $lastIndex = ( $lastIndex > $#softwareLparIds ) ? $#softwareLparIds : $lastIndex;
        push( @idBatches, "$softwareLparIds[$firstIndex],$softwareLparIds[$lastIndex]" );
    }
    ilog( "id batches count: " . scalar(@idBatches) );

    return @idBatches;
}

sub querySoftwareLparIds {
    my ( $self, $testMode, $deltaOnly, $count ) = @_;
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from software_lpar a
        left outer join software_lpar_map b on
            a.id = b.software_lpar_id
        left outer join scan_record c on
            b.scan_record_id = c.id
    ';
    if ( $count == 1 ) {
        $query .= '
        left outer join software_manual sm on
            c.id = sm.scan_record_id
        ';
    }
    elsif ( $count == 2 ) {
        $query .= '
        left outer join software_dorana sd on
            c.id = sd.scan_record_id
        ';
    }
    elsif ( $count == 3 ) {
        $query .= '
        left outer join software_tlcmz st on
            c.id = st.scan_record_id
        ';
    }
    elsif ( $count == 4 ) {
        $query .= '
        left outer join software_filter sf on
            c.id = sf.scan_record_id
        ';
    }
    elsif ( $count == 5 ) {
        $query .= '
        left outer join software_signature ss on
            c.id = ss.scan_record_id
        ';
    }
    elsif ( $count == 6 ) {
        $query .= '
        left outer join scan_software_item si on
            c.id = si.scan_record_id
        ';
    }
    my $clause = 'where';
    if ( $deltaOnly == 1 ) {
        $query .= ' ' . $clause . ' ( (
        a.action != \'COMPLETE\'
        or b.action != \'COMPLETE\' ';
        if ( $count == 1 ) {
            $query .= '
                or sm.action != \'COMPLETE\'
            ';
        }
        elsif ( $count == 2 ) {
            $query .= '
                or sd.action != \'COMPLETE\'
            ';
        }
        elsif ( $count == 3 ) {
            $query .= '
                or st.action != \'COMPLETE\'
            ';
        }
        elsif ( $count == 4 ) {
            $query .= '
                or sf.action != \'COMPLETE\'
            ';
        }
        elsif ( $count == 5 ) {
            $query .= '
                or ss.action != \'COMPLETE\'
            ';
        }
        elsif ( $count == 6 ) {
            $query .= '
                or si.action != 0
            ';
        }
        $query .= '))';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
        $clause = 'and';
    }
    $query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
    dlog("querySoftwareLparIds=$query");
    return ( 'softwareLparIds', $query, \@fields );
}

###TODO: for the memory, hdisk, ipaddr, and osinfo tables,
###can i leverage the fact that the intermediary script
###has selected the scan record w/ the greatest scan time
###and join to these tables based on that element???
sub querySoftwareLparDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (
        qw(
            id
            customerId
            computerId
            objectId
            name
            model
            biosSerial
            osName
            osType
            osMajor
            osMinor
            osSub
            osInst
            userName
            manufacturer
            biosModel
            serverType
            techImageId
            extId
            memory
            disk
            dedicatedProcessors
            totalProcessors
            sharedProcessors
            processorType
            sharedProcByCores
            dedicatedProcByCores
            totalProcByCores
            alias
            physicalTotalKb
            virtualMemory
            physicalFreeMemory
            virtualFreeMemory
            nodeCapacity
            lparCapacity
            biosDate
            biosSerialNumber
            biosUniqueId
            boardSerial
            caseSerial
            caseAssetTag
            powerOnPassword
            processorCount
            scanTime
            status
            action
            mapId
            mapAction
            scanRecordId
            scanRecordComputerId
            bankAccountId
            scanRecordScanTime
            scanRecordAuthenticated
            scanRecordAction
            installedSoftwareType
            installedSoftwareTypeTableId
            installedSoftwareTypeId
            softwareId
            path
            installedSoftwareTypeAction
            installedSoftwareTypeUsers
            installedSoftwareTypeVersion
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'MANUAL\' as type
                ,d.id as type_table_id
                ,0 as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,d.users
                ,d.version                
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_manual d on d.scan_record_id = c.id
            where
                a.id >= ?
                and a.id <= ?
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and (a.action != \'COMPLETE\'
                    or b.action = \'DELETE\'
                    or d.action != \'COMPLETE\'
                )
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
            union
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'SIGNATURE\' as type
                ,d.id as type_table_id
                ,d.software_signature_id as type_id
                ,d.software_id
                ,d.path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_signature d on d.scan_record_id = c.id
            where
                a.id >= ?
                and a.id <= ?
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and (a.action != \'COMPLETE\'
                    or b.action = \'DELETE\'
                    or d.action != \'COMPLETE\'
               )
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
            union
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'FILTER\' as type
                ,d.id as type_table_id
                ,d.software_filter_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_filter d on d.scan_record_id = c.id
            where
                a.id >= ?
                and a.id <= ?
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and (a.action != \'COMPLETE\'
                    or b.action = \'DELETE\'
                    or d.action != \'COMPLETE\'
                )
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
            union
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'TLCMZ\' as type
                ,d.id as type_table_id
                ,d.sa_product_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_tlcmz d on d.scan_record_id = c.id
            where
                a.id >= ?
                and a.id <= ?
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and (a.action != \'COMPLETE\'
                    or b.action = \'DELETE\'
                    or d.action != \'COMPLETE\'
                )
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
            union
            select
                a.id as lpar_id
                ,a.customer_id
                ,a.computer_id
                ,a.object_id                
                ,a.name
                ,a.model
                ,a.bios_serial
                ,a.os_name
                ,a.os_type
                ,a.os_major_vers
                ,a.os_minor_vers
                ,a.os_sub_vers
                ,a.os_inst_date
                ,a.user_name
                ,a.bios_manufacturer
                ,a.bios_model
                ,a.server_type
                ,a.tech_img_id
                ,a.ext_id
                ,a.memory
                ,a.disk
                ,a.dedicated_processors
                ,a.total_processors
                ,a.shared_processors
                ,a.processor_type
                ,a.shared_proc_by_cores
                ,a.dedicated_proc_by_cores
                ,a.total_proc_by_cores
                ,a.alias
                ,a.physical_total_kb
                ,a.virtual_memory
                ,a.physical_free_memory
                ,a.virtual_free_memory
                ,a.node_capacity
                ,a.lpar_capacity
                ,a.bios_date
                ,a.bios_serial_number
                ,a.bios_unique_id
                ,a.board_serial
                ,a.case_serial
                ,a.case_asset_tag
                ,a.power_on_password                     
                ,a.processor_count
                ,a.scan_time
                ,a.status
                ,a.action
                ,b.id as map_id
                ,b.action
                ,c.id as scan_record_id
                ,c.computer_id as scan_record_computer_id
                ,c.bank_account_id
                ,c.scan_time as scan_record_scan_time
                ,c.authenticated
                ,c.action
                ,\'DORANA\' as type
                ,d.id as type_table_id
                ,d.dorana_product_id as type_id
                ,d.software_id
                ,\'NULL\' as path
                ,d.action
                ,c.users
                ,\'\'
            from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_dorana d on d.scan_record_id = c.id
            where
                a.id >= ?
                and a.id <= ?
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and (a.action != \'COMPLETE\'
                    or b.action = \'DELETE\'
                    or d.action != \'COMPLETE\'
                )
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x.lpar_id
            ,x.map_id
            ,x.scan_record_id
            ,x.software_id
        with ur
    ';
    dlog("querySoftwareLparIds=$query");
    return ( 'softwareLparDataByMinMaxIds', $query, \@fields );
}

sub queryIpAddressDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (
        qw(
            customerId
            name
            ipAddressId
            scanRecordId
            ipAddress
            hostname
            domain
            subnet
            ipAction
            gateway
            primaryDns
            secondaryDns
            isDhcp
            instanceId
            permMacAddress
            ipv6Address
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.customer_id
                ,a.name
                ,d.id as ip_address_id
                ,d.scan_record_id                                
                ,d.ip_address    
                ,d.hostname
                ,d.domain
                ,d.subnet   
                ,d.action 
                ,d.gateway
                ,d.primary_dns
                ,d.secondary_dns   
                ,d.is_dhcp
                ,d.instance_id  
                ,d.perm_mac_address              
                ,d.ipv6_address
            from 
                software_lpar a
                ,software_lpar_map b
                ,scan_record c
                ,ip_address d
            where
                a.id >= ?
                and a.id <= ?
                and a.action = \'COMPLETE\'
                and b.action = \'COMPLETE\'
                and c.action = \'COMPLETE\'
                and a.id = b.software_lpar_id
                and c.id = b.scan_record_id
                and d.scan_record_id = c.id

    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and d.action != \'COMPLETE\'
        ';
    }

    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x.customer_id
            ,x.ip_address_id
        with ur
    ';
    dlog("queryIpAddressIds=$query");
    return ( 'ipAddressDataByMinMaxIds', $query, \@fields );
}

sub queryHdiskDataByMinMaxIds {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = (
        qw(
            customerId
            name
            hdiskId
            scanRecordId
            model
            size
            manufacturer
            serialNumber
            storageType
            action
            )
    );
    my $query = '
        select * from (
    ';
    $query .= '
            select
                a.customer_id
                ,a.name
                ,d.id as hdisk_id
                ,d.scan_record_id                                
                ,d.model    
                ,d.size
                ,d.manufacturer
                ,d.serial_number   
                ,d.storage_type
                ,d.action 
            from 
                software_lpar a
                ,software_lpar_map b
                ,scan_record c
                ,hdisk d
            where
                a.id >= ?
                and a.id <= ?
                and a.action = \'COMPLETE\'
                and b.action = \'COMPLETE\'
                and c.action = \'COMPLETE\'
                and a.id = b.software_lpar_id
                and c.id = b.scan_record_id
                and d.scan_record_id = c.id                
    ';
    if ( $deltaOnly == 1 ) {
        $query .= '
                and d.action != \'COMPLETE\'
        ';
    }
    if ( $testMode == 1 ) {
        $query .= '
                and a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
    }
    $query .= '
        ) as x
        order by
            x.customer_id
            ,x.hdisk_id
        with ur
    ';
    dlog("queryHdiskIds=$query");
    return ( 'hdiskDataByMinMaxIds', $query, \@fields );
}

sub queryLparMaps {
    my @fields = (
        qw(
            scanRecordId
            scanRecordComputerId
            scanRecordName
            scanRecordObjectId
            scanRecordModel
            scanRecordSerialNumber
            scanRecordScanTime
            scanRecordOsName
            scanRecordOsType
            scanRecordOsMajor
            scanRecordOsMinor
            scanRecordOsSub
            scanRecordOsInst
            scanRecordUserName
            scanRecordManufacturer
            scanRecordBiosModel
            scanRecordServerType
            scanRecordTechImageId
            scanRecordExtId
            scanRecordMemory
            scanRecordDisk
            scanRecordDedicatedProcessors
            scanRecordTotalProcessors
            scanRecordSharedProcessors
            scanRecordProcessorType
            scanRecordSharedProcByCores
            scanRecordDedicatedProcByCores
            scanRecordTotalProcByCores
            scanRecordAlias
            scanRecordPhysicalTotalKb
            scanRecordVirtualMemory
            scanRecordPhysicalFreeMemory
            scanRecordVirtualFreeMemory
            scanRecordNodeCapacity
            scanRecordLparCapacity
            scanRecordBiosDate
            scanRecordBiosSerialNumber
            scanRecordBiosUniqueId
            scanRecordBoardSerial
            scanRecordCaseSerial
            scanRecordCaseAssetTag
            scanRecordPowerOnPassword
            scanRecordProcessorCount
            users
            authenticated
            bankAccountId
            isManual
            scanRecordAction
            softwareLparId
            customerId
            softwareLparComputerId
            softwareLparObjectId
            softwareLparName
            softwareLparModel
            softwareLparSerialNumber
            softwareLparOsName
            softwareLparOsType
            softwareLparOsMajor
            softwareLparOsMinor
            softwareLparOsSub
            softwareLparOsInst
            softwareLparUserName
            softwareLparManufacturer
            softwareLparBiosModel
            softwareLparServerType
            softwareLparTechImageId
            softwareLparExtId
            softwareLparMemory
            softwareLparDisk
            softwareLparDedicatedProcessors
            softwareLparTotalProcessors
            softwareLparSharedProcessors
            softwareLparProcessorType
            softwareLparSharedProcByCores
            softwareLparDedicatedProcByCores
            softwareLparTotalProcByCores
            softwareLparAlias
            softwareLparPhysicalTotalKb
            softwareLparVirtualMemory
            softwareLparPhysicalFreeMemory
            softwareLparVirtualFreeMemory
            softwareLparNodeCapacity
            softwareLparLparCapacity
            softwareLparBiosDate
            softwareLparBiosSerialNumber
            softwareLparBiosUniqueId
            softwareLparBoardSerial
            softwareLparCaseSerial
            softwareLparCaseAssetTag
            softwareLparPowerOnPassword
            softwareLparProcessorCount
            softwareLparScanTime
            softwareLparStatus
            softwareLparAction
            softwareLparMapId
            softwareLparMapAction)
    );

    my $query = '
        select
            T.sr_id
            ,T.sr_computer_id
            ,T.sr_name
            ,T.sr_object_id
            ,T.sr_model
            ,T.serial_number
            ,T.sr_scan_time
            ,T.sr_os_name
            ,T.sr_os_type
            ,T.sr_os_major_vers
            ,T.sr_os_minor_vers
            ,T.sr_os_sub_vers
            ,T.sr_os_inst_date
            ,T.sr_user_name
            ,T.sr_bios_manufacturer
            ,T.sr_bios_model
            ,T.sr_server_type
            ,T.sr_tech_img_id
            ,T.sr_ext_id
            ,T.sr_memory
            ,T.sr_disk
            ,T.sr_dedicated_processors
            ,T.sr_total_processors
            ,T.sr_shared_processors
            ,T.sr_processor_type
            ,T.sr_shared_proc_by_cores
            ,T.sr_dedicated_proc_by_cores
            ,T.sr_total_proc_by_cores
            ,T.sr_alias
            ,T.sr_physical_total_kb
            ,T.sr_virtual_memory
            ,T.sr_physical_free_memory
            ,T.sr_virtual_free_memory
            ,T.sr_node_capacity
            ,T.sr_lpar_capacity
            ,T.sr_bios_date
            ,T.sr_bios_serial_number
            ,T.sr_bios_unique_id
            ,T.sr_board_serial
            ,T.sr_case_serial
            ,T.sr_case_asset_tag
            ,T.sr_power_on_password            
            ,T.sr_processor_count
            ,T.users
            ,T.authenticated
            ,T.bank_account_id
            ,T.is_manual
            ,T.sr_action
            ,T.sl_id
            ,T.customer_id
            ,T.sl_computer_id
            ,T.sl_object_id
            ,T.sl_name
            ,T.sl_model
            ,T.bios_serial   
            ,T.sl_os_name
            ,T.sl_os_type
            ,T.sl_os_major_vers
            ,T.sl_os_minor_vers
            ,T.sl_os_sub_vers
            ,T.sl_os_inst_date
            ,T.sl_user_name
            ,T.sl_bios_manufacturer
            ,T.sl_bios_model
            ,T.sl_server_type
            ,T.sl_tech_img_id
            ,T.sl_ext_id
            ,T.sl_memory
            ,T.sl_disk
            ,T.sl_dedicated_processors
            ,T.sl_total_processors
            ,T.sl_shared_processors
            ,T.sl_processor_type
            ,T.sl_shared_proc_by_cores
            ,T.sl_dedicated_proc_by_cores
            ,T.sl_total_proc_by_cores
            ,T.sl_alias
            ,T.sl_physical_total_kb
            ,T.sl_virtual_memory
            ,T.sl_physical_free_memory
            ,T.sl_virtual_free_memory
            ,T.sl_node_capacity
            ,T.sl_lpar_capacity
            ,T.sl_bios_date
            ,T.sl_bios_serial_number
            ,T.sl_bios_unique_id
            ,T.sl_board_serial
            ,T.sl_case_serial
            ,T.sl_case_asset_tag
            ,T.sl_power_on_password                        
            ,T.sl_processor_count
            ,T.sl_scan_time
            ,T.status
            ,T.sl_action
            ,T.sl_map_id
            ,T.sl_map_action
        from (
        select
            a.id as sr_id
            ,a.computer_id as sr_computer_id
            ,a.name as sr_name
            ,a.object_id as sr_object_id
            ,a.model as sr_model
            ,a.serial_number
            ,a.scan_time as sr_scan_time
            ,a.os_name as sr_os_name
            ,a.os_type as sr_os_type
            ,a.os_major_vers as sr_os_major_vers
            ,a.os_minor_vers as sr_os_minor_vers
            ,a.os_sub_vers as sr_os_sub_vers
            ,a.os_inst_date as sr_os_inst_date
            ,a.user_name as sr_user_name
            ,a.bios_manufacturer as sr_bios_manufacturer
            ,a.bios_model  as sr_bios_model
            ,a.server_type as sr_server_type
            ,a.tech_img_id as sr_tech_img_id
            ,a.ext_id as sr_ext_id
            ,a.memory as sr_memory
            ,a.disk as sr_disk
            ,a.dedicated_processors as sr_dedicated_processors
            ,a.total_processors as sr_total_processors
            ,a.shared_processors as sr_shared_processors
            ,a.processor_type as sr_processor_type
            ,a.shared_proc_by_cores as sr_shared_proc_by_cores
            ,a.dedicated_proc_by_cores as sr_dedicated_proc_by_cores
            ,a.total_proc_by_cores as sr_total_proc_by_cores
            ,a.alias as sr_alias
            ,a.physical_total_kb as sr_physical_total_kb
            ,a.virtual_memory as sr_virtual_memory
            ,a.physical_free_memory as sr_physical_free_memory
            ,a.virtual_free_memory as sr_virtual_free_memory
            ,a.node_capacity as sr_node_capacity
            ,a.lpar_capacity as sr_lpar_capacity
            ,a.bios_date as sr_bios_date
            ,a.bios_serial_number as sr_bios_serial_number
            ,a.bios_unique_id as sr_bios_unique_id
            ,a.board_serial as sr_board_serial
            ,a.case_serial as sr_case_serial
            ,a.case_asset_tag as sr_case_asset_tag
            ,a.power_on_password as sr_power_on_password              
            ,a.processor_count as sr_processor_count
            ,a.users
            ,a.authenticated
            ,a.bank_account_id
            ,a.is_manual
            ,a.action as sr_action
            ,b.id as sl_id
            ,b.customer_id
            ,b.computer_id as sl_computer_id
            ,b.object_id as sl_object_id   
            ,b.name as sl_name
            ,b.model as sl_model
            ,b.bios_serial
            ,b.os_name as sl_os_name
            ,b.os_type as sl_os_type
            ,b.os_major_vers as sl_os_major_vers
            ,b.os_minor_vers as sl_os_minor_vers
            ,b.os_sub_vers as sl_os_sub_vers
            ,b.os_inst_date as sl_os_inst_date
            ,b.user_name as sl_user_name
            ,b.bios_manufacturer as sl_bios_manufacturer
            ,b.bios_model  as sl_bios_model
            ,b.server_type as sl_server_type
            ,b.tech_img_id as sl_tech_img_id
            ,b.ext_id as sl_ext_id
            ,b.memory as sl_memory
            ,b.disk as sl_disk
            ,b.dedicated_processors as sl_dedicated_processors
            ,b.total_processors as sl_total_processors
            ,b.shared_processors as sl_shared_processors
            ,b.processor_type as sl_processor_type
            ,b.shared_proc_by_cores as sl_shared_proc_by_cores
            ,b.dedicated_proc_by_cores as sl_dedicated_proc_by_cores
            ,b.total_proc_by_cores as sl_total_proc_by_cores
            ,b.alias as sl_alias
            ,b.physical_total_kb as sl_physical_total_kb
            ,b.virtual_memory as sl_virtual_memory
            ,b.physical_free_memory as sl_physical_free_memory
            ,b.virtual_free_memory as sl_virtual_free_memory
            ,b.node_capacity as sl_node_capacity
            ,b.lpar_capacity as sl_lpar_capacity
            ,b.bios_date as sl_bios_date
            ,b.bios_serial_number as sl_bios_serial_number
            ,b.bios_unique_id as sl_bios_unique_id
            ,b.board_serial as sl_board_serial
            ,b.case_serial as sl_case_serial
            ,b.case_asset_tag as sl_case_asset_tag
            ,b.power_on_password as sl_power_on_password                          
            ,b.processor_count as sl_processor_count
            ,b.scan_time as sl_scan_time
            ,b.status
            ,b.action as sl_action
            ,c.id as sl_map_id
            ,c.action as sl_map_action
        from
            scan_record a
            left outer join software_lpar_map c on
                a.id = c.scan_record_id
            left outer join software_lpar b on
                b.id = c.software_lpar_id
        union
        select
            a.id as sr_id
            ,a.computer_id as sr_computer_id
            ,a.name as sr_name
            ,a.object_id as sr_object_id
            ,a.model as sr_model
            ,a.serial_number
            ,a.scan_time as sr_scan_time
            ,a.os_name as sr_os_name
            ,a.os_type as sr_os_type
            ,a.os_major_vers as sr_os_major_vers
            ,a.os_minor_vers as sr_os_minor_vers
            ,a.os_sub_vers as sr_os_sub_vers
            ,a.os_inst_date as sr_os_inst_date
            ,a.user_name as sr_user_name
            ,a.bios_manufacturer as sr_bios_manufacturer
            ,a.bios_model  as sr_bios_model
            ,a.server_type as sr_server_type
            ,a.tech_img_id as sr_tech_img_id
            ,a.ext_id as sr_ext_id
            ,a.memory as sr_memory
            ,a.disk as sr_disk
            ,a.dedicated_processors as sr_dedicated_processors
            ,a.total_processors as sr_total_processors
            ,a.shared_processors as sr_shared_processors
            ,a.processor_type as sr_processor_type
            ,a.shared_proc_by_cores as sr_shared_proc_by_cores
            ,a.dedicated_proc_by_cores as sr_dedicated_proc_by_cores
            ,a.total_proc_by_cores as sr_total_proc_by_cores
            ,a.alias as sr_alias
            ,a.physical_total_kb as sr_physical_total_kb
            ,a.virtual_memory as sr_virtual_memory
            ,a.physical_free_memory as sr_physical_free_memory
            ,a.virtual_free_memory as sr_virtual_free_memory
            ,a.node_capacity as sr_node_capacity
            ,a.lpar_capacity as sr_lpar_capacity
            ,a.bios_date as sr_bios_date
            ,a.bios_serial_number as sr_bios_serial_number
            ,a.bios_unique_id as sr_bios_unique_id
            ,a.board_serial as sr_board_serial
            ,a.case_serial as sr_case_serial
            ,a.case_asset_tag as sr_case_asset_tag
            ,a.power_on_password as sr_power_on_password              
            ,a.processor_count as sr_processor_count
            ,a.users
            ,a.authenticated
            ,a.bank_account_id
            ,a.is_manual
            ,a.action as sr_action
            ,b.id as sl_id
            ,b.customer_id
            ,b.computer_id as sl_computer_id
            ,b.object_id as sl_object_id   
            ,b.name as sl_name
            ,b.model as sl_model
            ,b.bios_serial
            ,b.os_name as sl_os_name
            ,b.os_type as sl_os_type
            ,b.os_major_vers as sl_os_major_vers
            ,b.os_minor_vers as sl_os_minor_vers
            ,b.os_sub_vers as sl_os_sub_vers
            ,b.os_inst_date as sl_os_inst_date
            ,b.user_name as sl_user_name
            ,b.bios_manufacturer as sl_bios_manufacturer
            ,b.bios_model  as sl_bios_model
            ,b.server_type as sl_server_type
            ,b.tech_img_id as sl_tech_img_id
            ,b.ext_id as sl_ext_id
            ,b.memory as sl_memory
            ,b.disk as sl_disk
            ,b.dedicated_processors as sl_dedicated_processors
            ,b.total_processors as sl_total_processors
            ,b.shared_processors as sl_shared_processors
            ,b.processor_type as sl_processor_type
            ,b.shared_proc_by_cores as sl_shared_proc_by_cores
            ,b.dedicated_proc_by_cores as sl_dedicated_proc_by_cores
            ,b.total_proc_by_cores as sl_total_proc_by_cores
            ,b.alias as sl_alias
            ,b.physical_total_kb as sl_physical_total_kb
            ,b.virtual_memory as sl_virtual_memory
            ,b.physical_free_memory as sl_physical_free_memory
            ,b.virtual_free_memory as sl_virtual_free_memory
            ,b.node_capacity as sl_node_capacity
            ,b.lpar_capacity as sl_lpar_capacity
            ,b.bios_date as sl_bios_date
            ,b.bios_serial_number as sl_bios_serial_number
            ,b.bios_unique_id as sl_bios_unique_id
            ,b.board_serial as sl_board_serial
            ,b.case_serial as sl_case_serial
            ,b.case_asset_tag as sl_case_asset_tag
            ,b.power_on_password as sl_power_on_password                          
            ,b.processor_count as sl_processor_count
            ,b.scan_time as sl_scan_time
            ,b.status
            ,b.action as sl_action
            ,c.id as sl_map_id
            ,c.action as sl_map_action
        from
            software_lpar b
            left outer join software_lpar_map c on
                b.id = c.software_lpar_id
            left outer join scan_record a on
                a.id = c.scan_record_id
        ) as T
        order by
           T.is_manual ASC
           ,T.sr_scan_time DESC
        with ur
    ';
    dlog("queryLparMaps=$query");
    return ( 'lparMaps', $query, \@fields );
}

sub queryLicenseLastUpdate {
    my ( $self, $deltaOnly ) = @_;
    my @fields = (
        qw(
            lastUpdate
            )
    );
    my $query = '
        select
            max(a.swcm_record_time)
        from
            license a
        with ur
    ';

    dlog("queryLicenseLastUpdate=$query");
    return ( 'licenseLastUpdate', $query, \@fields );
}

sub queryLicenseData {
    my ( $self, $testMode, $deltaOnly ) = @_;
    my @fields = qw(
        id
        extSrcId
        licType
        capType
        customerId
        softwareId
        quantity
        ibmOwned
        draft
        pool
        tryAndBuy
        expireDate
        endDate
        poNumber
        prodName
        fullDesc
        version
        cpuSerial
        licenseStatus
        swcmRecordTime
        agreementType
        environment
        status
        action
    );
    my $query = '
        select
            a.id
            ,a.ext_src_id
            ,a.lic_type
            ,a.cap_type
            ,a.customer_id
            ,a.software_id            
            ,a.quantity
            ,a.ibm_owned  
            ,a.draft
            ,a.pool
            ,a.try_and_buy            
            ,a.expire_date
            ,a.end_date
            ,a.po_number
            ,a.prod_name
            ,a.full_desc
            ,a.version
            ,a.cpu_serial
            ,a.license_status
            ,a.swcm_record_time  
            ,a.agreement_type
            ,a.environment
            ,a.status          
            ,a.action
        from
            license a
    ';
    my $clause = 'where';

    if ( $deltaOnly == 1 ) {
        $query .= '
        ' . $clause . '
            a.action != \'COMPLETE\'
        ';
        $clause = 'and';
    }
    if ( $testMode == 1 ) {
        $query .= '
        ' . $clause . '
                a.customer_id in (' . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
        $clause = 'and';
    }
    $query .= '
        with ur
    ';
    dlog("queryLicenseData=$query");
    return ( 'licenseData', $query, \@fields );
}

sub queryHwLastUpdate {
    my ( $self, $deltaOnly ) = @_;
    my @fields = (
        qw(
            hwDate
            lparDate
            )
    );
    my $query = '
        select
            max(a.update_date)
            ,max(b.update_date)
        from
            hardware a
            left outer join hardware_lpar b
                on a.id = b.hardware_id
        with ur
    ';

    dlog("queryHwLastUpdate=$query");
    return ( 'hwLastUpdate', $query, \@fields );
}

sub markHardwareAsError {
    my ( $self, $connection, $id ) = @_;

    $connection->prepareSqlQuery( $self->queryMarkHardwareAsError() );

    my $sth = $connection->sql->{markHardwareAsError};
    $sth->execute($id);
    $sth->finish;
}

sub queryMarkHardwareAsError {
    my $query = '
        update hardware
        set
            action = \'ERROR\'
        where
            id = ?
    ';
    return ( 'markHardwareAsError', $query );
}

sub markHardwareLparAsError {
    my ( $self, $connection, $id ) = @_;

    $connection->prepareSqlQuery( $self->queryMarkHardwareLparAsError() );

    my $sth = $connection->sql->{markHardwareLparAsError};
    $sth->execute($id);
    $sth->finish;
}

sub queryMarkHardwareLparAsError {
    my $query = '
        update hardware_lpar
        set
            action = \'ERROR\'
        where
            id = ?
    ';
    return ( 'markHardwareLparAsError', $query );
}

sub markEffectiveProcessorAsError {
    my ( $self, $connection, $id ) = @_;

    $connection->prepareSqlQuery( $self->queryMarkEffectiveProcessorAsError() );

    my $sth = $connection->sql->{markEffectiveProcessorAsError};
    $sth->execute($id);
    $sth->finish;
}

sub queryMarkEffectiveProcessorAsError {
    my $query = '
        update effective_processor
        set
            action = \'ERROR\'
        where
            id = ?
    ';
    return ( 'markEffectiveProcessorAsError', $query );
}

sub getStagingScanRecordsBySoftwareLpar {
    my ( $self, $connection, $swLpar ) = @_;

    my @scanRecords = ();

    $connection->prepareSqlQueryAndFields( $self->queryStagingScanRecordsBySoftwareLpar() );
    my $sth = $connection->sql->{stagingScanRecordsBySoftwareLpar};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{stagingScanRecordsBySoftwareLparFields} } );
    $sth->execute( $swLpar->customerId, $swLpar->name );
    while ( $sth->fetchrow_arrayref ) {

        my $scanRecord = new Staging::OM::ScanRecord;
        $scanRecord->id( $rec{id} );
        $scanRecord->getById($connection);

        push @scanRecords, $scanRecord;
    }
    $sth->finish;

    return @scanRecords;
}

sub queryStagingScanRecordsBySoftwareLpar {
    my @fields = qw( id );
    my $query  = '
        select
            sr.id
        from
            software_lpar sl
            join software_lpar_map slm on slm.software_lpar_id = sl.id
            join scan_record sr on sr.id = slm.scan_record_id
        where
            sl.customer_id = ?
            and sl.name = ?
    ';

    return ( 'stagingScanRecordsBySoftwareLpar', $query, \@fields );
}

sub queryScanSoftwareItemData {
	my ($self, $deltaOnly, $bankAccountId) = @_;
	my $query = '
        select
            a.id
            ,a.scan_record_id
            ,a.guid
            ,a.last_used
            ,a.use_count
            ,a.action
            ,b.bank_account_id
        from
            scan_software_item a
           ,scan_record b 
     where a.scan_record_id=b.id and b.bank_account_id = ' . $bankAccountId ;
	my $clause = ' and ' ;

	if ( $deltaOnly == 1 ) {
		$query .= '
        ' . $clause . '
            a.action != 0
         with ur ';
	}else {
		$query .= ' with ur';
	}
   dlog($query);
	return ( 'scanSoftwareItemData', $query );
}


sub getScanRecordHdiskBatches {
	my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

	my @scanRecordIds = ();

	###Prepare query to pull  ids from staging for Ip addresses
	dlog("preparing Scan Record ids for hdisk query");
	$connection->prepareSqlQueryAndFields(
		$self->queryScanRecordHdiskIds( $testMode, $loadDeltaOnly ) );
	dlog("prepared Scan Record ids for hdisk query");

	###Get the statement handle
	dlog("getting sth for Scan Record ids for hdisk query");
	my $sth = $connection->sql->{scanRecordHdiskIds};
	dlog("got sth for Scan Record ids for hdisk query");

	###Bind our columns
	my %rec;
	dlog("binding columns for Scan Record ids for hdisk query");
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{scanRecordHdiskIdsFields} } );
	dlog("binded columns for Scan Record ids for hdisk query");

	###Excute the query
	ilog("executing Scan Record ids for hdisk query");
	$sth->execute();
	ilog("executed Scan Record ids for hdisk query");

	while ( $sth->fetchrow_arrayref ) {

		###Clean record values
		cleanValues( \%rec );

		push( @scanRecordIds, $rec{id} );
	}
	ilog( "got scan Record ids, count: " . scalar(@scanRecordIds) );
	ilog( "min id=" . $scanRecordIds[0] );
	ilog( "max id=" . $scanRecordIds[$#scanRecordIds] );

	###
	###Calculate the batches of MaxLparsInQuery.
	###
	my @idBatches = ();
	my $firstIndex;
	my $lastIndex;
	for ( my $i = 0 ; $i <= $#scanRecordIds ; $i++ ) {
		if ( $i == 0 ) {
			$firstIndex = 0;
		}
		elsif ( $firstIndex < $i && $i < $lastIndex ) {
			next;
		}
		elsif ( $lastIndex == $#scanRecordIds ) {
			last;
		}
		else {
			$firstIndex = $lastIndex + 1;
		}
		$lastIndex = $firstIndex + $maxLparsInQuery - 1;
		$lastIndex =
		  ( $lastIndex > $#scanRecordIds ) ? $#scanRecordIds : $lastIndex;
		push( @idBatches,
			"$scanRecordIds[$firstIndex],$scanRecordIds[$lastIndex]" );
	}
	ilog( "id batches count: " . scalar(@idBatches) );

	return @idBatches;
}

sub queryScanRecordHdiskIds {
	my ( $self, $testMode, $deltaOnly ) = @_;
	my @fields = (qw( id ));
	my $query  = '
        select
            a.id
        from 
            scan_record a 
            join hdisk b on b.scan_record_id = a.id
        where
            a.action = \'COMPLETE\'
    ';
	my $clause = 'and';
	if ( $deltaOnly == 1 ) {
		$query .= '
        ' . $clause . ' (
            b.action != \'COMPLETE\')
        ';
		$clause = 'and';
	}
	if ( $testMode == 1 ) {
		$query .= '
                and a.customer_id in ('
		  . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
	}
	$query .= '
        group by
            a.id
        order by
            a.id
        with ur
    ';
	dlog("queryScanRecordHdiskIds=$query");
	return ( 'scanRecordHdiskIds', $query, \@fields );
}


sub getScanRecordMemModBatches {
	my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

	my @scanRecordIds = ();

	###Prepare query to pull Scan Record ids from staging for Ip addresses
	dlog("preparing Scan Record ids for memmod query");
	$connection->prepareSqlQueryAndFields(
		$self->queryScanRecordMemModIds( $testMode, $loadDeltaOnly ) );
	dlog("prepared Scan Record ids for memmod query");

	###Get the statement handle
	dlog("getting sth for Scan Record ids for memmod query");
	my $sth = $connection->sql->{scanRecordMemModIds};
	dlog("got sth for Scan Record ids for memmod query");

	###Bind our columns
	my %rec;
	dlog("binding columns for Scan Record ids for memmod query");
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{scanRecordMemModIdsFields} } );
	dlog("binded columns for Scan Record ids for memmod query");

	###Excute the query
	ilog("executing Scan Record ids for memmod query");
	$sth->execute();
	ilog("executed Scan Record ids for memmod query");

	while ( $sth->fetchrow_arrayref ) {

		###Clean record values
		cleanValues( \%rec );

		push( @scanRecordIds, $rec{id} );
	}
	ilog( "got scan Record ids, count: " . scalar(@scanRecordIds) );
	ilog( "min id=" . $scanRecordIds[0] );
	ilog( "max id=" . $scanRecordIds[$#scanRecordIds] );

	###
	###Calculate the batches of MaxLparsInQuery.
	###
	my @idBatches = ();
	my $firstIndex;
	my $lastIndex;
	for ( my $i = 0 ; $i <= $#scanRecordIds ; $i++ ) {
		if ( $i == 0 ) {
			$firstIndex = 0;
		}
		elsif ( $firstIndex < $i && $i < $lastIndex ) {
			next;
		}
		elsif ( $lastIndex == $#scanRecordIds ) {
			last;
		}
		else {
			$firstIndex = $lastIndex + 1;
		}
		$lastIndex = $firstIndex + $maxLparsInQuery - 1;
		$lastIndex =
		  ( $lastIndex > $#scanRecordIds ) ? $#scanRecordIds : $lastIndex;
		push( @idBatches,
			"$scanRecordIds[$firstIndex],$scanRecordIds[$lastIndex]" );
	}
	ilog( "id batches count: " . scalar(@idBatches) );

	return @idBatches;
}

sub queryScanRecordMemModIds {
	my ( $self, $testMode, $deltaOnly ) = @_;
	my @fields = (qw( id ));
	my $query  = '
        select
            distinct a.id
        from 
            scan_record a 
            join mem_mod b on b.scan_record_id = a.id
        where
            a.action = \'COMPLETE\'
    ';
	my $clause = 'and';
	if ( $deltaOnly == 1 ) {
		$query .= '
        ' . $clause . ' (
            b.action != \'COMPLETE\')
        ';
		$clause = 'and';
	}
	if ( $testMode == 1 ) {
		$query .= '
                and a.customer_id in ('
		  . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
	}
	$query .= '
        order by
            a.id
        with ur
    ';
	dlog("queryScanRecordMemModIds=$query");
	return ( 'scanRecordMemModIds', $query, \@fields );
}

sub getScanRecordIpBatches {
	my ( $self, $connection, $testMode, $loadDeltaOnly, $maxLparsInQuery ) = @_;

	my @scanRecordIds = ();

	###Prepare query to pull  ids from staging for Ip addresses
	dlog("preparing Scan Record ids for ip addresses query");
	$connection->prepareSqlQueryAndFields(
		$self->queryScanRecordIpIds( $testMode, $loadDeltaOnly ) );
	dlog("prepared Scan Record ids for ip addresses query");

	###Get the statement handle
	dlog("getting sth for Scan Record ids for ip addresses query");
	my $sth = $connection->sql->{scanRecordIpIds};
	dlog("got sth for Scan Record ids for ip addresses query");

	###Bind our columns
	my %rec;
	dlog("binding columns for Scan Record ids for ip addresses query");
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{scanRecordIpIdsFields} } );
	dlog("binded columns for Scan Record ids for ip addresses query");

	###Excute the query
	ilog("executing Scan Record ids for ip addresses query");
	$sth->execute();
	ilog("executed Scan Record ids for ip addresses query");

	while ( $sth->fetchrow_arrayref ) {

		###Clean record values
		cleanValues( \%rec );

		push( @scanRecordIds, $rec{id} );
	}
	ilog( "got scan Record ids, count: " . scalar(@scanRecordIds) );
	ilog( "min id=" . $scanRecordIds[0] );
	ilog( "max id=" . $scanRecordIds[$#scanRecordIds] );

	###
	###Calculate the batches of MaxLparsInQuery.
	###
	my @idBatches = ();
	my $firstIndex;
	my $lastIndex;
	for ( my $i = 0 ; $i <= $#scanRecordIds ; $i++ ) {
		if ( $i == 0 ) {
			$firstIndex = 0;
		}
		elsif ( $firstIndex < $i && $i < $lastIndex ) {
			next;
		}
		elsif ( $lastIndex == $#scanRecordIds ) {
			last;
		}
		else {
			$firstIndex = $lastIndex + 1;
		}
		$lastIndex = $firstIndex + $maxLparsInQuery - 1;
		$lastIndex =
		  ( $lastIndex > $#scanRecordIds ) ? $#scanRecordIds : $lastIndex;
		push( @idBatches,
			"$scanRecordIds[$firstIndex],$scanRecordIds[$lastIndex]" );
	}
	ilog( "id batches count: " . scalar(@idBatches) );

	return @idBatches;
}

sub queryScanRecordIpIds {
	my ( $self, $testMode, $deltaOnly ) = @_;
	my @fields = (qw( id ));
	my $query  = '
        select
            distinct a.id
        from 
            scan_record a 
            join ip_address b on b.scan_record_id = a.id
        where
            a.action = \'COMPLETE\'
    ';
	my $clause = 'and';
	if ( $deltaOnly == 1 ) {
		$query .= '
        ' . $clause . ' (
            b.action != \'COMPLETE\')
        ';
		$clause = 'and';
	}
	if ( $testMode == 1 ) {
		$query .= '
                and a.customer_id in ('
		  . Base::ConfigManager->instance()->testCustomerIdsAsString() . ')';
	}
	$query .= '
        order by
            a.id
        with ur
    ';
	dlog("queryScanRecordIpIds=$query");
	return ( 'scanRecordIpIds', $query, \@fields );
}

1;

