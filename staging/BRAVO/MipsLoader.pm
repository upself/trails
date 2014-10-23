package BRAVO::MipsLoader;

use strict;
use Base::Utils;
use Database::Connection;
use Sigbank::Delegate::SystemScheduleStatusDelegate;
use SIMS::Delegate::SimsDelegate;

###Object constructor.
sub new {
    my ($class) = @_;
    my $self = {
                 _testMode      => undef,
                 _loadDeltaOnly => undef,
                 _applyChanges  => undef,
                 _mipsList      => undef,
                 _bravoMipsList => undef
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

sub mipsList {
    my ( $self, $value ) = @_;
    $self->{_mipsList} = $value if defined($value);
    return ( $self->{_mipsList} );
}

sub bravoMipsList {
    my ( $self, $value ) = @_;
    $self->{_bravoMipsList} = $value if defined($value);
    return ( $self->{_bravoMipsList} );
}

###Primary method used by calling clients to load swcm
###license data to the staging db.
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
        $job = 'MIPS TO BRAVO (DELTA)';
    }
    else {
        $job = 'MIPS TO BRAVO (FULL)';
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
        ###Get the SIMS->MIPS data from the SIMS db
        $self->prepareSourceData( $simsConnection, $bravoConnection );
        ilog("got data from sims");
        ilog( "mips record count: " . scalar keys %{ $self->mipsList } );

        ###Get Bravo data
        $self->bravoMipsList( BRAVO::Delegate::BRAVODelegate->getMipsData($bravoConnection) );
        ilog("got data from bravo");
        ilog( "mips record count: " . scalar keys %{ $self->bravoMipsList } );

        ###Process the list from SIMS.MIPS and insert/update/delete records from
        ###PROCGRPS table in BRAVO

        ###Let us do insert/updates first
        foreach my $key ( keys %{ $self->mipsList } ) {
            my $mips = $self->mipsList->{$key};

            if ( !defined $self->bravoMipsList->{$key} ) {
                ###we need to insert
                $mips->status('ACTIVE');
                $mips->insert($bravoConnection);
                $insertCount++;
            }
            else {
                if ( !$mips->equals( $self->bravoMipsList->{$key} ) ) {
                    ###we will update the record
                    $mips->status('ACTIVE');
                    $mips->update($bravoConnection);
                    $updateCount++;
                }
            }
        }

        ###Take care of deletes now - if there is a row in BRAVO->MIPS
        ###table that doesn't exist in SIMS, mark the record as inactive
        foreach my $key ( keys %{ $self->bravoMipsList } ) {
            my $mips = $self->bravoMipsList->{$key};
            next if ( defined $self->mipsList->{$key} );

            ###we need to soft delete this record
            if ( $mips->status eq "ACTIVE" ) {
                dlog(" Soft deleting -> $key");
                $mips->status("INACTIVE");
                $mips->delete($bravoConnection);
                $deleteCount++;
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

    eval { $self->mipsList( SIMS::Delegate::SimsDelegate->getMipsData( $connection, $bravoConnection ) ); };
    if ($@) {
        wlog($@);
        die $@;
    }

    dlog('End prepareSourceData method');
}

1;
