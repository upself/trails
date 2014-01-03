package SWCMDelegate;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::OM::License;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::CapType;
use BRAVO::OM::LicenseType;

sub getData {
    my ($self,             $swcmConnection,  $bravoConnection,
        $accountNumberMap, $customerNameMap, $dupCustomerNameMap,
        $testMode,         $delta,           $lastUpdateDate
        )
        = @_;

    my %licenseList;

    ###To maintain a hash of software names that exist in TRAILS software and software_h tables
    ###To avoid going back to the db for software_names that have already been found
    my %softwareNameMap = undef;

    ###To maintain a hash of account_ids and software_names from SWCM that are not there in CNDB
    my %missingAccountIds    = undef;
    my %missingSoftwareNames = undef;

    dlog('Preparing swcm data query');
    
    if ( $delta == 1 ) {
        $swcmConnection->prepareSqlQueryAndFields(
            $self->querySWCMLicenseDeltaData($testMode) );
    }
    else {
        $swcmConnection->prepareSqlQueryAndFields(
            $self->querySWCMLicenseData($testMode) );
    }
    dlog('swcm data query prepared');

    ###Get the statement handle
    my $sth = $swcmConnection->sql->{swcmLicenseData};
    dlog("got sth obj");

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} }
            @{ $swcmConnection->sql->{swcmLicenseDataFields} } );
    dlog("binded cols to sth");

    dlog('Executing query');
    if ( $delta == 1 ) {
        dlog( 'Executing delta query ' . "LASTUPDATE: $lastUpdateDate" );
        $sth->execute($lastUpdateDate);
        dlog('Execution complete');
    }
    else {
        dlog('Executing full query');
        $sth->execute();
        dlog('Execution complete');
    }

    while ( $sth->fetchrow_arrayref ) {

        my $customerId      = undef;
        my $serialResetFlag = 0;

        ###Clean record values
        cleanValues( \%rec );

        ###Upper case record values
        upperValues( \%rec );

        ###We can't have a blank swcm_license_id
        if ( !defined $rec{swcmLicenseId} || $rec{swcmLicenseId} eq '' ) {
            logMsg("blank swcmLicenseId, skipping");
            logRec( 'elog', \%rec );
            next;
        }

        ###We can't have a blank account_id
        if ( !defined $rec{accountId} || $rec{accountId} eq '' ) {
            logMsg("blank accountId, skipping");
            logRec( 'elog', \%rec );
            next;
        }

        ###The account_id coming in can be account_number or account_name.  We need to test
        ###for presence in cndb

        ###First check if we have already found this accountId to be invalid
        if ( exists( $missingAccountIds{ $rec{accountId} } ) ) {
            ###This is an invalid accountId
            dlog(
                "************* Found record that doesn't have a matching account_id/name, skipping record **********"
            );
            logRec( 'dlog', \%rec );
            next;
        }

        if ( !exists( $accountNumberMap->{ $rec{accountId} } ) ) {
            ###Either the accountId does not exist or we got the customer_name

            ###First check in dups map
            if ( exists( $dupCustomerNameMap->{ $rec{accountId} } ) ) {
                ### we have found a customer_name that has dups - reject
                dlog(
                    "************* Found customer name that is not unique, skipping record **********"
                );
                logRec( 'dlog', \%rec );
                $missingAccountIds{ $rec{accountId} } = "true";
                logMsg( "Found customerName in SWCM that is not unique - "
                        . $rec{accountId} );
                next;
            }

            ###Ok - doesn't exist in dups
            if ( !exists( $customerNameMap->{ $rec{accountId} } ) ) {
                ###does not exist in customerName map either - reject
                dlog(
                    "************* Found record that doesn't have a matching account_id/name, skipping record **********"
                );
                logRec( 'dlog', \%rec );
                $missingAccountIds{ $rec{accountId} } = "true";
                logMsg(
                    "Account id/name missing in CNDB - " . $rec{accountId} );
                next;
            }
            else {
                $customerId = $customerNameMap->{ $rec{accountId} };
            }
        }
        else {
            $customerId = $accountNumberMap->{ $rec{accountId} };
        }

        ###Time to get the softwareId
        my $softwareId = undef;

        if ( defined $rec{prodName} && $rec{prodName} eq "SOFTREQ UNKNOWN" ) {
            ### softwareId needs to stay undef and set prodName to null
            $rec{prodName} = undef;
        }
        else {
            ### check in the local cache if we have already looked up this id
            if ( !exists( $missingSoftwareNames{ $rec{prodName} } ) ) {

                if ( exists( $softwareNameMap{ $rec{prodName} } ) ) {
                    $softwareId = $softwareNameMap{ $rec{prodName} };
                }
                else {
                    $softwareId = BRAVO::Delegate::BRAVODelegate
                        ->getSoftwareIdBySoftwareNameAndType(
                        $bravoConnection, $rec{prodName},
                        'SOFTWARE_PRODUCT' );

                    if ( !defined $softwareId ) {
                        $softwareId = BRAVO::Delegate::BRAVODelegate
                            ->getSoftwareIdBySoftwareNameAndTypeFromHistory(
                            $bravoConnection, $rec{prodName},
                            'SOFTWARE_PRODUCT' );
                    }
                    if ( !defined $softwareId ) {
                        $softwareId = BRAVO::Delegate::BRAVODelegate
                            ->getSoftwareIdBySoftwareNameAndType(
                            $bravoConnection, $rec{prodName}, 'COMPONENT' );
                    }
                    if ( !defined $softwareId ) {
                        $softwareId = BRAVO::Delegate::BRAVODelegate
                            ->getSoftwareIdBySoftwareNameAndTypeFromHistory(
                            $bravoConnection, $rec{prodName}, 'COMPONENT' );
                    }
                    if ( !defined $softwareId ) {
                        dlog(
                            "************* Found record that doesn't have a matching softwareId **********"
                        );
                        logRec( 'dlog', \%rec );
                        $missingSoftwareNames{ $rec{prodName} } = "true";
                        logMsg( "Software_name missing in TRAILS - "
                                . $rec{prodName} );
                    }
                }
            }
        }

        if ( defined $softwareId ) {
            ###Add the softwareId to the local cache
            $softwareNameMap{ $rec{prodName} } = $softwareId;
        }

        ###Undef any nullables which are blank
        blank2undef( \%rec );

        ###If the extSrcCode is not softreq, we need to add SWCM_ to the beginning of the license id
        if ( $rec{extSrcCode} ne "SOFTREQ" ) {
            $rec{extSrcId} = "SWCM_" . $rec{swcmLicenseId};
        }
        
        my $prodNmae;
        my $fullDesc;
        if ( length( $rec{prodName} ) > 128 ) {
        	dlog(
                    "************* Found record that has longer software name than 128 characters , cut off record **********"
                );
                $prodNmae = substr $rec{prodName}, 0, 128 ;
        } else {
        	$prodNmae =  $rec{prodName} ;
        }
        if ( length( $rec{fullDesc} ) > 255 ) {
        	dlog(
                    "************* Found record that has longer software description than 255 characters , cut off record **********"
                );
                $fullDesc = substr $rec{fullDesc}, 0, 255 ;
        } else {
        	$fullDesc = $rec{fullDesc} ;
        }

        ###Construct the key
        my $key = $rec{extSrcId};

        ###Build our license object list
        my $license = new Staging::OM::License();
        $license->extSrcId( $rec{extSrcId} );
        $license->licType( $rec{licType} );
        $license->capType( $rec{capType} );
        $license->customerId($customerId);
        $license->softwareId($softwareId);
        $license->quantity( $rec{quantity} );
        $license->ibmOwned( $rec{ibmOwned} );
        $license->draft( $rec{draft} );
        $license->pool( $rec{pool} );
        $license->tryAndBuy( $rec{tryAndBuy} );
        $license->expireDate( $rec{expireDate} );
        $license->endDate( $rec{endDate} );
        $license->poNumber( $rec{poNumber} );
        $license->prodName( $prodNmae );
        $license->fullDesc( $fullDesc );
        $license->version( $rec{version} );
        $license->cpuSerial( $rec{cpuSerial} );
        $license->licenseStatus( $rec{licenseStatus} );
        $license->swcmRecordTime( $rec{recordTime} );
        $license->agreementType( $rec{agreementType} );
        $license->lparName($rec{lparName});

		###Add the license to the list
		if ( !exists $licenseList{$key} ) {
			$license->environment(
				$self->getEnvironment( $rec{environment}, undef ) );
			$licenseList{$key} = $license;
			$serialResetFlag = 0;
		}
		else {
			$license->environment(
				$self->getEnvironment( $rec{environment}, $licenseList{$key}->environment ) );
				dlog('Found the same license again');
				
			if ( $serialResetFlag == 0 ) {
				###We haven't reset the serial number yet
				if (   defined $licenseList{$key}->cpuSerial
					&& defined $rec{cpuSerial} )
				{
					$licenseList{$key}->cpuSerial(undef);
					$serialResetFlag = 1;
					logMsg(
"Found duplicate lic_id with different serial number - blanking it out - lic_id: "
						  . $key );
				}
			}
			else {
				###We have already reset the serial number for this license_id, ignore the record
				dlog( "serial number already reset for this license_id: "
					  . $key );
			}
		}

		dlog( "lic obj=" . $license->toString() );
	}


    ilog( "swcm lic count: " . scalar keys %licenseList );
    
    

