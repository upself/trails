package integration::reconEngine::TestLogScarletBuilt;

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
  qr{license\(s\) found from scarlet},
  'check log - fetch license from scarlet'
 );

 file_contains_like(
  $self->logFile,
  qr{scarlet reconcile built},
  'check log - scarlet reconcile built'
 );
}

1;

