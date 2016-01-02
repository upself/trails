package integration::Scarlet::Story38372::TestEndpoint;

use base qw(Test::Class integration::ScarletAPIManager);

use strict;
use Test::More;

use Scarlet::GuidEndpoint;

sub _startup : Test(startup) {
 my $self  = shift;
 my $class = ref($self);
 diag("---start of $class---");
}

sub _01_checkOutOfService : Test(2) {
 my $self = shift;

 $self->{connectionFile} = '/opt/staging/v2/config/connectionConfig.txt';

 $self->setGuidOutOfService;
 my $endpoint = Scarlet::GuidEndpoint->new();
 ok( $endpoint->outOfService eq 1, 'scarlet out of service' );

 $self->resetGuid;
 $endpoint = Scarlet::GuidEndpoint->new();
 ok( $endpoint->outOfService eq 0, 'scarlet in service' );

}

1;

