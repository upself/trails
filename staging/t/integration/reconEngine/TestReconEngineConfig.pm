package integration::reconEngine::TestReconEngineConfig;

use strict;
use base qw(integration::reconEngine::Properties);

use Test::File;
use Test::More;

sub new {
 my ( $class, $properties, $label ) = @_;

 my $self = $class->SUPER::new($properties);
 $self->{_label} = $label;

 bless $self, $class;
 return $self;

}

sub label {
 my $self = shift;
 $self->{_label} = shift
   if scalar @_ == 1;
 return $self->{_label};
}

sub test {
 my $self = shift;

 file_contains_like( $self->reconConfigFile, qr{testMode\s*=\s*0},
  $self->label . ', check recon engine config - testMode=0' );
 file_contains_like( $self->reconConfigFile, qr{debugLevel\s*=\s*debug},
  $self->label . ', check recon engine config - debugLevel=debug' );   

}

1;

