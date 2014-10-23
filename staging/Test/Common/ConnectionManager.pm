package Test::Common::ConnectionManager;

use strict;
use Database::Connection;

sub new {
	my ($class) = @_;
	my $self = {};
	bless( $self, $class );
	return $self;
}

sub getBravoConnection {
	return Database::Connection->new('trails');
}

sub getStagingConnection {
	return Database::Connection->new('staging');
}
1;