###Close the statement handle
    $sth->finish;
    dlog("closed sth");

###Return the list
	return ( \%licenseList );
}

sub getEnvironment {
	my ( $self, $newEnvironment, $currentEnvironment ) = @_;
	dlog("newEnvironemtn=$newEnvironment,currentEnvironment=$currentEnvironment");
	return 'PRODUCTION'
	  if ( !defined $newEnvironment || $newEnvironment eq '' );
	return 'PRODUCTION' if $newEnvironment ne 'DEVELOPMENT';
	return 'PRODUCTION'
	  if defined $currentEnvironment && $currentEnvironment eq 'PRODUCTION';
	return 'DEVELOPMENT';
}

sub querySWCMLicenseData {
    my ( $self, $testMode ) = @_;

    my @fields = qw(
        swcmLicenseId
        accountId
        licType
        capType
        quantity
        prodName
        endDate
        poNumber
        ibmOwned
        fullDesc
        recordTime
        version
        licenseStatus
        draft
        pool
        tryAndBuy
        expireDate
        extSrcId
        extSrcCode
        cpuSerial
        recordTime
        agreementType
        environment
        lparName
    );
    my $query = '
        select
        	distinct
            a.swcm_license_id
            ,a.account_id
            ,a.license_type
            ,a.swcm_lic_cap_type_id
            ,a.total_quantity
            ,a.swcm_lic_sw_prod_id
            ,a.expiration_date
            ,a.po_number
            ,cast(a.sw_owner AS char(1) FOR SBCS DATA)
            ,a.full_desc
            ,a.record_time
            ,a.version
            ,a.swcm_lic_lic_status_id
            ,cast(a.draft AS char(1) FOR SBCS DATA)
            ,cast(a.pool AS char(1) FOR SBCS DATA)
            ,a.tryandbuy
            ,a.maint_exp_date
            ,a.lic_ext_src_id
            ,a.lic_ext_src_code
            ,b.serial_number
            ,a.record_time
            ,a.lic_agree_type
            ,a.environment
            ,c.name
        from
            swlm.lics2trails5 a 
        left outer join swlm.cpu2trails b
            on a.swcm_license_id = b.lic_id
        left outer join swlm.lpar2trails c
            on a.swcm_license_id= c.lic_id
            
    ';

    if ( $testMode == 1 ) {
        $query .= '
		where 
    	    a.account_id = \'15020\' 
    	and ';
    	
    }   

    $query .= ' order by a.swcm_license_id';

    dlog("querySWCMLicenseData=$query");
    return ( 'swcmLicenseData', $query, \@fields );

}

