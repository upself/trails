package CNDB::Delegate::CNDBDelegate;

use strict;
use Base::Utils;
use BRAVO::OM::AccountPool;
use BRAVO::OM::Contact;
use BRAVO::OM::CountryCode;
use BRAVO::OM::Customer;
use BRAVO::OM::CustomerNumber;
use BRAVO::OM::CustomerType;
use BRAVO::OM::Geography;
use BRAVO::OM::Industry;
use BRAVO::OM::OutsourceProfile;
use BRAVO::OM::Pod;
use BRAVO::OM::Region;
use BRAVO::OM::Sector;

sub getCustomerMaps {
    my ($self) = @_;

    ###Hash to return
    my %data;
    my %objectIdMap;
    my %namePrefixMap;
    my %prefix;
    my %suffix;
    my %nameMap;
    my %customerAcctMap;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryCustomerMaps() );

    my $sth = $connection->sql->{customerMaps};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerMapsFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        upperValues( \%rec );

        if ( $rec{tmeObjectIds} ) {
            if ( $rec{tmeObjectIds} =~ /\,/ ) {
                foreach my $i ( split( /\,/, $rec{tmeObjectIds} ) ) {
                    $i =~ s/\"//g;
                    $i =~ s/\s+$//g;
                    $i =~ s/^\s+//g;
                    $objectIdMap{$i} = $rec{customerId} if $rec{tmeObjectIds};
                }
            }
            else {
                $objectIdMap{ $rec{tmeObjectIds} } = $rec{customerId}
                    if $rec{tmeObjectIds};
            }
        }
        if ( $rec{hostnamePrefixes} ) {
            if ( $rec{hostnamePrefixes} =~ /\,/ ) {
                foreach my $i ( split( /\,/, $rec{hostnamePrefixes} ) ) {
                    $i =~ s/\"||\s+//g;
                    $namePrefixMap{$i} = $rec{customerId}
                        if $rec{hostnamePrefixes};
                }
            }
            else {
                $namePrefixMap{ $rec{hostnamePrefixes} } = $rec{customerId}
                    if $rec{hostnamePrefixes};
            }
        }
        if ( defined $rec{customerSuffix} ) {
            $rec{customerSuffix} =~ s/^\s+//;
            $rec{customerSuffix} =~ s/\s+$//;

            $suffix{ $rec{customerId} } = $rec{customerSuffix}
                if ( $rec{customerSuffix} ne '' );
        }

        if ( defined $rec{customerPrefix} ) {
            $rec{customerPrefix} =~ s/^\s+//;
            $rec{customerPrefix} =~ s/\s+$//;

            $prefix{ $rec{customerId} } = $rec{customerPrefix}
                if ( $rec{customerPrefix} ne '' );
        }

        $customerAcctMap{ $rec{accountNumber} } = $rec{customerId};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    my $hostnameMapFile = '/opt/common/conf/hostname.map';

    # First build the hostname mappings
    open HOSTNAMES, "$hostnameMapFile"
        or die "Could not open $hostnameMapFile";

    while (<HOSTNAMES>) {
        chomp;
        s/^M//g;
        s/\s+$//;
        my ( $value, $key ) = split(/\=/);

        $nameMap{ uc($key) } = $customerAcctMap{$value}
            if ( exists $customerAcctMap{$value} );
    }
    close HOSTNAMES;

    return ( \%suffix, \%prefix, \%objectIdMap, \%nameMap, \%namePrefixMap,
        \%customerAcctMap );
}

sub queryCustomerMaps {
    my @fields = (
        qw(
            customerId
            accountNumber
            hostnamePrefixes
            tmeObjectIds
            customerSuffix
            customerPrefix
            )
    );
    my $query = '
        select
            customer_id
            ,account_number
            ,hostname_prefix
            ,tme_object_id
            ,customer_suffix
            ,customer_prefix
        from
            LGCY_ACCOUNT
        where
            status = \'ACTIVE\'
        with ur
    ';

    return ( 'customerMaps', $query, \@fields );
}

