package Scarlet::LicenseEndPoint;

use strict;
use Base::Utils;
use URI;
use Scarlet::ScarletEndpoint;

our @ISA = qw(ScarletEndpoint);

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

 $self->SUPER::httpGet;

}

sub assembleURI {
 my ($self) = @_;

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
  && ( $jsonObj->{'match'} eq 'true' )
  && ( defined $jsonObj->{'skus'} )
  && ( scalar @{ $jsonObj->{'skus'} } >= 1 ) )
 {
  return 1;
 }

 return 0;
}

sub parseJson {
 my ( $self, $jsonObj ) = @_;

 my $skus      = $jsonObj->{'skus'};
 my $licenseId = [];

 foreach my $s ( @{$skus} ) {
  push @{$licenseId}, $s->{'licenseIds'};    
 }

 return $licenseId;
}

1;
