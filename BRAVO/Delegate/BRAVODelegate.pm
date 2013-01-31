package BRAVO::Delegate::BRAVODelegate;

use strict;
use Base::Utils;
use BRAVO::OM::HardwareLpar;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::HardwareSoftwareComposite;
use BRAVO::OM::SoftwareDiscrepancyHistory;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::InstalledSignature;
use BRAVO::OM::InstalledFilter;
use BRAVO::OM::InstalledTLCMZ;
use BRAVO::OM::InstalledTADZ;
use BRAVO::OM::InstalledDorana;
use Recon::Queue;

sub getDiscrepancyTypeMap {
    my ($self) = @_;

    my %data;

    ###NOTE: Hard coding these values from the database
    ###b/c they are extremely static and this data is
    ###required by the recon engine for the recon of
    ###every piece of installed software, and the recon
    ###engine children are short lived which does not
    ###allow for ability to get once and reuse across
    ###multiple recons.

    $data{'NONE'}      = 1;
    $data{'MISSING'}   = 2;
    $data{'FALSE HIT'} = 3;
    $data{'VALID'}     = 4;
    $data{'INVALID'}   = 5;
    $data{'TADZ'}      = 6;

    return \%data;
}

sub getCapacityTypeMap {
    my ( $self, $connection ) = @_;

    my %data;

    $connection->prepareSqlQueryAndFields( $self->queryCapacityTypeMap() );
    my $sth = $connection->sql->{capacityTypeNameMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{capacityTypeMapFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        $data{ $rec{code} } = $rec{description};
    }
    $sth->finish;

    return \%data;
}

sub queryCapacityTypeMap {
    my @fields = qw(
        code
        description
    );
    my $query = '
        select
            a.code
            ,a.description
        from
            capacity_type a
    ';

    return ( 'capacityTypeMap', $query, \@fields );
}

sub getMachineTypeNameMap {
    my ( $self, $connection ) = @_;

    my %data = ();

    $connection->prepareSqlQueryAndFields( $self->queryMachineTypeNameMap() );
    my $sth = $connection->sql->{machineTypeNameMap};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{machineTypeNameMapFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {
        $data{ $rec{name} } = $rec{id};
    }
    $sth->finish;

    return \%data;
}

sub queryMachineTypeNameMap {
    my @fields = qw(
        name
        id
    );
    my $query = '
        select
            upper(a.name)
            ,a.id
        from
            machine_type a
        where
            a.status = \'ACTIVE\'
    ';

    return ( 'machineTypeNameMap', $query, \@fields );
}

sub getInstalledSoftwareCountById {
    my ( $self, $connection, $id ) = @_;

    my $count = undef;

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareCountById() );
    my $sth = $connection->sql->{installedSoftwareCountById};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwareCountByIdFields} } );
    $sth->execute( $id, $id, $id, $id,$id );
    while ( $sth->fetchrow_arrayref ) {
        $count = $count+ $rec{count};
    }
    $sth->finish;

    return $count;
}

sub queryInstalledSoftwareCountById {
    my @fields = (qw( count ));
    my $query  = '
        select count(*)
        from installed_signature a
        where a.installed_software_id = ?
        union
        select count(*)
        from installed_filter a
        where a.installed_software_id = ?
        union
        select count(*)
        from installed_sa_product a
        where a.installed_software_id = ?
        union
        select count(*)
        from installed_dorana_product a
        where a.installed_software_id = ?
        union
        select count(*)
        from installed_tadz a
        where a.installed_software_id = ?
    ';

    return ( 'installedSoftwareCountById', $query, \@fields );
}

sub getInstalledSoftwareCountBySwLparId {
    my ( $self, $connection, $id ) = @_;

    my $count = undef;

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareCountBySwLparId() );
    my $sth = $connection->sql->{installedSoftwareCountBySwLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwareCountBySwLparIdFields} } );
    $sth->execute($id);
    while ( $sth->fetchrow_arrayref ) {

        $count = $rec{count};
    }
    $sth->finish;

    return $count;
}

sub queryInstalledSoftwareCountBySwLparId {
    my @fields = (qw( count ));
    my $query  = '
        select
            count(*)
        from
            installed_software a
        where
            a.software_lpar_id = ?
            and a.status = \'ACTIVE\'
    ';
    return ( 'installedSoftwareCountBySwLparId', $query, \@fields );
}

sub getInstalledSoftwareIdsBySwLparId {
    my ( $self, $connection, $id ) = @_;

    my @ids = ();

    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareIdsBySwLparId() );
    my $sth = $connection->sql->{installedSoftwareIdsBySwLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwareIdsBySwLparIdFields} } );
    $sth->execute($id);
    while ( $sth->fetchrow_arrayref ) {

        push @ids, $rec{id};
    }
    $sth->finish;

    return @ids;
}