sub getCustomerNumberMap {
    my ($self) = @_;

    my %data_customer_number;
    my %data_account_number;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryCustomerNumberMap() );
    my %rec;
    my $sth = $connection->sql->{customerNumberMap};
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerNumberMapFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        cleanValues( \%rec );

        $rec{accountNumber} = $rec{accountNumber} . 'X'
            while ( length( $rec{accountNumber} ) < 7 );

        $data_account_number{ $rec{accountNumber} }{'count'} = 1;
        $data_account_number{ $rec{accountNumber} }{'customerId'}  = $rec{customerId};

        if ( $rec{customerNumber} ) {
            $data_customer_number{ $rec{customerNumber} }{'count'}++;
            $data_customer_number{ $rec{customerNumber} }{ $rec{countryCode} }
                = $rec{customerId};
        }
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return ( \%data_customer_number , \%data_account_number );
}

sub queryCustomerNumberMap {
    my @fields = (
        qw(
            customerId
            accountNumber
            customerNumber
            countryCode
            )
    );
    my $query = '
        select
            c.customer_id
            ,c.account_number
            ,cn.customer_number
            ,cc.code
        from
            LGCY_ACCOUNT c
            left outer join V_SOFTWARE_CUST_NBR cn on
                cn.customer_id = c.customer_id
                and cn.status = \'ACTIVE\'
            left outer join country_code cc on
                cc.id = cn.country_code_id
        where
            c.status = \'ACTIVE\'
        with ur
    ';

    return ( 'customerNumberMap', $query, \@fields );
}

sub getAllAccountNumberMap {
    my ($self) = @_;

    my %data;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQuery( queryAllAccountNumberMap() );

    my @fields = (qw(accountNumber customerId));
    my $sth    = $connection->sql->{allAccountNumberMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        $data{ $rec{accountNumber} } = $rec{customerId};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryAllAccountNumberMap {
    my $query = '
        select
            a.account_number
            ,a.customer_id
        from
            lgcy_account a
        with ur
    ';

    return ( 'allAccountNumberMap', $query );
}

sub getAccountPoolParents {
    my ( $self, $connection, $customerId ) = @_;

    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryAccountPoolParents() );

    my $sth = $connection->sql->{accountPoolParents};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{accountPoolParentsFields} } );
    $sth->execute($customerId);
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );

        $data{ $rec{customerId} }++;
    }
    $sth->finish;

    return \%data;
}

sub queryAccountPoolParents {
    my @fields = (
        qw(
            customerId
            )
    );
    my $query = '
        select
            a.master_account_id
        from
            account_pool a
            ,customer b
        where
            a.member_account_id = ?
            and a.logical_delete_ind = 0
            and a.master_account_id = b.customer_id
            and b.status = \'ACTIVE\'
            and b.sw_license_mgmt = \'YES\'
        with ur
    ';

    return ( 'accountPoolParents', $query, \@fields );
}

sub getAccountPoolChildren {
    my ( $self, $connection, $customerId ) = @_;

    my %data;
    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( queryAccountPoolChildren() );

    my $sth = $connection->sql->{accountPoolChildren};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{accountPoolChildrenFields} } );
    $sth->execute($customerId);
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );

        $data{1}{ $rec{customerId} }++;
    }
    $sth->finish;

    $data{0}{$customerId}++;

    return \%data;
}

sub queryAccountPoolChildren {
    my @fields = (
        qw(
            customerId
            )
    );
    my $query = '
        select
            a.member_account_id
        from
            account_pool a
            ,customer b
        where
            a.master_account_id = ?
            and a.logical_delete_ind = 0
            and a.member_account_id = b.customer_id
            and b.status = \'ACTIVE\'
            and b.sw_license_mgmt = \'YES\'
        with ur
    ';

    return ( 'accountPoolChildren', $query, \@fields );
}