sub querySWCMLicenseDeltaData {
    my ( $self, $testMode ) = @_;

    my @fields = qw(
        swcmLicenseId
        accountId
        licType
        capType
        quantity
        prodName
        endDate
        poNumber
        ibmOwned
        fullDesc
        recordTime
        version
        licenseStatus
        draft
        pool
        tryAndBuy
        expireDate
        extSrcId
        extSrcCode
        cpuSerial
        recordTime
        agreementType
        environment
        lparName
    );
    my $query = '
        select
        	distinct
            a.swcm_license_id
            ,a.account_id
            ,a.license_type
            ,a.swcm_lic_cap_type_id
            ,a.total_quantity
            ,a.swcm_lic_sw_prod_id
            ,a.expiration_date
            ,a.po_number
            ,cast(a.sw_owner AS char(1) FOR SBCS DATA)
            ,a.full_desc
            ,a.record_time
            ,a.version
            ,a.swcm_lic_lic_status_id
            ,cast(a.draft AS char(1) FOR SBCS DATA)
            ,cast(a.pool AS char(1) FOR SBCS DATA)
            ,a.tryandbuy
            ,a.maint_exp_date
            ,a.lic_ext_src_id
            ,a.lic_ext_src_code
            ,b.serial_number
            ,a.record_time
            ,a.lic_agree_type
            ,a.environment
            ,c.name
        from
            swlm.lics2trails5 a 
            left outer join swlm.cpu2trails b
            on a.swcm_license_id = b.lic_id
            left outer join swlm.lpar2trails c
            on a.swcm_license_id= c.lic_id
        where
            a.record_time > ?
    ';

    if ( $testMode == 1 ) {
        $query .= '
    		and 
    	    a.account_id = \'15020\'
    	';
    }

    $query .= ' order by a.swcm_lic_sw_prod_id, a.swcm_license_id';

    dlog("querySWCMLicenseDeltaData=$query");
    return ( 'swcmLicenseData', $query, \@fields );

}

