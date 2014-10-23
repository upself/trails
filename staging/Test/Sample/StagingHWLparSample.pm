package Sample::StagingHWLparSample;

use strict;
use Staging::OM::HardwareLpar;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);

#super called.
sub buildModel {
	my $self = shift;

	my $stagingHWLpar = new Staging::OM::HardwareLpar();
	$stagingHWLpar->name('UTHWLpar');
	$stagingHWLpar->customerId( $self->customerId );
	$stagingHWLpar->hardwareId( $self->hardwareId );
	$stagingHWLpar->status('ACTIVE');
	$stagingHWLpar->action('COMPLETE');
	$stagingHWLpar->updateDate('01/01/1970');
	$stagingHWLpar->extId('A0025519');
	$stagingHWLpar->techImageId('DBKDSSAP1.RZE.DE.DB.COM');

	$self->model($stagingHWLpar);
}

#super called.
sub getDeleteQuery {
	return 'delete from hardware_lpar where id=?';
}

sub customerId {
	my $self = shift;
	if (@_) { $self->{_customerId} = shift }
	return $self->{_customerId};
}

sub hardwareId{
	my $self = shift;
    if (@_) { $self->{_hardwareId} = shift }
    return $self->{_hardwareId};
}

1;
