package Scan::Delegate::ProcessorDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Staging::OM::Processor;
use Text::CSV_XS;

sub getProcessorData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getProcessorData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';
    return if $bankAccount->type eq 'DORANA';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedProcessorData( $connection, $bankAccount, $delta, $scanMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedProcessorData( $bankAccount, $delta, $scanMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedProcessorData {
    my ( $self, $bankAccount, $delta, $scanMap ) = @_;

    dlog('in the getDisconnectedProcessorData method');

    ###Now we need to do the computer file if it exists..we will only do the old one that has been processed
    my $filePart        = 'processor';
    my $disconnectedDir = '/var/staging/disconnected';
    my $fileName        = $bankAccount->name . '_' . $filePart . '.tsv.gz';

    my $fileToProcess = "$disconnectedDir/$fileName";

    my %processorList;

    if (-e "$fileToProcess") {

        dlog("processing $fileToProcess");

        dlog('Creating tsv object');
        my $tsv = Text::CSV_XS->new( { sep_char => "\t", binary => 1, eol => $/ } );
        dlog('tsv object created');

        dlog('opening gzipped file');
        my $gz = gzopen( "$fileToProcess", "rb" )
          or die "Cannot open $fileToProcess: $gzerrno\n";
        dlog('gzipped file open');

        my $line;
        dlog('looping through gzip lines');
        my @fields = (
            qw (computerId processorNum recordTime acqTime manufacturer model
              maxSpeed busSpeed isActive serialNumber numBoards numModules
              pvu cache currentSpeed)
        );

        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);

            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            ###Build our hardware object list
            my $processor = $self->buildProcessor( \%rec, $scanMap );
            next if ( !defined $processor );

            my $key = $processor->scanRecordId . '|' . $processor->processorNum;

            ###Add the hardware to the list
            $processorList{$key} = $processor
              if ( !defined $processorList{$key} );
        }
        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    ###Return the lists
    return ( \%processorList );
}

sub getConnectedProcessorData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

    my %processorList;

    eval { $connection->prepareSqlQuery( $self->queryProcessorData ); };    
    if ($@) {
        $connection->prepareSqlQuery( $self->queryProcessorData2 );
    }
    my @fields = (
        qw (computerId processorNum manufacturer model
          maxSpeed busSpeed isActive serialNumber numBoards numModules
          cache currentSpeed)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{processorData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our hardware object list
        my $processor = $self->buildProcessor( \%rec, $scanMap );
        next if ( !defined $processor );

        my $key = $processor->scanRecordId . '|' . $processor->processorNum;

        ###Add the hardware to the list
        $processorList{$key} = $processor
          if ( !defined $processorList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%processorList );
}

sub buildProcessor {
    my ( $self, $rec, $scanMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###return undef if processorNum is is null or empty
    return undef if ( !defined $rec->{processorNum} || $rec->{processorNum} == '' );

    ###return undef if processorNum is not an integer
    return undef if ( !( $rec->{processorNum} =~ /^\d+$/ ) );

    ###If integer fields are not an integer, set them to undef
    if ( !( $rec->{pvu} =~ /^\d+$/ ) ) {
        $rec->{pvu} = undef;
    }
    if ( !( $rec->{maxSpeed} =~ /^\d+$/ ) ) {
        $rec->{maxSpeed} = undef;
    }
    if ( !( $rec->{busSpeed} =~ /^\d+$/ ) ) {
        $rec->{busSpeed} = undef;
    }
    if ( !( $rec->{numBoards} =~ /^\d+$/ ) ) {
        $rec->{numBoards} = undef;
    }
    if ( !( $rec->{numModules} =~ /^\d+$/ ) ) {
        $rec->{numModules} = undef;
    }
    if ( !( $rec->{currentSpeed} =~ /^\d+$/ ) ) {
        $rec->{currentSpeed} = undef;
    }

    my $processor = new Staging::OM::Processor();
    $processor->processorNum( $rec->{processorNum} );
    $processor->manufacturer( $rec->{manufacturer} );
    $processor->model( $rec->{model} );
    $processor->maxSpeed( $rec->{maxSpeed} );
    $processor->scanRecordId( $scanMap->{ $rec->{computerId} } );
    $processor->busSpeed( $rec->{busSpeed} );
    $processor->isActive( $rec->{isActive} );
    $processor->serialNumber( $rec->{serialNumber} );
    $processor->numBoards( $rec->{numBoards} );
    $processor->numModules( $rec->{numModules} );
    $processor->pvu( $rec->{pvu} );
    $processor->cache( $rec->{cache} );
    $processor->currentSpeed( $rec->{currentSpeed} );
    dlog( $processor->toString );

    return $processor;
}

sub queryProcessorData {
    my $query = '
        select
            a.computer_sys_id
            ,b.processor_num
            ,c.manufacturer
            ,c.processor_model
            ,c.max_speed
            ,c.bus_speed
            ,b.is_enabled
            ,b.ser_num
            ,b.processor_board
            ,b.processor_module
            ,c.ecache_mb
            ,c.current_speed
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id,
            processor c
        where
            b.processor_id = c.processor_id
        with ur
    ';

    return ( 'processorData', $query );
}

sub queryProcessorData2 {
    my $query = qq{
        select
            a.computer_sys_id
            ,b.processor_num
            ,c.manufacturer
            ,c.processor_model
            ,c.max_speed
            ,'' as bus_speed
            ,'' as is_enabled
            ,b.ser_num
            ,'' as processor_board
            ,'' as processor_module
            ,'' as ecache_mb
            ,c.current_speed
        from
            computer a
            left outer join inst_processor b on
                a.computer_sys_id = b.computer_sys_id,
            processor c
        where
            b.processor_id = c.processor_id
        with ur
    };

    return ( 'processorData', $query );
}

1;
