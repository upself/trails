package integration::ScarletAPIManager;

use strict;
use base qw(integration::TestUtils);

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

sub mokeGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://localhost:8080/springrest/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub mokeEmptyGuidAPI {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://localhost:8080/springrest/empty/guid';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );
}

sub resetGuid {
 my $self = shift;

 my $file = $self->{connectionFile};
 my $api  = 'http://prodpcrdsherlk3.w3-969.ibm.com:9100/guids';
 $self->changeFileProperty( $file, 'scarlet.guids', $api );    
}

1;
