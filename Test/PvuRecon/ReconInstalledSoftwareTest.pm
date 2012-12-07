package Test::PvuRecon::ReconInstalledSoftwareTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::InstalledSoftware;
use BRAVO::OM::InstalledSoftware;
use Recon::OM::PvuMap;
use Recon::OM::Pvu;
use Recon::OM::PvuInfo;

sub test01_fetch_processor_info : Test(2) {
 my $self = shift;

 my $installedOMSw = new BRAVO::OM::InstalledSoftware;
 $installedOMSw->id('7716191');    #processor type=POWER/Model=MMA
 $installedOMSw->getById( $self->getBravoConnection );

 my $installedSw =
   new Recon::InstalledSoftware( $self->getBravoConnection, $installedOMSw );
 $installedSw->getInstalledSoftwareReconData;

 my $infoView = $installedSw->installedSoftwareReconData;
 is( $infoView->hProcessorBrand, 'POWER', 'Processor brand is POWER' );
 is( $infoView->hProcessorModel, 'MMA',   'Processor model is MMA' );

 #diag($infoView->toString);
}

sub test02_method_getValueUnitsPerProcessor : Test(6) {
 my $self          = shift;
 my $installedOMSw = new BRAVO::OM::InstalledSoftware;
 $installedOMSw->id('7716191');    #processor type=POWER/Model=MMA
 $installedOMSw->getById( $self->getBravoConnection );

 my $installedSw =
   new Recon::InstalledSoftware( $self->getBravoConnection, $installedOMSw );
 $installedSw->getInstalledSoftwareReconData;
 $installedSw->connection( $self->getBravoConnection );

 #build multi-core type, 20 is expect result
 my $chipsCount     = 1;
 my $processorCount = 3;
 $installedSw->installedSoftwareReconData->hProcessorBrand('test_brand');
 $installedSw->installedSoftwareReconData->hProcessorModel('test_model');

 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 20, 'the value units per core is 20.' );

 #build default, 100 is expect result
 $chipsCount     = 1;
 $processorCount = -3;
 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 100, 'the value units per core is 100.' );

 #build default, 100 is expect result
 $chipsCount     = 0;
 $processorCount = 2;
 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 100, 'the value units per core is 100.' );

 #build default, 100 is expect result
 $chipsCount     = 2;
 $processorCount = 1;
 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 100, 'the value units per core is 100.' );

 #build daul core, 30 is expect result
 $chipsCount     = 1;
 $processorCount = 4;
 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 30, 'the value units per core is 30.' );

 #build single core, 10 is expect result
 $chipsCount     = 1;
 $processorCount = 1;
 my $value =
   $installedSw->getValueUnitsPerProcessor( $chipsCount, $processorCount );
 is( $value, 10, 'the value units per core is 10.' );

}

sub startup01_build_test_data : Test(startup) {
 my $self = shift;

 my $pvu = new Recon::OM::Pvu;
 $pvu->processorBrand('testPvuBrand');
 $pvu->processorModel('testPvuModel');
 $pvu->save( $self->getBravoConnection );
 $self->{pvu} = $pvu;

 my $pvuMap = new Recon::OM::PvuMap;
 $pvuMap->processorBrand('test_brand');
 $pvuMap->processorModel('test_model');
 $pvuMap->pvuId( $pvu->id );
 $pvuMap->save( $self->getBravoConnection );
 $self->{pvuMap} = $pvuMap;

 my @pvuInfoArrays;

 my $pvuInfo = new Recon::OM::PvuInfo;
 $pvuInfo->id(1);
 $pvuInfo->getById( $self->getBravoConnection );

 $pvuInfo->id(undef);
 $pvuInfo->pvuId( $pvu->id );
 $pvuInfo->processorType('SINGLE-CORE');
 $pvuInfo->valueUnitsPerCore(10);
 $pvuInfo->save( $self->getBravoConnection );

 my $pvuInfoTemp = new Recon::OM::PvuInfo;
 $pvuInfoTemp->id( $pvuInfo->id );
 $pvuInfoTemp->getById( $self->getBravoConnection );
 push @pvuInfoArrays, $pvuInfoTemp;

 $pvuInfo->id(undef);
 $pvuInfo->pvuId( $pvu->id );
 $pvuInfo->processorType('MULTI-CORE');
 $pvuInfo->valueUnitsPerCore(20);
 $pvuInfo->save( $self->getBravoConnection );

 my $pvuInfoTemp = new Recon::OM::PvuInfo;
 $pvuInfoTemp->id( $pvuInfo->id );
 $pvuInfoTemp->getById( $self->getBravoConnection );
 push @pvuInfoArrays, $pvuInfoTemp;

 $pvuInfo->id(undef);
 $pvuInfo->pvuId( $pvu->id );
 $pvuInfo->processorType('DUAL-CORE');
 $pvuInfo->valueUnitsPerCore(30);
 $pvuInfo->save( $self->getBravoConnection );

 my $pvuInfoTemp = new Recon::OM::PvuInfo;
 $pvuInfoTemp->id( $pvuInfo->id );
 $pvuInfoTemp->getById( $self->getBravoConnection );
 push @pvuInfoArrays, $pvuInfoTemp;

 $self->{pvuInfoArrays} = \@pvuInfoArrays;
}

sub shutdown01_cleanTestData : Test(shutdown) {
 my $self = shift;

 $self->{pvuMap}->delete( $self->getBravoConnection );

 my $refPvuInfos = $self->{pvuInfoArrays};
 for (@$refPvuInfos) {
  $_->delete( $self->getBravoConnection );
 }

 $self->{pvu}->delete( $self->getBravoConnection );

}
1;
