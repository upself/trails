package integration::TestUtils;

use strict;
use Config::Properties;

sub changeProperty {
 my ( $self, $file, $key, $value ) = @_;

 open my $fileRead, '<', $file
   or die "unable to open configuration file";

 my $properties = Config::Properties->new();
 $properties->load($fileRead);
 $properties->changeProperty( $key, $value );
 close $fileRead;

 open my $fh, '>', $file
   or die 'unable to open file for writing';
 $properties->format('%s=%s');
 $properties->store($fh);
 close $fh;
}
1;    
