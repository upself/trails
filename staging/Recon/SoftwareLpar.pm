package Recon::SoftwareLpar;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::Lpar;
use Recon::AlertSoftwareLpar;
use Recon::AlertExpiredScan;
use Recon::AlertZeroProcessorCount;
use Recon::AlertInvalidScanTime;
use Recon::AlertNoOperatingSystem;
use Recon::AlertNoInstalledSoftware;
use Recon::AlertNoLicensableProduct;
use Recon::AlertNoCustomer;

sub new {
	my ( $class, $connection, $softwareLpar, $action ) = @_;
	my $self = {
		_connection   => $connection,
		_softwareLpar => $softwareLpar,
		_action       => $action,
		_reconDeep    => 0
	};
	bless $self, $class;

	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Connection is undefined'
	  unless defined $self->connection;

	croak 'Hardware Lpar is undefined'
	  unless defined $self->softwareLpar;
}

sub recon {
	my $self = shift;

	ilog("Entering recon method of SoftwareLpar");
	ilog( $self->softwareLpar->toString );

	###Create recon lpar object
	my $reconLpar = new Recon::Lpar();

	###Set the database connection
	$reconLpar->connection( $self->connection );

	###Set the software lpar
	$reconLpar->softwareLpar( $self->softwareLpar );

	if ( defined $self->action &&(
	    $self->action eq 'OS'
		|| $self->action eq 'SW'
		|| $self->action eq 'LICENSABLE'))
	{
		ilog("Only performing alertLogic if action = OS or SW or LICENSABLE");
		$self->alertLogic( undef, $self->action );
		ilog("alertLogic for OS or SW or LICENSABLE complete");
	}
	else {
		###Call the recon method of the recon lpar object
		ilog("Performing recon");
		$reconLpar->recon;
		ilog("Recon complete");

		$self->reconDeep( $reconLpar->reconDeep )
		  if ( $self->reconDeep != 1 );

		$self->reconDeep(1) if ( defined $self->action && $self->action eq 'DEEP' );

		###Run the alert logic
		$self->alertLogic( $reconLpar->hardwareLpar, $self->action );

		###Call recon on items we have designated to reconcile from the recon logic
		ilog("Performing additional reconciliations");
		$reconLpar->performAdditionalRecons;
		ilog("Additional reconciliations complete");

		###Call recon on the installed softwares object
		$self->addInstalledSoftwareToQueue if $self->reconDeep == 1;
	}
	ilog("Recon complete");
}

sub alertLogic {
	my ( $self, $hardwareLpar, $action ) = @_;
	ilog("Performing alert logic");
	my $alert;
	
	$action='' 
	   if !defined $self->action;
	if ( $action eq 'OS' ) {
		$alert =
		  Recon::AlertNoOperatingSystem->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;
	}
	elsif ( $action eq 'SW' ) {
		$alert =
		  Recon::AlertNoInstalledSoftware->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;
	}
	elsif ( $action eq 'LICENSABLE' ) {
		$alert =
		  Recon::AlertNoLicensableProduct->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;
	}
	else {
		$alert =
		  Recon::AlertSoftwareLpar->new( $self->connection, $self->softwareLpar,
			$hardwareLpar );
		$alert->recon;

		$alert =
		  Recon::AlertInvalidScanTime->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;
		my $isValidScantime = $alert->isValidScantime();

		$alert =
		  Recon::AlertExpiredScan->new( $self->connection, $self->softwareLpar,
			$isValidScantime );
		$alert->recon;

		$alert =
		  Recon::AlertZeroProcessorCount->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;

		$alert =
		  Recon::AlertNoOperatingSystem->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;

		$alert =
		  Recon::AlertNoInstalledSoftware->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;

		$alert =
		  Recon::AlertNoLicensableProduct->new( $self->connection,
			$self->softwareLpar );
		$alert->recon;
		
		$alert =
          Recon::AlertNoCustomer->new( $self->connection,
            $self->softwareLpar );
        $alert->recon;
	}
	ilog("Alert logic complete");
}

sub addInstalledSoftwareToQueue {
	my $self = shift;
	dlog("begin reconSoftwareLpar");

	dlog("calling recon on inst sw for this sw lpar");
	my @ids =
	  BRAVO::Delegate::BRAVODelegate->getInstalledSoftwareIdsBySwLparId(
		$self->connection, $self->softwareLpar->id );
	my $total = scalar @ids;
	my $count = 0;
	foreach my $id (@ids) {
		$count++;
		my $installedSoftware = new BRAVO::OM::InstalledSoftware();
		$installedSoftware->id($id);
		my $queue =
		  Recon::Queue->new( $self->connection, $installedSoftware,
			$self->softwareLpar, 'UPDATE' );
		$queue->add;
		dlog("reconed $count of $total inst sw records for this sw lpar");
	}

	###Return to caller.
	dlog("end reconSoftwareLpar");
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

sub softwareLpar {
	my $self = shift;
	$self->{_softwareLpar} = shift if scalar @_ == 1;
	return $self->{_softwareLpar};
}

sub reconDeep {
	my $self = shift;
	$self->{_reconDeep} = shift if scalar @_ == 1;
	return $self->{_reconDeep};
}

sub action {
	my $self = shift;
	$self->{_action} = shift if scalar @_ == 1;
	return $self->{_action};
}

1;
