package Scarlet::GuidEndpoint;

use strict;
use Base::Utils;
use URI;
use Scarlet::ScarletEndpoint;

our @ISA = qw(Scarlet::ScarletEndpoint);

sub new {
 my ($class) = @_;
 my $self = $class->SUPER::new();

 $self->{_api}      = $self->config->getProperty('scarlet.guids');
 $self->{_extSrcId} = undef;

 
 bless $self, $class;
}

sub extSrcId {
 my $self = shift;
 $self->{_extSrcId} = shift if scalar @_ == 1;
 return $self->{_extSrcId};
}

sub httpGet {
 my ( $self, $swcmId ) = @_;

 $self->extSrcId($swcmId);
 $self->SUPER::httpGet;

}

sub assembleURI {
 my $self = shift;

 my $uri = URI->new( $self->api );
 $uri->query_form( 'licenseId' => $self->extSrcId );
 return $uri;
}

sub validateJsonFeedback {
 my ( $self, $jsonObj ) = @_;

 if ( defined $jsonObj->{'guids'} ) {
  return 1;
 }
 else {
  return 0;
 }
}

sub parseJson {
 my ( $self, $jsonObj ) = @_;

 my $guids = $jsonObj->{'guids'};
 return $guids;
}

1;
