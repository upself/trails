#!/usr/bin/perl -w

###Globals

###Modules
use strict;
use Getopt::Std;
use Base::Utils;
use Database::Connection;
use BRAVO::OM::Customer;
use BRAVO::OM::SoftwareLpar;
use Staging::OM::SoftwareSignature;
use Staging::OM::ScanSoftwareItem;
use Staging::OM::SoftwareFilter;
use BRAVO::Delegate::BRAVODelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareManual;
use Staging::OM::SoftwareDorana;
use Staging::OM::SoftwareTlcmz;

###Set logging level
logging_level("debug");
my $logFile         = "/var/staging/logs/stagingSyncGENAdvance/stagingSyncGENAdvance.log";
$| = 1;

###Get bravo db connection
my $bravoConnection = Database::Connection->new('trails');

###Get staging db connection
my $stagingConnection = Database::Connection->new('staging');

use vars qw (
  $opt_a
);

getopt("a");

open LOG, ">>$logFile";
if ($opt_a) {
	my $accountNumber = $opt_a;
	print LOG "Working on $accountNumber \n";
eval {
	###Get software lpar id list
	my @softwareLparIds = getSoftwareLparIds($bravoConnection,$accountNumber);

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
}
else {
	usage();
}
###Close log file 
close LOG;

###Close bravo db connection
$bravoConnection->disconnect;

###Close staging db connection
$stagingConnection->disconnect;

exit 0;

sub usage {
	print "$0 -a <account_number> \n";
	exit 0;
}

sub getSoftwareLparIds {
	my ($bravoConnection,$accountNumber) = @_;

	###Array to return
	my @softwareLparIds = ();

	###Prepare and execute query
	$bravoConnection->prepareSqlQueryAndFields(
		querySoftwareLparIds() );
	my $sth = $bravoConnection->sql->{softwareLparIds};
	my %rec;
	my $lparcount = 0 ;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $bravoConnection->sql->{softwareLparIdsFields} } );
	$sth->execute($accountNumber);
	while ( $sth->fetchrow_arrayref ) {
	##print "found " . $rec{id};
	    $lparcount++;
		push @softwareLparIds, $rec{id};
	}
	$sth->finish;
    print LOG "Found $lparcount lpars \n" ;
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
	###Hash to store staging manual sw data
	my %stagingManualSoftware = ();

	###Prepare and execute query
	$stagingConnection->prepareSqlQueryAndFields(
		queryStagingSoftwareDataByCustomerId() );
	my $stagingSth = $stagingConnection->sql->{stagingSoftwareDataByCustomerId};
	my %stagingRec;
	$stagingSth->bind_columns( map { \$stagingRec{$_} }
		  @{ $stagingConnection->sql->{stagingSoftwareDataByCustomerIdFields} }
	);
	$stagingSth->execute( $customerId, $name, $customerId, $name, $customerId, $name, $customerId, $name,
		$customerId, $name, $customerId, $name);
	while ( $stagingSth->fetchrow_arrayref ) {

		###Only want rows with valid software line item
		next unless defined $stagingRec{softwareId};


		###Get the sw lpar key
		my $lparKey = $customerId . '|' . $stagingRec{name};

		###Store sw lpar info in hash
		$stagingSoftwareLpars{$lparKey}->{slId} = $stagingRec{slId};	
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
		  
		  ###Get the manual sw key
		my $manualKey =
		    $customerId . '|'
		  . $stagingRec{name} . '|'
		  . $stagingRec{softwareId}  ;

		###Store inst sw record in hash
		foreach my $elem ( keys %stagingRec ) {
			$stagingInstalledSoftware{$swKey}->{$elem} = $stagingRec{$elem};
			if( $stagingRec{itType} eq 'MANUAL'){
			$stagingManualSoftware{$manualKey} = 1;
			}
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
		$customerId, $name, $customerId, $name );
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
		  
		###Get the manual key
		my $manualkey =
		    $customerId . '|'
		  . $bravoRec{name} . '|'
		  . $bravoRec{softwareId} ;

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
			my $StagingLparStatus = 'NO';
			my $baScanTime = 'NULL';
			my $lparKey    = $customerId . '|' . $bravoRec{name};
			if ( defined $stagingSoftwareLpars{$lparKey} and $stagingSoftwareLpars{$lparKey}->{slId} ne '' ) {
				$StagingLparStatus = 'EXIST';
				if (
					defined $stagingSoftwareLpars{$lparKey}
					->{ $bravoRec{bankAccountId} } and defined $stagingSoftwareLpars{$lparKey}
					->{ $bravoRec{bankAccountId} }->{scanRecordId} ne '' )
				{
					$baStatus   = 'EXIST';
					$baScanTime =
					  $stagingSoftwareLpars{$lparKey}
					  ->{ $bravoRec{bankAccountId} }->{scanTime};
				}
			}

			###Print entry to stdout
			print LOG "BRAVO_NOT_STAGING,"
			  . $customer->accountNumber . "|"
                          . $bravoRec{id} . "|"
			  . $bravoRec{name} . "|"
			  . $bravoRec{softwareId} . "|"
			  . $bravoRec{bankAccountId} . "|"
			  . $bravoRec{itType} . "|"
			  . $bravoRec{itTypeId} . "|"
			  . $bravoRec{isRecordTime} . "|"
			  . $bravoRec{isRemoteUser} . "|"		  
			  . $StagingLparStatus . "|"
			  . $baStatus . "|"
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
                               elsif($bravoRec{itType} eq 'TADZ') {
                                my $tadz = new Staging::OM::ScanSoftwareItem();
                                $tadz->action(2);
                                $tadz->guId($bravoRec{softwareId});
                                $tadz->useCount($bravoRec{itTypeId});
                                $tadz->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $tadz->save($stagingConnection);
                            }
                            elsif($bravoRec{itType} eq 'TLCMZ') {
                                my $tlcmz = new Staging::OM::SoftwareTlcmz();
                                $tlcmz->action('DELETE');
                                $tlcmz->softwareTlcmzId($bravoRec{itTypeId});
                                $tlcmz->softwareId($bravoRec{softwareId});
                                $tlcmz->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $tlcmz->save($stagingConnection);
                            }
                             elsif($bravoRec{itType} eq 'DORANA') {
                                my $dorana = new Staging::OM::SoftwareDorana();
                                $dorana->action('DELETE');
                                $dorana->softwareDoranaId($bravoRec{itTypeId});
                                $dorana->softwareId($bravoRec{softwareId});
                                $dorana->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $dorana->save($stagingConnection);
                            }
                              elsif($bravoRec{itType} eq 'MANUAL' &&  $stagingManualSoftware{$manualkey} !=1 ) {
                                my $manual = new Staging::OM::SoftwareManual();
                                $manual->action('DELETE');
                                $manual->softwareId($bravoRec{softwareId});
                                ## see the query statment, the bankaccountid for manual actually is version
                                ##  and the itTypeId is users 
                                $manual->version($bravoRec{bankAccountId});
                                $manual->users($bravoRec{itTypeId});
                                $manual->scanRecordId($stagingSoftwareLpars{$lparKey}->{ $bravoRec{bankAccountId} }->{scanRecordId});
                                $manual->save($stagingConnection);
                            }
                        }
                        elsif ($StagingLparStatus eq 'NO' and $baStatus eq 'NO' ) {
                        	print LOG " NO|NO,Inactive $bravoRec{id} \n ";
                        	if ($bravoRec{itType} eq 'MANUAL'){$bravoRec{bankAccountId} = 5 ;}
                           BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId(
                               $bravoConnection, $bravoRec{id}, $bravoRec{bankAccountId}); 
                        }elsif ($StagingLparStatus eq 'EXIST' and $baStatus eq 'NO' ) {
                        	print LOG " EXIST|NO,Inactive $bravoRec{id} \n ";
                        	if ($bravoRec{itType} eq 'MANUAL'){$bravoRec{bankAccountId} = 5 ;}
                        	my $StaingSWLpar = new Staging::OM::SoftwareLpar();
                        	$StaingSWLpar->id($stagingSoftwareLpars{$lparKey}->{slId});
                        	$StaingSWLpar->getById($stagingConnection);
                        	my $isOrphanLpar = isOrphanLparById( $stagingConnection, $StaingSWLpar->id );
                          	if ($isOrphanLpar == 0 and defined $StaingSWLpar){
                        		print LOG " Delete " . $StaingSWLpar->id . "\n ";
                        	$StaingSWLpar->action('DELETE');
                        	$StaingSWLpar->save($stagingConnection); 
                        	}
                        	BRAVO::Delegate::BRAVODelegate->inactivateInstalledSoftwaresBySoftwareLparIdAndBankAccountId(
                               $bravoConnection, $bravoRec{id}, $bravoRec{bankAccountId});
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

        my $lparkey = $customerId . $stagingInstalledSoftware{$key}->{name};
		###Print entry to stdout
		print LOG "STAGING_NOT_BRAVO,"
		  . $customer->accountNumber . ","
		  . $stagingInstalledSoftware{$key}->{name} . "|"
		  . $stagingInstalledSoftware{$key}->{softwareId} . "|"
		  . $stagingInstalledSoftware{$key}->{bankAccountId} . "|"
		  . $stagingInstalledSoftware{$key}->{itType} . "|"
		  . $stagingInstalledSoftware{$key}->{itTypeId} . "|"
		  . $stagingInstalledSoftware{$key}->{itTypeAction} . "\n";

                if($stagingInstalledSoftware{$key}->{itType}  eq 'SIGNATURE'
                and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                    my $sig = new Staging::OM::SoftwareSignature();
                    $sig->action('UPDATE');
                    $sig->softwareSignatureId($stagingInstalledSoftware{$key}->{itTypeId});
                    $sig->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $sig->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $sig->id($stagingInstalledSoftware{$key}->{itId});
                    $sig->save($stagingConnection);
                }
                elsif($stagingInstalledSoftware{$key}->{itType}  eq 'FILTER'
                 and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                    my $filter = new Staging::OM::SoftwareFilter();
                    $filter->action('UPDATE');
                    $filter->softwareFilterId($stagingInstalledSoftware{$key}->{itTypeId});
                    $filter->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $filter->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $filter->id($stagingInstalledSoftware{$key}->{itId});
                    $filter->save($stagingConnection);
                }
                elsif($stagingInstalledSoftware{$key}->{itType}  eq 'TADZ'
                 and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                    my $tadz = new Staging::OM::ScanSoftwareItem();
                    $tadz->action(1);
                    $tadz->useCount($stagingInstalledSoftware{$key}->{itTypeId});
                    $tadz->guId($stagingInstalledSoftware{$key}->{softwareId});
                    $tadz->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $tadz->id($stagingInstalledSoftware{$key}->{itId});
                    $tadz->save($stagingConnection);
                 }
                  elsif($stagingInstalledSoftware{$key}->{itType}  eq 'TLCMZ'
                 and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                 	my $bankAccountIds = '410,180,406,5';
                 	my $srCount = getScanRecordCountByKey( $stagingConnection, $lparkey, $bankAccountIds);
                   if ($srCount == 0) {
                    my $tlcmz = new Staging::OM::SoftwareTlcmz();
                    $tlcmz->action('UPDATE');
                    $tlcmz->softwareTlcmzId($stagingInstalledSoftware{$key}->{itTypeId});
                    $tlcmz->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $tlcmz->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $tlcmz->id($stagingInstalledSoftware{$key}->{itId});
                    $tlcmz->save($stagingConnection);
                   }
                }
                   elsif($stagingInstalledSoftware{$key}->{itType}  eq 'DORANA'
                 and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                 	my $bankAccountIds = '410,180,406,5';
                 	my $srCount = getScanRecordCountByKey( $stagingConnection, $lparkey, $bankAccountIds);
                   if ($srCount == 0) {
                    my $dorana = new Staging::OM::SoftwareDorana();
                    $dorana->action('UPDATE');
                    $dorana->softwareDoranaId($stagingInstalledSoftware{$key}->{itTypeId});
                    $dorana->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $dorana->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $dorana->id($stagingInstalledSoftware{$key}->{itId});
                    $dorana->save($stagingConnection);
                   }
                }
                    elsif($stagingInstalledSoftware{$key}->{itType}  eq 'MANUAL'
                 and $stagingInstalledSoftware{$key}->{itTypeAction} eq 'COMPLETE' ) {
                 	my $bankAccountIds = '406,5';
                 	my $srCount = getScanRecordCountByKey( $stagingConnection, $lparkey, $bankAccountIds);
                   if ($srCount == 0) {
                    my $manual = new Staging::OM::SoftwareManual();
                    $manual->action('UPDATE');
                    $manual->users($stagingInstalledSoftware{$key}->{itTypeId});
                    ## see the query statment, the bankaccountid for manual actually is version
                    ##  and the itTypeId is users 
                    $manual->version($stagingInstalledSoftware{$key}->{bankAccountId});
                    $manual->softwareId($stagingInstalledSoftware{$key}->{softwareId});
                    $manual->scanRecordId($stagingInstalledSoftware{$key}->{id});
                    $manual->id($stagingInstalledSoftware{$key}->{itId});
                    $manual->save($stagingConnection);
                   }
                }            
	}
}
sub getScanRecordCountByKey {
	my ( $connection, $lparkey, $bankAccountIds) = @_;
    my %rec;
    my $count = undef;
    my $sql = queryScanRecordCountByKey( $lparkey, $bankAccountIds );
    $connection->prepareSqlQuery('queryScanRecordCountByKey',$sql);
        my $sth = $connection->sql->{'queryScanRecordCountByKey'};
        	$sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        $count = $rec{count};
    }
    $sth->finish;

    return $count;
}

