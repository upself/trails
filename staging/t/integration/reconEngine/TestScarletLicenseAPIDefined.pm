package integration::reconEngine::TestScarletLicenseAPIDefined;

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
  $self->connCfgFile,    
  qr{scarlet\.license\s*=\s*http},
  'check connection config - scarlet license api defined'
 );
}

1;

