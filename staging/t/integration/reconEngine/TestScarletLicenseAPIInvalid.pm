package integration::reconEngine::TestScarletLicenseAPIInvalid;

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

 
 file_contains_like( $self->connCfgFile, qr{scarlet.license.*invalid},
  'check connection config - license api set to invalid' );
}

1;