sub queryInstalledSoftwareIdsBySwLparId {
    my @fields = qw( id );
    my $query  = '
        select
            a.id
        from
            installed_software a
        where
            a.software_lpar_id = ?
            and a.status = \'ACTIVE\'
    ';
    return ( 'installedSoftwareIdsBySwLparId', $query, \@fields );
}

sub getSoftwareIdBySoftwareNameAndType {
    my ( $self, $connection, $softwareName, $type ) = @_;

    my $softwareId = undef;
    $connection->prepareSqlQuery( $self->querySoftwareIdBySoftwareName() );
    my $sth = $connection->sql->{softwareIdBySoftwareName};
    $sth->bind_columns( \$softwareId );
    $sth->execute( $softwareName, $type );
    $sth->fetchrow_arrayref;
    $sth->finish;

    return $softwareId;
}

sub getSoftwareIdBySoftwareNameAndTypeFromHistory {
    my ( $self, $connection, $softwareName, $type ) = @_;

    my $softwareIdInHistory = undef;

    $connection->prepareSqlQuery( $self->querySoftwareIdBySoftwareNameFromHistory() );
    my $sth = $connection->sql->{softwareIdBySoftwareNameFromHistory};
    $sth->bind_columns( \$softwareIdInHistory );
    $sth->execute( $softwareName, $type );
    $sth->fetchrow_arrayref;
    $sth->finish;

    return $softwareIdInHistory;
}

sub querySoftwareIdBySoftwareName {
    my $query = '
        select
            pi.id
        from
            product_info pi
            ,product p
            ,software_item si
            ,kb_definition kd
        where
            upper(si.name) = ?
            and product_role = ?
            and kd.deleted != 1
            and pi.id = p.id
            and p.id = si.id
            and si.id = kd.id
    ';
    return ( 'softwareIdBySoftwareName', $query );
}

sub querySoftwareIdBySoftwareNameFromHistory {
    my $query = '
        select
            pa.product_id
        from
            alias a
            ,product_alias pa
            ,product p
            ,software_item si
            ,kb_definition kd
        where
            upper(a.name) = ?
            and si.product_role = ?
            and kd.deleted != 1
            and a.id = pa.alias_id
            and pa.product_id = p.id
            and p.id = si.id
            and si.id = kd.id
    ';
    return ( 'softwareIdBySoftwareNameFromHistory', $query );
}

sub getHwSwCompositeBySwLparId {
    my ( $self, $connection, $swLparId ) = @_;

    $connection->prepareSqlQueryAndFields( $self->queryHwSwCompositeBySwLparId() );
    my $sth = $connection->sql->{hwSwCompositeBySwLparId};
    my $id;
    $sth->bind_columns( \$id );
    $sth->execute($swLparId);
    $sth->fetchrow_arrayref;
    $sth->finish;

    my $hwSwComposite;
    if ( defined $id ) {
        $hwSwComposite = new BRAVO::OM::HardwareSoftwareComposite();
        $hwSwComposite->id($id);
        $hwSwComposite->getById($connection);
    }

    return $hwSwComposite;
}

sub queryHwSwCompositeBySwLparId {
    my $query = '
        select
            a.id
        from
            hw_sw_composite a
        where
            a.software_lpar_id = ?
    ';

    return ( 'hwSwCompositeBySwLparId', $query );
}

sub getHwLparsByCustomerIdAndShortName {
    my ( $self, $connection, $customerId, $shortName ) = @_;

    my %hardwareLpars = ();

    ###Escape any underscores to avoid use as wildcard.
    dlog( "shortName=" . $shortName );
    my $shortNameForLike = $shortName;
    $shortNameForLike =~ s/\\/\\\\/g;
    $shortNameForLike =~ s/_/\\_/g;
    dlog( "shortNameForLike=" . $shortNameForLike );

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryHwLparByCustomerIdAndShortName() );
    my $sth = $connection->sql->{hwLparsByCustomerIdAndShortName};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{hwLparsByCustomerIdAndShortNameFields} } );
    $sth->execute( $customerId, $shortName, $shortNameForLike . '.%' );
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id( $rec{id} );
        $hardwareLpar->getById($connection);

        ###Add to the list.
        $hardwareLpars{ $rec{id} } = $hardwareLpar;
        dlog( "added id=" . $rec{id} );
    }
    $sth->finish;

    return %hardwareLpars;
}

