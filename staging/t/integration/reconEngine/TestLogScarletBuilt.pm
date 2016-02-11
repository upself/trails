package integration::reconEngine::TestLogScarletBuilt;

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

 file_contains_like(
  $self->logFile,
  qr{license\(s\) found from scarlet},
  $self->label . ', check log - fetch license from scarlet'
 );

 file_contains_like(
  $self->logFile,
  qr{scarlet reconcile built},
  $self->label . ', check log - scarlet reconcile built'    
 );
}

1;

