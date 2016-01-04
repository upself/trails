package integration::reconEngine::TestLogAlertClosed;

use strict;
use base qw(integration::reconEngine::Properties);

use Test::File;
use Test::More;

sub new {
 my ( $class, $properties ) = @_;

 my $self = $class->SUPER::new($properties);

 bless $self, $class;
 return $self;

}

sub test {
 my $self = shift;

 file_contains_like(
  $self->logFile,
  qr{end closeAlertUnlicensedSoftware},
  'check log - alert closed'
 );
}

1;

