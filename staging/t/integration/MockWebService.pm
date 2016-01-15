package integration::MockWebService;

use strict;

sub serviceURI {
 return 'http://lexbz181197.cloud.dst.ibm.com:9001/springrest';
}

sub mockStatus400 {
 my $self = shift;
 return $self->serviceURI . '/status/400';
}

sub mockStatus404 {
 my $self = shift;
 return $self->serviceURI . '/status/404';
}

sub mockStatus500 {
 my $self = shift;
 return $self->serviceURI . '/status/500';
}

sub mockStatus501 {
 my $self = shift;
 return $self->serviceURI . '/status/501';
}

sub mockStatus502 {
 my $self = shift;
 return $self->serviceURI . '/status/502';
}

sub mockStatus503 {
 my $self = shift;
 return $self->serviceURI . '/status/503';
}

sub mockStatus504 {
 my $self = shift;
 return $self->serviceURI . '/status/504';
}

sub mockStatus505 {
 my $self = shift;    
 return $self->serviceURI . '/status/505';
}

1;
