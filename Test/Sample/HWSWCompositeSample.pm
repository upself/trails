package Sample::HWSWCompositeSample;

use strict;
use BRAVO::OM::HardwareSoftwareComposite;

use Test::Sample::BaseSample;

our @ISA = qw(Sample::BaseSample);

sub buildModel {
	my $self = shift;

	my $hwSwCompoiste = new BRAVO::OM::HardwareSoftwareComposite;
	$hwSwCompoiste->hardwareLparId( $self->hardwareLparId );
	$hwSwCompoiste->softwareLparId( $self->softwareLparId );
	if ( !defined $self->matchMethod ) {
		$self->matchMethod('EXT_ID');
	}
	$hwSwCompoiste->matchMethod( $self->matchMethod );
	$hwSwCompoiste->action('UPDATE');

	$self->model($hwSwCompoiste);
}
#super called.
sub getDeleteQuery {
	return 'delete from hw_sw_composite where id=?';
}

sub hardwareLparId {
	my $self = shift;
	if (@_) { $self->{_hardwareLparId} = shift }
	return $self->{_hardwareLparId};
}

sub softwareLparId {
	my $self = shift;
	if (@_) { $self->{_softwareLparId} = shift }
	return $self->{_softwareLparId};
}

sub matchMethod {
	my $self = shift;
	if (@_) { $self->{_matchMethod} = shift }
	return $self->{_matchMethod};
}


sub exist{
	my $self = shift;
    $self->model->softwareLparId(undef);
    $self->model->getById( $self->connection );

    return defined $self->model->softwareLparId;
}