sub queryHwLparByCustomerIdAndShortName {
    my @fields = (qw( id ));

    my $query = '
        select
            a.id
        from
            hardware_lpar a
        where
            a.customer_id = ?
            and (a.name = ? or a.name like ? escape \'\\\')
            and a.status = \'ACTIVE\'
    ';
    return ( 'hwLparsByCustomerIdAndShortName', $query, \@fields );
}

sub getSwLparsByCustomerIdAndShortName {
    my ( $self, $connection, $customerId, $shortName ) = @_;

    my %softwareLpars = ();

    ###Escape any underscores to avoid use as wildcard.
    dlog( "shortName=" . $shortName );
    my $shortNameForLike = $shortName;
    $shortNameForLike =~ s/\\/\\\\/g;
    $shortNameForLike =~ s/_/\\_/g;
    dlog( "shortNameForLike=" . $shortNameForLike );

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->querySwLparByCustomerIdAndShortName() );
    my $sth = $connection->sql->{swLparsByCustomerIdAndShortName};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{swLparsByCustomerIdAndShortNameFields} } );
    $sth->execute( $customerId, $shortName, $shortNameForLike . '.%' );
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id( $rec{id} );
        $softwareLpar->getById($connection);

        ###Add to the list.
        $softwareLpars{ $rec{id} } = $softwareLpar;
    }
    $sth->finish;

    return %softwareLpars;
}

sub getProcgrpsData {
    my ( $self, $connection ) = @_;

    dlog('In the getProcgrpsData method');
    ###We are not doing deltas here

    my %procgrpsList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryProcgrpsData );

    ###Define the fields
    my @fields = (
        qw(type model group vendor description updUser updStamp msu pslcInd wlcInd totalEngines zosEngines ewlcInd updIntranetID status)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{procgrpsData};

    ###Bind the columns
    my %rec;
    my %origRec;
    my $dupProcgrps = 0;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    my $i = 0;
    while ( $sth->fetchrow_arrayref ) {
        ###Build our hardware object list
        my $procgrps = $self->buildProcgrps( \%rec );
        next if ( !defined $procgrps );

        my $key = $procgrps->type . '|' . $procgrps->model . '|' . $procgrps->group . '|' . $procgrps->vendor;

        ###Add the hardware to the list
        $procgrpsList{$key} = $procgrps
            if ( !defined $procgrpsList{$key} );
    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%procgrpsList );
}

sub getMipsData {
    my ( $self, $connection ) = @_;

    dlog('In BRAVODelegate->getMipsData method');

    my %mipsList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryMipsData );

    ###Define the fields
    my @fields = (
        qw(type model group vendor mipsVendor mips updUser updStamp updIntranetID status)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{mipsData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our hardware object list
        my $mips = $self->buildMips( \%rec );
        next if ( !defined $mips );

        ###Build our mips object list
        my $key =
            $mips->type . '|' . $mips->model . '|' . $mips->group . '|' . $mips->vendor . '|' . $mips->mipsVendor;
        $mipsList{$key} = $mips
            if ( !defined $mipsList{$key} );

    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%mipsList );
}

