package Scan::Delegate::IpAddressDelegate;

use strict;
use Base::Utils;
use Compress::Zlib;
use Database::Connection;
use Staging::Delegate::ScanRecordDelegate;
use Text::CSV_XS;

sub getIpAddressData {
    my ( $self, $connection, $bankAccount, $delta ) = @_;

    dlog('In the getIpAddressData method');

    return if $bankAccount->type eq 'TLCMZ';
    return if $bankAccount->type eq 'SW_DISCREPANCY';
    return if $bankAccount->type eq 'DORANA';

    if ( $bankAccount->connectionType eq 'CONNECTED' ) {
        dlog( $bankAccount->name );
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getConnectedIpAddressData( $connection, $bankAccount, $delta, $scanMap );
    }
    elsif ( $bankAccount->connectionType eq 'DISCONNECTED' ) {
        my $scanMap = ScanRecordDelegate->getScanRecordMap($bankAccount);
        return $self->getDisconnectedIpAddressData( $bankAccount, $delta, $scanMap );
    }

    die('This is neither a connected or disconnected bank account');
}

sub getDisconnectedIpAddressData {
    my ( $self, $bankAccount, $delta, $scanMap ) = @_;

    dlog('in the getDisconnectedIpAddressData method');

    my $filePart = 'ip_address';
    dlog($filePart);

    dlog('Determining the file to process');
    my $fileToProcess = ScanDelegate->getDisconnectedFile( $bankAccount, $delta, $filePart );

    my %ipList;

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
        my @fields = (
            qw (computerId ipAddress hostname domain subnet recordTime acqTime
              instanceId gateway primaryDns secondaryDns isDhcp permMacAddress ipv6Address)
        );
        while ( $gz->gzreadline($line) > 0 ) {
            my $status = $tsv->parse($line);

            my $index = 0;
            my %rec   = map { $fields[ $index++ ] => $_ } $tsv->fields();

            ###Build our hardware object list
            my $ip = $self->buildIpAddress( \%rec, $scanMap );
            next if ( !defined $ip );

            my $key = $ip->scanRecordId . '|' . $ip->ipAddress;

            ###Add the hardware to the list
            $ipList{$key} = $ip
              if ( !defined $ipList{$key} );
        }
        die "Error reading from $fileToProcess: $gzerrno" . ( $gzerrno + 0 ) . "\n"
          if $gzerrno != Z_STREAM_END;
        $gz->gzclose();
    }
    else {
        dlog("no $filePart to process");
    }

    ###Return the lists
    return ( \%ipList );
}

sub getConnectedIpAddressData {
    my ( $self, $connection, $bankAccount, $delta, $scanMap ) = @_;

    my %ipList;
    my @fields;
    my $sth;
    my %rec;

    eval {
        $connection->prepareSqlQuery( $self->queryIpAddress4232Data );
        @fields = (
            qw (computerId ipAddress hostname domain subnet gateway primaryDns
              secondaryDns isDhcp permMacAddress)
        );

        ###Get the statement handle
        $sth = $connection->sql->{ipAddressData};
        $sth->bind_columns( map { \$rec{$_} } @fields );
    };

    if ($@) {
        ###4.2.3.2 query errored out, lets try the regular query
        wlog( $@ . " - 4.2.3.2 Ip Address query failed - trying 4.2 query" );

        eval {
            $connection->prepareSqlQuery( $self->queryIpAddressData );
            @fields = (
                qw (computerId ipAddress hostname domain subnet gateway primaryDns
                  secondaryDns isDhcp permMacAddress)
            );

            ###Get the statement handle
            $sth = $connection->sql->{ipAddressData};
            $sth->bind_columns( map { \$rec{$_} } @fields );
        };

        if ($@) {
            ###4.2 query errored out, lets try the query without is_dhcp
            wlog( $@ . " - 4.2 Ip Address query failed - trying without is_dhcp" );

            $connection->prepareSqlQuery( $self->queryIpAddressDataWithoutDhcp );
            @fields = (
                qw (computerId ipAddress hostname domain subnet gateway primaryDns
                  secondaryDns permMacAddress)
            );

            ###Get the statement handle
            $sth = $connection->sql->{ipAddressData};
            $sth->bind_columns( map { \$rec{$_} } @fields );
        }
    }

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our hardware object list
        my $ip = $self->buildIpAddress( \%rec, $scanMap );
        next if ( !defined $ip );

        my $key = $ip->scanRecordId . '|' . $ip->ipAddress;

        ###Add the hardware to the list
        $ipList{$key} = $ip
          if ( !defined $ipList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%ipList );
}

