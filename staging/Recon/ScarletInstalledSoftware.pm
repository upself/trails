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

sub new {
	my ( $class, $reconcileTypeId, $machineLevel, $allocMethodId,
		$scheduleFScopeName )
	  = @_;
	my $self = {
		_connection         => Database::Connection->new('trails'),
		_extSrcIds          => [],
		_guids              => {},
		_usedLicenses       => [],
		_reconcileTypeId    => $reconcileTypeId,
		_machineLevel       => $machineLevel,
		_allocMethodId      => $allocMethodId,
		_scheduleFScopeName => $scheduleFScopeName,
		_config             => Config::Properties::Simple->new(
			file => '/opt/staging/v2/config/connectionConfig.txt'
		)
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

sub scheduleFScopeName {
	my $self = shift;
	$self->{_scheduleFScopeName} = shift if scalar @_ == 1;
	return $self->{_scheduleFScopeName};
}

sub config {
	my $self = shift;
	$self->{_config} = shift if scalar @_ == 1;
	return $self->{_config};
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
	dlog(   'scarlet cache data extSrcId= '
		  . $extSrcId
		  . ' usedLicenseId='
		  . $usedLicenseId );

	push @{ $self->extSrcIds },    $extSrcId;
	push @{ $self->usedLicenses }, $usedLicenseId;
}

sub existInScarlet {
	my ( $self, $extSrcId, $guid ) = @_;

	my $swcmLicenseId = undef;
	if ( $extSrcId =~ /SWCM_(\d*)/ ) {
		$swcmLicenseId = $1;
	}
	else {
		return 0;
	}

	my $scarletGuids = $self->httpGetScarletGuids( $swcmLicenseId, $guid );
	foreach my $id ( @{$scarletGuids} ) {    
		return 1 if ( $id eq $guid );
	}

	return 0;
}

sub httpGetScarletGuids {
	my ( $self, $swcmLicenseId, $guid ) = @_;

	my $scarletGuidsApi = $self->config->getProperty('scarlet.guids');
	dlog("GET $scarletGuidsApi?componentGuid=$guid&licenseId=$swcmLicenseId");
	my $uri = URI->new($scarletGuidsApi);
	$uri->query_form(
		'componentGuid' => $guid,
		'licenseId'     => $swcmLicenseId
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
		dlog( 'extra ' . scalar @{$scarletGuids} . ' guid found in scarlet' );
	}
	else {
		wlog( 'scarlet requesting failed: ' . $response->status_line );
	}

	return $scarletGuids;
}

sub setUpGuidsFromScarlet {

	my ( $self, $installedSoftwareId ) = @_;

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

		my $scarletGuids = $self->httpGetScarletGuids( $swcmLicenseId, $guid );

		foreach my $id ( @{$scarletGuids} ) {
			next if ( $id eq $guid );

			$self->guids->{$id} = 1;
			dlog( 'guid=' . $id );
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

	my ( $self, $installedSoftware ) = @_;

	$self->setUpGuidsFromScarlet( $installedSoftware->id );

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

	my $query = ' select is . id from alert_unlicensed_sw aus,
			  installed_software is,
			  kb_definition kbd where aus . installed_software_id = is . id
			  and is . software_id      = kbd . id
			  and aus . open            = 1
			  and is . software_lpar_id =
			      ' . $installedSoftware->softwareLparId . '
			  and is . id != ' . $installedSoftware->id . '
			  and kbd
			  . guid in(' . $guids . ') with ur ';

	dlog( ' getInstalledSoftwareIdQuery = ' . $query );

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

	dlog( scalar @isIds . ' matched installed software found' );

	foreach my $isId (@isIds) {
		my $is = new BRAVO::OM::InstalledSoftware();
		$is->id($isId);
		$is->getById( $self->connection );

		my $installedSoftware =
		  new Recon::LicensingInstalledSoftware( $self->connection, $is, 0 );

		###reuse the validate of installed software to check if it's in scope.
		my $validation = $installedSoftware->validateScope();

		#validate code 1, in scope installed software without any reconcile.
		if ( $validation->validationCode == 1 ) {

			if (
				not $installedSoftware->validateScheduleFScope(
					$self->scheduleFScopeName
				)
			  )
			{
				next;
			}
			dlog("ScheduleF defined and matched");

			my $reconcile =
			  $installedSoftware->createReconcile( $self->reconcileTypeId,
				$self->machineLevel, $isId, $self->allocMethodId );

			foreach my $ulId ( @{ $self->usedLicenses } ) {
				$installedSoftware->createReconcileUsedLicenseMap( $reconcile,
					$ulId );
			}

			$installedSoftware->closeAlertUnlicensedSoftware(1);

		}
	}

}

1;
