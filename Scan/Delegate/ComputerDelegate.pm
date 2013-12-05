package ComputerDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Scan::Delegate::ScanDelegate;
use Scan::Delegate::ScanTADzDelegate;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

# String to hold the correct TADz SQL
my $tadzSQL;

###TODO this probably should be broken out into respective delegates...its getting big
###TODO need to take into account processor counts for bank accounts other than tcm


sub getScanRecordData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getScanRecordData method');

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        return $self->getConnectedScanRecordData( $connection, $bankAccount, $delta );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        return $self->getDisconnectedScanRecordData( $bankAccount, $delta );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedScanRecordData {
    my ( $self, $bankAccount, $delta ) = @_;

    dlog('in the getDisconnectedScanRecordData method');

    my $filePart = 'computer';

    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );

    my %scanList;

    if ($fileToProcess) {
        dlog("processing $fileToProcess");

        dlog('Creating tsv object');
        my $tsv = Text::CSV_XS->new(
                                     {
                                       sep_char    => "\t",
                                       binary      => 1,
                                       eol         => $/,
                                       escape_char => '',
                                       quote_char  => ''
                                     }
        );
        dlog('tsv object created');

        dlog('opening gzipped file');
        my $gz = gzopen( "$fileToProcess", "rb" )
            or die "Cannot open $fileToProcess: $gzerrno\n";
        dlog('gzipped file open');

        my $line;
        dlog('looping through gzip lines');
        my @fields = (
            qw(computerId
                scanTime
                objectId
                name
                model
                serialNumber
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
                recordTime
                acqTime
                techImgId
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
                )
        );

        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);

            my $index = 0;
            my %rec = map { $fields[ $index++ ] => $_ } $tsv->fields();

            ###Need to add some fields to disconnected
            $rec{processorCount} = 0;
            $rec{isManual}       = 0;
            $rec{users}          = 0;
            $rec{authenticated}  = 2;

            my $sr = $self->buildScanRecord( \%rec, $bankAccount );
            next if ( !defined $sr );

            ###Add the scan record to the list
            $scanList{ $rec{computerId} } = $sr
                if ( !exists $scanList{ $rec{computerId} } );
        }

        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
            if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    if ( $bankAccount->authenticatedData eq 'Y' ) {
        ###WE are going to need to alter this to for the counts are done differently for tcm environments
        ###vs everything else
        dlog('parsing the processor file now');

        $filePart = 'cpu_count';
        dlog("filePart=$filePart");

        $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );
        dlog("fileToProcess=$fileToProcess");

        if ($fileToProcess) {
            dlog("processing $fileToProcess");

            dlog('creating tsv object');
            my $tsv = Text::CSV_XS->new( { sep_char => "\t", binary => 1, eol => $/ } );
            dlog('tsv object created');

            dlog('opening gzipped file');
            my $gz = gzopen( "$fileToProcess", "rb" )
                or die "Cannot open $fileToProcess: $gzerrno\n";
            dlog('gzipped file open');

            my $line;
            my %data;
            dlog('looping through gzip lines');
            my @fields = (qw(computerId htStatus logical physical acqTime));
            while ( $gz->gzreadline($line) > 0 ) {

                ###TODO: ALEX I ADDED THESE 2 LINES
                my $status = $tsv->parse($line);

                my $index = 0;
                my %rec = map { $fields[ $index++ ] => $_ } $tsv->fields();
                cleanValues( \%rec );
                upperValues( \%rec );

                if ( defined $rec{physical} && $rec{physical} != '' ) {
                    if ( exists $scanList{ $rec{computerId} } ) {
                        $scanList{ $rec{computerId} }->processorCount( $rec{physical} );
                    }
                }
            }

            die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
                if $gzerrno != Z_STREAM_END;

            $gz->gzclose();
        }
    }
    else {
        dlog("no $filePart to process");
    }

    ###WE are going to need to alter this to for the counts are done differently for tcm environments
    ###vs everything else
    dlog('parsing the processor file now');

    $filePart = 'processor';
    dlog("filePart=$filePart");

    $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );
    dlog("fileToProcess=$fileToProcess");

    if ($fileToProcess) {
        dlog("processing $fileToProcess");

        dlog('creating tsv object');
        my $tsv = Text::CSV_XS->new( { sep_char => "\t", binary => 1, eol => $/ } );
        dlog('tsv object created');

        dlog('opening gzipped file');
        my $gz = gzopen( "$fileToProcess", "rb" )
            or die "Cannot open $fileToProcess: $gzerrno\n";
        dlog('gzipped file open');

        my $line;
        my %data;
        dlog('looping through gzip lines');
        my @fields = (qw(computerId processorCount recordTime acqTime));
        while ( $gz->gzreadline($line) > 0 ) {
            my $index = 0;

            ###TODO: ALEX I ADDED THESE 2 LINES
            my $status = $tsv->parse($line);

            my %rec = map { $fields[ $index++ ] => $_ } $tsv->fields();
            cleanValues( \%rec );
            upperValues( \%rec );

            ###TODO: ALEX I CHANGED THIS NEXT LINE, WAS=>$rec{physical}
            if ( defined $rec{processorCount} && $rec{processorCount} != '' ) {
                if ( $bankAccount->type eq 'TCM' ) {
                    $data{ $rec{computerId} }++;
                }
                else {
                    $data{ $rec{computerId} } = $rec{processorCount};
                }
            }
        }

        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
            if $gzerrno != Z_STREAM_END;

        $gz->gzclose();

        dlog('Looping through processors');
        foreach my $computerId ( keys %data ) {
            if ( exists $scanList{$computerId} ) {
                $scanList{$computerId}->processorCount( $data{$computerId} )
                    if ( $scanList{$computerId}->processorCount == 0 );
            }
        }
    }
    else {
        dlog("no $filePart to process");
    }

    ###Return the lists
    return ( \%scanList );
}

