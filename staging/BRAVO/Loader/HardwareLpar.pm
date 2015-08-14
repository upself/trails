package BRAVO::Loader::HardwareLpar;

use strict;
use Carp qw( croak );
use Base::Utils;
use BRAVO::OM::HardwareLpar;
use Staging::OM::HardwareLparEff;
use BRAVO::Loader::HardwareLparEff;
use Recon::Queue;
use BRAVO::OM::Hardware;
use BRAVO::OM::SoftwareLpar;

###Object constructor.
sub new {
	my ( $class, $stagingConnection, $bravoConnection, $stagingHardwareLpar,
		$bravoHardware )
	  = @_;

	my $self = {
		_stagingConnection     => $stagingConnection,
		_bravoConnection       => $bravoConnection,
		_stagingHardwareLpar   => $stagingHardwareLpar,
		_bravoHardware         => $bravoHardware,
		_bravoHardwareLpar     => undef,
		_saveBravoHardwareLpar => 0,
		_error                 => 0,
		_reconDeep             => 0,
		_reconHardware         => undef,
		_hardwareLparEffLoader => undef,
		_updateCntShl          => 0,
		_updateCntTrEff        => 0,
		_completeCntShl        => 0,
		_updateCntRhl          => 0,
		_updateCntRsl          => 0,
		_updateCntRh           => 0

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

	croak 'Staging hardware lpar is undefined'
	  unless defined $self->stagingHardwareLpar;

	croak 'Bravo hardware is undefined'
	  unless defined $self->bravoHardware;
}

sub logic {
	my $self = shift;

	$self->buildBravoHardwareLpar;

	###Find the hardware lpar in bravo
	my $bravoHardwareLpar = new BRAVO::OM::HardwareLpar();
	$bravoHardwareLpar->customerId( $self->bravoHardwareLpar->customerId );
	$bravoHardwareLpar->name( $self->bravoHardwareLpar->name );
	$bravoHardwareLpar->getByBizKey( $self->bravoConnection );
	dlog( $bravoHardwareLpar->toString );

	if ( defined $bravoHardwareLpar->id ) {
		###We have a matching bravo hardware lpar

		###Set the new bravo hardware lpar id to the old id
		$self->bravoHardwareLpar->id( $bravoHardwareLpar->id );
		dlog('found matched bravo hw lpar with staging');
		###Set to save the bravo hardware lpar if they are not equal
		if ( !$bravoHardwareLpar->equals( $self->bravoHardwareLpar ) ) {
			dlog('staging hw lpar and bravo not same');
			$self->saveBravoHardwareLpar(1);

			if (   $self->bravoHardwareLpar->lparStatus eq 'HWCOUNT'
				&& $bravoHardwareLpar->lparStatus ne 'HWCOUNT' )
			{
				$self->reconDeep(1);
			}
			elsif ($bravoHardwareLpar->lparStatus eq 'HWCOUNT'
				&& $self->bravoHardwareLpar->lparStatus ne 'HWCOUNT' )
			{
				$self->reconDeep(1);
			}

			if ( $bravoHardwareLpar->partMIPS !=
				$self->bravoHardwareLpar->partMIPS )
			{
				$self->reconDeep(1);
			}
			elsif ( $bravoHardwareLpar->partMSU !=
				$self->bravoHardwareLpar->partMSU )
			{
				$self->reconDeep(1);
			}

			if ( defined $self->bravoHardwareLpar->hardwareId ) {
				if ( $self->bravoHardwareLpar->hardwareId !=
					$bravoHardwareLpar->hardwareId )
				{
					$self->reconDeep(1);

					my $bravoHardware = new BRAVO::OM::Hardware();
					$bravoHardware->id( $bravoHardwareLpar->hardwareId );
					$bravoHardware->getById( $self->bravoConnection );
					dlog( $bravoHardware->toString );

					$self->reconHardware($bravoHardware);
				}
			}
			else {
				$self->reconDeep(1);
			}
		}

		if (
			($self->stagingHardwareLpar->action eq 'DELETE' || substr($self->stagingHardwareLpar->action,-1) eq '2')
			&& (   $self->bravoHardwareLpar->status ne 'INACTIVE'
				|| $self->bravoHardwareLpar->lparStatus ne 'INACTIVE' )
		  )
		{
			$self->bravoHardwareLpar->status('INACTIVE');
			$self->bravoHardwareLpar->lparStatus('INACTIVE');
			$self->saveBravoHardwareLpar(1);
		}

	}
	else {
		dlog('new hw lpar from staging');
		###This is a new record

		###Set to save the hardware
		$self->saveBravoHardwareLpar(1);
	}

	$self->processHardwareLparEff;
}

sub processHardwareLparEff {
	my $self = shift;

	my $stagingHardwareLparEff = new Staging::OM::HardwareLparEff();
	$stagingHardwareLparEff->hardwareLparId( $self->stagingHardwareLpar->id );
	$stagingHardwareLparEff->getByBizKey( $self->stagingConnection );
	dlog( $stagingHardwareLparEff->toString );

	return if ( !defined $stagingHardwareLparEff->id );

	if ( $self->stagingHardwareLpar->action eq 'DELETE' || substr($self->stagingHardwareLpar->action,-1) eq '2' ) {
		if ( $stagingHardwareLparEff->action ne 'DELETE' &&  substr($stagingHardwareLparEff->action,-1) ne '2') {
			$self->error(1);
			$self->stagingHardwareLpar->action('1');
			$self->stagingHardwareLpar->save( $self->stagingConnection );
			$self->addToCount( 'STAGING', 'HARDWARE_LPAR', 'STATUS_UPDATE' );
			return;
		}
	}

	my $hardwareLparEffLoader = new BRAVO::Loader::HardwareLparEff(
		$self->stagingConnection, $self->bravoConnection,
		$stagingHardwareLparEff,  $self->bravoHardwareLpar
	);

	$hardwareLparEffLoader->logic;

	$self->hardwareLparEffLoader($hardwareLparEffLoader);
}

sub save {
	my $self = shift;

	return if $self->error == 1;

	###Save the license if we're supposed to
	if ( $self->saveBravoHardwareLpar == 1 ) {
		dlog( 'saving hwlpar ' . $self->bravoHardwareLpar->toString );
		$self->bravoHardwareLpar->save( $self->bravoConnection );
		$self->addToCount( 'TRAILS', 'HARDWARE_LPAR', 'UPDATE' );
	}

	if ( defined $self->hardwareLparEffLoader ) {
		$self->hardwareLparEffLoader->bravoHardwareLparEff->hardwareLparId(
			$self->bravoHardwareLpar->id );
		$self->hardwareLparEffLoader->save;
		$self->addCountToCount( $self->hardwareLparEffLoader );
	}

	###Call the recon engine if we save anything
	if ( $self->saveBravoHardwareLpar == 1 ) {
		$self->recon;
	}
	elsif ( $self->reconDeep == 1 ) {
		$self->recon;
	}
	
	if ( defined $self->hardwareLparEffLoader ) {
		if ( $self->hardwareLparEffLoader->saveBravoHardwareLparEff == 1 ) {
			if( $self->bravoHardwareLpar->action =~ m/\d/){
			$self->bravoHardwareLpar->action( $self->bravoHardwareLpar->action + $self->hardwareLparEffLoader->bravoHardwareLparEff->action);
			} else {
		     $self->bravoHardwareLpar->action($self->hardwareLparEffLoader->bravoHardwareLparEff->action);
			}
			dlog( 'bravoHardwareLpar action ' . $self->bravoHardwareLpar->action );
			$self->recon;
		}
	}

	###Return here if the staging license is already in complete
	return if ($self->stagingHardwareLpar->action eq 'COMPLETE' || substr($self->stagingHardwareLpar->action,-1) eq '0' );

	###Delete the staging license and return, if we're supposed to
	if ( $self->stagingHardwareLpar->action eq 'DELETE' || substr($self->stagingHardwareLpar->action,-1) eq '2') {
		$self->stagingHardwareLpar->delete( $self->stagingConnection );
		$self->addToCount( 'STAGING', 'HARDWARE_LPAR', 'DELETE' );
		return;
	}

	###Set the staging license to complete
	$self->stagingHardwareLpar->action('0');

	###Save the staging license
	$self->stagingHardwareLpar->save( $self->stagingConnection );
	$self->addToCount( 'STAGING', 'HARDWARE_LPAR', 'STATUS_COMPLETE' );
}

sub recon {
	my $self = shift;

	my $queue =
	  Recon::Queue->new( $self->bravoConnection, $self->bravoHardwareLpar );
	$queue->add;
	$self->addToCount( 'TRAILS', 'RECON_HW_LPAR', 'UPDATE' );

	if ( $self->reconDeep == 1 ) {
		my $softwareLparId = $self->getSoftwareLparId;

		if ( defined $softwareLparId ) {
			my $softwareLpar = new BRAVO::OM::SoftwareLpar();
			$softwareLpar->id($softwareLparId);
			$softwareLpar->getById( $self->bravoConnection );
			dlog( $softwareLpar->toString );

			my $queue =
			  Recon::Queue->new( $self->bravoConnection, $softwareLpar, undef,
				'DEEP' );
			$queue->add;
			$self->addToCount( 'TRAILS', 'RECON_SW_LPAR', 'UPDATE' );
		}
	}

	if ( defined $self->reconHardware ) {
		my $queue =
		  Recon::Queue->new( $self->bravoConnection, $self->reconHardware );
		$queue->add;
		$self->addToCount( 'TRAILS', 'RECON_HW', 'UPDATE' );
	}
}

sub getSoftwareLparId {
	my ( $self, $softwareLpar ) = @_;

	$self->bravoConnection->prepareSqlQueryAndFields(
		$self->queryHwSwComposite );
	my $sth = $self->bravoConnection->sql->{hwSwComposite};
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
		  @{ $self->bravoConnection->sql->{hwSwCompositeFields} } );
	$sth->execute( $self->bravoHardwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;

	return $rec{softwareLparId};
}

sub queryHwSwComposite {
	my $self = shift;

	my @fields = qw(
	  softwareLparId
	);

	my $query = qq{
        select
            software_lpar_id
        from
            hw_sw_composite
        where
            hardware_lpar_id = ?      
    };

	dlog("queryHwSwComposite=$query");
	return ( 'hwSwComposite', $query, \@fields );
}

sub buildBravoHardwareLpar {
	my $self = shift;

	my $bravoHardwareLpar = new BRAVO::OM::HardwareLpar();
	$bravoHardwareLpar->name( $self->stagingHardwareLpar->name );
	$bravoHardwareLpar->customerId( $self->stagingHardwareLpar->customerId );
	$bravoHardwareLpar->hardwareId( $self->bravoHardware->id );
	$bravoHardwareLpar->status( $self->stagingHardwareLpar->status );

	my $action     = $self->stagingHardwareLpar->action;
	my $lparStatus = $self->stagingHardwareLpar->lparStatus;
	if (( 'DELETE' eq $action || substr($action,-1) eq '2')
		&& (   !defined $lparStatus
			|| "null" eq $lparStatus
			|| '' eq $lparStatus ) )
	{
		$bravoHardwareLpar->lparStatus('INACTIVE');
	}
	else {
		$bravoHardwareLpar->lparStatus(
			$self->stagingHardwareLpar->lparStatus );
	}

	$bravoHardwareLpar->extId( $self->stagingHardwareLpar->extId );
	$bravoHardwareLpar->techImageId( $self->stagingHardwareLpar->techImageId );
	$bravoHardwareLpar->serverType( $self->stagingHardwareLpar->serverType );
	$bravoHardwareLpar->partMIPS( $self->stagingHardwareLpar->partMIPS );
	$bravoHardwareLpar->partMSU( $self->stagingHardwareLpar->partMSU );
	$bravoHardwareLpar->partGartnerMIPS( $self->stagingHardwareLpar->partGartnerMIPS );
	$bravoHardwareLpar->effectiveThreads( $self->stagingHardwareLpar->effectiveThreads );
	$bravoHardwareLpar->osType( $self->stagingHardwareLpar->osType );
	$bravoHardwareLpar->spla( $self->stagingHardwareLpar->spla );
	$bravoHardwareLpar->sysplex( $self->stagingHardwareLpar->sysplex );
	$bravoHardwareLpar->internetIccFlag(
		$self->stagingHardwareLpar->internetIccFlag );
	$bravoHardwareLpar->backupMethod(
		$self->stagingHardwareLpar->backupMethod );
	$bravoHardwareLpar->clusterType(
		$self->stagingHardwareLpar->clusterType );
	$bravoHardwareLpar->vMobilRestrict(
		$self->stagingHardwareLpar->vMobilRestrict );
	$bravoHardwareLpar->cappedLpar(
		$self->stagingHardwareLpar->cappedLpar );
	$bravoHardwareLpar->virtualFlag(
		$self->stagingHardwareLpar->virtualFlag );
	$bravoHardwareLpar->action(
		$self->stagingHardwareLpar->action );

	$self->bravoHardwareLpar($bravoHardwareLpar);
	dlog( 'build hw lpar from staging ' . $bravoHardwareLpar->toString );
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

sub stagingHardwareLpar {
	my ( $self, $value ) = @_;
	$self->{_stagingHardwareLpar} = $value if defined($value);
	return ( $self->{_stagingHardwareLpar} );
}

sub bravoHardware {
	my ( $self, $value ) = @_;
	$self->{_bravoHardware} = $value if defined($value);
	return ( $self->{_bravoHardware} );
}

sub bravoHardwareLpar {
	my ( $self, $value ) = @_;
	$self->{_bravoHardwareLpar} = $value if defined($value);
	return ( $self->{_bravoHardwareLpar} );
}

sub saveBravoHardwareLpar {
	my ( $self, $value ) = @_;
	$self->{_saveBravoHardwareLpar} = $value if defined($value);
	return ( $self->{_saveBravoHardwareLpar} );
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

sub reconHardware {
	my ( $self, $value ) = @_;
	$self->{_reconHardware} = $value if defined($value);
	return ( $self->{_reconHardware} );
}

sub hardwareLparEffLoader {
	my ( $self, $value ) = @_;
	$self->{_hardwareLparEffLoader} = $value if defined($value);
	return ( $self->{_hardwareLparEffLoader} );
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

