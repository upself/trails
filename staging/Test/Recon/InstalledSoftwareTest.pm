package Test::Recon::InstalledSoftwareTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::InstalledSoftware;

sub test01_fetchMechineLevelServerType : Test(2) {
	my $self = shift;

	my $bravoConnection   = $self->getBravoConnection;
	my $installedSoftware = new BRAVO::OM::InstalledSoftware();
	#FIX: it's fixed installed software id.
	$installedSoftware->id(68428856);
	$installedSoftware->getById($bravoConnection);

	my $reconInstalledSw =
	  new Recon::InstalledSoftware( $bravoConnection, $installedSoftware );
	$reconInstalledSw->setUp;

	###test the route if hw server type is production.
	$reconInstalledSw->installedSoftwareReconData->hServerType('PRODUCTION');
	diag('hardware server type is: '.$reconInstalledSw->installedSoftwareReconData->hServerType);
	my $hwServerType = $reconInstalledSw->fetchMechineLevelServerType(
		$reconInstalledSw->installedSoftwareReconData->hId,
		$reconInstalledSw->installedSoftwareReconData->hServerType
	);
	ok(defined $hwServerType, "hwServerType=$hwServerType");
	
	###test the route if hw server type is development.
	$reconInstalledSw->installedSoftwareReconData->hServerType('DEVELOPMENT');
	diag('hardware server type is: '.$reconInstalledSw->installedSoftwareReconData->hServerType);
	diag('hw id is: '.$reconInstalledSw->installedSoftwareReconData->hId);
	
	$hwServerType = $reconInstalledSw->fetchMechineLevelServerType(
		$reconInstalledSw->installedSoftwareReconData->hId,
		$reconInstalledSw->installedSoftwareReconData->hServerType
	);
	ok(defined $hwServerType, "hwServerType=$hwServerType");

}
1;
