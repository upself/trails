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
  _config => Config::Properties::Simple->new(
   file => '/opt/staging/v2/config/connectionConfig.txt'
  ),
  _api    => undef,
  _status => undef
 };

 bless $self, $class;
}

sub outOfService {
 my $self = shift;

 my $ua = LWP::UserAgent->new;
 $ua->timeout(30);
 $ua->env_proxy;
 $ua->max_redirect(0);

 my $request  = HTTP::Request->new( GET => $self->api );
 my $response = $ua->request($request);

 my $code        = $response->code;
 my $serverError = '^5\d\d$';

 if ( $code =~ $serverError ) {

  #server error occured.
  return 1;
 }

 return 0;
}

sub status {
 my $self = shift;
 $self->{_status} = shift if scalar @_ == 1;
 return $self->{_status};
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
 $ua->timeout(30);
 $ua->env_proxy;

 my $uri = $self->assembleURI;
 dlog(" GET $uri");
 my $response = $ua->get($uri);

 my $result = undef;
 if ( $response->is_success ) {
  my $json = new JSON;
  try {
   local $SIG{__DIE__};    # No sigdie handler
   my $jsObj = $json->decode( $response->decoded_content );

   $result = $self->parseJson($jsObj)
     if ( $self->validateJsonFeedback($jsObj) );

   $self->status('SUCCESS');
    }
    catch {
   wlog('no data found.');
   $self->status('ERROR');
    };
 }
 else {
  $self->status('ERROR');
  elog(
   'scarlet requesting failed: ' . $response->status_line . ' uri=' . $uri );

  my $code = $response->code;    
  if ( $code >= 500 ) {
   elog( $response->content . ' uri=' . $uri );
  }
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
