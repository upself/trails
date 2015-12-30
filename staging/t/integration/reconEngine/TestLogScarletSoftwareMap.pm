package integration::reconEngine::TestLogScarletSoftwareMap;

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
  qr{begin validateLicenseSoftwareMap},
  'check log - begin validateLicenseSoftwareMap'
 );

 file_contains_like(
  $self->logFile,
  qr{software not match but in scarlet reconcile},
  'check log - software not match but in scarlet reconcile'
 );
}

1;

