package integration::reconEngine::TestLogScarletSoftwareMap;

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
  qr{begin validateLicenseSoftwareMap},
  $self->label . ', check log - begin validateLicenseSoftwareMap'
 );

 file_contains_like(
  $self->logFile,
  qr{software not match but in scarlet reconcile},
  $self->label .    
    ', check log - software not match but in scarlet reconcile'
 );
}

1;

