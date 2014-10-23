package ScanRecordDelegate;

use Base::Utils;
use Database::Connection;

use strict;

sub getMaxScanTimeByBankAccount {
    my( $self, $bankAccount ) = @_;

    dlog('In getMaxScanTimeByBankAccount method');

    my $max;

    ###Get a cndb connection
    my $connection = Database::Connection->new('staging');

    ###Prepare the necessary sql
    $connection->prepareSqlQuery(queryMaxScanTimeByBankAccount());

    my @fields = ( qw(max) );
    my $sth = $connection->sql->{maxScanTimeByBankAccount};
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);
    $sth->execute($bankAccount->id);
    $sth->fetchrow_arrayref;
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return $rec{max};
}

sub getScanRecordMap {
    my( $self, $bankAccount ) = @_;

    my %data;

    ###Get a cndb connection
    my $connection = Database::Connection->new('staging');

    ###Prepare the necessary sql
    $connection->prepareSqlQuery(queryScanRecordMap());

    my @fields = ( qw(id computerId) );
    my $sth = $connection->sql->{scanRecordMap};
    my %rec;
    $sth->bind_columns(map {\$rec{$_}} @fields);
    $sth->execute($bankAccount->id);
    while( $sth->fetchrow_arrayref ) {
        $data{$rec{computerId}} = $rec{id};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryScanRecordMap {
    my $query = '
        select
            a.id
            ,a.computer_id
        from
            scan_record a
        where
            a.bank_account_id = ?
            and a.action != \'DELETE\'
    ';

    return ('scanRecordMap',$query);
}

sub queryMaxScanTimeByBankAccount {
    my $query = '
        select
            max(a.scan_time)
        from
            scan_record a
        where
            a.bank_account_id = ?
        ';

    return ('maxScanTimeByBankAccount',$query);
}

sub queryMapList {
    my @fields = ( qw(
        id
        computerId
        name
        objectId
        model
        serialNumber
        scanTime
        processorCount
        bankAccountId
        isManual
        action 
    ));

    my $query = '
        select
            a.id
            ,a.computer_id
            ,a.name
            ,a.object_id
            ,a.model
            ,a.serial_number
            ,a.scan_time
            ,a.processor_count
            ,a.bank_account_id
            ,a.is_manual
            ,a.action
        from
            scan_record a
        order by
            a.is_manual ASC
            ,a.scan_time DESC
    ';
    return ('mapList',$query,\@fields);
}
1;
