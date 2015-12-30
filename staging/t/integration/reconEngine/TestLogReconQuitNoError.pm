package integration::reconEngine::TestLogReconQuitNoError;

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
  qr{returning to caller},
  'check log - return to caller'
 );
 file_contains_unlike( $self->logFile, qr{ERROR}, 'check log - no error' )
   ;    
}

1;

