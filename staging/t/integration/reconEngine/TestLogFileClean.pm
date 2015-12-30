package integration::reconEngine::TestLogFileClean;

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

 unlink( $self->logFile ) if ( -e $self->logFile );

 file_not_exists_ok( $self->logFile, 'log file clean' );
}

1;

