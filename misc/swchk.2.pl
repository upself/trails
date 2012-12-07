#!/usr/bin/perl -w

###Globals

###Modules
use strict;
use Base::Utils;
use Database::Connection;
use BRAVO::OM::Customer;

###Set logging level
logging_level("info");
$| = 1;

###Get bravo db connection
dlog("getting bravo connection");
my $bravoConnection = Database::Connection->new('trails');

###Get staging db connection
dlog("getting staging connection");
my $stagingConnection = Database::Connection->new('staging');

eval {
	###Get customer list
	dlog("getting customer list");
	my @customerIds = getCustomerIds($bravoConnection);
	dlog( "customer count=" . ( scalar @customerIds ) );

	###Perform healthchecks customer at a time
	foreach my $customerId (@customerIds) {
		ilog("processing customerId=$customerId");
		executeHchk( $bravoConnection, $stagingConnection, $customerId );
	}
};
if ($@) {
	die "ERROR: $@";
}

###Close bravo db connection
dlog("closing bravo connection");
$bravoConnection->disconnect;

###Close staging db connection
dlog("closing staging connection");
$stagingConnection->disconnect;

exit 0;

sub getCustomerIds {
	my ($bravoConnection) = @_;

	###Array to return
	my @customerIds = ();

	###Prepare and execute query
	$bravoConnection->prepareSqlQueryAndFields(
		queryCustomerIds() );
	my $sth = $bravoConnection->sql->{customerIds};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $bravoConnection->sql->{customerIdsFields} } );
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {
		push @customerIds, $rec{customerId};
	}
	$sth->finish;

	return @customerIds;
}

sub queryCustomerIds {
	my @fields = qw(
	  customerId
	);
	my $query = '
        select
            c.customer_id
        from customer c
        	join country_code cc on cc.id = c.country_code_id
        	where cc.name = \'UNITED STATES\'
        order by
        	c.customer_id
    ';
	dlog("queryCustomerIds=$query");
	return ( 'customerIds', $query, \@fields );
}

sub executeHchk {
	my ( $bravoConnection, $stagingConnection, $customerId ) = @_;

	###Get customer object by customer id
	my $customer = new BRAVO::OM::Customer();
	$customer->id($customerId);
	$customer->getById($bravoConnection);
	dlog( "customer=" . $customer->toString() );

	###
	###Get staging data in memory
	###

	###Hash to store staging sw lpar data
	my %stagingSoftwareLpars = ();

	###Hash to store staging inst sw data
	my %stagingInstalledSoftware = ();

	###Prepare and execute query
	$stagingConnection->prepareSqlQueryAndFields(
		queryStagingSoftwareDataByCustomerId() );
	my $stagingSth = $stagingConnection->sql->{stagingSoftwareDataByCustomerId};
	my %stagingRec;
	$stagingSth->bind_columns( map { \$stagingRec{$_} }
		  @{ $stagingConnection->sql->{stagingSoftwareDataByCustomerIdFields} }
	);
	$stagingSth->execute( $customerId, $customerId, $customerId, $customerId,
		$customerId );
	while ( $stagingSth->fetchrow_arrayref ) {

		###Only want rows with valid software line item
		next unless defined $stagingRec{softwareId};

		logRec( 'dlog', \%stagingRec );

		###Get the sw lpar key
		my $lparKey = $customerId . '|' . $stagingRec{name};

		###Store sw lpar info in hash
		$stagingSoftwareLpars{$lparKey}->{ $stagingRec{bankAccountId} } =
		  $stagingRec{scanRecordScanTime};

		###Get the inst sw key
		my $swKey =
		    $customerId . '|'
		  . $stagingRec{name} . '|'
		  . $stagingRec{softwareId} . '|'
		  . $stagingRec{bankAccountId} . '|'
		  . $stagingRec{itType} . '|'
		  . $stagingRec{itTypeId};
		dlog("swKey=$swKey");

		###Store inst sw record in hash
		foreach my $elem ( keys %stagingRec ) {
			$stagingInstalledSoftware{$swKey}->{$elem} = $stagingRec{$elem};
		}

		###Place found for compare
		$stagingInstalledSoftware{$swKey}->{found} = 0;
	}
	$stagingSth->finish;

	###
	###Loop over bravo data and compare to staging data in memory
	###

	###Prepare and execute query
	#$bravoConnection->prepareSqlQueryAndFields(
	#	queryBravoSoftwareDataByCustomerId() );
	#my $bravoSth = $bravoConnection->sql->{bravoSoftwareDataByCustomerId};
	#my %bravoRec;
	#$bravoSth->bind_columns( map { \$bravoRec{$_} }
	#	  @{ $bravoConnection->sql->{bravoSoftwareDataByCustomerIdFields} } );
	my $bravoDbh = $bravoConnection->dbh;
	my ( $queryId, $query, $fields ) = queryBravoSoftwareDataByCustomerId();
	my $bravoSth = $bravoDbh->prepare($query);
	my %bravoRec;
	$bravoSth->bind_columns( map { \$bravoRec{$_} } @{$fields} );

	$bravoSth->execute( $customerId, $customerId, $customerId, $customerId,
		$customerId );
	while ( $bravoSth->fetchrow_arrayref ) {

		###Only want rows with valid software line item
		next unless defined $bravoRec{softwareId};

		logRec( 'dlog', \%bravoRec );

		###Get the key
		my $key =
		    $customerId . '|'
		  . $bravoRec{name} . '|'
		  . $bravoRec{softwareId} . '|'
		  . $bravoRec{bankAccountId} . '|'
		  . $bravoRec{itType} . '|'
		  . $bravoRec{itTypeId};
		dlog("key=$key");

		###Compare to staging data
		if ( defined $stagingInstalledSoftware{$key} ) {
			dlog("key found in staging");

			###Set the found flag
			$stagingInstalledSoftware{$key}->{found} = 1;
		}
		else {
			dlog("key not found in staging");

			###Ignore manual discrepancies if remote user is not staging
			next
			  if ( $bravoRec{itType} eq 'MANUAL'
				&& $bravoRec{isRemoteUser} ne 'STAGING' );

			###See if we have a scan for this lpar from this bank account
			my $baStatus   = 'NO';
			my $baScanTime = 'NULL';
			my $lparKey    = $customerId . '|' . $bravoRec{name};
			if ( defined $stagingSoftwareLpars{$lparKey} ) {
				if (
					defined $stagingSoftwareLpars{$lparKey}
					->{ $bravoRec{bankAccountId} } )
				{
					$baStatus   = 'YES';
					$baScanTime =
					  $stagingSoftwareLpars{$lparKey}
					  ->{ $bravoRec{bankAccountId} };
				}
			}

			###Print entry to stdout
			print "BRAVO_NOT_STAGING,"
			  . $customer->accountNumber . ","
			  . $bravoRec{name} . ","
			  . $bravoRec{softwareId} . ","
			  . $bravoRec{bankAccountId} . ","
			  . $bravoRec{itType} . ","
			  . $bravoRec{itTypeId} . ","
			  . $bravoRec{isRecordTime} . ","
			  . $bravoRec{isRemoteUser} . ","
			  . $baStatus . ","
			  . $baScanTime . "\n";
		}
	}
	$bravoSth->finish;

	###
	###Loop over staging memory data and print not founds
	###

	foreach my $key ( keys %stagingInstalledSoftware ) {

		###Only want records not found in bravo
		next if $stagingInstalledSoftware{$key}->{found} == 1;

		dlog("key=$key");

		###Print entry to stdout
		print "STAGING_NOT_BRAVO,"
		  . $customer->accountNumber . ","
		  . $stagingInstalledSoftware{$key}->{name} . ","
		  . $stagingInstalledSoftware{$key}->{softwareId} . ","
		  . $stagingInstalledSoftware{$key}->{bankAccountId} . ","
		  . $stagingInstalledSoftware{$key}->{itType} . ","
		  . $stagingInstalledSoftware{$key}->{itTypeId} . ","
		  . $stagingInstalledSoftware{$key}->{itTypeAction} . "\n";
	}
}

