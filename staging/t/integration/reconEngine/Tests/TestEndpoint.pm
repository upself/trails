package integration::reconEngine::Tests::TestEndpoint;

use base qw(
  Test::Class
  integration::ScarletAPIManager
  integration::LogManager
);

use strict;
use Test::More;
use Test::File;

use Scarlet::GuidEndpoint;


sub setupLog : Test(startup) {
 my $self = shift;

 $self->{logFile} = '/tmp/testEndpoint.txt';
 $self->configDebugLevel( $self->{logFile} );

 $self->{connectionFile} = '/opt/staging/v2/config/connectionConfig.txt';
}

sub shutdown : Test(shutdown) {
 my $self = shift;

 $self->resetGuid;
 $self->deleteLogFile;
}

sub cleanLogFile : Test(setup) {
 my $self = shift;
 $self->deleteLogFile;
}

sub story38372_checkOutOfService : Test(2) {
 my $self = shift;

 $self->setGuidOutOfService;
 my $endpoint = Scarlet::GuidEndpoint->new();
 ok( $endpoint->outOfService eq 1, 'scarlet out of service' );

 $self->resetGuid;
 $endpoint = Scarlet::GuidEndpoint->new();
 ok( $endpoint->outOfService eq 0, 'scarlet in service' );

}

sub story38636_http400 : Test(1) {
 my $self = shift;

 $self->setGuid400;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('400 Bad Request');
}

sub story38636_http404 : Test(1) {
 my $self = shift;

 $self->setGuid404;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('404 Not Found');
}

sub story38636_http500 : Test(1) {
 my $self = shift;

 $self->setGuid500;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('500 Internal Server Error');
}

sub story38636_http501 : Test(1) {
 my $self = shift;

 $self->setGuid501;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('501 Not Implemented');
}

sub story38636_http502 : Test(1) {
 my $self = shift;

 $self->setGuid502;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('502 Bad Gateway');
}

sub story38636_http503 : Test(1) {
 my $self = shift;

 $self->setGuid503;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('503 Service Unavailable');
}

sub story38636_http504 : Test(1) {
 my $self = shift;

 $self->setGuid504;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('504 Gateway Timeout');
}

sub story38636_http505 : Test(1) {
 my $self = shift;

 $self->setGuid505;
 my $endpoint = Scarlet::GuidEndpoint->new();
 $endpoint->httpGet(999999);

 $self->checkLog('505 HTTP Version Not Supported');
}

sub checkLog {
 my $self    = shift;
 my $pattern = shift;

 file_contains_like( $self->{logFile}, qr{$pattern},
  'check log - ' . $pattern );
}

sub deleteLogFile {
 my $self = shift;
 unlink( $self->{logFile} ) if ( -e $self->{logFile} );
}

1;

