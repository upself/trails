package Scan::Delegate::MemModDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

sub getMemModData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getMemModData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';
    return if $bankAccount->type eq 'DORANA';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedMemModData( $connection, $bankAccount, $delta, $scanMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedMemModData( $bankAccount, $delta, $scanMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedMemModData {
    my ( $self, $bankAccount, $delta, $scanMap ) = @_;

    dlog('in the getDisconnectedMemModData method');

    dlog("delta=$delta");
    my $filePart = 'mem_mod';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );

    my %memModList;

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
        my @fields = (qw( computerId instMemId moduleSizeMb maxModuleSizeMb socketName packaging 
                            memType createTime updateTime));
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            
            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            my $memMod = $self->buildMemMod( \%rec, $scanMap );
            next if ( !defined $memMod );
            
            my $key = $memMod->scanRecordId . '|' . $memMod->instMemId;

            ###Add the memMod to the list
            $memModList{$key} = $memMod
                if ( !defined $memModList{$key} );
        }

        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    return \%memModList;
}

sub getConnectedMemModData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

    ###We are not doing deltas here

    my %memModList;
    
    $connection->prepareSqlQuery( $self->queryMemModData );

    ###Define the fields
    my @fields = (qw( computerId instMemId moduleSizeMb maxModuleSizeMb packaging memType socketName));

    ###Get the statement handle
    my $sth = $connection->sql->{memModData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our hardware object list
        my $memMod = $self->buildMemMod( \%rec, $scanMap );
        next if ( !defined $memMod );

        my $key = $memMod->scanRecordId . '|' . $memMod->instMemId;

        ###Add the hardware to the list
        $memModList{$key} = $memMod
          if ( !defined $memModList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%memModList );
}

sub buildMemMod {
    my ( $self, $rec, $scanMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );  
    
    ###return undef if instMemId is is null or empty
    return undef if (! defined $rec->{instMemId} || $rec->{instMemId} == '');

    ###Build the MemMod record
    my $memMod = new Staging::OM::MemMod();
    $memMod->instMemId( $rec->{instMemId} );
    $memMod->moduleSizeMb( $rec->{moduleSizeMb} );
    $memMod->maxModuleSizeMb( $rec->{maxModuleSizeMb} );
    $memMod->packaging( $rec->{packaging} );    
    $memMod->memType( $rec->{memType} );   
    $memMod->socketName( $rec->{socketName} );       
    $memMod->scanRecordId( $scanMap->{ $rec->{computerId} } );
    dlog( $memMod->toString );

    return $memMod;
}

sub queryMemModData {
    my $query = '
        select
            a.computer_sys_id
            ,b.inst_mem_id
            ,b.module_size_mb
            ,b.max_module_size_mb
            ,b.packaging
            ,b.mem_type
            ,b.socket_name          
        from
            computer a
            ,Mem_Modules b
        where
            a.computer_sys_id = b.computer_sys_id
        with ur
    ';

    return ( 'memModData', $query );
}
1;
