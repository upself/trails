package SoftwareFilterDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Sigbank::Delegate::SoftwareFilterDelegate;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

###TODO this probably should be broken out into respective delegates...its getting big
###TODO need to take into account processor counts for bank accounts other than tcm

sub getSoftwareFilterData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getSoftwareFilterData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $softwareFilterMap = SoftwareFilterDelegate->getSoftwareFilterMap;
        my $scanMap           = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedSoftwareFilterData( $connection, $bankAccount, $delta, $scanMap, $softwareFilterMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $softwareFilterMap = SoftwareFilterDelegate->getSoftwareFilterMap;
        my $scanMap           = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedSoftwareFilterData( $bankAccount, $delta, $scanMap, $softwareFilterMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedSoftwareFilterData {
    my ( $self, $bankAccount, $delta, $scanMap, $softwareFilterMap ) = @_;

    dlog('in the getDisconnectedSoftwareFilterData method');

    my $filePart = 'software_filter';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );

    my %filterList = ();

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
        my @fields = (qw (computerId nativId softwareName softwareVersion acqTime ));
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            

            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            my $sf = $self->buildSoftwareFilter( \%rec, $scanMap, $softwareFilterMap );
            next if ( !defined $sf );

            my $key = $sf->scanRecordId . '|' . $sf->softwareFilterId . '|' . $sf->softwareId;

            ###Add the hardware to the list
            $filterList{$key} = $sf
              if ( !defined $filterList{$key} );
        }
        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    ###Now we need to do the computer file if it exists..we will only do the old one that has been processed
    $filePart = 'computer';
    my $disconnectedDir = '/var/staging/disconnected';
    my $fileName        = $bankAccount->name . '_' . $filePart . '.tsv.gz';

    $fileToProcess = "$disconnectedDir/$fileName";

    if ( -e $fileToProcess ) {

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
            qw(computerId
              scanTime
              objectId
              name model
              serialNumber
              softwareName
              osType
              softwareVersion
              osMinor
              osSub
              osInst
              userName
              manufacturer
              biosModel
              serverType
              recordTime
              acqTime)
        );
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            

            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            ###Build our hardware object list
            my $sf = $self->buildSoftwareFilter( \%rec, $scanMap, $softwareFilterMap );
            next if ( !defined $sf );

            my $key = $sf->scanRecordId . '|' . $sf->softwareFilterId . '|' . $sf->softwareId;

            ###Add the hardware to the list
            $filterList{$key} = $sf
              if ( !defined $filterList{$key} );
        }
        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();    
    }
    else {
        dlog("no $filePart to process");
    }

    return \%filterList;
}

sub getConnectedSoftwareFilterData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap, $softwareFilterMap ) = @_;

    ###We are not doing deltas

    my %filterList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->querySoftwareFilterData );

    ###Define the fields
    my @fields = (qw(computerId softwareName softwareVersion ));

    ###Get the statement handle
    my $sth = $connection->sql->{softwareFilterData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    dlog('Retrieving software filters from bank account');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $sf = $self->buildSoftwareFilter( \%rec, $scanMap, $softwareFilterMap );
        next if ( !defined $sf );

        my $key = $sf->scanRecordId . '|' . $sf->softwareFilterId . '|' . $sf->softwareId;

        ###Add the hardware to the list
        $filterList{$key} = $sf
          if ( !defined $filterList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryComputerSoftwareFilterData );

    ###Define the fields
    @fields = (qw(computerId softwareName softwareVersion ));

    ###Get the statement handle
    $sth = $connection->sql->{computerSoftwareFilterData};

    ###Bind the columns
    %rec = ();
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    dlog('Retrieving software filters from bank account');
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $sf = $self->buildSoftwareFilter( \%rec, $scanMap, $softwareFilterMap );
        next if ( !defined $sf );

        my $key = $sf->scanRecordId . '|' . $sf->softwareFilterId . '|' . $sf->softwareId;

        ###Add the hardware to the list
        $filterList{$key} = $sf
          if ( !defined $filterList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%filterList );
}

sub buildSoftwareFilter {
    my ( $self, $rec, $scanMap, $softwareFilterMap ) = @_;

    cleanValues($rec);

    $rec->{computerId} = uc( $rec->{computerId} );

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    $rec->{softwareVersion} = '' if ( !defined $rec->{softwareVersion} );

    return undef if ( !exists $softwareFilterMap->{ $rec->{softwareName} } );

    return undef
      if ( !exists $softwareFilterMap->{ $rec->{softwareName} }->{ $rec->{softwareVersion} } );

    my $softwareFilterId =
      $softwareFilterMap->{ $rec->{softwareName} }->{ $rec->{softwareVersion} }->{'softwareFilterId'};
    my $softwareId = $softwareFilterMap->{ $rec->{softwareName} }->{ $rec->{softwareVersion} }->{'softwareId'};

    ###Build the hdisk record
    my $sf = new Staging::OM::SoftwareFilter();
    $sf->softwareFilterId($softwareFilterId);
    $sf->softwareId($softwareId);
    $sf->scanRecordId( $scanMap->{ $rec->{computerId} } );

    return $sf;
}

sub querySoftwareFilterData {
    my $query = '
        select
            upper(a.computer_sys_id)
            ,b.package_name
            ,b.package_vers
        from
            inst_nativ_sware a
            ,nativ_sware b
        where
            a.nativ_id = b.nativ_id
        with ur
    ';

    return ( 'softwareFilterData', $query );
}

sub queryComputerSoftwareFilterData {
    my $query = '
        select
            a.computer_sys_id
            ,a.os_name
            ,a.os_major_vers
        from
            computer a
        where
            a.os_name is not null
            and a.os_name != \'\' 
        with ur
    ';

    return ( 'computerSoftwareFilterData', $query );
}
1;
