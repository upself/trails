package BRAVO::ProcgrpsLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use SIMS::Delegate::SimsDelegate;
use BRAVO::Delegate::BRAVODelegate;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode          => undef,
                 _loadDeltaOnly     => undef,
                 _applyChanges      => undef,
                 _procgrpsList      => undef,
                 _bravoProcgrpsList => undef
    };

    bless $self, $class;
    dlog("instantiated self");

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

sub procgrpsList {
    my ( $self, $value ) = @_;
    $self->{_procgrpsList} = $value if defined($value);
    return ( $self->{_procgrpsList} );
}

sub bravoProcgrpsList {
    my ( $self, $value ) = @_;
    $self->{_bravoProcgrpsList} = $value if defined($value);
    return ( $self->{_bravoProcgrpsList} );
}

###Primary method used by calling clients to load SIMS->PROCGRPS
###data to the staging db.
sub load {
    my ( $self, %args ) = @_;

    dlog("start load method");

    ###Check and set arguments.
    dlog("checking passed arguments");
    $self->checkArgs( \%args );
    dlog("checked passed arguments");

    ###Set the job name of this script to update the status
    my $job;
    if ( $self->loadDeltaOnly == 1 ) {
        $job = 'PROCGRPS TO BRAVO (DELTA)';
    }
    else {
        $job = 'PROCGRPS TO BRAVO (FULL)';
    }
    dlog("job=$job");

    my $systemScheduleStatus;
    if ( $self->applyChanges == 1 ) {
        ###Notify the scheduler that we are starting
        ilog("starting $job system schedule status");
        $systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
        ilog("started $job system schedule status");
    }

    ###Get a connection to sims
    ilog("getting sims db connection");
    my $simsConnection = Database::Connection->new('sims');
    ilog("got sims db connection");

    ###Get a connection to bravo
    ilog("getting bravo db connection");
    my $bravoConnection = Database::Connection->new('trails');
    ilog("got bravo db connection");

    ###Get start time for processing
    my $begin = time();

    ###Hash to keep load statistics
    my %statistics  = ();
    my $insertCount = 0;
    my $updateCount = 0;
    my $deleteCount = 0;

    ###Wrap all of this in an eval so we can close the
    ###connections if something dies.  Use dieMsg to
    ###determine if this method should throw the die.
    my $dieMsg;
    eval {

        ###Get the sims data from the sims db
        $self->prepareSourceData( $simsConnection, $bravoConnection );
        ilog("got data from sims");
        ilog( "procgrps record count: " . scalar keys %{ $self->procgrpsList } );

        ###Get Bravo data
        $self->bravoProcgrpsList(
                            BRAVO::Delegate::BRAVODelegate->getProcgrpsData( $bravoConnection, $self->loadDeltaOnly ) );
        ilog("got data from bravo");
        ilog( "procgrps record count: " . scalar keys %{ $self->bravoProcgrpsList } );

        ###Process the list from SIMS.PROCGRPS and insert/update/delete records from
        ###PROCGRPS table in BRAVO

        ###Let us do insert/updates first
        foreach my $key ( keys %{ $self->procgrpsList } ) {
            my $procgrps = $self->procgrpsList->{$key};

            if ( !defined $self->bravoProcgrpsList->{$key} ) {
                ###we need to insert
                $procgrps->status('ACTIVE');
                $procgrps->insert($bravoConnection);
                $insertCount++;
            }
            else {
                ###we will update the record now
                if ( !$procgrps->equals( $self->bravoProcgrpsList->{$key} ) ) {
                    $procgrps->status('ACTIVE');
                    $procgrps->update($bravoConnection);
                    $updateCount++;
                }
            }
        }

        ###Take care of deletes now - if there is a row in BRAVO->PROCGRPS
        ###table that doesn't exist in SIMS, mark the record as inactive
        foreach my $key ( keys %{ $self->bravoProcgrpsList } ) {
            my $procgrps = $self->bravoProcgrpsList->{$key};

            next if ( defined $self->procgrpsList->{$key} );

            dlog( "status is -> " . $procgrps->status );
            if ( $procgrps->status eq "ACTIVE" ) {
                ###we need to soft delete this record
                dlog(" Soft deleting -> $key");
                $procgrps->status("INACTIVE");
                $procgrps->delete($bravoConnection);
            }
        }

    };
    if ($@) {
        ###Something died in the eval, set dieMsg so
        ###we know to die after closing the db connections.
        elog($@);
        $dieMsg = $@;

        if ( $self->applyChanges == 1 ) {

            ###Notify the scheduler that we had an error
            ilog("erroring $job system schedule status");
            SystemScheduleStatusDelegate->error($systemScheduleStatus);
            ilog("errored $job system schedule status");
        }
    }
    else {
        if ( $self->applyChanges == 1 && !defined $dieMsg ) {

            ###Notify the scheduler that we are stopping
            ilog("stopping $job system schedule status");
            SystemScheduleStatusDelegate->stop($systemScheduleStatus);
            ilog("stopped $job system schedule status");
        }
    }

    $statistics{"updateCount"} = $updateCount;
    $statistics{"insertCount"} = $insertCount;
    $statistics{"deleteCount"} = $deleteCount;

    ###Display statistics
    foreach my $key ( sort keys %statistics ) {
        logMsg( "statistics: $key=" . $statistics{$key} );
    }

    ###Calculate duration of this processing
    my $totalProcessingTime = time() - $begin;
    logMsg("totalProcessingTime: $totalProcessingTime secs");

    ###Close the swcm connection
    ilog("disconnecting sims db connection");
    $simsConnection->disconnect;
    ilog("disconnected sims db connection");

    ###Close the staging db connection
    ilog("disconnecting bravo db connection");
    $bravoConnection->disconnect;
    ilog("disconnected bravo db connection");

    ###die if dieMsg is defined
    die $dieMsg if defined $dieMsg;
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
}

sub prepareSourceData {
    my ( $self, $connection, $bravoConnection ) = @_;

    dlog('Start prepareSourceData method');

    eval { $self->procgrpsList( SIMS::Delegate::SimsDelegate->getProcgrpsData( $connection, $bravoConnection ) ); };
    if ($@) {
        wlog($@);
        die $@;
    }

    dlog('End prepareSourceData method');
}
1;
