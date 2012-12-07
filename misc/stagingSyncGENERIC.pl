#!/usr/bin/perl -w

###Globals

###Modules
use strict;
use Base::Utils;
use Database::Connection;
use BRAVO::OM::Customer;
use BRAVO::OM::SoftwareLpar;
use Staging::OM::SoftwareSignature;
use Staging::OM::SoftwareFilter;
use BRAVO::Delegate::BRAVODelegate;

###Set logging level
logging_level("debug");
$| = 1;

###Get bravo db connection
my $bravoConnection = Database::Connection->new('trails');

###Get staging db connection
my $stagingConnection = Database::Connection->new('staging');

my $accountNumber = $ARGV[0];
#print "Working on $accountNumber \n";
# exit;

eval {
	###Get software lpar id list
	my @softwareLparIds = getSoftwareLparIds($bravoConnection);

	###Perform healthchecks customer at a time
	foreach my $softwareLparId (@softwareLparIds) {
		my $softwareLpar = new BRAVO::OM::SoftwareLpar();
		$softwareLpar->id($softwareLparId);
		$softwareLpar->getById($bravoConnection);
		executeHchk(
			$bravoConnection,          $stagingConnection,
			$softwareLpar->customerId, $softwareLpar->name
		);
	}
};
if ($@) {
	die "ERROR: $@";
}

###Close bravo db connection
$bravoConnection->disconnect;

###Close staging db connection
$stagingConnection->disconnect;

exit 0;

sub getSoftwareLparIds {
	my ($bravoConnection) = @_;

	###Array to return
	my @softwareLparIds = ();

	###Prepare and execute query
	$bravoConnection->prepareSqlQueryAndFields(
		querySoftwareLparIds() );
	my $sth = $bravoConnection->sql->{softwareLparIds};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $bravoConnection->sql->{softwareLparIdsFields} } );
	$sth->execute($accountNumber);
	while ( $sth->fetchrow_arrayref ) {
		print "found " . $rec{id};
		push @softwareLparIds, $rec{id};
	}
	$sth->finish;

	return @softwareLparIds;
}

sub querySoftwareLparIds {
	my @fields = qw(
	  id
	);
	my $query = '
        select
            sl.id
        from software_lpar sl
        join customer c on c.customer_id = sl.customer_id 
        where sl.status = \'ACTIVE\'
        and c.status = \'ACTIVE\'
        and c.account_number = ?
    ';
	return ( 'softwareLparIds', $query, \@fields );
}