sub getAccountNumberMap {
    my ($self) = @_;

    my %data;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQuery( queryAccountNumberMap() );

    my @fields = (qw(accountNumber customerId));
    my $sth    = $connection->sql->{accountNumberMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );
        $data{ $rec{accountNumber} } = $rec{customerId};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryAccountNumberMap {
    my $query = '
        select
            a.account_number
            ,a.customer_id
        from
            lgcy_account a
        where
            a.status = \'ACTIVE\'
        with ur
    ';

    return ( 'accountNumberMap', $query );
}

sub getCustomerNameMap {
    my ($self) = @_;

    my %data;
    my %dupsData;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQuery( queryCustomerNameMap() );

    my @fields = (qw(customerName customerId));
    my $sth    = $connection->sql->{customerNameMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        cleanValues( \%rec );

        ###Check to see if this is already in the dups map
        if ( exists( $dupsData{ $rec{customerName} } ) ) {
            next;
        }
        else {
            if ( exists( $data{ $rec{customerName} } ) ) {
                ###put this customer name in the dups hash
                $dupsData{ $rec{customerName} } = $rec{customerId};

                ###remove it from unique name map
                delete( $data{ $rec{customerName} } );
                next;
            }
        }

        $data{ $rec{customerName} } = $rec{customerId};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return ( \%data, \%dupsData );
}

sub queryCustomerNameMap {
    my $query = '
        select
            a.account_name
            ,a.customer_id
        from
            lgcy_account a
        where
            a.status = \'ACTIVE\'
        with ur
    ';

    return ( 'customerNameMap', $query );
}

sub getCustomerIdByAccountNumber {

    my ( $self, $connection, $accountNumber ) = @_;

    my $customerId;
    $connection->prepareSqlQuery( $self->queryCustomerIdByAccountNumber() );
    my $sth = $connection->sql->{customerIdByAccountNumber};
    $sth->bind_columns( \$customerId );
    $sth->execute($accountNumber);
    $sth->fetchrow_arrayref;
    $sth->finish;

    if ( defined $customerId ) {
        return $customerId;
    }
    else {
        die
            "Unable to query customerIdByAccountNumber for account number: $accountNumber !";
        return;
    }
}

sub queryCustomerIdByAccountNumber {
    my $query = '
        select
            a.customer_id
        from
            customer a
        where
            a.account_number = ?
        with ur
    ';
    return ( 'customerIdByAccountNumber', $query );
}

sub isInScopeForSwlm {

    my ( $self, $connection, $customerId ) = @_;

    my $status;
    my $swLicenseMgmt;
    $connection->prepareSqlQuery( $self->queryIsInScopeForSwlm() );
    my $sth = $connection->sql->{isInScopeForSwlm};
    $sth->bind_columns( \$status, \$swLicenseMgmt );
    $sth->execute($customerId);
    $sth->fetchrow_arrayref;
    $sth->finish;

    if ( defined $status && defined $swLicenseMgmt ) {
        if ( $status eq 'ACTIVE' ) {
            if ( $swLicenseMgmt eq 'YES' ) {
                return 1;
            }
            else {
                return 0;
            }
        }
        else {
            return 0;
        }
    }
    else {
        ###TODO: change this back to die when in production
       #die "Unable to query isInScopeForSwlm for customer id: $customerId !";
        wlog(
            "Unable to query isInScopeForSwlm for customer id: $customerId !"
        );
        return;
    }
}

sub queryIsInScopeForSwlm {
    my $query = '
        select
            a.status
            ,a.sw_license_mgmt
        from
            customer a
        where
            a.customer_id = ?
        with ur
    ';
    return ( 'isInScopeForSwlm', $query );
}

sub getCustomerIdMap {
    my ( $self, $status ) = @_;

    dlog('Start getCustomerIdMap method');

    ###Hash to return
    my %data;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    if ( defined $status ) {
        $connection->prepareSqlQueryAndFields(
            $self->queryCustomerIdMapByStatus($status) );
    }
    else {
        $connection->prepareSqlQueryAndFields( $self->queryCustomerIdMap() );
    }

    my $sth = $connection->sql->{customerIdMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerIdMapFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        $data{ $rec{customerId} } = $rec{accountNumber};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCustomerIdMap {
    my @fields = (qw(customerId accountNumber));
    my $query  = '
        select
            a.customer_id
            ,a.account_number
        from
            lgcy_account a
        with ur
    ';

    return ( 'customerIdMap', $query, \@fields );
}

sub queryCustomerIdMapByStatus {
    my ( $self, $status ) = @_;
    die "ERROR: Must pass status argument!!\n"
        unless defined $status;
    my @fields = (qw(customerId accountNumber));
    my $query  = '
        select
            a.customer_id
            ,a.account_number
        from
            lgcy_account a
        where
            a.status = \'' . $status . '\'
        with ur
    ';

    return ( 'customerIdMap', $query, \@fields );
}

sub getCustomerIdsByGeography {
    my ( $self, $geography ) = @_;

    dlog('Start getCustomerIdsByGeography method');

    ###Hash to return
    my %data;

    ###Get a cndb connection
    my $connection = Database::Connection->new('cndb');

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields(
        $self->queryCustomerIdsByGeography($geography) );

    my $sth = $connection->sql->{customerIdsByGeography};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerIdsByGeographyFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        $data{ $rec{customerId} } = $rec{accountNumber};
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCustomerIdsByGeography {
    my ( $self, $geography ) = @_;
    die "ERROR: Must pass status argument!!\n"
        unless defined $geography;
    my @fields = (qw(customerId accountNumber));
    my $query  = '
        select
            a.customer_id
            ,a.account_number
        from
            lgcy_account a
            ,country_code b
            ,region c
            ,geography d
        where
            d.name = \'' . $geography . '\'
            and a.country_code_id = b.id
            and b.region_id = c.id
            and c.geography_id = d.id
        with ur
    ';

    return ( 'customerIdsByGeography', $query, \@fields );
}

sub getContactData {
    my ( $self, $connection ) = @_;

    dlog('Start getContactData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryContactData() );

    my $sth = $connection->sql->{contactData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{contactDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $contact = new BRAVO::OM::Contact();
        $contact->contactId( $rec{id} );
        $contact->role( $rec{role} );
        $contact->serial( $rec{serial} );
        $contact->fullName( $rec{fullName} );
        $contact->remoteUserHolder( $rec{remoteUser} );
        $contact->notesMail( $rec{notesMail} );
        $contact->creationDateTime( $rec{creationDateTime} );
        $contact->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $contact;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryContactData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            role
            serial
            fullName
            remoteUser
            notesMail
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.contact_id
            ,a.role
            ,a.serial
            ,a.full_name
            ,a.remote_user
            ,a.notes_mail
            ,a.creation_date_time
            ,a.update_date_time
        from
            contact a
        with ur
    ';

    return ( 'contactData', $query, \@fields );
}

sub getGeographyData {
    my ( $self, $connection ) = @_;

    dlog('Start getGeographyData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryGeographyData() );

    my $sth = $connection->sql->{geographyData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{geographyDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $geography = new BRAVO::OM::Geography();
        $geography->geographyId( $rec{id} );
        $geography->name( $rec{name} );
        $geography->creationDateTime( $rec{creationDateTime} );
        $geography->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $geography;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryGeographyData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.id
            ,a.name
            ,a.creation_date_time
            ,a.update_date_time
        from
            geography a
        with ur
    ';

    return ( 'geographyData', $query, \@fields );
}

sub getRegionData {
    my ( $self, $connection ) = @_;

    dlog('Start getRegionData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryRegionData() );

    my $sth = $connection->sql->{regionData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{regionDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $region = new BRAVO::OM::Region();
        $region->regionId( $rec{id} );
        $region->geographyId( $rec{geographyId} );
        $region->name( $rec{name} );
        $region->creationDateTime( $rec{creationDateTime} );
        $region->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $region;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryRegionData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            geographyId
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.id
            ,a.geography_id
            ,a.name
            ,a.creation_date_time
            ,a.update_date_time
        from
            region a
        with ur
    ';

    return ( 'regionData', $query, \@fields );
}

sub getCountryCodeData {
    my ( $self, $connection ) = @_;

    dlog('Start getCountryCodeData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryCountryCodeData() );

    my $sth = $connection->sql->{countryCodeData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{countryCodeDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $countryCode = new BRAVO::OM::CountryCode();
        $countryCode->countryCodeId( $rec{id} );
        $countryCode->regionId( $rec{regionId} );
        $countryCode->name( $rec{name} );
        $countryCode->code( $rec{code} );
        $countryCode->creationDateTime( $rec{creationDateTime} );
        $countryCode->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $countryCode;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCountryCodeData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            regionId
            name
            code
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.id
            ,a.region_id
            ,a.name
            ,a.code
            ,a.creation_date_time
            ,a.update_date_time
        from
            country_code a
        with ur
    ';

    return ( 'countryCodeData', $query, \@fields );
}

sub getPodData {
    my ( $self, $connection ) = @_;

    dlog('Start getPodData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryPodData() );

    my $sth = $connection->sql->{podData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{podDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $pod = new BRAVO::OM::Pod();
        $pod->podId( $rec{id} );
        $pod->name( $rec{name} );
        $pod->creationDateTime( $rec{creationDateTime} );
        $pod->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $pod;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryPodData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.AA_DEPT_ID
            ,a.ASSET_ADMIN_DEPT_NAME
            ,a.creation_date_time
            ,a.update_date_time
        from
            ASSET_ADMIN_DEPT a
        with ur
    ';

    return ( 'podData', $query, \@fields );
}

sub getSectorData {
    my ( $self, $connection ) = @_;

    dlog('Start getSectorData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->querySectorData() );

    my $sth = $connection->sql->{sectorData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{sectorDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $sector = new BRAVO::OM::Sector();
        $sector->sectorId( $rec{id} );
        $sector->name( $rec{name} );
        $sector->creationDateTime( $rec{creationDateTime} );
        $sector->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $sector;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub querySectorData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
            a.sector_id
            ,a.sector_name
            ,a.creation_date_time
            ,a.update_date_time
        from
            sector a
        with ur
    ';

    return ( 'sectorData', $query, \@fields );
}

sub getIndustryData {
    my ( $self, $connection ) = @_;

    dlog('Start getIndustryData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryIndustryData() );

    my $sth = $connection->sql->{industryData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{industryDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $industry = new BRAVO::OM::Industry();
        $industry->industryId( $rec{id} );
        $industry->name( $rec{name} );
        $industry->creationDateTime( $rec{creationDateTime} );
        $industry->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $industry;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryIndustryData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
        	a.industry_id
            ,a.industry_name
            ,a.creation_date_time
            ,a.update_date_time
        from
            LGCY_INDUSTRY a
        with ur
    ';

    return ( 'industryData', $query, \@fields );
}

sub getOutsourceProfileData {
    my ( $self, $connection ) = @_;

    dlog('Start getOutsourceProfileData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields(
        $self->queryOutsourceProfileData() );

    my $sth = $connection->sql->{outsourceProfileData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{outsourceProfileDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $outsourceProfile = new BRAVO::OM::OutsourceProfile();
        $outsourceProfile->outsourceProfileId( $rec{id} );
        $outsourceProfile->customerId( $rec{customerId} );
        $outsourceProfile->assetProcessId( $rec{assetProcessId} );
        $outsourceProfile->countryId( $rec{countryId} );
        $outsourceProfile->outsourceable( $rec{outsourceable} );
        $outsourceProfile->comment( $rec{comment} );
        $outsourceProfile->approver( $rec{approver} );
        $outsourceProfile->recordTime( $rec{recordTime} );
        $outsourceProfile->current( $rec{current} );
        $outsourceProfile->creationDateTime( $rec{creationDateTime} );
        $outsourceProfile->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $outsourceProfile;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryOutsourceProfileData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            customerId
            assetProcessId
            countryId
            outsourceable
            comment
            approver
            recordTime
            current
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
        	a.id
            ,a.customer_id
            ,a.asset_process_id
            ,a.country_id
            ,a.outsourceable
            ,a.comment
            ,a.approver
            ,a.record_time
            ,a.current
            ,a.creation_date_time
            ,a.update_date_time
        from
            V_SOFTWARE_OP a
        with ur
    ';

    return ( 'outsourceProfileData', $query, \@fields );
}

sub getCustomerTypeData {
    my ( $self, $connection ) = @_;

    dlog('Start getCustomerTypeData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryCustomerTypeData() );

    my $sth = $connection->sql->{customerTypeData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerTypeDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $customerType = new BRAVO::OM::CustomerType();
        $customerType->customerTypeId( $rec{id} );
        $customerType->name( $rec{name} );
        $customerType->creationDateTime( $rec{creationDateTime} );
        $customerType->updateDateTime( $rec{updateDateTime} );

        $data{$key} = $customerType;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCustomerTypeData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
        	a.customer_type_id
            ,a.customer_type_name
            ,a.creation_date_time
            ,a.update_date_time
        from
            customer_type a
        with ur
    ';

    return ( 'customerTypeData', $query, \@fields );
}

sub getCustomerData {
    my ( $self, $connection ) = @_;

    dlog('Start getCustomerData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryCustomerData() );

    my $sth = $connection->sql->{customerData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $customer = new BRAVO::OM::Customer();
        $customer->customerId( $rec{id} );
        $customer->customerTypeId( $rec{customerTypeId} );
        $customer->podId( $rec{podId} );
        $customer->industryId( $rec{industryId} );
        $customer->accountNumber( $rec{accountNumber} );
        $customer->customerName( $rec{customerName} );
        $customer->contactDpeId( $rec{contactDpeId} );
        $customer->contactFaId( $rec{contactFaId} );
        $customer->contactHwId( $rec{contactHwId} );
        $customer->contactSwId( $rec{contactSwId} );
        $customer->contactFocalAssetId( $rec{contactFocalAssetId} );
        $customer->contractSignDate( $rec{contractSignDate} );
        $customer->assetToolsBillingCode( $rec{assetToolsBillingCode} );
        $customer->status( $rec{status} );
        $customer->hwInterlock( $rec{hwInterlock} );
        $customer->swInterlock( $rec{swInterlock} );
        $customer->invInterlock( $rec{invInterlock} );
        $customer->swLicenseMgmt( $rec{swLicenseMgmt} );
        $customer->swSupport( $rec{swSupport} );
        $customer->hwSupport( $rec{hwSupport} );
        $customer->transitionStatus( $rec{transitionStatus} );
        $customer->countryCodeId( $rec{countryCodeId} );
        $customer->scanValidity( $rec{scanValidity} );
        $customer->swTracking( $rec{swTracking} );
        $customer->swComplianceMgmt( $rec{swComplianceMgmt} );
        $customer->swFinancialResponsibility(
            $rec{swFinancialResponsibility} );
        $customer->swFinancialMgmt( $rec{swFinancialMgmt} );
        $customer->creationDateTime( $rec{creationDateTime} );
        $customer->updateDateTime( $rec{updateDateTime} );
        $customer->tmeObjectId( $rec{tmeObjectId} );        
        $customer->sectorId( $rec{sectorId} ); 

        $data{$key} = $customer;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCustomerData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            customerTypeId
            podId
            industryId
            accountNumber
            customerName
            contactDpeId
            contactFaId
            contactHwId
            contactSwId
            contactFocalAssetId
            contactTransitionId
            contractSignDate
            assetToolsBillingCode
            status
            hwInterlock
            swInterlock
            invInterlock
            swLicenseMgmt
            swSupport
            hwSupport
            transitionStatus
            transitionExitDate
            countryCodeId
            scanValidity
            swTracking
            swComplianceMgmt
            swFinancialResponsibility
            swFinancialMgmt
            creationDateTime
            updateDateTime
            tmeObjectId
            sectorId
            )
    );

    my $query = '
        select
        	a.customer_id
        	,a.customer_type_id
        	,a.ASSET_ADMIN_DEPT_ID
        	,a.indutry_id
        	,a.account_number
        	,a.ACCOUNT_NAME
        	,a.DPE_CONTACT_ID
        	,a.FIN_ANALYST_CONTACT_ID
        	,a.HW_CONTACT_ID
        	,a.SW_CONTACT_ID
        	,a.FOCAL_ASSET_CONTACT_ID
        	,a.TRANSITION_CONTACT_ID
        	,a.CONTRACT_SIGN_DATE
        	,a.ASSET_TOOLS_BILLING_CODE
        	,a.status
        	,a.hw_interlock
        	,a.sw_interlock
        	,a.inv_interlock
        	,a.sw_license_mgmt
        	,a.sw_support
        	,a.hw_support
        	,a.transition_status
        	,a.transition_exit_date
        	,a.country_code_id
        	,a.scan_validity
        	,a.sw_tracking
        	,a.sw_compliance_mgmt
        	,a.sw_financial_responsibility
        	,a.sw_financial_mgmt
            ,a.creation_date_time
            ,a.update_date_time
            ,a.tme_object_id
            ,a.sector_id
        from
            LGCY_ACCOUNT a
        with ur
    ';

    return ( 'customerData', $query, \@fields );
}

sub getCustomerNumberData {
    my ( $self, $connection ) = @_;

    dlog('Start getCustomerNumberData method');

    ###Hash to return
    my %data;

    ###Prepare the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryCustomerNumberData() );

    my $sth = $connection->sql->{customerNumberData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{customerNumberDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $key = $rec{id};
        dlog("key=$key");

        my $customerNumber = new BRAVO::OM::CustomerNumber();
        $customerNumber->customerNumberId( $rec{id} );
        $customerNumber->customerId( $rec{customerId} );
        $customerNumber->customerNumber( $rec{customerNumber} );
        $customerNumber->status( $rec{status} );
        $customerNumber->creationDateTime( $rec{creationDateTime} );
        $customerNumber->updateDateTime( $rec{updateDateTime} );
        $customerNumber->lpidId( $rec{lpidId} );
        $customerNumber->countryCodeId( $rec{countryCodeId} );

        $data{$key} = $customerNumber;
    }
    $sth->finish;

    ###Close our cndb connection
    $connection->disconnect;

    return \%data;
}

sub queryCustomerNumberData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            customerId
            customerNumber
            lpidId
            countryCodeId
            status
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
        	a.customer_number_id
        	,a.customer_id
        	,a.customer_number
        	, case when a.lpid_id is null then 999999 else a.lpid_id end
        	,a.country_code_id
        	,a.status
            ,a.creation_date_time
            ,a.update_date_time
        from
            V_SOFTWARE_CUST_NBR a
        with ur
    ';

    return ( 'customerNumberData', $query, \@fields );
}

sub getAccountPoolData {
    my ( $self, $connection ) = @_;

    dlog('In CNDBDelegate->getAccountPoolData method');

    my %accountPoolList;

    ###Prepare the query
    $connection->prepareSqlQueryAndFields( $self->queryAccountPoolData );

    ###Get the statement handle
    my $sth = $connection->sql->{accountPoolData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $connection->sql->{accountPoolDataFields} } );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our accountpool object
        my $accountPool = $self->buildAccountPool( \%rec );
        next if ( !defined $accountPool );

        ###Build our CapType object list
        my $key = $accountPool->accountPoolId;
        $accountPoolList{$key} = $accountPool
            if ( !defined $accountPoolList{$key} );

    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%accountPoolList );
}

sub queryAccountPoolData {
    my ($self) = @_;

    my @fields = (
        qw(
            accountPoolId
            masterAccountId
            memberAccountId
            logicalDeleteInd
            )
    );

    my $query = '
        select
            account_pool_id
            ,master_account_id
            ,member_account_id
            ,logical_delete_ind            
        from
            account_pool
        with ur
    ';

    return ( 'accountPoolData', $query, \@fields );
}

sub buildAccountPool {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the account pool record
    my $accountPool = new BRAVO::OM::AccountPool();
    $accountPool->accountPoolId( $rec->{accountPoolId} );
    $accountPool->logicalDeleteInd( $rec->{logicalDeleteInd} );
    $accountPool->masterAccountId( $rec->{masterAccountId} );
    $accountPool->memberAccountId( $rec->{memberAccountId} );

    return $accountPool;
}

1;
