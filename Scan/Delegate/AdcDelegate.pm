package Scan::Delegate::AdcDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;
use Staging::OM::Adc;

sub getAdcData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getAdcData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';
    return if $bankAccount->type eq 'DORANA';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedAdcData( $connection, $bankAccount, $delta,
            $scanMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedAdcData( $bankAccount, $delta,
            $scanMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedAdcData {
    my ( $self, $bankAccount, $delta, $scanMap ) = @_;

    dlog('in the getDisconnectedAdcData method');

    dlog("delta=$delta");
    my $filePart = 'adc';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess
        = ScanDelegate->getDisconnectedFile( $bankAccount, $delta,
        $filePart );

    my %adcList;

    if ($fileToProcess) {
        dlog("processing $fileToProcess");

        dlog('Creating tsv object');
        my $tsv = Text::CSV_XS->new(
            { sep_char => "\t", binary => 1, eol => $/ } );
        dlog('tsv object created');

        dlog('opening gzipped file');
        my $gz = gzopen( "$fileToProcess", "rb" )
            or die "Cannot open $fileToProcess: $gzerrno\n";
        dlog('gzipped file open');

        my $line;
        dlog('looping through gzip lines');
        my @fields = (
            qw( computerId epName epOid ipAddress cust loc gu serverType
                sesdrLocation sesdrBpUsing sesdrSystid)
        );
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);
            my $index  = 0;
            my %rec    = map { $fields[ $index++ ] => $_ } $tsv->fields();

            my $adc = $self->buildAdc( \%rec, $scanMap );
            next if ( !defined $adc );

            my $key = $adc->scanRecordId . '|' . $adc->epName;

            ###Add the hardware to the list
            $adcList{$key} = $adc
                if ( !defined $adcList{$key} );
        }

        die "Error reading from $fileToProcess: $gzerrno"
            . ( $gzerrno + 0 ) . "\n"
            if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    return \%adcList;
}

sub getConnectedAdcData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

    ###We are not doing deltas here

    my %adcList;

    ###For adc data, we are only processing disconnected accounts - therefore
    ###return an empty list.  In future, we may change this to retrieve ADC data for
    ###connected accounts as well

    ###Return the list
    return ( \%adcList );
}

sub buildAdc {
    my ( $self, $rec, $scanMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###Check string length of required fields
    return undef if length( $rec->{epName} ) > 64;

    ###Build the adc record
    my $adc = new Staging::OM::Adc();
    $adc->epName( $rec->{epName} );
    $adc->epOid( $rec->{epOid} )         if length( $rec->{epOid} ) <= 50;
    $adc->ipAddress( $rec->{ipAddress} ) if length( $rec->{ipAddress} ) <= 15;
    $adc->cust( $rec->{cust} )           if length( $rec->{cust} ) <= 3;
    $adc->loc( $rec->{loc} )             if length( $rec->{loc} ) <= 3;
    $adc->gu( $rec->{gu} )               if length( $rec->{gu} ) <= 10;
    $adc->serverType( $rec->{serverType} )
        if length( $rec->{serverType} ) <= 1;
    $adc->sesdrLocation( $rec->{sesdrLocation} )
        if length( $rec->{sesdrLocation} ) <= 15;
    $adc->sesdrBpUsing( $rec->{sesdrBpUsing} )
        if length( $rec->{sesdrBpUsing} ) <= 12;
    $adc->sesdrSystid( $rec->{sesdrSystid} )
        if length( $rec->{sesdrSystid} ) <= 8;
    $adc->scanRecordId( $scanMap->{ $rec->{computerId} } );
    dlog( $adc->toString );

    return $adc;
}

1;