sub queryScanRecordCountByKey {
    my ( $lparkey, $bankAccountIds ) = @_;
    my $query  = '
        select
            count(*)
        from
            software_lpar a
            ,software_lpar_map b
            ,scan_record c
        where
            b.software_lpar_id=a.id
        and b.scan_record_id=c.id
        and char(a.customer_id)||a.name= \'' . $lparkey .'\'
        and c.bank_account_id not in ( ' . $bankAccountIds . ' )
        with ur
    ';
    return $query;
}

sub isOrphanLparById {
	my ( $connection, $id ) = @_;

    my $count = undef;

    ###Prepare and execute the necessary sql
    $connection->prepareSqlQueryAndFields( queryIsOrphanLparCountBySwLparId() );
    my $sth = $connection->sql->{isOrphanLparCountBySwLparId};
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @{ $connection->sql->{isOrphanLparCountBySwLparIdFields} } );
    $sth->execute($id);
    while ( $sth->fetchrow_arrayref ) {

        $count = $rec{count};
    }
    $sth->finish;

    return $count;
}

sub queryIsOrphanLparCountBySwLparId {
    my @fields = (qw( count ));
    my $query  = '
        select
            count(*)
        from
            software_lpar_map a
        where
            a.software_lpar_id = ?
        with ur
    ';
    return ( 'isOrphanLparCountBySwLparId', $query, \@fields );
}

