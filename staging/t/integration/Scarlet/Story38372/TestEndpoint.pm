package integration::Scarlet::Story38372::TestEndpoint;

use base qw(Test::Class);

use strict;
use Test::More;

use integration::TestUtils;

use Scarlet::GuidEndpoint;

sub _01_checkOutOfService : Test(2) {
 my $self = shift;

 my $file       = '/opt/staging/v2/config/connectionConfig.txt';
 my $key        = 'scarlet.guids';
 my $validURI   = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/guids';
 my $invalidURI = 'http://prodpcrdsherlk3.w3-969.ibm.err:9100/guids';

 integration::TestUtils->changeProperty( $file, $key, $invalidURI );
 my $endpoint = Scarlet::GuidEndpoint->new();

 ok( $endpoint->outOfService eq 1, 'scarlet out of service' );

 integration::TestUtils->changeProperty( $file, $key, $validURI );
 $endpoint = Scarlet::GuidEndpoint->new();

 ok( $endpoint->outOfService eq 0, 'scarlet in service' );

}

1;

