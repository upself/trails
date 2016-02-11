package integration::ScarletAPIManager;

use strict;
use base qw(
  integration::TestUtils
  integration::MockWebService
);

sub connectionFile {
 my $self = shift;
 my $file = shift;

 $self->{connectionFile} = $file
   if defined $file;

 if ( !defined $self->{connectionFile} ) {
  $self->{connectionFile} = '/opt/staging/v2/config/connectionConfig.txt';
 }

 return $self->{connectionFile};
}

##parent api
sub setParentOutOfService {
 my $self = shift;

 my $api = 'http://prodpcrdsherlk3.w3-969.ibm.err:9300/guids';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids.parents',
  $api );
}

sub resetParent {
 my $self = shift;

 my $api = 'http://prodpcrdsherlk3.w3-969.ibm.com:9300/guids';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids.parents',
  $api );
}

#license api.
sub resetLicenseAPI {
 my $self = shift;

 my $api = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/licenses';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.license', $api );
}

sub mockLicenseAPI {
 my $self = shift;

 my $api = $self->serviceURI . '/license';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.license', $api );
}

sub setLicenseAPIInvalid {
 my $self = shift;

 my $api = $self->serviceURI . '/license/invalid';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.license', $api );
}

#guid api.
sub setGuidOutOfService {
 my $self = shift;

 my $api = 'http://prodpcrdsherlk3.w3-969.ibm.err:9100/guids';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids', $api );
}

sub mockGuidAPI {
 my $self = shift;

 my $api = $self->serviceURI . '/guid';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids', $api );
}

sub mockEmptyGuidAPI {
 my $self = shift;

 my $api = $self->serviceURI . '/empty/guid';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids', $api );
}

sub resetGuid {
 my $self = shift;

 my $api = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/guids';
 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids', $api );
}

sub setGuid400 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus400 );
}

sub setGuid404 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus404 );
}

sub setGuid500 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus500 );
}

sub setGuid501 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus501 );
}

sub setGuid502 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus502 );
}

sub setGuid503 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus503 );
}

sub setGuid504 {
 my $self = shift;

 $self->changeFileProperty(
  $self->connectionFile, 'scarlet.guids',    
  $self->mockStatus504
 );
}

sub setGuid505 {
 my $self = shift;

 $self->changeFileProperty( $self->connectionFile, 'scarlet.guids',
  $self->mockStatus505 );
}

1;
