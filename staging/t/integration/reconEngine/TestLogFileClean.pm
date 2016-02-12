package integration::reconEngine::TestLogFileClean;

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

 unlink( $self->logFile ) if ( -e $self->logFile );

 file_not_exists_ok( $self->logFile, $self->label . ', log file clean' );

 
}

1;