sub getCapTypeData {
    my ( $self, $connection ) = @_;

    dlog('In SWCMDelegate->getCapTypeData method');

    my %capTypeList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryCapTypeData );

    ###Define the fields
    my @fields = (qw(code description recordTime));

    ###Get the statement handle
    my $sth = $connection->sql->{capTypeData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our CapType object
        my $capType = $self->buildCapType( \%rec );
        next if ( !defined $capType );

        ###Build our CapType object list
        my $key = $capType->code;
        $capTypeList{$key} = $capType
            if ( !defined $capTypeList{$key} );

    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%capTypeList );
}

sub queryCapTypeData {
    my $query = '
        select
            cap_type_code
            ,cap_type_desc
            ,cap_last_modified
        from
            swlm.capt2trails
    ';

    return ( 'capTypeData', $query );
}

sub buildCapType {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the capType record
    my $capType = new BRAVO::OM::CapType();
    $capType->code( $rec->{code} );
    $capType->description( $rec->{description} );
    $capType->recordTime( $rec->{recordTime} );

    return $capType;
}

sub getLicTypeData {
    my ( $self, $connection ) = @_;

    dlog('In SWCMDelegate->getLicTypeData method');

    my %licTypeList;

    ###Prepare the query
    $connection->prepareSqlQuery( $self->queryLicTypeData );

    ###Define the fields
    my @fields = (qw(code description recordTime));

    ###Get the statement handle
    my $sth = $connection->sql->{licTypeData};

    ###Bind the columns
    my %rec;
    $sth->bind_columns( map { \$rec{$_} } @fields );

    ###Execute the query
    $sth->execute();
    while ( $sth->fetchrow_arrayref ) {

        ###Build our LicenseType object
        my $licType = $self->buildLicType( \%rec );
        next if ( !defined $licType );

        ###Build our LicenseType object list
        my $key = $licType->code;
        $licTypeList{$key} = $licType
            if ( !defined $licTypeList{$key} );

    }

    ###Close the statement handle
    $sth->finish;

    ###Return the lists
    return ( \%licTypeList );
}

sub queryLicTypeData {
    my $query = '
        select
            lic_type_code
            ,lic_type_desc
            ,lic_type_last_modified
        from
            swlm.lict2trails
    ';

    return ( 'licTypeData', $query );
}

sub buildLicType {
    my ( $self, $rec ) = @_;

    cleanValues($rec);
    upperValues($rec);

    ###Build the LicenseType record
    my $licType = new BRAVO::OM::LicenseType();
    $licType->code( $rec->{code} );
    $licType->description( $rec->{description} );
    $licType->recordTime( $rec->{recordTime} );

    return $licType;
}

1;
