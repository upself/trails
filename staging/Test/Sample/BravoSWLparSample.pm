package Sample::BravoSWLparSample;

use strict;
use BRAVO::OM::SoftwareLpar;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);

sub buildModel {
	my $self = shift;

	my $bravoSoftwareLpar = new BRAVO::OM::SoftwareLpar;
	$bravoSoftwareLpar->customerId( $self->customerId );
	$bravoSoftwareLpar->name( $self->name );
	$bravoSoftwareLpar->processorCount(2);
	$bravoSoftwareLpar->scanTime('2007-11-19-10.50.42.000000');
	$bravoSoftwareLpar->extId('UNKNOWN');
	$bravoSoftwareLpar->status('ACTIVE');
	$bravoSoftwareLpar->action('COMPLETE');
	$bravoSoftwareLpar->computerId('39780.TAP.RALEIGH.IBM.COM');
	$bravoSoftwareLpar->objectId('39780');
	$bravoSoftwareLpar->remoteUser('STAGING');
	$bravoSoftwareLpar->recordTime('2007-11-19-11.50.42.000000');

	$self->model($bravoSoftwareLpar);
}

#super called.
sub getDeleteQuery {
	return 'delete from software_lpar where id=?';
}

sub customerId {
	my $self = shift;
	if (@_) { $self->{_customerId} = shift }
	return $self->{_customerId};
}

sub name {
	my $self = shift;
	if (@_) { $self->{_name} = shift }
	return $self->{_name};
}
