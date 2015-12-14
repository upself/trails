package Scarlet::ScarletEndpoint;

use strict;
use Base::Utils;
use Carp qw( croak );
use LWP::UserAgent;
use URI;
use JSON;
use Config::Properties::Simple;
use Try::Tiny;

sub new {
 my ($class) = @_;
 my $self = {
  _outOfService => 1,
  _config       => Config::Properties::Simple->new(
   file => '/opt/staging/v2/config/connectionConfig.txt'
  ),
  _api => undef
 };

 bless $self, $class;
}

sub outOfService {
 my $self = shift;
 $self->{_outOfService} = shift if scalar @_ == 1;
 return $self->{_outOfService};
}

sub config {
 my $self = shift;
 $self->{_config} = shift if scalar @_ == 1;
 return $self->{_config};
}

sub api {
 my $self = shift;
 $self->{_api} = shift if scalar @_ == 1;
 return $self->{_api};
}

sub convertArrayToHash {
 my ( $self, $array ) = @_;

 my $hash = {};
 foreach my $i ( @{$array} ) {
  $hash->{$i} = 1;
 }
 return $hash;
}

sub httpGet {
 my $self = shift;

 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
 $ua->env_proxy;

 my $uri = $self->assembleURI;
 dlog("GET $uri");
 my $response = $ua->get($uri);

 my $result = undef;
 if ( $response->is_success ) {
  $self->outOfService(0);
  my $json = new JSON;
  try {
   local $SIG{__DIE__};    # No sigdie handler
   my $jsObj = $json->decode( $response->decoded_content );

   $result = $self->parseJson($jsObj)
     if ( $self->validateJsonFeedback($jsObj) );

    }
    catch { wlog('no data found.') };
 }
 else {
  $self->outOfService(1);
  wlog( 'scarlet requesting failed: ' . $response->status_line );
 }

 return $result;    
}

sub validateJsonFeedback {
 my ( $self, $jsonObj ) = @_;
 return 0;
}

sub parseJson {
 my ( $self, $jsonObj ) = @_;
}

sub assembleURI {
 return 'need/rewrite/';
}

1;
