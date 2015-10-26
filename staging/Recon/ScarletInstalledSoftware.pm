package Recon::ScarletInstalledSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use LWP::UserAgent;
use URI;
use JSON;
use Recon::LicensingInstalledSoftware;
use Database::Connection;
use BRAVO::OM::InstalledSoftware;
use Config::Properties::Simple;
use Try::Tiny;
use Log::Log4perl;
use Log::Log4perl::Level;
use Log::Log4perl::Layout;
use Log::Log4perl::Appender;
use Log::Dispatch::FileRotate;
use Recon::OM::ScarletReconcile;

sub new {
 my ( $class, $reconcileTypeId, $machineLevel, $allocMethodId, $hardwareId ) =
   @_;
 my $self = {
  _connection      => Database::Connection->new('trails'),
  _extSrcIds       => [],
  _guids           => {},
  _usedLicenses    => [],
  _reconcileTypeId => $reconcileTypeId,
  _machineLevel    => $machineLevel,
  _allocMethodId   => $allocMethodId,
  _hardwareId      => $hardwareId,
  _config          => Config::Properties::Simple->new(
   file => '/opt/staging/v2/config/connectionConfig.txt'

  ),
  _cachedParentGuids => {},
  _outOfService      => 0
 };
 bless $self, $class;
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

sub config {
 my $self = shift;
 $self->{_config} = shift if scalar @_ == 1;
 return $self->{_config};
}

sub cachedParentGuids {
 my $self = shift;
 $self->{_cachedParentGuids} = shift if scalar @_ == 1;
 return $self->{_cachedParentGuids};
}

sub hardwareId {
 my $self = shift;
 $self->{_hardwareId} = shift if scalar @_ == 1;
 return $self->{_hardwareId};
}

sub outOfService {
 my $self = shift;
 $self->{_outOfService} = shift if scalar @_ == 1;
 return $self->{_outOfService};
}

sub appendData {

 my ( $self, $freePoollData, $licenseId, $usedLicenseId ) = @_;

 my $extSrcId;
 if ( defined $freePoollData ) {
  dlog('license cached in the free pool');
  $extSrcId = $freePoollData->{$licenseId}->extSrcId();
 }
 else {
  dlog('license not cached, fetching by id');
  my $license = new BRAVO::OM::License();
  $license->id($licenseId);
  $license->getById( $self->connection );
  $extSrcId = $license->extSrcId();
 }
 dlog('scarlet cache data extSrcId= '
    . $extSrcId
    . ' usedLicenseId='
    . $usedLicenseId );

 push @{ $self->extSrcIds },    $extSrcId;
 push @{ $self->usedLicenses }, $usedLicenseId;
}

sub httpGetScarletGuids {
 my ( $self, $uri, $member ) = @_;

 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
 $ua->env_proxy;

 my $response = $ua->get($uri);

 my $scarletGuids = [];
 if ( $response->is_success ) {
  $self->outOfService(0);
  my $json = new JSON;
  try {
   local $SIG{__DIE__};    # No sigdie handler
   my $jsObj = $json->decode( $response->decoded_content );
   $scarletGuids = $jsObj->{$member} if ( defined $jsObj->{$member} );
    }
    catch { wlog('bad json format.') };
 }
 else {
  if ( $response->status_line =~ /500/ ) {
   $self->outOfService(1);
   wlog('http 500 scarlet not accessable');
  }    
  else {
   wlog( 'scarlet requesting failed: ' . $response->status_line );
  }
 }

 return $scarletGuids;
}

sub initByReconcileId {
 my ( $self, $reconcileId ) = @_;

 #set up extSrcIds
 my $query = '
select 
r.reconcile_type_id,
r.machine_level,
r.allocation_methodology_id,
ul.id, 
l.ext_src_id  
from 
RECONCILE r,RECONCILE_USED_LICENSE rul, USED_LICENSE ul, LICENSE l
where
r.id = rul.reconcile_id
and rul.used_license_id = ul.id
and l.id = ul.license_id
and rul.reconcile_id = ?
 ';

 dlog( 'getExtSrcIdsQuery=' . $query );
 my $rTypeId;
 my $mLevel;
 my $allMthdId;
 my $ulId;
 my $extSrcId;
 $self->connection->prepareSqlQuery( 'getExtSrcIdsQuery', $query );
 my $sth = $self->connection->sql->{getExtSrcIdsQuery};
 $sth->bind_columns( \$rTypeId, \$mLevel, \$allMthdId, \$ulId, \$extSrcId );
 $sth->execute($reconcileId);

 while ( $sth->fetchrow_arrayref ) {
  $self->allocMethodId($allMthdId);
  $self->reconcileTypeId($rTypeId);
  $self->machineLevel($mLevel);

  push @{ $self->usedLicenses }, $ulId;
  push @{ $self->extSrcIds },    $extSrcId;
 }
 $sth->finish;
}

sub existInScarlet {
 my ( $self, $reconcileId, $isId ) = @_;

 dlog("existInScarlet reconcileId=$reconcileId,isId=$isId");

 $self->initByReconcileId($reconcileId);
 my $guid = $self->setUpGuidsFromScarlet( $isId, 0 );

 return 1 if ( $self->guids->{$guid} );

 return 0;
}

sub setUpGuidsFromScarlet {

 my ( $self, $installedSoftwareId, $excludeSelf ) = @_;

 my $guid = $self->getGuiIdByInstalledSoftwareId($installedSoftwareId);

 foreach my $extSrcId ( @{ $self->extSrcIds } ) {
  my $swcmLicenseId = undef;
  if ( $extSrcId =~ /SWCM_(\d*)/ ) {
   $swcmLicenseId = $1;
  }
  else {
   dlog('license not from swcm, skip');
   next;
  }

  my $scarletGuidsApi = $self->config->getProperty('scarlet.guids');
  my $uri             = URI->new($scarletGuidsApi);
  $uri->query_form( 'licenseId' => $swcmLicenseId );
  my $scarletGuids = $self->httpGetScarletGuids( $uri, 'guids' );

  dlog("GET $uri");
  dlog( scalar @{$scarletGuids} . ' guid(s) found' );
  foreach my $id ( @{$scarletGuids} ) {
   next if ( $excludeSelf && ( $id eq $guid ) );

   $self->guids->{$id} = 1;
   dlog( 'guid=' . $id );
  }
 }

 $self->traverseUp( [ keys %{ $self->guids } ] );

 return $guid;
}

sub traverseUp {
 my ( $self, $guids ) = @_;

 if ( !defined $guids || scalar @{$guids} <= 0 ) {
  return;
 }

 my $scarletGuidsApi = $self->config->getProperty('scarlet.guids.parents');

 foreach my $id ( @{$guids} ) {

  ###avoid duplicate request to scarlet.
  next
    if ( $self->cachedParentGuids->{$id} );

  $self->cachedParentGuids->{$id} = 1;

  my $uri = URI->new("$scarletGuidsApi/$id/parents");

  my $scarletParentsGuids = $self->httpGetScarletGuids( $uri, 'parents' );

  $self->traverseUp($scarletParentsGuids);

  dlog("GET $uri");
  dlog( scalar @{$scarletParentsGuids} . ' guid(s) found' );
  foreach my $id ( @{$scarletParentsGuids} ) {
   $self->guids->{$id} = 1;
   dlog( 'parentGuid=' . $id );
  }
 }
}

sub getGuiIdByInstalledSoftwareId {
 my ( $self, $installedSoftwareId ) = @_;

 my $query = 'select kbd.guid from kb_definition kbd, installed_software is
	where kbd.id = is.software_id
	and is.id = ?';

 dlog( 'getGuiIdByInstalledSoftwareIdQuery=' . $query );
 my $guid;
 $self->connection->prepareSqlQuery( 'getGuiIdByInstalledSoftwareIdQuery',
  $query );
 my $sth = $self->connection->sql->{getGuiIdByInstalledSoftwareIdQuery};
 $sth->bind_columns( \$guid );
 $sth->execute($installedSoftwareId);
 $sth->fetchrow_arrayref;
 $sth->finish;

 dlog( 'guid=' . $guid );

 return $guid;
}

sub tryToReconcile {

 my ( $self, $isObj ) = @_;

 if ( $self->reconcileTypeId != 5 ) {
  $self->info( 'NOT_AUTO:' . $isObj->toString );
  return;
 }

 #set up guids exclude guid of $isObj.
 $self->setUpGuidsFromScarlet( $isObj->id, 1 );

 my $foundQty = scalar keys %{ $self->guids };
 if ( $foundQty <= 0 ) {
  dlog('no guid found in scarlet');
  return;
 }
 dlog( $foundQty . ' guid found in scarlet' );

 my $counter = 0;
 my $guids;
 foreach my $id ( keys %{ $self->guids } ) {
  $counter++;
  if ( $counter < $foundQty ) {
   $guids .= "'$id',";
  }
  else {
   $guids .= "'$id'";
  }
 }

 my $query = undef;
 if ( $self->machineLevel == 1 ) {
  $query = 'select is.id
from
alert_unlicensed_sw aus, 
installed_software is,
kb_definition kbd,
hw_sw_composite hsc, 
hardware_lpar hl,
hardware h
where aus.installed_software_id = is.id
and is.software_id = kbd.id
and is.software_lpar_id = hsc.software_lpar_id
and hsc.hardware_lpar_id = hl.id
and hl.hardware_id = h.id
and aus.open = 1
and h.id =  ?
and is.id <> ?
and kbd.guid in (' . $guids . ') with ur ';
 }
 else {
  $query = ' select is.id 
from 
alert_unlicensed_sw aus,
installed_software is,
kb_definition kbd 
where aus.installed_software_id = is.id
and is.software_id = kbd.id
and aus.open= 1
and is.software_lpar_id =?
and is.id != ?
and kbd.guid in(' . $guids . ') with ur ';
 }

 dlog( ' getInstalledSoftwareIdQuery = ' . $query );

 my $installedSwId;
 $self->connection->prepareSqlQuery( 'getInstalledSoftwareIdQuery', $query );
 my $sth = $self->connection->sql->{getInstalledSoftwareIdQuery};
 $sth->bind_columns( \$installedSwId );

 if ( $self->machineLevel == 1 ) {
  $sth->execute( $self->hardwareId, $isObj->id );
 }
 else {
  $sth->execute( $isObj->softwareLparId, $isObj->id );
 }

 my @isIds;
 while ( $sth->fetchrow_arrayref ) {
  push @isIds, $installedSwId;
 }
 $sth->finish;

 dlog( scalar @isIds . ' matched installed software found' );

 if ( scalar @isIds == 0 ) {
  $self->info( 'ZERO_INSTALLED_SW_FOUND:' . $isObj->toString );
 }

 foreach my $isId (@isIds) {
  my $is = new BRAVO::OM::InstalledSoftware();
  $is->id($isId);
  $is->getById( $self->connection );

  my $licensingInstalledSoftware =
    new Recon::LicensingInstalledSoftware( $self->connection, $is, 0 );

  ###reuse the validate of installed software to check if it's in scope.
  my $validation = $licensingInstalledSoftware->validateScope();

  #validate code 1, in scope installed software without any reconcile.
  if ( $validation->validationCode == 1 ) {

   if ( $licensingInstalledSoftware->validateScheduleFScope == 0 ) {
    $self->info(
     'NO_SCHEDULE_F:' . $is->toString . ' ref ' . $isObj->toString );
    next;
   }
   dlog("ScheduleF defined and matched");

   my $reconcile =
     $licensingInstalledSoftware->createReconcile( $self->reconcileTypeId,
    $self->machineLevel, $isId, $self->allocMethodId );

   my $scarletReconcile = new Recon::OM::ScarletReconcile();
   $scarletReconcile->id($reconcile);
   $scarletReconcile->save( $self->connection );

   $self->info( 'SUCCESS:' . $reconcile . ' ref ' . $isObj->toString );

   foreach my $ulId ( @{ $self->usedLicenses } ) {
    $licensingInstalledSoftware->createReconcileUsedLicenseMap( $reconcile,
     $ulId );
   }

   $licensingInstalledSoftware->closeAlertUnlicensedSoftware(1);

  }
  else {
   $self->info( 'VALIDATE_FAIL:' . $is->toString . ' ref ' . $isObj->toString );
  }
 }

}

my $sLog = undef;

sub initLogger {
 $sLog = Log::Log4perl->get_logger('scarlet');
 my $layout = Log::Log4perl::Layout::PatternLayout->new("%m%n");

 my $appender = Log::Log4perl::Appender->new(
  "Log::Dispatch::FileRotate",
  filename => '/var/staging/logs/Scarlet/scarlet.log',
  mode     => 'append',
  size     => 10000000,
  max      => 100
 );

 $appender->layout($layout);
 $sLog->add_appender($appender);
 $sLog->level($INFO);
}

sub info() {
 my ( $self, $msg ) = @_;

 my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
   localtime();
 my $dt = sprintf(
  "%04d-%02d-%02d %02d:%02d:%02d",
  $year + 1900,
  $mon + 1, $mday, $hour, $min, $sec
 );

 initLogger if ( !defined $sLog );
 $sLog->info( "[$dt]" . $msg );

}

1;
