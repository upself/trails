package integration::ScarletAPIManager;

use strict;
use base qw(
  integration::TestUtils
  integration::MockWebService
);

sub setParentOutOfService {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.err:9300/guids';
 $self->changeFileProperty( $file, 'scarlet.guids.parents', $api );
}

sub resetParent {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.com:9300/guids';
 $self->changeFileProperty( $file, 'scarlet.guids.parents', $api );
}

sub setGuidOutOfService {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.err:9100/guids';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub mockGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = $self->serviceURI . '/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub mockEmptyGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = $self->serviceURI . '/empty/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub resetGuid {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/guids';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub setGuid400 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus400 );
}

sub setGuid404 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus404 );
}

sub setGuid500 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus500 );
}

sub setGuid501 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus501 );
}

sub setGuid502 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus502 );
}

sub setGuid503 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus503 );
}

sub setGuid504 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus504 );
}

sub setGuid505 {
 my $self = shift;

 my $file = $self->{connectionFile};
 $self->changeFileProperty( $file, 'scarlet.guids', $self->mockStatus505 );
}    

1;
