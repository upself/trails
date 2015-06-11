package Recon::ScarletInstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use LWP::UserAgent;
use URI;
use JSON;
use Recon::InstalledSoftware;
use Database::Connection;

sub new {
 my ( $class, $reconcileTypeId, $machineLevel, $allocMethodId ) = @_;
 my $self = {
  _connection      => Database::Connection->new('trails'),
  _extSrcIds       => [],
  _guids           => {},
  _usedLicenses    => [],
  _reconcileTypeId => $reconcileTypeId,
  _machineLevel    => $machineLevel,
  _allocMethodId   => $allocMethodId
 };
 bless $self, $class;

 return $self;
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub extSrcIds {
 my $self = shift;
 $self->{_extSrcIds} = shift if scalar @_ == 1;
 return $self->{_extSrcIds};
}

sub guids {
 my $self = shift;
 $self->{_guids} = shift if scalar @_ == 1;
 return $self->{_guids};
}

sub usedLicenses {
 my $self = shift;
 $self->{_usedLicenses} = shift if scalar @_ == 1;
 return $self->{_usedLicenses};
}

sub reconcileTypeId {
 my $self = shift;
 $self->{_reconcileTypeId} = shift if scalar @_ == 1;
 return $self->{_reconcileTypeId};
}

sub machineLevel {
 my $self = shift;
 $self->{_machineLevel} = shift if scalar @_ == 1;
 return $self->{_machineLevel};
}

sub allocMethodId {
 my $self = shift;
 $self->{_allocMethodId} = shift if scalar @_ == 1;
 return $self->{_allocMethodId};
}

sub appendData {

 my ( $self, $freePoollData, $licenseId, $usedLicense ) = @_;

 my $extSrcId;
 if ( defined $freePoollData ) {
  $extSrcId = $freePoollData->{$licenseId}->extSrcId();
 }
 else {

  #it's machine level there's no free pool data constructed.
  my $license = new BRAVO::OM::License();
  $license->id($licenseId);
  $license->getById( $self->connection );
  dlog( "license=" . $license->toString() );
  $extSrcId = $license->extSrcId();
 }

 push @{ $self->extSrcIds },    $extSrcId;
 push @{ $self->usedLicenses }, $usedLicense;
}

sub httpGetGuids {

 my ( $self, $guid ) = @_;

 my $scarletGuidsApi = "http://lexbz180075.cloud.dst.ibm.com:13080/guids";

 foreach my $extSrcId ( @{ $self->extSrcIds } ) {

  my $uri = URI->new($scarletGuidsApi);
  $uri->query_form(
   'componentGuid' => $guid,
   'licenseId'     => $extSrcId
  );

  my $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  $ua->env_proxy;

  my $response = $ua->get($uri);

  my $scarletGuids = [];
  if ( $response->is_success ) {
   my $json  = new JSON;
   my $jsObj = $json->decode( $response->decoded_content );
   $scarletGuids = $jsObj->{'guids'} if ( defined $jsObj->{'guids'} );
  }
  else {
   die $response->status_line;
  }

  foreach my $guid ( @{$scarletGuids} ) {
   $self->guids->{$guid} = 1;
  }

 }
}

sub tryToReconcile {

 my ($self) = @_;

 #TODO.
 my $softwareLparId;
 my $installedSoftwareId;
 my $guids;

 my $query = 'select is.id 
from 
alert_unlicensed_sw aus, 
installed_software is, 
kb_definition kbd
where aus.installed_software_id = is.id
and is.software_id = kbd.id
and aus.open =1
and is.software_lpar_id = ' . $softwareLparId . '
and is.id != ' . $installedSoftwareId . '
and kbd.guid in (' . $guids . ')
with ur';

 dlog( 'getInstalledSoftwareIdQuery=' . $query );

 my $installedSwId;
 $self->connection->prepareSqlQuery( 'getInstalledSoftwareIdQuery', $query );
 my $sth = $self->connection->sql->{getInstalledSoftwareIdQuery};
 $sth->bind_columns( \$installedSwId );
 $sth->execute();

 my @isIds;
 while ( $sth->fetchrow_arrayref ) {
  push @isIds, $installedSwId;
 }

 $sth->finish;

 foreach my $isId (@isIds) {
  my $installedSoftware =
    new Recon::InstalledSoftware( $self->connection, $isId, 0 );

  #reuse the validate of installed software to check if it's in scope.
  my $validation = $installedSoftware->validateScope();

  #validate code 1, in scope installed software without any reconcile.
  if ( $validation->validationCode == 1 ) {

   my $reconcile =
     $installedSoftware->createReconcile( $self->reconcileTypeId,
    $self->machineLevel, $isId, $self->allocMethodId );

   foreach my $ulId ( @{ $self->usedLicenses } ) {
    $installedSoftware->createReconcileUsedLicenseMap( $reconcile, $ulId );
   }

   $installedSoftware->closeAlertUnlicensedSoftware(1);

  }
 }

}
