package BRAVO::Loader::Hardware;

use strict;
use Carp qw( croak );
use Base::Utils;
use Recon::Queue;
use BRAVO::OM::Hardware;
use Staging::OM::HardwareLpar;
use BRAVO::Loader::HardwareLpar;
use Recon::Queue;
use BRAVO::Delegate::BRAVODelegate;

###Object constructor.
sub new {
	my ( $class, $stagingConnection, $bravoConnection, $stagingHardware ) = @_;
	my $self = {
		_stagingConnection      => $stagingConnection,
		_bravoConnection        => $bravoConnection,
		_stagingHardware        => $stagingHardware,
		_error                  => 0,
		_reconDeep              => 0,
		_bravoHardware          => undef,
		_saveBravoHardware      => 0,
		_stagingHardwareLparIds => undef,
		_hardwareLparLoaders    => undef
	};
	bless $self, $class;

	###Call validation
	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Staging connection is undefined'
	  unless defined $self->stagingConnection;

	croak 'BRAVO connection is undefined'
	  unless defined $self->bravoConnection;

	croak 'Staging hardware is undefined'
	  unless defined $self->stagingHardware;
}

sub logic {
	my $self = shift;

	$self->buildBravoHardware;

	my $bravoHardware = new BRAVO::OM::Hardware();
	$bravoHardware->machineTypeId( $self->stagingHardware->machineTypeId );
	$bravoHardware->serial( $self->stagingHardware->serial );
	$bravoHardware->country( $self->stagingHardware->country );
	$bravoHardware->getByBizKey( $self->bravoConnection );
	dlog( $bravoHardware->toString );

	if ( defined $bravoHardware->id ) {
		###We have a matching bravo hardware

		###Set the new bravo hardware id to the old id
		$self->bravoHardware->id( $bravoHardware->id );

		###Set to save the bravo hardware if they are not equal
		if ( !$bravoHardware->equals( $self->bravoHardware ) ) {
			$self->saveBravoHardware(1);

			if (   $self->bravoHardware->hardwareStatus eq 'HWCOUNT'
				&& $bravoHardware->hardwareStatus ne 'HWCOUNT' )
			{
				$self->reconDeep(1);
			}
			elsif ($bravoHardware->hardwareStatus eq 'HWCOUNT'
				&& $self->bravoHardware->hardwareStatus ne 'HWCOUNT' )
			{
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->processorCount !=
				$self->bravoHardware->processorCount )
			{
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->chips != $self->bravoHardware->chips ) {
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->machineTypeId !=
				$self->bravoHardware->machineTypeId )
			{
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->model ne $self->bravoHardware->model ) {
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->processorType ne
				$self->bravoHardware->processorType )
			{
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->cpuMIPS != $self->bravoHardware->cpuMIPS ) {
				dlog(
					"$bravoHardware->cpuMIPS != $self->bravoHardware->cpuMIPS");
				$self->reconDeep(1);
			}
			elsif ( $bravoHardware->cpuMSU != $self->bravoHardware->cpuMSU ) {
				dlog(
					"$bravoHardware->cpuMIPS != $self->bravoHardware->cpuMIPS");
				$self->reconDeep(1);
			}
		}
	}
	else {
		###This is a new record

		###Set to save the hardware
		$self->saveBravoHardware(1);
	}

	$self->processHardwareLpars;
}

sub processHardwareLpars {
	my $self = shift;

	$self->getStagingHardwareLparIds;

	foreach my $id ( sort @{ $self->stagingHardwareLparIds } ) {
		my $stagingHardwareLpar = new Staging::OM::HardwareLpar();
		$stagingHardwareLpar->id($id);
		$stagingHardwareLpar->getById( $self->stagingConnection );
		dlog( $stagingHardwareLpar->toString );

		if ( $self->stagingHardware->action eq 'DELETE' || substr($self->stagingHardware->action,-1) eq '2' ) {
			if ( $stagingHardwareLpar->action ne 'DELETE' || substr($stagingHardwareLpar->action,-1) ne '2' ) {
				$self->error(1);
				$self->stagingHardware->action('1');
				$self->stagingHardware->save( $self->stagingConnection );
				$self->addToCount( 'STAGING', 'HARDWARE', 'STATUS_UPDATE' );
				next;
			}
		}

		my $hardwareLparLoader = new BRAVO::Loader::HardwareLpar(
			$self->stagingConnection, $self->bravoConnection,
			$stagingHardwareLpar,     $self->bravoHardware
		);
		$hardwareLparLoader->reconDeep( $self->reconDeep );
		$hardwareLparLoader->logic;
		if ( $hardwareLparLoader->error == 1 ) {
			$self->error(1);
			next;
		}
		$self->addToHardwareLparLoaders($hardwareLparLoader);
	}
}

