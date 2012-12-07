package SoftwareManualDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Sigbank::Delegate::SoftwareDelegate;
use Text::CSV_XS;

sub getSoftwareManualData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getSoftwareFilterData method');

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        ###Get computer id map
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);

        ###Get the software map
        my $softwareMap = SoftwareDelegate->getSoftwareMap;
        return $self->getConnectedSoftwareManualData( $connection, $bankAccount, $delta, $scanMap,
            $softwareMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getConnectedSoftwareManualData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap, $softwareMap ) = @_;

    ###No delta processing
    my %manualList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->querySoftwareManualData );

    ###Define the fields
    my @fields = (qw(computerId softwareId version users ));

    ###Get the statement handle
    my $sth = $connection->sql->{softwareManualData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Clean up the data
        cleanValues( \%rec );

        my $sm = $self->buildSoftwareManual( \%rec, $scanMap, $softwareMap );
        next if ( !defined $sm );

        my $key = $sm->scanRecordId . '|' . $sm->softwareId;

        ###Add the hardware to the list
        $manualList{$key} = $sm
          if ( !defined $manualList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%manualList );
}

sub buildSoftwareManual {
    my ( $self, $rec, $scanMap, $softwareMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###We don't care if the software name does not exist
    #### We really need to check the logic here as to whether or not it is really
    ###  acceptable to not uppercase or lower case these things
    return undef if ( !exists $softwareMap->{ $rec->{softwareId} } );

    ###Build our hardware object list
    my $sm = new Staging::OM::SoftwareManual();
    $sm->softwareId( $rec->{softwareId} );
    $sm->scanRecordId( $scanMap->{ $rec->{computerId} } );
    $sm->version( $rec->{version} );
    $sm->users( $rec->{users} );

    return $sm;
}

sub querySoftwareManualData {
    my $query = '
        select
            a.computer_sys_id
            ,a.software_id
            ,a.prod_version
            ,a.users
        from
            inst_manual_sware a
        with ur
    ';

    return ( 'softwareManualData', $query );
}
1;
