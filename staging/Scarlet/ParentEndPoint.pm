package Scarlet::ParentEndpoint;

use strict;
use Base::Utils;
use URI;

our @ISA = qw(ScarletEndpoint);

sub new {
 my ($class) = @_;
 my $self = $class->SUPER::new();

 $self->{_api}  = $self->config->getProperty('scarlet.guids.parents');
 $self->{_guid} = undef;

 bless $self, $class;
}

sub guid {
 my $self = shift;
 $self->{_guid} = shift if scalar @_ == 1;
 return $self->{_guid};
}

sub httpGet {
 my ( $self, $guid ) = @_;
 $self->guid = $guid;

 $self->SUPER::httpGet;
}

sub assembleURI {
 my ($self) = @_;

 my $uri = URI->new( $self->api . "/" . $self->guid . "/parents" );
 dlog("GET $uri");
 return $uri;
}

sub validateJsonFeedback {
 my ( $self, $jsonObj ) = @_;

 if ( defined $jsonObj->{'parents'} ) {
  return 1;
 }
 else {
  return 0;
 }
}

sub parseJson {
 my ( $self, $jsonObj ) = @_;

 my $guids = $jsonObj->{'parents'};    
 return $guids;
}

1;