sub queryStagingSoftwareDataByCustomerId {
	my @fields = qw(
	  slId
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
            a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,d.version
            ,c.scan_time
            ,c.action
            ,d.id
            ,CHAR(d.software_id)
            ,\'MANUAL\'
            ,d.users
            ,d.action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join software_manual d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
             a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,CHAR(c.bank_account_id)
            ,c.scan_time
            ,c.action
            ,d.id
            ,CHAR(d.software_id)
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
             a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,CHAR(c.bank_account_id)
            ,c.scan_time
            ,c.action
            ,d.id
            ,CHAR(d.software_id)
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
             a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,CHAR(c.bank_account_id)
            ,c.scan_time
            ,c.action
            ,d.id
            ,CHAR(d.software_id)
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
             a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,CHAR(c.bank_account_id)
            ,c.scan_time
            ,c.action
            ,d.id
            ,d.guid
            ,\'TADZ\'
            ,d.USE_COUNT
            ,case when d.action = 0 then \'COMPLETE\' 
             when d.action = 1 then \'UPDATE\' 
             when d.action = 2 then \'DELETE\' 
             end  as action
        from software_lpar a
            left outer join software_lpar_map b on b.software_lpar_id = a.id
            left outer join scan_record c on c.id = b.scan_record_id
            left outer join scan_software_item d on d.scan_record_id = c.id
            where a.customer_id = ?
            and a.name = ?
        union
        select
             a.id
            ,a.name
            ,a.scan_time
            ,a.status
            ,a.action
            ,c.id
            ,CHAR(c.bank_account_id)
            ,c.scan_time
            ,c.action
            ,d.id
            ,CHAR(d.software_id)
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
        	,CHAR(is.software_id)
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'SIGNATURE\'
        	,it.software_signature_id
        	,CHAR(it.bank_account_id)
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
        	,CHAR(is.software_id)
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'FILTER\'
        	,it.software_filter_id
        	,CHAR(it.bank_account_id)
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
        	,CHAR(is.software_id)
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'TLCMZ\'
        	,it.sa_product_id
        	,CHAR(it.bank_account_id)
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
        	,kb.guid
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'TADZ\'
        	,it.USE_COUNT
        	,CHAR(it.bank_account_id)
        from software_lpar sl
        	join installed_software is on is.software_lpar_id = sl.id
        	join installed_tadz it on it.installed_software_id = is.id
        	join kb_definition kb on it.mainframe_feature_id=kb.id
        	where sl.customer_id = ?
                and sl.name = ?
        	and sl.status = \'ACTIVE\'
        	and is.status = \'ACTIVE\'
        union
        select
                sl.id
        	,sl.name
        	,CHAR(is.software_id)
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'DORANA\'
        	,it.dorana_product_id
        	,CHAR(it.bank_account_id)
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
        	,CHAR(is.software_id)
        	,is.discrepancy_type_id
        	,is.remote_user
        	,is.record_time
        	,is.status
        	,\'MANUAL\'
        	,is.users
        	,is.version
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
	        and not exists (select 1 from installed_tadz it where it.installed_software_id = is.id)
	    with ur
    ';
	return ( 'bravoSoftwareDataByCustomerId', $query, \@fields );
}
