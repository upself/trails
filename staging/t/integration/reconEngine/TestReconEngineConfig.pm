package integration::reconEngine::TestReconEngineConfig;

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

 file_contains_like( $self->reconConfigFile, qr{testMode\s*=\s*0},
  'check recon engine config - testMode=0' );
 file_contains_like( $self->reconConfigFile, qr{debugLevel\s*=\s*debug},
  'check recon engine config - debugLevel=debug' );

}

1;