sub save {
	my $self = shift;

	return if $self->error == 1;

	###Save the hardware if we're supposed to
	if ( $self->saveBravoHardware == 1 ) {
		$self->bravoHardware->save( $self->bravoConnection );
		$self->addToCount( 'TRAILS', 'HARDWARE', 'UPDATE' );
	}

	###Call save on the hardware lpar objects
	if ( defined $self->hardwareLparLoaders ) {
		foreach my $hardwareLparLoader ( @{ $self->hardwareLparLoaders } ) {
			$hardwareLparLoader->bravoHardwareLpar->hardwareId(
				$self->bravoHardware->id );
			$hardwareLparLoader->save;
			$self->addCountToCount($hardwareLparLoader);
		}
	}

	###Call the recon engine if we save anything
	$self->recon
	  if ( $self->saveBravoHardware == 1 );

	###Return here if the staging hardware is already in complete
	return if ( $self->stagingHardware->action eq 'COMPLETE' || substr($self->stagingHardware->action,-1) eq '0' );

	###Delete the staging hardware and return, if we're supposed to
	if ( $self->stagingHardware->action eq 'DELETE' || substr($self->stagingHardware->action,-1) eq '2' ) {
		$self->stagingHardware->delete( $self->stagingConnection );
		$self->addToCount( 'STAGING', 'HARDWARE', 'DELETE' );
		return;
	}

	###Set the staging hardware to complete
	$self->stagingHardware->action('0');

	###Save the staging hardware
	$self->stagingHardware->save( $self->stagingConnection );
	$self->addToCount( 'STAGING', 'HARDWARE', 'COMPLETE' );
}

sub recon {
	my $self = shift;

	my $queue =
	  Recon::Queue->new( $self->bravoConnection, $self->bravoHardware );
	$queue->add;
	$self->addToCount( 'TRAILS', 'RECON_HW', 'UPDATE' );
}

sub getStagingHardwareLparIds {
	my $self = shift;

	my @ids;
	my %rec;

	$self->stagingConnection->prepareSqlQueryAndFields(
		$self->queryHardwareLparData() );
	my $sth = $self->stagingConnection->sql->{hardwareLparData};
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->stagingConnection->sql->{hardwareLparDataFields} } );
	$sth->execute( $self->stagingHardware->id );
	while ( $sth->fetchrow_arrayref ) {
		push @ids, $rec{id};
	}
	$sth->finish;

	$self->stagingHardwareLparIds( \@ids );
}

sub queryHardwareLparData {
	my $self = shift;

	my @fields = qw(
	  id
	);

	my $query = '
        select
            hl.id
        from
            hardware_lpar hl
        where
            hl.hardware_id = ?
    ';

	dlog("queryHardwareLparData=$query");
	return ( 'hardwareLparData', $query, \@fields );
}

