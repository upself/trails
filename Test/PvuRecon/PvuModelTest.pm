package Test::PvuRecon::PvuModelTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::OM::Pvu;
use Recon::OM::PvuInfo;
use Recon::OM::PvuMap;

sub test01_pvuModel : Test(4) {
 my $self   = shift;
 my $pvuMap = new Recon::OM::PvuMap;
 $pvuMap->processorBrand('ITANIUM');
 $pvuMap->processorModel('BL60P');
 $pvuMap->getByBizKey( $self->getBravoConnection );

 ok( defined $pvuMap->pvuId, 'pvu_map id defined' );

 my $pvu = new Recon::OM::Pvu;
 $pvu->id( $pvuMap->pvuId );
 $pvu->getById( $self->getBravoConnection );

 ok( defined $pvu->processorBrand, 'pvu processor_brand defined' );
 ok( defined $pvu->processorModel, 'pvu processor_model defined' );

 my $pvuInfo = new Recon::OM::PvuInfo;
 $pvuInfo->pvuId( $pvu->id );
 $pvuInfo->processorType('DUAL-CORE');
 $pvuInfo->getByBizKey( $self->getBravoConnection );

 is( $pvuInfo->valueUnitsPerCore, 100, 'value units per core is 100' );
}
1;
