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
 my $skus     = $endpoint->httpGet( 35400, '152bff38a573430482bc30f8be9ee1fd' );

 is( $endpoint->status, 'SUCCESS', 'status success' );
 ok( defined $skus, 'skus defined' );
}

sub validateData : Test(3) {
 my $self = shift;

 $self->mockLicenseAPI();

 my $endpoint = Scarlet::SkuEndpoint->new;
 my $skus     = $endpoint->httpGet( 35400, '152bff38a573430482bc30f8be9ee1fd' );

 is( scalar @{$skus}, 3, '3 sku found' );
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
