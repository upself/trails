package Staging::ScanSoftwareItemLoader;

use strict;
use Base::Utils;
use Staging::Loader;
use Staging::OM::ScanSoftwareItem;
use Scan::Delegate::ScanDelegate;
use Staging::Delegate::StagingDelegate;
use Scan::Delegate::ScanSoftwareItemDelegate;

our @ISA = qw(Loader);

###Need to check and make sure current stuff has active customerIds, etc
sub new {
	my ( $class, $bankAccountName ) = @_;

	dlog('Building new ScanSoftwareItemLoader object');

	my $self = $class->SUPER::new($bankAccountName);

	$self->{_list} = undef;

	bless $self, $class;

	dlog( 'ScanSoftwareItemLoader instantiated for ' . $bankAccountName );

	return $self;
}

sub load {
	my ( $self, %args ) = @_;

	dlog('Start load method');

	my $job = $self->SUPER::bankAccountName . " SCAN SOFTWARE ITEM PULL";

	$self->SUPER::load( \%args, $job );
	my $bankAccount =$self->SUPER::bankAccount;
    dlog(' bankaccount id '. $bankAccount->id);
	ilog('Acquiring the staging connection');
	my $stagingConnection = Database::Connection->new('staging');
	ilog('Staging connection acquired');

	my $dieMsg = undef;
	eval {
		ilog('Preparing the source data');
		$self->prepareSourceData;
		ilog('Source data prepared');

		ilog('Performing the delta');
		$self->doDelta($stagingConnection, $bankAccount->id);
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
			ScanSoftwareItemDelegate->getScanSoftwareItemData(
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
	my ( $self, $connection, $bankAccountId ) = @_;

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

	dlog('Preparing staging scanSoftwareItem query');
	$connection->prepareSqlQuery(
		Staging::Delegate::StagingDelegate->queryScanSoftwareItemData( $self->SUPER::loadDeltaOnly, $bankAccountId ) );
	dlog("Prepared staging scanSoftwareItem query");

	###Define our fields
	my @fields = (qw(id scanRecordId guId lastUsed useCount action bankAccountId));

	###Get the statement handle
	my $sth = $connection->sql->{scanSoftwareItemData};

	###Bind our columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} } @fields );

	dlog('Executing staging scan software item query');
	$sth->execute();
	while ( $sth->fetchrow_arrayref ) {

		my $key =
		    $rec{scanRecordId} . '|'
		  . $rec{guId} ;
        dlog("key=$key");
        
        if($rec{action} == 2 ) {
            delete $self->list->{$key};
            next;
        }

		###Create and populate a new hardware object
		my $st = new Staging::OM::ScanSoftwareItem();
		$st->id( $rec{id} );
		$st->scanRecordId( $rec{scanRecordId} );
		$st->guId( $rec{guId} );
		$st->lastUsed( $rec{lastUsed} );
		$st->useCount( $rec{useCount} );
		$st->action( $rec{action} );
		dlog( $st->toString );
		if ( exists $self->list->{$key} ) {
			dlog("Scan software item exists in bank account");

			###Set the id
			$self->list->{$key}->id( $rec{id} );

		if ( !$st->equals( $self->list->{$key} ) ) {
				dlog("Scan software item is not equal");

				if ( $st->action == 0 ) {
					###Set to update if currently complete
					$self->list->{$key}->action(1);
					$self->SUPER::incrUpdateCnt();
				}
				else {
					###Set to complete so we don't save
					$self->list->{$key}->action(0);
				}				
			}
			else {
				dlog("Record is equal, setting to complete");
				$self->list->{$key}->action(0);
			}
		}
		else {
			
		if ( $self->SUPER::loadDeltaOnly == 1 ) {
                dlog("Setting to complete as this is delta only");
                $st->action(0);
            }
            else {
		
			if ( $st->action == 0 ) {
				###Set to delete if the action is complete
				$st->action(2);
				$self->SUPER::incrDeleteCnt();
			}
			else {
				### it is full load,so set new item to update to not save
				$st->action(1);
			 }
            }
			$self->list->{$key} = $st;
		}

		dlog( $self->list->{$key}->toString() );
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

		$self->list->{$key}->action(1)
		  if ( !defined $self->list->{$key}->action );

		if ( $self->list->{$key}->action == 0 ) {
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