sub querySwLparByCustomerIdAndShortName {
    my @fields = (qw( id ));
    my $query  = '
        select
            a.id
        from
            software_lpar a
        where
            a.customer_id = ?
            and (a.name = ? or a.name like ? escape \'\\\')
            and a.status = \'ACTIVE\'
    ';

    return ( 'swLparsByCustomerIdAndShortName', $query, \@fields );
}

sub queryInstalledSoftwaresBySoftwareLparId {
    my @fields = qw(
        isId
        swId
        dtId
        isUsers
        isProcCount
        isAuthenticated
        isVersion
        isRemoteUser
        isRecordTime
        isStatus
        itType
        itId
        itTypeId
        bankAccountId
    );
    my $query = '
        select
        	is.id
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'SIGNATURE\' as itType
        	,it.id as itId
        	,it.software_signature_id as itTypeId
        	,it.bank_account_id as bankAccountId
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_signature it on it.installed_software_id = is.id
        	where sl.id = ?
        	and is.status = \'ACTIVE\'
        union
        select 
			is.id
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'FILTER\' as itType
        	,it.id as itId
        	,it.software_filter_id as itTypeId
        	,it.bank_account_id as bankAccountId
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_filter it on it.installed_software_id = is.id
        	where sl.id = ?
        	and is.status = \'ACTIVE\'
        union
        select
        	is.id
            ,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'TLCMZ\' as itType
        	,it.id as itId
        	,it.sa_product_id as itTypeId
        	,it.bank_account_id as bankAccountId
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_sa_product it on it.installed_software_id = is.id
        	where sl.id = ?
        	and is.status = \'ACTIVE\'
        union
        select
        	is.id
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'DORANA\' as itType
        	,it.id as itId
        	,it.dorana_product_id as itTypeId
        	,it.bank_account_id as bankAccountId
        from software_lpar sl
	        join installed_software is on is.software_lpar_id = sl.id
	        join installed_dorana_product it on it.installed_software_id = is.id
	        where sl.id = ?
	        and is.status = \'ACTIVE\'
	    union
		select 
			is.id
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'TADZ\' as itType
        	,it.id as itId
        	,it.mainframe_feature_id as itTypeId
        	,it.bank_account_id as bankAccountId
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_tadz it on it.installed_software_id = is.id
        	where sl.id = ?
        	and is.status = \'ACTIVE\'
        union
        select
        	is.id
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.users
        	,is.processor_count
        	,is.authenticated
        	,is.version
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'MANUAL\' as itType
        	,0 as itId
        	,0 as itTypeId
        	,0 as bankAccountId
        from software_lpar sl
	        join installed_software is on is.software_lpar_id = sl.id
	        where sl.id = ?
	        and is.status = \'ACTIVE\'
	        and not exists (select 1 from installed_signature it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_filter it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_sa_product it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_dorana_product it where it.installed_software_id = is.id)
    ';
    return ( 'installedSoftwaresBySoftwareLparId', $query, \@fields );
}

sub getBankAccountsBySoftwareLpar {

    my ( $self, $connection, $softwareLpar ) = @_;

    my %bankAccountIds = ();

    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwaresBySoftwareLparId() );
    my $sth = $connection->sql->{installedSoftwaresBySoftwareLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwaresBySoftwareLparIdFields} } );
    $sth->execute( $softwareLpar->id, $softwareLpar->id, $softwareLpar->id, $softwareLpar->id, $softwareLpar->id );
    while ( $sth->fetchrow_arrayref ) {
        $bankAccountIds{ $rec{bankAccountId} }++;
    }
    $sth->finish;

    my @bankAccountIds = ();
    foreach my $bankAccountId ( sort keys %bankAccountIds ) {
        push @bankAccountIds, $bankAccountId;
    }

    return @bankAccountIds;
}

sub inactivateSoftwareLparById {

    my ( $self, $connection, $id, $statistics ) = @_;

    ###Loop over inst sw/types and delete all, last one will inactivate sw lpar.
    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwaresBySoftwareLparId() );
    my $sth = $connection->sql->{installedSoftwaresBySoftwareLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwaresBySoftwareLparIdFields} } );
    $sth->execute( $id, $id, $id, $id, $id );
    my %statistics;
    while ( $sth->fetchrow_arrayref ) {
        dlog("deleting installed types");
        if ( $rec{itType} eq 'MANUAL' ) {
            $self->deleteInstalledTypeByTypeAndId( $connection, $rec{itType}, $rec{isId}, $statistics );
        }
        else {
            $self->deleteInstalledTypeByTypeAndId( $connection, $rec{itType}, $rec{itId}, $statistics )
                ;
        }
    }
    $sth->finish;
}

sub inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId {
    my ( $self, $connection, $softwareLparId, $bankAccountId ) = @_;
    my %statistics =();
    ###Loop over inst sw/types and delete all for this bank account id.
    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwaresBySoftwareLparId() );
    my $sth = $connection->sql->{installedSoftwaresBySoftwareLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{installedSoftwaresBySoftwareLparIdFields} } );
    $sth->execute( $softwareLparId, $softwareLparId, $softwareLparId, $softwareLparId, $softwareLparId );
    while ( $sth->fetchrow_arrayref ) {
        next unless $rec{bankAccountId} == $bankAccountId;
        if ( $rec{itType} eq 'MANUAL' ) {
            $self->deleteInstalledTypeByTypeAndId( $connection, $rec{itType}, $rec{isId},  \%statistics );
        }
        else {
            $self->deleteInstalledTypeByTypeAndId( $connection, $rec{itType}, $rec{itId},  \%statistics );
        }
    }
    $sth->finish;
}

sub inactivateInstalledSoftwareById {

    my ( $self, $connection, $softwareLparId, $softwareId ) = @_;
    my %statistics =();
    $connection->prepareSqlQueryAndFields( $self->queryInstalledSoftwareBySoftwareLparIdAndSoftwareId() );
    my $sth = $connection->sql->{installedSoftwareBySoftwareLparIdAndSoftwareId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
                        @{ $connection->sql->{installedSoftwareBySoftwareLparIdAndSoftwareIdFields} } );
    $sth->execute( $softwareLparId, $softwareId );
    while ( $sth->fetchrow_arrayref ) {
        $self->deleteInstalledTypeByTypeAndId( $connection, 'MANUAL', $rec{isId},  \%statistics );
    }
    $sth->finish;
}

