package BRAVO::ContactLoader;

use strict;
use Base::Utils;
use CNDB::Delegate::CNDBDelegate;
use BRAVO::Delegate::BRAVODelegate;
use Sigbank::Delegate::SystemScheduleStatusDelegate;

###Need to check and make sure current stuff has active customerIds, etc
sub new {
	my ($class) = @_;
	my $self = {
		_testMode           => undef,
		_loadDeltaOnly      => undef,
		_applyChanges       => undef,
		_list               => undef
	};
	bless $self, $class;
	dlog("instantiated self");

	return $self;
}

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

sub load {
	my ( $self, %args ) = @_;

	dlog('Start load method');
	
	###Check and set arguments.
	dlog("checking passed arguments");
	$self->checkArgs( \%args );
	dlog("checked passed arguments");

	my $job = "CONTACT REPLICATION";
	dlog("job=$job");
	
	my $systemScheduleStatus;
	if ( $self->applyChanges == 1 ) {
		###Notify the scheduler that we are starting
		ilog("starting $job system schedule status");
		$systemScheduleStatus = SystemScheduleStatusDelegate->start($job);
		ilog("started $job system schedule status");
	}

	ilog('Get the bravo connection');
	my $bravoConnection = Database::Connection->new('trails');
	ilog('Got bravo connection');
	
	ilog('Get the cndb connection');
	my $cndbConnection = Database::Connection->new('cndb');
	ilog('Got cndb connection');

	my $dieMsg = undef;
	eval {
		ilog('Preparing the source data');
		$self->prepareSourceData($cndbConnection);
		ilog('Source data prepared');

		ilog('Performing the delta');
		$self->doDelta($bravoConnection);
		ilog('Delta complete');

		ilog('Applying deltas');
		$self->applyDelta($bravoConnection);
		ilog('Deltas applied');
	};
	if ($@) {
		$dieMsg = $@;
		elog($dieMsg);

		if ( $self->applyChanges == 1 ) {
			SystemScheduleStatusDelegate->error( $systemScheduleStatus,
				$dieMsg );
		}
	}
	else {
		if ( $self->applyChanges == 1 ) {
			ilog("Stopping $job system schedule status");
			SystemScheduleStatusDelegate->stop($systemScheduleStatus);
			ilog("Stopped $job system schedule status");
		}
	}

	ilog('Disconnecting from staging');
	$bravoConnection->disconnect;
	ilog('Staging disconnected');
	
	ilog('Disconnecting from bravo');
	$cndbConnection->disconnect;
	ilog('Bravo disconnected');

	die $dieMsg if defined $dieMsg;

	dlog('End load method complete');
}

sub prepareSourceData {
	my ( $self, $connection ) = @_;

	dlog('Start prepareSourceData method');

	ilog('Acquring contact data');

	$self->list(
			CNDB::Delegate::CNDBDelegate->getContactData(
				$connection));

	dlog('End prepareSourceData method');
}

sub doDelta {
	my ( $self, $connection ) = @_;

	dlog('Start doDelta method');

	dlog('Preparing bravo contact query');
	$connection->prepareSqlQueryAndFields(
		BRAVO::Delegate::BRAVODelegate->queryContactData()
	);
	dlog('bravo contact query prepared');

	dlog('Getting statement handle');
	my $sth = $connection->sql->{contactData};
	dlog('Acquired statement handle');

	dlog('Binding columns');
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $connection->sql->{contactDataFields} } );
	dlog('Columns binded');

	ilog('Executing bravo contact query');
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {

		###Get the key
		my $key = $rec{id};
		dlog("contact key=$key");

		###Create and populate a new contact object
		my $contact = new BRAVO::OM::Contact();
		$contact->id( $rec{id} );
		$contact->contactId($rec{id});
		$contact->role( $rec{role} );
		$contact->serial( $rec{serial} );
		$contact->fullName( $rec{fullName} );
		$contact->remoteUserHolder( $rec{remoteUser} );
		$contact->notesMail( $rec{notesMail} );
		$contact->creationDateTime( $rec{creationDateTime} );
        $contact->updateDateTime( $rec{updateDateTime} );
		
		dlog( $contact->toString );

		if ( defined $self->list->{$key} ) {
			dlog('contact exists in cndb');
			
			$self->list->{$key}->id($rec{id});

			if ( !$contact->equals( $self->list->{$key} ) ) {
				dlog('contact is not equal');
				dlog( $self->list->{$key}->toString );

				$self->list->{$key}->action('UPDATE');
			}
			else {
				dlog('contact is equal, setting to complete');
				$self->list->{$key}->action('COMPLETE');
			}
		}
		else {
			elog('contact does not exist in cndb');
#			die('Contact deleted from CNDB');
		}
	}
	$sth->finish();

	dlog('End doDelta method');
}

sub applyDelta {
	my ( $self, $connection ) = @_;

	dlog('Start applyDelta method');
	
	foreach my $key ( keys %{ $self->list } ) {
		dlog("Applying key=$key");

		$self->list->{$key}->action('UPDATE')
		  if ( !defined $self->list->{$key}->action );

		if ( $self->list->{$key}->action eq 'COMPLETE' ) {
			dlog("Skipping this as is complete");
		}
		else {
			$self->list->{$key}->save($connection)
				if ( $self->applyChanges == 1 );
			$self->list->{$key}->action('COMPLETE');
		}
	}

	dlog('End apply method');
}

sub list {
	my ( $self, $value ) = @_;
	$self->{list} = $value if defined($value);
	return ( $self->{list} );
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
1;
