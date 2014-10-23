package Sample::StagingHWSample;

use strict;
use Staging::OM::Hardware;
use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);
#super called.
sub buildModel {
	my $self = shift;

	my $stagingHW = new Staging::OM::Hardware();
	$stagingHW->machineTypeId(1764);
	$stagingHW->serial('UTSerial');
	$stagingHW->country('BR');
	$stagingHW->owner('IBM');
	$stagingHW->customerNumber('81310XX');
	$stagingHW->hardwareStatus('HWCOUNT');
	$stagingHW->status('ACTIVE');
	$stagingHW->updateDate('10/22/2009');
	$stagingHW->action('COMPLETE');
	$stagingHW->customerId(7130);
	$stagingHW->processorCount(2);
	$stagingHW->model('UTModel');
	$stagingHW->classification('OEM SERVER');
	$stagingHW->chips(10);
	$stagingHW->processorType('0');

	$self->model($stagingHW);
}
#super called.
sub getDeleteQuery {
	return 'delete from hardware where id=?';
}