sub queryInstalledSoftwareBySoftwareLparIdAndSoftwareId {
    my @fields = qw(
        isId
    );

    # ALEX: This query DID have the condition that the discrepancy_type is 2
    # HOWEVER, the users have by-passed this so it is no longer valid to think that
    # manual spreadsheets will have a discrepancy of 2
    # too this test out of the query 'and is.discrepancy_type_id = 2'
    my $query = '
        select
        	is.id
        from installed_software is
	        where is.software_lpar_id = ?
            and is.software_id = ?            
	        and is.status = \'ACTIVE\'
	        and not exists (select 1 from installed_signature it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_filter it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_sa_product it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_dorana_product it where it.installed_software_id = is.id)
    ';
    return ( 'installedSoftwareBySoftwareLparIdAndSoftwareId', $query, \@fields );
}

sub deleteInstalledTypeByTypeAndId {
    my ( $self, $connection, $type, $id, $stats ) = @_;
    my %statistics = %{$stats};
    my $installedSoftware = new BRAVO::OM::InstalledSoftware();
    if ( $type eq 'MANUAL' ) {

        ###Get inst sw from passed id.
        $installedSoftware->id($id);
        $installedSoftware->getById($connection);
    }
    else {

        ###Get inst type from passed id by type.
        my $installedType;
        if ( $type eq 'SIGNATURE' ) {
            $installedType = new BRAVO::OM::InstalledSignature();
        }
        elsif ( $type eq 'FILTER' ) {
            $installedType = new BRAVO::OM::InstalledFilter();
        }
        elsif ( $type eq 'TLCMZ' ) {
            $installedType = new BRAVO::OM::InstalledTLCMZ();
        }
        elsif ( $type eq 'DORANA' ) {
            $installedType = new BRAVO::OM::InstalledDorana();
        }
        elsif( $type eq 'TADZ'){
           $installedType = new BRAVO::OM::InstalledTADZ();
        }
        $installedType->id($id);
        $installedType->getById($connection);

        ###Get inst sw from inst type.
        $installedSoftware->id( $installedType->installedSoftwareId );
        $installedSoftware->getById($connection);

        ###Delete inst type.
        $installedType->delete($connection);
        $statistics{'TRAILS'}{$type}{'DELETE'}++;
    }

    ###Get inst type count for inst sw now.
    my $itCount = $self->getInstalledSoftwareCountById( $connection, $installedSoftware->id );
    if ( $itCount == 0 ) {

        ###Set inst sw to inactive.
        $installedSoftware->status('INACTIVE');
        $installedSoftware->save($connection);
        $statistics{'TRAILS'}{'INSTALLED_SOFTWARE'}{'DELETE'}++;

        ###Insert history record if discrepancy.
        if ( $type eq 'MANUAL' ) {
            my $discrepancyHistory = new BRAVO::OM::SoftwareDiscrepancyHistory();
            $discrepancyHistory->installedSoftwareId( $installedSoftware->id );
            $discrepancyHistory->action('CLOSED - MISSING');
            $discrepancyHistory->comment('AUTO CLOSE');
            $discrepancyHistory->save($connection);
            $statistics{'TRAILS'}{'SW_DISCREP_HIS'}{'UPDATE'}++;
        }

        ###Get software lpar object.
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id( $installedSoftware->softwareLparId );
        $softwareLpar->getById($connection);

        ###Call the recon engine for the inst sw object.
        my $queue = Recon::Queue->new( $connection, $installedSoftware, $softwareLpar );
        $queue->add;
        $statistics{'TRAILS'}{'RECON_INST_SW'}{'UPDATE'}++;

        ###Get inst sw count for sw lpar.
        my $isCount = $self->getInstalledSoftwareCountBySwLparId( $connection, $softwareLpar->id );
        if ( $isCount == 0 ) {

            ###Set sw lpar to inactive.
            $softwareLpar->status('INACTIVE');
            $softwareLpar->save($connection);
            $statistics{'TRAILS'}{'SOFTWARE_LPAR'}{'DELETE'}++;

            ###Call the recon engine for the sw lpar object.
            my $queue = Recon::Queue->new( $connection, $softwareLpar );
            $queue->add;
            $statistics{'TRAILS'}{'RECON_SW_LPAR'}{'UPDATE'}++;
        }
    }
}

