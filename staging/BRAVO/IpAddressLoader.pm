package BRAVO::IpAddressLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Staging::Delegate::StagingDelegate;
use Staging::OM::SoftwareLpar;
use Staging::OM::SoftwareLparMap;
use Staging::OM::ScanRecord;
use Staging::OM::IpAddress;
use BRAVO::Delegate::BRAVODelegate;
use BRAVO::OM::SoftwareLpar;
use BRAVO::OM::IpAddress;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode           => undef,
                 _loadDeltaOnly      => undef,
                 _applyChanges       => undef,
                 _maxLparsInQuery    => undef,
                 _firstId            => undef,
                 _lastId             => undef,
                 _discrepancyTypeMap => undef
    };
    bless $self, $class;
    dlog("instantiated self");

    ###Get the discrepancy type map
    $self->discrepancyTypeMap( BRAVO::Delegate::BRAVODelegate->getDiscrepancyTypeMap );
    dlog("got discrepancy type map");

    return $self;
}

###Object get/set methods.
sub testMode {
    my ( $self, $value ) = @_;
    $self->{_testMode} = $value if defined($value);
    return ( $self->{_testMode} );
}

sub loadDeltaOnly {
    my ( $self, $value ) = @_;
    $self->{_loadDeltaOnly} = $value if defined($value);
    return ( $self->{_loadDeltaOnly} );
}

sub applyChanges {
    my ( $self, $value ) = @_;
    $self->{_applyChanges} = $value if defined($value);
    return ( $self->{_applyChanges} );
}

sub maxLparsInQuery {
    my ( $self, $value ) = @_;
    $self->{_maxLparsInQuery} = $value if defined($value);
    return ( $self->{_maxLparsInQuery} );
}

sub firstId {
    my ( $self, $value ) = @_;
    $self->{_firstId} = $value if defined($value);
    return ( $self->{_firstId} );
}

sub lastId {
    my ( $self, $value ) = @_;
    $self->{_lastId} = $value if defined($value);
    return ( $self->{_lastId} );
}

sub discrepancyTypeMap {
    my ( $self, $value ) = @_;
    $self->{_discrepancyTypeMap} = $value if defined($value);
    return ( $self->{_discrepancyTypeMap} );
}