sub buildBravoHardware {
	my $self = shift;

	my $bravoHardware = new BRAVO::OM::Hardware();
	$bravoHardware->machineTypeId( $self->stagingHardware->machineTypeId );
	$bravoHardware->serial( $self->stagingHardware->serial );
	$bravoHardware->country( $self->stagingHardware->country );
	$bravoHardware->owner( $self->stagingHardware->owner );
	$bravoHardware->customerNumber( $self->stagingHardware->customerNumber );
	$bravoHardware->hardwareStatus( $self->stagingHardware->hardwareStatus );
	$bravoHardware->status( $self->stagingHardware->status );
	$bravoHardware->customerId( $self->stagingHardware->customerId );
	$bravoHardware->processorCount( $self->stagingHardware->processorCount );
	$bravoHardware->classification( $self->stagingHardware->classification );
	$bravoHardware->chips( $self->stagingHardware->chips );
	$bravoHardware->model( $self->stagingHardware->model );
	$bravoHardware->processorType( $self->stagingHardware->processorType );
	$bravoHardware->mastProcessorType( $self->stagingHardware->mastProcessorType );
	$bravoHardware->serverType( $self->stagingHardware->serverType );
	$bravoHardware->cpuMIPS( $self->stagingHardware->cpuMIPS );
	$bravoHardware->cpuMSU( $self->stagingHardware->cpuMSU );
	$bravoHardware->cpuGartnerMIPS( $self->stagingHardware->cpuGartnerMIPS );
	$bravoHardware->processorManufacturer(
		$self->stagingHardware->processorManufacturer );
	$bravoHardware->processorModel( $self->stagingHardware->processorModel );
	$bravoHardware->nbrCoresPerChip( $self->stagingHardware->nbrCoresPerChip );
	$bravoHardware->nbrOfChipsMax( $self->stagingHardware->nbrOfChipsMax );
	$bravoHardware->shared( $self->stagingHardware->shared );
	$bravoHardware->sharedProcessor( $self->stagingHardware->sharedProcessor );
	$bravoHardware->cloudName( $self->stagingHardware->cloudName );
	$bravoHardware->chassisId( $self->stagingHardware->chassisId );
	my $accountNumber = $self->stagingHardware->customerNumber;
	$accountNumber =~ s/X//g;
	$bravoHardware->accountNumber($accountNumber);

	$self->bravoHardware($bravoHardware);
}

sub stagingConnection {
	my ( $self, $value ) = @_;
	$self->{_stagingConnection} = $value if defined($value);
	return ( $self->{_stagingConnection} );
}

sub bravoConnection {
	my ( $self, $value ) = @_;
	$self->{_bravoConnection} = $value if defined($value);
	return ( $self->{_bravoConnection} );
}

sub stagingHardware {
	my ( $self, $value ) = @_;
	$self->{_stagingHardware} = $value if defined($value);
	return ( $self->{_stagingHardware} );
}

sub bravoHardware {
	my ( $self, $value ) = @_;
	$self->{_bravoHardware} = $value if defined($value);
	return ( $self->{_bravoHardware} );
}

sub saveBravoHardware {
	my ( $self, $value ) = @_;
	$self->{_saveBravoHardware} = $value if defined($value);
	return ( $self->{_saveBravoHardware} );
}

sub error {
	my ( $self, $value ) = @_;
	$self->{_error} = $value if defined($value);
	return ( $self->{_error} );
}

sub reconDeep {
	my ( $self, $value ) = @_;
	$self->{_reconDeep} = $value if defined($value);
	return ( $self->{_reconDeep} );
}

sub stagingHardwareLparIds {
	my ( $self, $value ) = @_;
	$self->{_stagingHardwareLparIds} = $value if defined($value);
	return ( $self->{_stagingHardwareLparIds} );
}

sub hardwareLparLoaders {
	my ( $self, $value ) = @_;
	$self->{_hardwareLparLoaders} = $value if defined($value);
	return ( $self->{_hardwareLparLoaders} );
}

sub addToHardwareLparLoaders {
	my ( $self, $value ) = @_;

	my @array;

	if ( defined $self->hardwareLparLoaders ) {
		@array = @{ $self->hardwareLparLoaders };
	}
	push @array, $value;
	$self->hardwareLparLoaders( \@array );
}

sub addToCount {
	my ( $self, $db, $object, $action ) = @_;
	my $hash;
	if ( defined $self->count ) {
		$hash = $self->count;
		$hash->{$db}->{$object}->{$action}++;
	}
	else {
		$hash->{$db}->{$object}->{$action} = 1;
	}
	$self->count($hash);
}

sub count {
	my ( $self, $value ) = @_;
	$self->{_count} = $value if defined($value);
	return ( $self->{_count} );
}

sub addCountToCount {
	my ( $self, $object ) = @_;
	my $hash;
	if ( defined $object->count ) {
		foreach my $db ( keys %{ $object->count } ) {
			foreach my $type ( keys %{ $object->count->{$db} } ) {
				foreach my $action ( keys %{ $object->count->{$db}->{$type} } )
				{
					my $count = $object->count->{$db}->{$type}->{$action};
					if ( defined $self->count ) {
						$hash = $self->count;
						$hash->{$db}->{$type}->{$action} =
						  $hash->{$db}->{$type}->{$action} + $count;
					}
					else {
						$hash->{$db}->{$type}->{$action} = $count;
					}
				}
			}
		}
		$self->count($hash);
	}
}

1;