sub getHwLparsByCustomerId {
    my ( $self, $connection, $customerId ) = @_;

    my %hardwareLpars = ();

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryHwLparsByCustomerId() );
    my $sth = $connection->sql->{hwLparsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{hwLparsByCustomerIdFields} } );
    $sth->execute($customerId);
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $hardwareLpar = new BRAVO::OM::HardwareLpar();
        $hardwareLpar->id( $rec{id} );
        $hardwareLpar->getById($connection);

        ###Add to the list.
        $hardwareLpars{ $rec{id} } = $hardwareLpar;
        dlog( "added id=" . $rec{id} );
    }
    $sth->finish;

    return %hardwareLpars;
}

sub queryHwLparsByCustomerId {
    my @fields = qw( id );
    my $query  = '
        select
            a.id
        from
            hardware_lpar a
        where
            a.customer_id = ?
    ';
    return ( 'hwLparsByCustomerId', $query, \@fields );
}

sub getSwLparsByCustomerId {
    my ( $self, $connection, $customerId ) = @_;

    my %softwareLpars = ();

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->querySwLparsByCustomerId() );
    my $sth = $connection->sql->{swLparsByCustomerId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{swLparsByCustomerIdFields} } );
    $sth->execute($customerId);
    while ( $sth->fetchrow_arrayref ) {

        ###Get the lpar object.
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id( $rec{id} );
        $softwareLpar->getById($connection);

        ###Add to the list.
        $softwareLpars{ $rec{id} } = $softwareLpar;
        dlog( "added id=" . $rec{id} );
    }
    $sth->finish;

    return %softwareLpars;
}

sub getBankAccountInclusionMap {
    my ( $self, $connection ) = @_;

    my %map = ();

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( $self->queryBankAccountInclusion() );
    my $sth = $connection->sql->{bankAccountInclusion};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{bankAccountInclusionFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Add to the list.
        $map{ $rec{customerId} }{ $rec{bankAccountId} } = 1;
        dlog( "customerId=" . $rec{customerId} . " bank account=" . $rec{bankAccountId} );
    }
    $sth->finish;

    return \%map;
}

sub queryBankAccountInclusion {
    my @fields = qw( customerId bankAccountId );
    my $query  = '
        select
            a.customer_id
            ,a.bank_account_id
        from
            bank_account_inclusion a
    ';
    return ( 'bankAccountInclusion', $query, \@fields );
}

sub querySwLparsByCustomerId {
    my @fields = qw( id );
    my $query  = '
        select
            a.id
        from
            software_lpar a
        where
            a.customer_id = ?
    ';
    return ( 'swLparsByCustomerId', $query, \@fields );
}

sub queryCompositeDataByCustomerId {
    my @fields = qw( hscId hlId hlCustomerId hlStatus slId slCustomerId slStatus );
    my $query  = '
        select
            hsc.id
            ,hl.id
            ,hl.customer_id
            ,hl.status
            ,sl.id
            ,sl.customer_id
            ,sl.status
        from
            hw_sw_composite hsc
            join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
            join software_lpar sl on sl.id = hsc.software_lpar_id
        where
            (hl.customer_id = ? or sl.customer_id = ?)
    ';
    return ( 'compositeDataByCustomerId', $query, \@fields );
}

sub queryHardwareDataByCustomerId {
    my @fields = qw( hlId hlCustomerId hlStatus slId slCustomerId slStatus );
    my $query  = '
        select
            hl.id
            ,hl.customer_id
            ,hl.status
            ,h.id
            ,h.customer_number
            ,h.status
            ,h.hardware_status
        from
            hardware_lpar hl
            join hardware h on h.id = hl.hardware_id
        where
            hl.customer_id = ?
    ';
    return ( 'hardwareDataByCustomerId', $query, \@fields );
}

sub isInCompositeByHwLparId {
    my ( $self, $connection, $id ) = @_;
    my $hsc = $self->getHwSwCompositeByHwLparId( $connection, $id );
    if ( defined $hsc ) {
        if ( defined $hsc->id ) {
            return 1;
        }
    }
    return 0;
}

sub isInCompositeBySwLparId {
    my ( $self, $connection, $id ) = @_;
    my $hsc = $self->getHwSwCompositeBySwLparId( $connection, $id );
    if ( defined $hsc ) {
        if ( defined $hsc->id ) {
            return 1;
        }
    }
    return 0;
}

sub getEffProcCountBySwLparId {
    my ( $self, $connection, $id ) = @_;
    my $slEffProc = new BRAVO::OM::SoftwareLparEff();
    $slEffProc->softwareLparId($id);
    if ( $slEffProc->getByBizKey($connection) ) {
        if ( $slEffProc->status eq 'ACTIVE' ) {
            return $slEffProc->processorCount;
        }
    }
    my $softwareLpar = new BRAVO::OM::SoftwareLpar();
    $softwareLpar->id($id);
    $softwareLpar->getById($connection);
    return $softwareLpar->processorCount;
}