sub getCustomerId {
    my ( $self, $scanRecord, $mapService ) = @_;
    ###add customer id from map service for each scan record.
    dlog('Start looping for adding customer id');
    my $customerId = $mapService->getCustomerId($scanRecord);
    if ( $customerId =~ m/\D/ ) {
        $customerId = 999999;
    }
    return $customerId;
    dlog('End looping for adding customer id');
}

sub getConnectedScanRecordData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    my $max;

    dlog('in getConnectedScanRecordData method');
    if ($delta) {
        dlog('Only pulling deltas');

        dlog( 'Determining max scantime for ' . $bankAccount->name );
        $max = ScanRecordDelegate->getMaxScanTimeByBankAccount($bankAccount);
        dlog("max=$max");
    }

    dlog('Preparing the computer query');
    my $sth;
    if ($max) {
        if ( $bankAccount->type eq 'SW_DISCREPANCY' ) {
            $connection->prepareSqlQuery( queryComputerDiscrepancyDeltaData() );
            $sth = $connection->sql->{computerDiscrepancyDeltaData};
        }
        elsif ( $bankAccount->type eq 'TLCMZ' ) {
            $connection->prepareSqlQuery( queryComputerTlcmzDeltaData() );
            $sth = $connection->sql->{computerTlcmzDeltaData};
        }
        elsif ( $bankAccount->type eq 'DORANA' ) {
            $connection->prepareSqlQuery( queryComputerDoranaDeltaData() );
            $sth = $connection->sql->{computerDoranaDeltaData};
        }
        elsif ( $bankAccount->type eq 'TADZ' ) {
        	dlog("Performing Delta query for TADZ " . $bankAccount->name);
			my $infra = ScanTADzDelegate->getTADzInfrastructure($bankAccount);
    		$tadzSQL = ScanTADzDelegate->getCorrectSQL($infra, 1);
            $connection->prepareSqlQuery( queryTAD4ZDeltaData() );
            $sth = $connection->sql->{tad4zDeltaData};
        }
        elsif ( $bankAccount->authenticatedData eq 'Y' ) {
            $connection->prepareSqlQuery( queryAuthComputerDeltaData() );
            $sth = $connection->sql->{authComputerDeltaData};
        }
        else {
            eval {
                $connection->prepareSqlQuery( queryComputerDeltaData1() );
                $sth = $connection->sql->{computerDeltaData};
            };
            if ($@) {
                $connection->prepareSqlQuery( queryComputerDeltaData2() );
                $sth = $connection->sql->{computerDeltaData};
            }
        }
    }
    else {
        if ( $bankAccount->type eq 'SW_DISCREPANCY' ) {
            $connection->prepareSqlQuery( queryComputerDiscrepancyData() );
            $sth = $connection->sql->{computerDiscrepancyData};
        }
        elsif ( $bankAccount->type eq 'TLCMZ' ) {
            $connection->prepareSqlQuery( queryComputerTlcmzData() );
            $sth = $connection->sql->{computerTlcmzData};
        }
        elsif ( $bankAccount->type eq 'DORANA' ) {
            $connection->prepareSqlQuery( queryComputerDoranaData() );
            $sth = $connection->sql->{computerDoranaData};
        }
        elsif ( $bankAccount->type eq 'TADZ' ) {
			my $infra = ScanTADzDelegate->getTADzInfrastructure($bankAccount);
    		$tadzSQL = ScanTADzDelegate->getCorrectSQL($infra, 0);
        	dlog("Performing full query for TADZ " . $bankAccount->name);
            $connection->prepareSqlQuery( queryTAD4ZData() );
            $sth = $connection->sql->{tad4zData};
        }
        elsif ( $bankAccount->authenticatedData eq 'Y' ) {
            $connection->prepareSqlQuery( queryAuthComputerData() );
            $sth = $connection->sql->{authComputerData};
        }
        else {
            eval {
                $connection->prepareSqlQuery( queryComputerData1() );
                $sth = $connection->sql->{computerData};
            };
            if ($@) {
                $connection->prepareSqlQuery( queryComputerData2() );
                $sth = $connection->sql->{computerData};
            }
        }
    }
    dlog('Computer query prepared');

    ###Define the fields
    my @fields;
    if (    $bankAccount->name eq 'TLCMZ'
         || $bankAccount->name eq 'DORANA'
         || $bankAccount->name eq 'SWDISCRP' )
    {
        @fields = (
            qw (computerId name objectId model serialNumber scanTime users authenticated isManual authProcessorCount processorCount
                userName manufacturer biosModel physicalTotalKb virtualMemory physicalFreeMemory virtualFreeMemory)
        );
    }
    elsif ( $bankAccount->authenticatedData eq 'Y' ) {
        @fields = (
            qw (computerId name objectId model serialNumber scanTime users authenticated isManual authProcessorCount processorCount
                osName osType osMajor osMinor osSub osInst userName manufacture biosModel alias physicalTotalKb
                virtualMemory physicalFreeMemory virtualFreeMemory)
        );
    }
    elsif ($bankAccount->type eq 'TADZ' ) {
        @fields = (
            qw (computerId name objectId model serialNumber scanTime users authenticated isManual authProcessorCount processorCount
                osName osType osMajor osMinor osSub osInst userName manufacture biosModel alias physicalTotalKb
                virtualMemory physicalFreeMemory virtualFreeMemory biosDate biosSerialNumber biosUniqueId boardSerial
                caseSerial caseAssetTag extId techImgId )
        );
    }

    else {
        @fields = (
            qw (computerId name objectId model serialNumber scanTime users authenticated isManual authProcessorCount processorCount
                osName osType osMajor osMinor osSub osInst userName manufacture biosModel alias physicalTotalKb
                virtualMemory physicalFreeMemory virtualFreeMemory biosDate biosSerialNumber biosUniqueId boardSerial
                caseSerial caseAssetTag)
        );
    }

    dlog('binding columns');
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    dlog('columns binded');

    ###Execute the query
    if ($max) {
        $sth->execute($max);
    }
    else {
        $sth->execute();
    }
    
    # only load the techImgId list IF TADz
