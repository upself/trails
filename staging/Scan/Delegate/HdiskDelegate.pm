package Scan::Delegate::HdiskDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

sub getHdiskData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getHdiskData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';
    return if $bankAccount->type eq 'DORANA';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedHdiskData( $connection, $bankAccount, $delta, $scanMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedHdiskData( $bankAccount, $delta, $scanMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedHdiskData {
    my ( $self, $bankAccount, $delta, $scanMap ) = @_;

    dlog('in the getDisconnectedHdiskData method');

    dlog("delta=$delta");
    my $filePart = 'hdisk';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );

    my %hdiskList;
    my %hdiskScanRecordIdMap;

    if ($fileToProcess) {
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
        my @fields = (qw( computerId model size recordTime acqTime manufacturer serialNumber storageType));
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            
            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            my $hdisk = $self->buildHdisk( \%rec, $scanMap );
            next if ( !defined $hdisk );
            
            my $key = $hdisk->scanRecordId . '|' . $hdisk->model . '|' .
                            $hdisk->size . '|' . $hdisk->serialNumber;

            ###Add the hardware to the list
            if ( !defined $hdiskList{$key} ) {
                $hdiskList{$key} = $hdisk;
            }
        }

        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    return \%hdiskList;
}

sub getConnectedHdiskData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

    ###We are not doing deltas here

    my %hdiskList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryHdiskData );

    ###Define the fields
    my @fields = (qw(computerId model size manufacturer serialNumber storageType));

    ###Get the statement handle
    my $sth = $connection->sql->{hdiskData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our hdisk object list
        my $hdisk = $self->buildHdisk( \%rec, $scanMap );
        next if ( !defined $hdisk );
        
        my $key = $hdisk->scanRecordId . '|' . $hdisk->model . '|' .
                        $hdisk->size . '|' . $hdisk->serialNumber;

        ###Add the hdisk to the list
        $hdiskList{$key} = $hdisk
          if ( !defined $hdiskList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the list
    return ( \%hdiskList );
}

sub buildHdisk {
    my ( $self, $rec, $scanMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###If size is not an integer, return undef
    return undef if ( !( $rec->{size} =~ /^\d+$/ ) );

    ###If model is an empty string, return undef
    return undef if ( ( $rec->{model} =~ /^$/ ) );

    ###Build the hdisk record
    my $hdisk = new Staging::OM::Hdisk();
    $hdisk->model( $rec->{model} );
    $hdisk->size( $rec->{size} );
    $hdisk->manufacturer( $rec->{manufacturer} );
    
    if (!defined $rec->{serialNumber} || $rec->{serialNumber} eq '') {
        $hdisk->serialNumber('UNKNOWN');
    }
    else {   
        $hdisk->serialNumber( $rec->{serialNumber} );
    }
    
    $hdisk->storageType( $rec->{storageType} );
    $hdisk->scanRecordId( $scanMap->{ $rec->{computerId} } );
    dlog( $hdisk->toString );

    return $hdisk;
}

sub queryHdiskData {
    my $query = '
        select
            a.computer_sys_id
            ,a.model
            ,b.hdisk_size_mb
            ,a.manufacturer
            ,a.ser_num
            ,a.storage_type            
        from
            storage_dev a
            ,hdisk b
        where
            a.hdisk_id = b.hdisk_id
        with ur
    ';

    return ( 'hdiskData', $query );
}
1;