sub querySoftwareLparsByHardwareId {
    my @fields = (qw( id ));
    my $query  = '
		select
			sl.id
		from
			hardware h
			join hardware_lpar hl on hl.hardware_id = h.id
			join hw_sw_composite hsc on hsc.hardware_lpar_id = hl.id
			join software_lpar sl on sl.id = hsc.software_lpar_id
		where
			h.id = ?
    ';
    return ( 'softwareLparsByHardwareId', $query, \@fields );
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
    ';

    return ( 'contactData', $query, \@fields );
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
    ';

    return ( 'geographyData', $query, \@fields );
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
    ';

    return ( 'regionData', $query, \@fields );
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
    ';

    return ( 'countryCodeData', $query, \@fields );
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
            a.pod_id
            ,a.pod_name
            ,a.creation_date_time
            ,a.update_date_time
        from
            pod a
    ';

    return ( 'podData', $query, \@fields );
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
    ';

    return ( 'sectorData', $query, \@fields );
}

sub queryIndustryData {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            sectorId
            name
            creationDateTime
            updateDateTime
            )
    );

    my $query = '
        select
        	a.industry_id
            ,a.sector_id
            ,a.industry_name
            ,a.creation_date_time
            ,a.update_date_time
        from
            industry a
    ';

    return ( 'industryData', $query, \@fields );
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
            ,country_id
            ,outsourceable
            ,comment
            ,approver
            ,record_time
            ,current
            ,a.creation_date_time
            ,a.update_date_time
        from
            outsource_profile a
    ';

    return ( 'outsourceProfileData', $query, \@fields );
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
    ';

    return ( 'customerTypeData', $query, \@fields );
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
            )
    );

    my $query = '
        select
        	a.customer_id
        	,a.customer_type_id
        	,a.pod_id
        	,a.industry_id
        	,a.account_number
        	,a.customer_name
        	,a.contact_dpe_id
        	,a.contact_fa_id
        	,a.contact_hw_id
        	,a.contact_sw_id
        	,a.contact_focal_asset_id
        	,a.contact_transition_id
        	,a.contract_sign_date
        	,a.asset_tools_billing_code
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
        from
            customer a
    ';

    return ( 'customerData', $query, \@fields );
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
        	,a.lpid_id
        	,a.country_code_id
        	,a.status
            ,a.creation_date_time
            ,a.update_date_time
        from
            customer_number a
    ';

    return ( 'customerNumberData', $query, \@fields );
}

sub queryProcgrpsData {
    my $query = '
        select
            a.machine_type_id
            ,a.model
            ,a.procgrps_group
            ,a.vendor
            ,a.description
            ,a.upduser
            ,a.updstamp
            ,a.msu
            ,a.pslc_ind
            ,a.wlc_ind
            ,a.total_engines
            ,a.zos_engines
            ,ewlc_ind
            ,a.upd_intranet_id
            ,status
        from
            eaadmin.procgrps a
        with ur
    ';

    return ( 'procgrpsData', $query );
}

sub buildProcgrps {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the procgrps record
    my $procgrps = new SIMS::OM::Procgrps();
    $procgrps->type( $rec->{type} );
    $procgrps->model( $rec->{model} );
    $procgrps->group( $rec->{group} );
    $procgrps->vendor( $rec->{vendor} );
    $procgrps->description( $rec->{description} );
    $procgrps->updUser( $rec->{updUser} );
    $procgrps->updStamp( $rec->{updStamp} );
    $procgrps->msu( $rec->{msu} );
    $procgrps->pslcInd( $rec->{pslcInd} );
    $procgrps->wlcInd( $rec->{wlcInd} );
    $procgrps->totalEngines( $rec->{totalEngines} );
    $procgrps->zosEngines( $rec->{zosEngines} );
    $procgrps->ewlcInd( $rec->{ewlcInd} );
    $procgrps->updIntranetID( $rec->{updIntranetID} );
    $procgrps->status( $rec->{status} );

    return $procgrps;
}

sub queryMipsData {
    my $query = '
        select
            a.machine_type_id
            ,a.model
            ,a.mips_group
            ,a.vendor
            ,a.mipsvendor
            ,a.mips
            ,a.upduser
            ,a.updstamp
            ,a.upd_intranet_id
            ,a.status
        from
            eaadmin.mips a
        with ur
    ';

    return ( 'mipsData', $query );
}