sub queryStagingSoftwareDataByCustomerId {
	my @fields = qw(
	  name
	  scanTime
	  status
	  action
	  bankAccountId
	  scanRecordScanTime
	  scanRecordAction
	  softwareId
	  itType
	  itTypeId
	  itTypeAction
	);
	my $query = '
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,0
            ,c.scan_time
            ,c.action
            ,d.software_id
            ,\'MANUAL\'
            ,0
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_manual d on d.scan_record_id = c.id
            where a.customer_id = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.software_id
            ,\'SIGNATURE\'
            ,d.software_signature_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_signature d on d.scan_record_id = c.id
            where a.customer_id = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.software_id
            ,\'FILTER\'
            ,d.software_filter_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_filter d on d.scan_record_id = c.id
            where a.customer_id = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.software_id
            ,\'TLCMZ\'
            ,d.sa_product_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_tlcmz d on d.scan_record_id = c.id
            where a.customer_id = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.software_id
            ,\'DORANA\'
            ,d.dorana_product_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_dorana d on d.scan_record_id = c.id
            where a.customer_id = ?
        with ur
    ';
	dlog("queryStagingSoftwareDataByCustomerId=$query");
	return ( 'stagingSoftwareDataByCustomerId', $query, \@fields );
}

sub queryBravoSoftwareDataByCustomerId {
	my @fields = qw(
	  name
	  softwareId
	  discrepancyTypeId
	  isRemoteUser
	  isRecordTime
	  isStatus
	  itType
	  itTypeId
	  bankAccountId
	);
	my $query = '
        select
        	sl.name
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'SIGNATURE\'
        	,it.software_signature_id
        	,it.bank_account_id
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_signature it on it.installed_software_id = is.id
        	where sl.customer_id = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select 
			sl.name
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'FILTER\'
        	,it.software_filter_id
        	,it.bank_account_id
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_filter it on it.installed_software_id = is.id
        	where sl.customer_id = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select
        	sl.name
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'TLCMZ\'
        	,it.sa_product_id
        	,it.bank_account_id
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_sa_product it on it.installed_software_id = is.id
        	where sl.customer_id = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select
        	sl.name
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'DORANA\'
        	,it.dorana_product_id
        	,it.bank_account_id
        from software_lpar sl
	        join installed_software is on is.software_lpar_id = sl.id
	        join installed_dorana_product it on it.installed_software_id = is.id
	        where sl.customer_id = ?
        	and sl.status = \'ACTIVE\'
	        and is.status = \'ACTIVE\'
        union
        select
        	sl.name
        	,is.software_id
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'MANUAL\'
        	,0
        	,0
        from software_lpar sl
	        join installed_software is on is.software_lpar_id = sl.id
	        where sl.customer_id = ?
        	and sl.status = \'ACTIVE\'
	        and is.status = \'ACTIVE\'
	        and not exists (select 1 from installed_signature it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_filter it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_sa_product it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_dorana_product it where it.installed_software_id = is.id)
	    with ur
    ';
	dlog("queryBravoSoftwareDataByCustomerId=$query");
	return ( 'bravoSoftwareDataByCustomerId', $query, \@fields );
}
