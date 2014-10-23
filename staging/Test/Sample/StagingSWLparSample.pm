package Sample::StagingSWLparSample;

use strict;
use Staging::OM::SoftwareLpar;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);
#super called.
sub buildModel {
	my $self                = shift;
	my $stagingSoftwareLpar = new Staging::OM::SoftwareLpar;

	$stagingSoftwareLpar->customerId( $self->customerId );
	$stagingSoftwareLpar->name('UTParName');
	$stagingSoftwareLpar->processorCount(2);
	$stagingSoftwareLpar->scanTime('2007-11-19-10.50.42.000000');
	$stagingSoftwareLpar->extId('UNKNOWN');
	$stagingSoftwareLpar->status('ACTIVE');
	$stagingSoftwareLpar->action('COMPLETE');
	$stagingSoftwareLpar->computerId('39780.TAP.RALEIGH.IBM.COM');
	$stagingSoftwareLpar->objectId('39780');

	$self->model($stagingSoftwareLpar);
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

1;