sub buildMips {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the mips record
    my $mips = new SIMS::OM::Mips();
    $mips->type( $rec->{type} );
    $mips->model( $rec->{model} );
    $mips->group( $rec->{group} );
    $mips->vendor( $rec->{vendor} );
    $mips->mipsVendor( $rec->{mipsVendor} );
    $mips->mips( $rec->{mips} );
    $mips->updUser( $rec->{updUser} );
    $mips->updStamp( $rec->{updStamp} );
    $mips->updIntranetID( $rec->{updIntranetID} );
    $mips->status( $rec->{status} );

    return $mips;
}

sub getReconSummaryData {
    my ( $self, $connection ) = @_;

    dlog('In BRAVODelegate->getReconSummaryData method');

    my @reconList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryReconSummaryData );

    ###Define the fields
    my @fields = (
        qw(type manufacturerName softwareId softwareName
            reconcileTypeId open count)
    );

    ###Get the statement handle
    my $sth = $connection->sql->{reconSummaryData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        logRec( 'dlog', \%rec );
        my $key;
        my $value;
        my %myRec;
        while ( ( $key, $value ) = each %rec ) {
            $myRec{$key} = $value;
        }
        push @reconList, \%myRec;

    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \@reconList );
}

sub queryReconSummaryData {
    my $query = '
     select distinct mt.type, m.name, s.software_id, s.software_name, reconcile_type_id, aus.open, count(*) as count 
     from	alert_unlicensed_sw aus, 
   		reconcile r, 
   		installed_software is, 
   		software_lpar sl, 
   		software s, 
   		hw_sw_composite hsc,
   		hardware_lpar hl,
   		hardware h,
   		machine_type mt,
   		manufacturer m,
   		customer c
     where aus.installed_software_id = r.installed_software_id
     and r.installed_software_id = is.id
     and is.software_lpar_id = sl.id
     and sl.id = hsc.software_lpar_id
     and hsc.hardware_lpar_id = hl.id
     and hl.hardware_id = h.id
     and h.machine_type_id = mt.id
     and is.software_id = s.software_id
     and s.manufacturer_id = m.id
     and sl.customer_id = c.customer_id
     and r.reconcile_type_id in (5, 7, 8, 2, 4, 1, 6, 13, 3)
     and c.status = \'ACTIVE\'
     and c.country_code_id = 66
     group by mt.type, m.name, s.software_id, s.software_name, r.reconcile_type_id, aus.open
     order by mt.type, m.name, s.software_id, s.software_name, r.reconcile_type_id, aus.open  
    ';

    return ( 'reconSummaryData', $query );
}

sub queryCapTypeDataAndFields {

    ###Define the fields
    my @fields = (qw(id code description recordTime));

    my $query = '
        select
            code
            ,code
            ,description
            ,record_time
        from
            eaadmin.capacity_type
    ';

    return ( 'capTypeData', $query, \@fields );
}

sub queryLicTypeDataAndFields {

    ###Define the fields
    my @fields = (qw(id code description recordTime));

    my $query = '
        select
            code
            ,code
            ,description
            ,record_time
        from
            eaadmin.license_type
    ';

    return ( 'licTypeData', $query, \@fields );
}

sub queryAccountPoolDataAndFields {
    my ($self) = @_;

    my @fields = (
        qw(
            id
            accountPoolId
            masterAccountId
            memberAccountId
            logicalDeleteInd
            )
    );

    my $query = '
        select
            account_pool_id
            ,account_pool_id
            ,master_account_id
            ,member_account_id
            ,logical_delete_ind            
        from
            account_pool
    ';

    return ( 'accountPoolData', $query, \@fields );
}

sub querySwassetQueueDataAndFields {
    my @fields = (
        qw(
            id
            customerId
            softwareLparId
            hostname)
    );
    my $query = '
        select
            id
            ,customer_id
            ,software_lpar_id
            ,hostname
        from
            swasset_queue
    ';
    return ( 'swassetQueueData', $query, \@fields );
}

sub getSwassetQueueData {
    my ( $self, $connection ) = @_;

    my @swassetQueue = ();

    $connection->prepareSqlQueryAndFields( $self->querySwassetQueueDataAndFields() );
    my $sth = $connection->sql->{swassetQueueData};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{swassetQueueDataFields} } );
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        my $swassetRecord = new BRAVO::OM::SwassetQueue();
        $swassetRecord->id( $rec{id} );
        $swassetRecord->customerId( $rec{customerId} );
        $swassetRecord->softwareLparId( $rec{softwareLparId} );
        $swassetRecord->hostname( $rec{hostname} );

        push @swassetQueue, $swassetRecord;
    }
    $sth->finish;

    return @swassetQueue;
}

1;

