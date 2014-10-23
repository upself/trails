package Staging::SoftwareManualLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::SoftwareManual;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::SoftwareManualDelegate;

our @ISA = qw(Loader);

###Need to check and make sure current stuff has active customerIds, etc
sub new {
	my ( $class, $bankAccountName ) = @_;

	dlog('Building new SoftwareManualLoader object');

	my $self = $class->SUPER::new($bankAccountName);

	$self->{_list} = undef;

	bless $self, $class;

	dlog( 'SoftwareFilterLoader instantiated for ' . $bankAccountName );

	return $self;
}

sub load {
	my ( $self, %args ) = @_;

	dlog('Start load method');

	my $job = $self->SUPER::bankAccountName . " SOFTWARE MANUAL PULL";

	$self->SUPER::load( \%args, $job );

	ilog('Acquiring the staging connection');
	my $stagingConnection = Database::Connection->new('staging');
	ilog('Staging connection acquired');

	my $dieMsg = undef;
	eval {
		ilog('Preparing the source data');
		$self->prepareSourceData;
		ilog('Source data prepared');

		ilog('Performing the delta');
		$self->doDelta($stagingConnection);
		ilog('Delta complete');

        ###Check if we have crossed the delete threshold     
        if ($self->SUPER::checkDeleteThreshold()) {
            $dieMsg = '**** We are deleting more than 15% of total records - Aborting ****';
        }
        else {
		  ilog('Applying deltas');
		  $self->applyDelta($stagingConnection);
		  ilog('Deltas applied');
        }
	};
	if ($@) {
		$dieMsg = $@;
		elog($dieMsg);
	}

	$self->SUPER::endLoad($dieMsg);

	ilog('Disconnecting from staging');
	$stagingConnection->disconnect;
	ilog('Staging disconnected');

	die $dieMsg if defined $dieMsg;

	dlog('Load method complete');
}

sub prepareSourceData {
	my ($self) = @_;

	dlog('Start prepareSourceData method');

	die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

	my $connection;
	my $dieMsg = undef;
	eval {
		if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' )
		{
			$connection =
			  Database::Connection->new(
				$self->SUPER::bankAccount );
		}
		$self->list(
			SoftwareManualDelegate->getSoftwareManualData(
				$connection, $self->SUPER::bankAccount,
				$self->loadDeltaOnly
			)
		);
	};
	if ($@) {
		$dieMsg = $@;
		elog($dieMsg);
	}

	if ( $self->SUPER::bankAccount->connectionType eq 'CONNECTED' ) {
		ilog('Disconnecting from bank account');
		$connection->disconnect;
		ilog('Disconnected from bank account');
	}

	die $dieMsg if defined $dieMsg;
	
    $self->SUPER::totalCnt( scalar keys %{ $self->list } );	
	dlog('End prepareSourceData method');
}

sub doDelta {
	my ( $self, $connection ) = @_;

	dlog('Start doDelta method');

	die('Cannot call method directly') if ( $self->SUPER::flag == 0 );

	if ( !defined $self->list ) {
		wlog('scanlist is not defined');
		return;
	}

	if ( scalar keys %{ $self->list } == 0 ) {
		wlog('scanlist is zero');
		return;
	}

	dlog('Preparing staging software manual query');
	$connection->prepareSqlQuery(
		Staging::Delegate::StagingDelegate->querySoftwareManualData() );
	dlog("Prepared staging software filter query");

	###Define our fields
	my @fields = (qw(id softwareId version users action scanRecordId ));

	###Get the statement handle
	my $sth = $connection->sql->{softwareManualData};

	###Bind our columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @fields );

	dlog('Executing staging software manual query');
	$sth->execute( $self->SUPER::bankAccount->id );
	while ( $sth->fetchrow_arrayref ) {

		my $key = $rec{scanRecordId} . '|' . $rec{softwareId};
        dlog("key=$key");
        
        if($rec{action} eq 'DELETE') {
            delete $self->list->{$key};
            next;
        }

		###Create and populate a new hardware object
		my $sm = new Staging::OM::SoftwareManual();
		$sm->id( $rec{id} );
		$sm->scanRecordId( $rec{scanRecordId} );
		$sm->softwareId( $rec{softwareId} );
		$sm->version( $rec{version} );
		$sm->users( $rec{users} );
		$sm->action( $rec{action} );
		dlog( $sm->toString );

		if ( $self->list->{$key} ) {
			dlog("Manual exists in bank account");

			###Set the id
			$self->list->{$key}->id( $rec{id} );

			if ( !$sm->equals( $self->list->{$key} ) ) {
				dlog("Manual is not equal");

				if ( $sm->action eq 'COMPLETE' ) {
					###Set to update if currently complete
					$self->list->{$key}->action('UPDATE');
					$self->SUPER::incrUpdateCnt();
				}
				else {
					###Set to complete so we don't save
					$self->list->{$key}->action('COMPLETE');
				}
			}
			else {
				dlog("Record is equal, setting to complete");
				$self->list->{$key}->action('COMPLETE');
			}
		}
		else {
			###We do not perform deltas
			if ( $sm->action eq 'COMPLETE' ) {
				###Set to delete if the action is complete
				$sm->action('DELETE');
				$self->SUPER::incrDeleteCnt();
			}
			else {
				###Action is not complete, so set it to complete to not save
				$sm->action('COMPLETE');
			}

			$self->list->{$key} = $sm;
		}

		dlog( $self->list->{$key} );
	}
	$sth->finish;

	dlog("End doDelta method");
}

sub applyDelta {
	my ( $self, $connection ) = @_;

	dlog('Start applyDelta method');

	die('Cannot call method directly') if ( !$self->flag );

	###TODO Need to discuss how to handle
	if ( $self->SUPER::applyChanges == 0 ) {
		dlog('Skipping apply per argument');
		return;
	}

	if ( !defined $self->list ) {
		wlog('scanlist is not defined');
		return;
	}

	if ( scalar keys %{ $self->list } == 0 ) {
		wlog('scanlist is zero');
		return;
	}

	foreach my $key ( keys %{ $self->list } ) {
		dlog("Applying key=$key");

		$self->list->{$key}->action('UPDATE')
		  if ( !defined $self->list->{$key}->action );

		if ( $self->list->{$key}->action eq 'COMPLETE' ) {
			dlog("Skipping this as is complete");
			next;
		}

		$self->list->{$key}->save($connection);
	}

	dlog("End applyDelta method");
}

sub list {
	my ( $self, $value ) = @_;
	$self->{_list} = $value if defined($value);
	return ( $self->{_list} );
}
1;