sub buildIpAddress {
    my ( $self, $rec, $scanMap ) = @_;

    cleanValues($rec);
    upperValues($rec);

    logRec( 'dlog', $rec );
    ###We don't care about records that are not in our scan records
    return undef if ( !exists $scanMap->{ $rec->{computerId} } );

    ###ignore record if ipAddress is missing since that is the key for our list
    ### and is a non-nullable field
    return undef if ( !defined $rec->{ipAddress} || $rec->{ipAddress} == '' );

    ###Make sure instanceId is an integer
    if ( defined $rec->{instanceId} ) {
        return undef if ( $rec->{instanceId} =~ /\D/ );
    }

    ###Make sure ipAddress is a valid IP address
    ###TODO - add other ip address fields in the test for valid ip address
    if ( !Base::Utils::isValidIpAddress( $rec->{ipAddress} ) ) {
        return undef;
    }

    ###Subsitute any nullable blanks with undefs
    blank2undef($rec);

    my $ip = new Staging::OM::IpAddress();
    $ip->ipAddress( $rec->{ipAddress} );
    $ip->hostname( $rec->{hostname} ) if length( $rec->{hostname} ) <= 64;
    $ip->domain( $rec->{domain} )     if length( $rec->{domain} ) <= 64;
    $ip->subnet( $rec->{subnet} )     if length( $rec->{subnet} ) <= 128;
    $ip->scanRecordId( $scanMap->{ $rec->{computerId} } );
    $ip->instanceId( $rec->{instanceId} );
    $ip->gateway( $rec->{gateway} )               if length( $rec->{gateway} ) <= 254;
    $ip->primaryDns( $rec->{primaryDns} )         if length( $rec->{primaryDns} ) <= 40;
    $ip->secondaryDns( $rec->{secondaryDns} )     if length( $rec->{secondaryDns} ) <= 40;
    $ip->isDhcp( $rec->{isDhcp} )                 if length( $rec->{isDhcp} ) <= 1;
    $ip->permMacAddress( $rec->{permMacAddress} ) if length( $rec->{permMacAddress} ) <= 64;
    $ip->ipv6Address( $rec->{ipv6Address} )       if length( $rec->{ipv6Address} ) <= 64;      
    dlog( $ip->toString );

    return $ip;
}

sub queryIpAddressData {
    my $query = '
        select
            a.computer_sys_id
            ,a.ip_addr
            ,a.ip_hostname
            ,a.ip_domain
            ,a.ip_subnet
            ,a.ip_gateway
            ,a.ip_primary_dns
            ,a.ip_secondary_dns
            ,a.is_dhcp
            ,b.perm_mac_addr
        from
            ip_addr a
            , net_adapter b
        where 
            a.computer_sys_id = b.computer_sys_id
        with ur
    ';

    return ( 'ipAddressData', $query );
}

sub queryIpAddressDataWithoutDhcp {
    my $query = '
        select
            a.computer_sys_id
            ,a.ip_addr
            ,a.ip_hostname
            ,a.ip_domain
            ,a.ip_subnet
            ,a.ip_gateway
            ,a.ip_primary_dns
            ,a.ip_secondary_dns
            ,b.perm_mac_addr
        from
            ip_addr a, net_adapter b
        where 
            a.computer_sys_id = b.computer_sys_id
        with ur
    ';

    return ( 'ipAddressData', $query );
}

sub queryIpAddress4232Data {
    my $query = '
        select
            a.computer_sys_id
            ,a.ip_addr
            ,a.ip_hostname
            ,a.ip_domain
            ,a.ip_subnet
            ,a.ip_gateway
            ,a.ip_primary_dns
            ,a.ip_secondary_dns
            ,a.is_dhcp
            ,a.perm_mac_address
        from
            ip_addr a
        with ur
    ';

    return ( 'ipAddressData', $query );
}
1;
