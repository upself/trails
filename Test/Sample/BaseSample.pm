package Sample::BaseSample;

use strict;

sub new {
	my ($class) = @_;
	my $self = {
		_model      => undef,
		_connection => undef
	};
	bless( $self, $class );
	return $self;
}

sub connection {
	my $self = shift;
	if (@_) { $self->{_connection} = shift }
	return $self->{_connection};
}

sub model {
	my $self = shift;
	if (@_) { $self->{_model} = shift }
	return $self->{_model};
}

sub remove {
	my $self = shift;
	
	$self->connection->prepareSqlQuery( ( 'remove', $self->getDeleteQuery ) );

	my $sth = $self->connection->sql->{remove};
	$sth->execute( $self->model->id );
	$sth->finish();
}

sub insert {
	my $self = shift;

	if ( defined $self->connection ) {
		if ( !defined $self->model ) {
			$self->buildModel;
		}
		$self->model->save( $self->connection );
	}
}

sub existLightWeight {
	my $self = shift;
	return defined $self->model
	  && defined $self->model->id;
}

sub retrieveModelById {
	my $self = shift;
	$self->model->getById( $self->connection );

	return $self->model;
}

sub exist {
	my $self = shift;
	$self->model->customerId(undef);
	$self->model->getById( $self->connection );

	return defined $self->model->customerId;
}
1;
