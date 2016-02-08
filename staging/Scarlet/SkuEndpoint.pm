package Scarlet::SkuEndpoint;

use strict;
use Base::Utils;
use URI;
use Scarlet::ScarletEndpoint;

our @ISA = qw(Scarlet::ScarletEndpoint);

sub new {
 my ($class) = @_;
 my $self = $class->SUPER::new();

 $self->{_api}       = $self->config->getProperty('scarlet.license');
 $self->{_accountNo} = undef;
 $self->{_guid}      = undef;

 bless $self, $class;
}

sub accountNo {
 my $self = shift;
 $self->{_accountNo} = shift if scalar @_ == 1;
 return $self->{_accountNo};
}

sub guid {
 my $self = shift;
 $self->{_guid} = shift if scalar @_ == 1;
 return $self->{_guid};
}

sub httpGet {
 my ( $self, $accountNo, $guid ) = @_;
 $self->accountNo($accountNo);
 $self->guid($guid);

 dlog("call super http get");    
 return $self->SUPER::httpGet;
}

sub assembleURI {
 my $self = shift;

 my $uri = URI->new( $self->api );
 $uri->query_form(
  'account' => $self->accountNo,
  'guid'    => $self->guid
 );

 return $uri;
}

sub validateJsonFeedback {
 my ( $self, $jsonObj ) = @_;

 if (( defined $jsonObj->{'match'} )
  && ( $jsonObj->{'match'} eq 'true' || $jsonObj->{'match'} == 1 )
  && ( defined $jsonObj->{'skus'} )
  && ( scalar @{ $jsonObj->{'skus'} } >= 1 ) )
 {
  dlog('sku json looks good.');
  return 1;
 }

 dlog('somthing wrong with the license json feedback.');
 return 0;
}

sub parseJson {
 my ( $self, $jsonObj ) = @_;

 my $skus = $jsonObj->{'skus'};
 dlog( ( defined $skus ? scalar @{$skus} : 0 ) . ' sku(s) found.' );

 return $skus;
}

1;