#    if ( $bankAccount->type eq 'TADZ' ) {
#    	ScanTADzDelegate->loadTechImgId();
#    }

    my %scanList;
    dlog('looping through query results');
    while ( $sth->fetchrow_arrayref ) {
        my $sr = $self->buildScanRecord( \%rec, $bankAccount );
        next if ( !defined $sr );

        ###Add the hardware to the list
        $scanList{ $rec{computerId} } = $sr
            if ( !exists $scanList{ $rec{computerId} } );
    }

    dlog('closing statement handle');
    $sth->finish;
    dlog('statement handle closed');

    ###Return the lists
    return ( \%scanList );
}

sub buildScanRecord {
    my ( $self, $rec, $bankAccount ) = @_;

    cleanValues($rec);
    upperValues($rec);
    

    dlog( $rec->{scanTime} );
    ###fix the scantime
    if ( !defined $rec->{scanTime} ) {
        $rec->{scanTime} = '1970-01-01-00.00.00.000000';
    }
    if ( $rec->{scanTime} eq '' ) {
        $rec->{scanTime} = '1970-01-01-00.00.00.000000';
    }

    my @fields = split( /\./, $rec->{scanTime} );
    my $size = scalar @fields;
    my $lastField;

    if ( $size == 1 ) {
        $rec->{scanTime} .= '.0';
        $lastField = 0;
    }
    else {
        $lastField = $fields[ $size - 1 ];
    }

    my $lastFieldSize = length($lastField);

    while ( length($lastField) < 6 ) {
        $lastField .= "0";
        $rec->{scanTime} .= "0";
    }

    if (    $rec->{scanTime} =~ /^\d{4}-\d{2}-\d{2}-\d{2}\.\d{2}\.\d{2}\.\d{6}$/
         || $rec->{scanTime} =~ /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}\.\d{6}$/ )
    {
        dlog('Good timestamp');
    }
    else {
        dlog('Bad timestamp');
        $rec->{scanTime} = '1970-01-01-00.00.00.000000';
    }

    ###fix the biosDate
    if ( !defined $rec->{biosDate} ) {
        $rec->{biosDate} = '1970-01-01-00.00.00.000000';
    }
    if ( $rec->{biosDate} eq '' ) {
        $rec->{biosDate} = '1970-01-01-00.00.00.000000';
    }

    @fields = split( /\./, $rec->{biosDate} );
    $size = scalar @fields;

    if ( $size == 1 ) {
        $rec->{biosDate} .= '.0';
        $lastField = 0;
    }
    else {
        $lastField = $fields[ $size - 1 ];
    }

    $lastFieldSize = length($lastField);

    while ( length($lastField) < 6 ) {
        $lastField .= "0";
        $rec->{biosDate} .= "0";
    }

    if (    $rec->{biosDate} =~ /^\d{4}-\d{2}-\d{2}-\d{2}\.\d{2}\.\d{2}\.\d{6}$/
         || $rec->{biosDate} =~ /^\d{4}-\d{2}-\d{2} \d{2}\:\d{2}\:\d{2}\.\d{6}$/ )
    {
        dlog('Good timestamp');
    }
    else {
        dlog('Bad timestamp');
        $rec->{biosDate} = '1970-01-01-00.00.00.000000';
    }

    ###Adjust the processor count
    if ( defined $rec->{authProcessorCount}
         && $rec->{authProcessorCount} != 0 )
    {
        $rec->{processorCount} = $rec->{authProcessorCount};
    }
    $rec->{processorCount} = 0
        if (    ( !defined $rec->{processorCount} )
             || ( $rec->{processorCount} eq '' ) );

    if ( !defined $rec->{computerId} ) {
        return undef;
    }

    if ( !defined $rec->{name} ) {
        return undef;
    }

    ###Skip it if the computerId or name is blank
    if ( $rec->{computerId} eq '' || $rec->{name} eq '' ) {
        return undef;
    }

    ###Skip if the name has a space in it
    if ( $rec->{name} =~ / / ) {
        return undef;
    }

    {
        use bytes;
        if ( length( $rec->{name} ) > 255 ) {
            return undef;
        }
        if ( length( $rec->{computerId} ) > 255 ) {
            return undef;
        }
        if ( length( $rec->{objectId} ) > 128 ) {
            $rec->{objectId} = undef;
        }
        if ( length( $rec->{model} ) > 128 ) {
            $rec->{model} = undef;
        }
        if ( length( $rec->{serialNumber} ) > 128 ) {
            $rec->{serialNumber} = undef;
        }
        if ( length( $rec->{osName} ) > 128 ) {
            $rec->{osName} = undef;
        }
        if ( length( $rec->{osType} ) > 128 ) {
            $rec->{osType} = undef;
        }
        if ( length( $rec->{osSub} ) > 32 ) {
            $rec->{osSub} = undef;
        }
        if ( length( $rec->{osInstDate} ) > 32 ) {
            $rec->{osInstDate} = undef;
        }
        if ( length( $rec->{userName} ) > 255 ) {
            $rec->{userName} = undef;
        }
        if ( length( $rec->{manufacturer} ) > 64 ) {
            $rec->{manufacturer} = undef;
        }
        if ( length( $rec->{biosModel} ) > 64 ) {
            $rec->{biosModel} = undef;
        }
        if ( length( $rec->{serverType} ) > 64 ) {
            $rec->{serverType} = undef;
        }
        if ( length( $rec->{techImgId} ) > 64 ) {
            $rec->{techImgId} = undef;
        }
        if ( length( $rec->{extId} ) > 8 ) {
            $rec->{extId} = undef;
        }
        if ( length( $rec->{alias} ) > 120 ) {
            $rec->{alias} = undef;
        }
        if ( length( $rec->{nodeCapacity} ) > 64 ) {
            $rec->{nodeCapacity} = undef;
        }
        if ( length( $rec->{lparCapacity} ) > 64 ) {
            $rec->{lparCapacity} = undef;
        }
        if ( length( $rec->{biosSerialNumber} ) > 64 ) {
            $rec->{biosSerialNumber} = undef;
        }
        if ( length( $rec->{biosUniqueId} ) > 36 ) {
            $rec->{biosUniqueId} = undef;
        }
        if ( length( $rec->{boardSerial} ) > 64 ) {
            $rec->{boardSerial} = undef;
        }
        if ( length( $rec->{caseSerial} ) > 64 ) {
            $rec->{caseSerial} = undef;
        }
        if ( length( $rec->{caseAssetTag} ) > 64 ) {
            $rec->{caseAssetTag} = undef;
        }
        if ( length( $rec->{powerOnPassword} ) > 64 ) {
            $rec->{powerOnPassword} = undef;
        }
    }
    
    ###Integer fields cannot be any larger than 2147483647
    ###Set integer fields to undef if they are not integers
    $rec->{users} = undef
        if ( !( $rec->{users} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{osMajor} = undef
        if ( !( $rec->{osMajor} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{osMinor} = undef
        if ( !( $rec->{osMinor} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{memory} = undef
        if ( !( $rec->{memory} =~ /^\d+$/ )   || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{disk} = undef
        if ( !( $rec->{disk} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{dedicatedProcessors} = undef
        if ( !( $rec->{dedicatedProcessors} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{totalProcessors} = undef
        if ( !( $rec->{totalProcessors} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{sharedProcessors} = undef
        if ( !( $rec->{sharedProcessors} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{processorType} = undef
        if ( !( $rec->{processorType} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{dedicatedProcByCores} = undef
        if ( !( $rec->{dedicatedProcByCores} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{totalProcByCores} = undef
        if ( !( $rec->{totalProcByCores} =~ /^\d+$/ )  || $rec->{sharedProcByCores} > 2147483647 );
    $rec->{sharedProcByCores} = undef
        if ( !( $rec->{sharedProcByCores} =~ /^\d+$/ ) || $rec->{sharedProcByCores} > 2147483647 );

    $rec->{physicalTotalKb} = undef
        if ( !( $rec->{physicalTotalKb} =~ /^\d+$/ ) ||  $rec->{physicalTotalKb} > 2147483647 );
    $rec->{virtualMemory} = undef
        if ( !( $rec->{virtualMemory} =~ /^\d+$/ )  ||  $rec->{virtualMemory} > 2147483647 );
    $rec->{physicalFreeMemory} = undef
        if ( !( $rec->{physicalFreeMemory} =~ /^\d+$/ )  ||  $rec->{physicalFreeMemory} > 2147483647 );
    $rec->{virtualFreeMemory} = undef
        if ( !( $rec->{virtualFreeMemory} =~ /^\d+$/ )  ||  $rec->{virtualFreeMemory} > 2147483647 );


    ###Build the scan record
    my $scanRecord = new Staging::OM::ScanRecord();
    $scanRecord->computerId( $rec->{computerId} );
    $scanRecord->name( $rec->{name} );
    $scanRecord->objectId( $rec->{objectId} );
    $scanRecord->model( $rec->{model} );
    $scanRecord->serialNumber( $rec->{serialNumber} );
    $scanRecord->scanTime( $rec->{scanTime} );
    $scanRecord->processorCount( $rec->{processorCount} );
    $scanRecord->bankAccountId( $bankAccount->id );
    $scanRecord->isManual( $rec->{isManual} );
    $scanRecord->users( $rec->{users} );
    $scanRecord->authenticated( $rec->{authenticated} );

    $scanRecord->osName( $rec->{osName} );
    $scanRecord->osType( $rec->{osType} );
    $scanRecord->osMajor( $rec->{osMajor} );
    $scanRecord->osMinor( $rec->{osMinor} );
    $scanRecord->osSub( $rec->{osSub} );
    $scanRecord->osInstDate( $rec->{osInstDate} );
    $scanRecord->userName( $rec->{userName} );
    $scanRecord->biosManufacturer( $rec->{manufacturer} );
    $scanRecord->biosModel( $rec->{biosModel} );
    $scanRecord->serverType( $rec->{serverType} );
    $scanRecord->techImgId( $rec->{techImgId} );
    $scanRecord->extId( $rec->{extId} );
    $scanRecord->memory( $rec->{memory} );
    $scanRecord->disk( $rec->{disk} );
    $scanRecord->dedicatedProcessors( $rec->{dedicatedProcessors} );
    $scanRecord->totalProcessors( $rec->{totalProcessors} );
    $scanRecord->sharedProcessors( $rec->{sharedProcessors} );
    $scanRecord->processorType( $rec->{processorType} );
    $scanRecord->sharedProcByCores( $rec->{sharedProcByCores} );
    $scanRecord->dedicatedProcByCores( $rec->{dedicatedProcByCores} );
    $scanRecord->totalProcByCores( $rec->{totalProcByCores} );
    $scanRecord->alias( $rec->{alias} );
    $scanRecord->physicalTotalKb( $rec->{physicalTotalKb} );
    $scanRecord->virtualMemory( $rec->{virtualMemory} );
    $scanRecord->physicalFreeMemory( $rec->{physicalFreeMemory} );
    $scanRecord->virtualFreeMemory( $rec->{virtualFreeMemory} );
    $scanRecord->nodeCapacity( $rec->{nodeCapacity} );
    $scanRecord->lparCapacity( $rec->{lparCapacity} );
    $scanRecord->biosDate( $rec->{biosDate} );
    $scanRecord->biosSerialNumber( $rec->{biosSerialNumber} );
    $scanRecord->biosUniqueId( $rec->{biosUniqueId} );
    $scanRecord->boardSerial( $rec->{boardSerial} );
    $scanRecord->caseSerial( $rec->{caseSerial} );
    $scanRecord->caseAssetTag( $rec->{caseAssetTag} );
    $scanRecord->powerOnPassword( $rec->{powerOnPassword} );
  #  $scanRecord->customerId($self->getCustomerId($scanRecord,$mapService));
    if ( $bankAccount->type eq 'TADZ' ) {
    	ScanTADzDelegate->mapTSID($scanRecord, $bankAccount);
    }

    dlog( $scanRecord->toString );

    return $scanRecord;
}

sub queryComputerData1 {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,d.bios_date
            ,d.sys_ser_num
            ,d.sys_uuid
            ,d.board_ser_num
            ,d.case_ser_num
            ,d.case_asset_tag         
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id
            left outer join inst_smbios_data d on
                a.computer_sys_id = d.computer_sys_id       
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,7
            ,8
            ,9
            ,10
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,d.bios_date
            ,d.sys_ser_num
            ,d.sys_uuid
            ,d.board_ser_num
            ,d.case_ser_num
            ,d.case_asset_tag               
        with ur
    ';

    return ( 'computerData', $query );
}

sub queryComputerData2 {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,e.bios_date
            ,\'\'
            ,\'\'
            ,\'\'
            ,\'\'
            ,\'\'      
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id      
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,7
            ,8
            ,9
            ,10
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,e.bios_date
            ,26
            ,27
            ,28
            ,29
            ,30            
        with ur
    ';

    return ( 'computerData', $query );
}

sub queryAuthComputerData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,case when ( d.user_count is null ) then 0
             else d.user_count
             end
            ,case when ( upper(d.server_type) = \'AUTHENTICATED\' ) then 1
             when ( upper(d.server_type) = \'UNAUTHENTICATED\') then 0
             else 2
             end
            ,0 as isManual
            ,c.physical_processor
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,f.physical_total_kb
            ,f.virt_total_kb
            ,f.physical_free_kb
            ,f.virt_free_kb             
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join cpu_count c on
                a.computer_sys_id = c.computer_sys_id
                and c.physical_processor is not null
                and c.physical_processor != 0
            left outer join win_auth d on
                a.computer_sys_id = d.computer_sys_id
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
            left outer join computer_sys_mem f on
                a.computer_sys_id = f.computer_sys_id
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,d.user_count
            ,d.server_type
            ,9
            ,c.physical_processor
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,f.physical_total_kb
            ,f.virt_total_kb
            ,f.physical_free_kb
            ,f.virt_free_kb            
        with ur
    ';

    return ( 'authComputerData', $query );
}

sub queryComputerDeltaData1 {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,d.bios_date
            ,d.sys_ser_num
            ,d.sys_uuid
            ,d.board_ser_num
            ,d.case_ser_num
            ,d.case_asset_tag         
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id
            left outer join inst_smbios_data d on
                a.computer_sys_id = d.computer_sys_id       
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
        where
            a.computer_scantime > ?                
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,7
            ,8
            ,9
            ,10
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,d.bios_date
            ,d.sys_ser_num
            ,d.sys_uuid
            ,d.board_ser_num
            ,d.case_ser_num
            ,d.case_asset_tag               
        with ur
    ';

    return ( 'computerDeltaData', $query );
}

sub queryComputerDeltaData2 {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,e.bios_date
            ,\'\'
            ,\'\'
            ,\'\'
            ,\'\'
            ,\'\'        
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id  
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
        where
            a.computer_scantime > ?                
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,7
            ,8
            ,9
            ,10
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb
            ,e.bios_date
            ,26
            ,27
            ,28
            ,29
            ,30            
        with ur
    ';

    return ( 'computerDeltaData', $query );
}

sub queryAuthComputerDeltaData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,case when ( d.user_count is null ) then 0
             else d.user_count
             end
            ,case when ( upper(d.server_type) = \'AUTHENTICATED\' ) then 1
             when ( upper(d.server_type) = \'UNAUTHENTICATED\') then 0
             else 2
             end
            ,0 as isManual
            ,c.physical_processor
            ,count(b.processor_num)
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.user_name
            ,e.bios_manufacturer
            ,e.bios_model
            ,a.computer_alias
            ,f.physical_total_kb
            ,f.virt_total_kb
            ,f.physical_free_kb
            ,f.virt_free_kb             
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id
            left outer join cpu_count c on
                a.computer_sys_id = c.computer_sys_id
                and c.physical_processor is not null
                and c.physical_processor != 0
            left outer join win_auth d on
                a.computer_sys_id = d.computer_sys_id
            left outer join pc_sys_params e on
                a.computer_sys_id = e.computer_sys_id  
            left outer join computer_sys_mem f on
                a.computer_sys_id = f.computer_sys_id
        where
            a.computer_scantime > ?                
        group by
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,a.computer_model
            ,a.sys_ser_num
            ,a.computer_scantime
            ,d.user_count
            ,d.server_type
            ,9
            ,c.physical_processor
            ,a.os_name
            ,a.os_type
            ,a.os_major_vers
            ,a.os_minor_vers
            ,a.os_sub_vers
            ,a.os_inst_date
            ,e.bios_model
            ,e.bios_manufacturer
            ,e.user_name
            ,a.computer_alias
            ,f.physical_total_kb
            ,f.virt_total_kb
            ,f.physical_free_kb
            ,f.virt_free_kb            
        with ur
    ';

    return ( 'authComputerDeltaData', $query );
}

sub queryComputerDiscrepancyDeltaData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,cast(null as varchar(32))
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,1 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb                
        from
            manual_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id              
        where
            a.computer_scantime > ?
        with ur
    ';

    return ( 'computerDiscrepancyDeltaData', $query );
}

sub queryComputerDiscrepancyData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,cast(null as varchar(32))
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,1 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb             
        from
            manual_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id              
        with ur
    ';

    return ( 'computerDiscrepancyData', $query );
}

sub queryComputerTlcmzDeltaData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb             
        from
            tlcmz_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id             
        where
            a.computer_scantime > ?
        with ur
    ';

    return ( 'computerTlcmzDeltaData', $query );
}

sub queryComputerTlcmzData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb             
        from
            tlcmz_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id             
        with ur
    ';

    return ( 'computerTlcmzData', $query );
}

sub queryComputerDoranaDeltaData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb             
        from
            dorana_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id                
        where
            a.computer_scantime > ?
        with ur
    ';

    return ( 'computerDoranaDeltaData', $query );
}

sub queryComputerDoranaData {
    my $query = '
        select
            a.computer_sys_id
            ,a.tme_object_label
            ,a.tme_object_id
            ,cast(null as varchar(32))
            ,a.sys_ser_num
            ,a.computer_scantime
            ,0 as users
            ,2 as authenticated
            ,0 as isManual
            ,0 as authProc
            ,a.processor_count
            ,b.user_name
            ,b.bios_manufacturer
            ,b.bios_model
            ,c.physical_total_kb
            ,c.virt_total_kb
            ,c.physical_free_kb
            ,c.virt_free_kb             
        from
            dorana_computer a
            left outer join pc_sys_params b on
                a.computer_sys_id = b.computer_sys_id  
            left outer join computer_sys_mem c on
                a.computer_sys_id = c.computer_sys_id            
        with ur
    ';


    return ( 'computerDoranaData', $query );
}

sub queryTAD4ZData {
	
	if ( length($tadzSQL) < 10 ) {
		elog("TADZ SQL was not properly prepared");
	}
    my $query = $tadzSQL;

    return ( 'tad4zData', $query );
}

sub queryTAD4ZDeltaData {
	if ( length($tadzSQL) < 10 ) {
		elog("TADZ SQL was not properly prepared");
	}

    my $query = $tadzSQL;


    return ( 'tad4zDeltaData', $query );
}

1;