sub executeHchk {
	my ( $bravoConnection, $stagingConnection, $customerId, $name ) = @_;

	###Get customer object by customer id
	my $customer = new BRAVO::OM::Customer();
	$customer->id($customerId);
	$customer->getById($bravoConnection);

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
	$stagingSth->execute( $customerId, $name, $customerId, $name, $customerId, $name, $customerId, $name,
		$customerId, $name );
	while ( $stagingSth->fetchrow_arrayref ) {

		###Only want rows with valid software line item
		next unless defined $stagingRec{softwareId};


		###Get the sw lpar key
		my $lparKey = $customerId . '|' . $stagingRec{name};

		###Store sw lpar info in hash
		$stagingSoftwareLpars{$lparKey}->{ $stagingRec{bankAccountId} }->{scanTime} =
		  $stagingRec{scanRecordScanTime};
                $stagingSoftwareLpars{$lparKey}->{ $stagingRec{bankAccountId} }->{scanRecordId} =
                  $stagingRec{id};


		###Get the inst sw key
		my $swKey =
		    $customerId . '|'
		  . $stagingRec{name} . '|'
		  . $stagingRec{softwareId} . '|'
		  . $stagingRec{bankAccountId} . '|'
		  . $stagingRec{itType} . '|'
		  . $stagingRec{itTypeId};

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

	$bravoSth->execute( $customerId, $name, $customerId, $name, $customerId, $name, $customerId, $name,
		$customerId, $name );
	while ( $bravoSth->fetchrow_arrayref ) {

		###Only want rows with valid software line item
		next unless defined $bravoRec{softwareId};


		###Get the key
		my $key =
		    $customerId . '|'
		  . $bravoRec{name} . '|'
		  . $bravoRec{softwareId} . '|'
		  . $bravoRec{bankAccountId} . '|'
		  . $bravoRec{itType} . '|'
		  . $bravoRec{itTypeId};

		###Compare to staging data
		if ( defined $stagingInstalledSoftware{$key} ) {

			###Set the found flag
			$stagingInstalledSoftware{$key}->{found} = 1;
		}
		else {

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
					  ->{ $bravoRec{bankAccountId} }->{scanTime};
				}
			}

			###Print entry to stdout
			print "BRAVO_NOT_STAGING,"
			  . $customer->accountNumber . ","
                          . $bravoRec{id} . ","
			  . $bravoRec{name} . ","
			  . $bravoRec{softwareId} . ","
			  . $bravoRec{bankAccountId} . ","
			  . $bravoRec{itType} . ","
			  . $bravoRec{itTypeId} . ","
			  . $bravoRec{isRecordTime} . ","
			  . $bravoRec{isRemoteUser} . ","
			  . $baStatus . ","
			  . $baScanTime . "\n";

                        if( defined $stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId} ) {
                            if($bravoRec{itType} eq 'SIGNATURE') {
                                my $sig = new Staging::OM::SoftwareSignature();
                                $sig->action('DELETE');
                                $sig->softwareSignatureId($bravoRec{itTypeId});
                                $sig->softwareId($bravoRec{softwareId});
                                $sig->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $sig->save($stagingConnection);
                            }
                            elsif($bravoRec{itType} eq 'FILTER') {
                                my $filter = new Staging::OM::SoftwareFilter();
                                $filter->action('DELETE');
                                $filter->softwareFilterId($bravoRec{itTypeId});
                                $filter->softwareId($bravoRec{softwareId});
                                $filter->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $filter->save($stagingConnection);
                            }
                        }
                        else {
                #            BRAVODelegate->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId(
                #                $bravoConnection, $bravoRec{id}, $bravoRec{bankAccountId}); 
                        }
		}
	}
	$bravoSth->finish;

	###
	###Loop over staging memory data and print not founds
	###

	foreach my $key ( keys %stagingInstalledSoftware ) {

		###Only want records not found in bravo
		next if $stagingInstalledSoftware{$key}->{found} == 1;


		###Print entry to stdout
		print "STAGING_NOT_BRAVO,"
		  . $customer->accountNumber . ","
		  . $stagingInstalledSoftware{$key}->{name} . ","
		  . $stagingInstalledSoftware{$key}->{softwareId} . ","
		  . $stagingInstalledSoftware{$key}->{bankAccountId} . ","
		  . $stagingInstalledSoftware{$key}->{itType} . ","
		  . $stagingInstalledSoftware{$key}->{itTypeId} . ","
		  . $stagingInstalledSoftware{$key}->{itTypeAction} . "\n";

                if($bravoRec{itType} eq 'SIGNATURE') {
                    my $sig = new Staging::OM::SoftwareSignature();
                    $sig->action('UPDATE');
                    $sig->softwareSignatureId($stagingInstalledSoftware{$key}->{itTypeId});
                    $sig->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $sig->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $sig->id($stagingInstalledSoftware{$key}->{itId});
                    $sig->save($stagingConnection);
                }
                elsif($bravoRec{itType} eq 'FILTER') {
                    my $filter = new Staging::OM::SoftwareFilter();
                    $filter->action('UPDATE');
                    $filter->softwareFilterId($stagingInstalledSoftware{$key}->{itTypeId});
                    $filter->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $filter->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $filter->id($stagingInstalledSoftware{$key}->{itId});
                    $filter->save($stagingConnection);
                }
	}
}

sub queryStagingSoftwareDataByCustomerId {
	my @fields = qw(
	  name
	  scanTime
	  status
	  action
          id
	  bankAccountId
	  scanRecordScanTime
	  scanRecordAction
          itId
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
            ,c.id
            ,0
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.software_id
            ,\'MANUAL\'
            ,0
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_manual d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.software_id
            ,\'SIGNATURE\'
            ,d.software_signature_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_signature d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.software_id
            ,\'FILTER\'
            ,d.software_filter_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_filter d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.software_id
            ,\'TLCMZ\'
            ,d.sa_product_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_tlcmz d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
            a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,c.bank_account_id
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.software_id
            ,\'DORANA\'
            ,d.dorana_product_id
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_dorana d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        with ur
    ';
	return ( 'stagingSoftwareDataByCustomerId', $query, \@fields );
}

sub queryBravoSoftwareDataByCustomerId {
	my @fields = qw(
          id
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
                sl.id
        	,sl.name
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
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select 
                sl.id
		,sl.name
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
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select
                sl.id
        	,sl.name
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
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select
                sl.id
        	,sl.name
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
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
	        and is.status = \'ACTIVE\'
        union
        select
                sl.id
        	,sl.name
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
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
	        and is.status = \'ACTIVE\'
	        and not exists (select 1 from installed_signature it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_filter it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_sa_product it where it.installed_software_id = is.id)
	        and not exists (select 1 from installed_dorana_product it where it.installed_software_id = is.id)
	    with ur
    ';
	return ( 'bravoSoftwareDataByCustomerId', $query, \@fields );
}