###Primary method used by calling clients to load staging
###software lpar data to bravo.
sub load {
    my ( $self, %args ) = @_;

    ###Check and set arguments.
    $self->checkArgs( \%args );

    ###Get a connection to staging
    ilog("getting staging db connection");
    my $stagingConnection = Database::Connection->new('staging');
    die "Unable to get staging db connection!\n"
      unless defined $stagingConnection;
    ilog("got staging db connection");

    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    die "Unable to get bravo db connection!\n"
      unless defined $bravoConnection;
    ilog("got bravo db connection");

    ###Get start time for processing
    my $begin = time();

    ###Hash to keep load statistics
    my %statistics = ();

    ###Wrap all of this in an eval so we can close the
    ###connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg;
    eval {

        my %stagingIpAddressesToDelete = ();
        ###Prepare query to pull ip address data from staging
        dlog("preparing ip address data query");
        $stagingConnection->prepareSqlQueryAndFields(    
                                 Staging::Delegate::StagingDelegate->queryIpAddressDataByMinMaxIds( $self->testMode, $self->loadDeltaOnly )
        );
        dlog("prepared ip address data query");

        ###Get the statement handle
        dlog("getting sth for ip address data query");
        my $sth = $stagingConnection->sql->{ipAddressDataByMinMaxIds};
        dlog("got sth for ip address data query");

        ###Bind our columns
        my %rec;
        dlog("binding columns for ip address data query");
        $sth->bind_columns( map { \$rec{$_} } @{ $stagingConnection->sql->{ipAddressDataByMinMaxIdsFields} } );
        dlog("binded columns for ip address data query");

        ###Excute the query
        ilog("executing ip address data query");
        $sth->execute( $self->firstId, $self->lastId );
        ilog("executed ip address data query");

        while ( $sth->fetchrow_arrayref ) {
            ###Clean record values
            cleanValues( \%rec );

            ###Upper case record values
            upperValues( \%rec );

            logRec( 'dlog', \%rec );

            ###Get bravo software lpar object by biz key if exists
            my $bravoSoftwareLpar;
            $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar();
            $bravoSoftwareLpar->customerId( $rec{customerId} );
            $bravoSoftwareLpar->name( $rec{name} );
            $bravoSoftwareLpar->getByBizKey($bravoConnection);

            if ( defined $bravoSoftwareLpar->id ) {
                dlog(   "matching bravo software lpar record found: "
                      . "old bravo software lpar obj="
                      . $bravoSoftwareLpar->toString() );
            }
            else {
                dlog(   "no matching bravo software lpar record found: "
                      . "old bravo software lpar obj="
                      . $bravoSoftwareLpar->toString() );
                next;
            }

            ###Check whether this record exists in BRAVO db
            my $bravoIpAddress = new BRAVO::OM::IpAddress();
            $bravoIpAddress->softwareLparId( $bravoSoftwareLpar->id );
            $bravoIpAddress->ipAddress( $rec{ipAddress} );
            $bravoIpAddress->getByBizKey($bravoConnection);

            ###Build staging bravo ip address record
            my $stagingBravoIpAddress = $self->buildBravoIpAddress( \%rec );
            $stagingBravoIpAddress->softwareLparId( $bravoSoftwareLpar->id );

            my $stagingIpAddress = $self->buildStagingIpAddress( \%rec );

            if ( defined $bravoIpAddress->id ) {
                dlog(   "matching bravo ip address record found: "
                      . "old bravo ip address obj="
                      . $bravoIpAddress->toString() );

                ###If staging action is update, compare the two records and then
                ###update is necessary
                if ( $rec{ipAction} eq 'UPDATE' ) {
                    dlog("Update Action");
                    if ( !$stagingBravoIpAddress->equals($bravoIpAddress) ) {

                        ### update fields from staging record to bravo record
                        $bravoIpAddress->domain( $stagingBravoIpAddress->domain );
                        $bravoIpAddress->subnet( $stagingBravoIpAddress->subnet );
                        $bravoIpAddress->hostname( $stagingBravoIpAddress->hostname );
                        $bravoIpAddress->isDhcp( $stagingBravoIpAddress->isDhcp );
                        $bravoIpAddress->instanceId( $stagingBravoIpAddress->instanceId );
                        $bravoIpAddress->primaryDns( $stagingBravoIpAddress->primaryDns );
                        $bravoIpAddress->secondaryDns( $stagingBravoIpAddress->secondaryDns );
                        $bravoIpAddress->ipv6Address( $stagingBravoIpAddress->ipv6Address );
                        $bravoIpAddress->permMacAddress( $stagingBravoIpAddress->permMacAddress );
                        $bravoIpAddress->gateway( $stagingBravoIpAddress->gateway );

                        if ( $self->applyChanges == 1 ) {
                            ###save the record
                            $bravoIpAddress->save($bravoConnection);
                        }
                    }
                }
                elsif ( $rec{ipAction} eq 'DELETE' ) {
                    ###Delete record from BRAVO
                    dlog("Delete Action");
                    if ( $self->applyChanges == 1 ) {
                        ###delete the bravo ip address record
                        $bravoIpAddress->delete($bravoConnection);
                    }
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }
            else {
                dlog(   "no matching bravo ip address record found: "
                      . "old bravo ip address obj="
                      . $bravoIpAddress->toString() );
                ### if action is update, we insert
                if ( $rec{ipAction} eq 'UPDATE' ) {
                    if ( $self->applyChanges == 1 ) {
                        ###save the record
                        $stagingBravoIpAddress->save($bravoConnection);
                    }
                }
                elsif ( $rec{ipAction} eq 'DELETE' ) {
                    ###There is nothing to delete in BRAVO - ignore
                }
                else {
                    ###Invalid action
                    dlog("Unknown action");
                }
            }

            ###Staging ip address logic.
            if ( $stagingIpAddress->action eq 'UPDATE' ) {

                ###Mark as complete.
                $stagingIpAddress->action('COMPLETE');
                dlog("marked staging ip address action as complete");

                ###Save if applyChanges is true.
                if ( $self->applyChanges == 1 ) {
                    dlog("saving staging ip address object");
                    $stagingIpAddress->save($stagingConnection);
                    dlog("saved staging ip address object: $stagingIpAddress->toString()");
                }

            }
            elsif ( $stagingIpAddress->action eq 'COMPLETE' ) {
                ###Do not save in this case to avoid a racing
                ###condition with the atp to staging loader.
                dlog("staging ip address already complete");
            }
            elsif ( $stagingIpAddress->action eq 'DELETE' ) {
                ###Mark for delete from staging.
                $stagingIpAddressesToDelete{ $stagingIpAddress->id }++;
                dlog("marking staging ip address object for delete");
            }
            else {
                ###Invalid action.
                die "Invalid action: " . $stagingIpAddress->toString() . "\n";
            }

        }

        $sth->finish;

        ###Delete any staging ip addresses which have been flagged
        ###and processed above.
        dlog("performing any pending staging ip address deletes");
        foreach my $id ( sort keys %stagingIpAddressesToDelete ) {
            my $stagingIpAddress = new Staging::OM::IpAddress();
            $stagingIpAddress->id($id);
            $stagingIpAddress->delete($stagingConnection);
            dlog( "deleted staging ip address: " . $stagingIpAddress->toString() );
        }

    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;
    }

    ###Display statistics
    foreach my $key ( sort keys %statistics ) {
        logMsg( "statistics: $key=" . $statistics{$key} );
    }

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    ilog("totalProcessingTime: $totalProcessingTime secs");

    ###Close the staging db connection
    ilog("disconnecting staging db connection");
    $stagingConnection->disconnect;
    ilog("disconnected staging db connection");

    ###Close the bravo connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    ###die if dieMsg is defined
    die $dieMsg if defined($dieMsg);
}

###Checks arguments passed to load method.
sub checkArgs {
    my ( $self, $args ) = @_;

    ###Check TestMode arg is passed correctly
    die "Must specify TestMode sub argument!\n"
      unless exists( $args->{'TestMode'} );
    die "Invalid value passed for TestMode param!\n"
      unless ( $args->{'TestMode'} == 0 || $args->{'TestMode'} == 1 );
    $self->testMode( $args->{'TestMode'} );
    ilog( "testMode=" . $self->testMode );

    ###Check LoadDeltaOnly arg is passed correctly
    die "Must specify LoadDeltaOnly sub argument!\n"
      unless exists( $args->{'LoadDeltaOnly'} );
    die "Invalid value passed for LoadDeltaOnly param!\n"
      unless ( $args->{'LoadDeltaOnly'} == 0 || $args->{'LoadDeltaOnly'} == 1 );
    $self->loadDeltaOnly( $args->{'LoadDeltaOnly'} );
    ilog( "loadDeltaOnly=" . $self->loadDeltaOnly );

    ###Check ApplyChanges arg is passed correctly
    die "Must specify ApplyChanges sub argument!\n"
      unless exists( $args->{'ApplyChanges'} );
    die "Invalid value passed for ApplyChanges param!\n"
      unless ( $args->{'ApplyChanges'} == 0 || $args->{'ApplyChanges'} == 1 );
    $self->applyChanges( $args->{'ApplyChanges'} );
    ilog( "applyChanges=" . $self->applyChanges );

    ###Check MaxLparsInQuery arg is passed correctly
    die "Must specify MaxLparsInQuery sub argument!\n"
      unless exists( $args->{'MaxLparsInQuery'} );
    die "Invalid value passed for MaxLparsInQuery param!\n"
      unless $args->{'MaxLparsInQuery'} =~ m/\d+/;
    $self->maxLparsInQuery( $args->{'MaxLparsInQuery'} );
    ilog( "maxLparsInQuery=" . $self->maxLparsInQuery );

    ###Check FirstId arg is passed correctly
    die "Must specify FirstId sub argument!\n"
      unless exists( $args->{'FirstId'} );
    die "Invalid value passed for FirstId param!\n"
      unless $args->{'FirstId'} =~ m/\d+/;
    $self->firstId( $args->{'FirstId'} );
    ilog( "firstId=" . $self->firstId );

    ###Check LastId arg is passed correctly
    die "Must specify LastId sub argument!\n"
      unless exists( $args->{'LastId'} );
    die "Invalid value passed for LastId param!\n"
      unless $args->{'LastId'} =~ m/\d+/;
    $self->lastId( $args->{'LastId'} );
    ilog( "lastId=" . $self->lastId );
}

sub buildBravoIpAddress {
    my ( $self, $rec ) = @_;

    my $ip = new BRAVO::OM::IpAddress();
    $ip->ipAddress( $rec->{ipAddress} );
    $ip->hostname( $rec->{hostname} );
    $ip->domain( $rec->{domain} );
    $ip->subnet( $rec->{subnet} );
    $ip->instanceId( $rec->{instanceId} );
    $ip->gateway( $rec->{gateway} );
    $ip->primaryDns( $rec->{primaryDns} );
    $ip->secondaryDns( $rec->{secondaryDns} );
    $ip->isDhcp( $rec->{isDhcp} );
    $ip->permMacAddress( $rec->{permMacAddress} );
    $ip->ipv6Address( $rec->{ipv6Address} );

    return $ip;
}

sub buildStagingIpAddress {
    my ( $self, $rec ) = @_;

    my $ip = new Staging::OM::IpAddress();
    $ip->id( $rec->{ipAddressId} );
    $ip->scanRecordId( $rec->{scanRecordId} );
    $ip->ipAddress( $rec->{ipAddress} );
    $ip->hostname( $rec->{hostname} );
    $ip->domain( $rec->{domain} );
    $ip->subnet( $rec->{subnet} );
    $ip->instanceId( $rec->{instanceId} );
    $ip->gateway( $rec->{gateway} );
    $ip->primaryDns( $rec->{primaryDns} );
    $ip->secondaryDns( $rec->{secondaryDns} );
    $ip->isDhcp( $rec->{isDhcp} );
    $ip->permMacAddress( $rec->{permMacAddress} );
    $ip->ipv6Address( $rec->{ipv6Address} );
    $ip->action( $rec->{ipAction} );

    return $ip;
}

1;
