package Scarlet::TestSkuEndpoint;

use strict;
use Base::Utils;
use base qw(Test::Class
  integration::ScarletAPIManager);
use Scarlet::SkuEndpoint;
use Test::More;

sub testSkuHttpGet : Test(2) {
 my $self = shift;

 $self->mockLicenseAPI();

 my $endpoint = Scarlet::SkuEndpoint->new;
 my $skus     = $endpoint->httpGet( 35400, '48cf4c5bfb5a46eb9f71bf8bcb14f47d' );

 is( $endpoint->status, 'SUCCESS', 'status success' );
 ok( defined $skus, 'skus defined' );
}

sub validateData : Test(3) {
 my $self = shift;

 $self->mockLicenseAPI();

 my $endpoint = Scarlet::SkuEndpoint->new;
 my $skus     = $endpoint->httpGet( 35400, '48cf4c5bfb5a46eb9f71bf8bcb14f47d' );

 is( scalar @{$skus}, 2, '2 sku found' );
 is( $skus->[1]->{licenseIds}->[0], 860683, 'license correct' );
 is(
  $skus->[1]->{guids}->[1],
  '1c27c0a7a3304ad89eb03621556ddf60',
  'guid correct'    
 );
}

sub teardown : Test(shutdown) {
 my $self = shift;
 $self->resetLicenseAPI;
}

1;
