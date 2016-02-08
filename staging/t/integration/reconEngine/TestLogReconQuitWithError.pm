package integration::reconEngine::TestLogReconQuitWithError;

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
  qr{returning to caller},
  $self->label . ', check log - return to caller'
 );
 file_contains_like( $self->logFile, qr{ERROR},
  $self->label . ', check log - no error' );    
}

1;

