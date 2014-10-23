package Test::PvuRecon::ReconPvuInfoTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::Pvu;
use Recon::Delegate::ReconLicenseValidation;

sub test01_testGetMinimumPVUValue : Test(1) {
 my $self         = shift;
 my $reconPvu = new Recon::Pvu( $self->getBravoConnection );
 my $minValue     = $reconPvu->getMinimumPvuValue;
 is( $minValue, 1, 'minimun value units per core is 1' );
}

sub test02_ReconInstalledSoftwareValidation_minimumPvuValue : Test(2) {
 my $self  = shift;
 my $swVal = new Recon::Delegate::ReconLicenseValidation;
 $swVal->connection( $self->getBravoConnection );
 my $minValue = $swVal->minimumPvuValue;
 is( $minValue, 1, 'minimun value units per core is 1' );
 
 $swVal = new Recon::Delegate::ReconLicenseValidation;
 $swVal->minimumPvuValue(123);
 $minValue = $swVal->minimumPvuValue;
 is( $minValue, 123, 'minimun value units per core is 123' );
}

sub test03_ReconInstalledSoftwareValidation_valueUnitsPerCore:Test(2){
 my $reconInstalledSWVal = new Recon::Delegate::ReconInstalledSoftwareValidation;
 is($reconInstalledSWVal->valueUnitsPerCore,100,'default value units per core is 100');
 $reconInstalledSWVal->valueUnitsPerCore(300);
 is($reconInstalledSWVal->valueUnitsPerCore,300,'default value units per core is 300');
}

sub startup01_reconPvuInfoTest_buildTestData : Test(startup) {
 my $self = shift;

 my $pvu = new Recon::OM::Pvu;
 $pvu->processorBrand('xx');
 $pvu->processorModel('yy');
 $pvu->save( $self->getBravoConnection );
 $self->{pvu} = $pvu;

 my $pvuInfo = new Recon::OM::PvuInfo;
 $pvuInfo->id(1);
 $pvuInfo->getById( $self->getBravoConnection );

 $pvuInfo->id(undef);
 $pvuInfo->pvuId( $pvu->id );
 $pvuInfo->valueUnitsPerCore(1);
 $pvuInfo->save( $self->getBravoConnection );
 $self->{pvuInfo} = $pvuInfo;

}

sub shutdown01_removeTestData : Test(shutdown) {
 my $self = shift;

 $self->{pvuInfo}->delete( $self->getBravoConnection );
 $self->{pvu}->delete( $self->getBravoConnection );
}
1;
