package Test::PvuRecon::PvuReconEngineTest;

use strict;
use Test::More;
use base qw(Test::Class Test::Common::ConnectionManager);

use Recon::ReconEnginePvu;
use Recon::OM::ReconPvu;
use Recon::OM::ReconSoftwareLpar;

sub test01_reconEnginePvu_loadQueue : Test(2) {
 my $self           = shift;
 my $reconEnginePvu = new Recon::ReconEnginePvu;
 $reconEnginePvu->isUnitTest(1);
 $reconEnginePvu->recon;
 $self->{teardownReconSwlparIds} = $reconEnginePvu->savedReconSwlparIds;

 my $reconSwlpar = $self->{reconSwlpar};
 my $custId      = $reconSwlpar->customerId;
 $reconSwlpar->getByBizKey( $self->getBravoConnection );

 ok( defined $reconSwlpar->id, "sw lpar in recon queue" );
 is( $reconSwlpar->customerId, $custId, "customer id is $custId" );
}

sub test02_reconPvu : Test(2) {
 my $self       = shift;
 my $reconOmPvu = $self->{reconPvu};

 #boot the pvu recon engine for this Recon::OM::ReconPvu instance.
 my $reconPvu = new Recon::Pvu( $self->getBravoConnection, $reconOmPvu );
 $reconPvu->isUnitTest(1);
 $reconPvu->recon;
 $self->{teardownReconSwlparIds} = $reconPvu->savedReconSwlparIds;

 my $reconSwlpar = $self->{reconSwlpar};
 my $custId      = $reconSwlpar->customerId;
 $reconSwlpar->getByBizKey( $self->getBravoConnection );

 ok( defined $reconSwlpar->id, "sw lpar in recon queue" );
 is( $reconSwlpar->customerId, $custId, "customer id is $custId" );
}

sub teardown01_removeSwlparReconQueue : Test(teardown) {
 my $self = shift;

 my $records = 0;

 #clear in sw lpar recon queue.
 foreach my $reconSwlparid ( @{ $self->{teardownReconSwlparIds} } ) {
  my $reconSwlpar = new Recon::OM::ReconSoftwareLpar;
  $reconSwlpar->id($reconSwlparid);
  $reconSwlpar->getById( $self->getBravoConnection );
  $reconSwlpar->delete( $self->getBravoConnection );
  $records++;
 }

 diag "tear down $records record(s)";

}

sub startup01_pvuReconEngineTest_buildTestData : Test(startup) {
 my $self = shift;

 #insert a row in recon_pvu table.
 #get recon pvu info in db.
 my $conn = $self->getBravoConnection;
 $conn->prepareSqlQuery( $self->queryReconPvuInfo );

 #acquire the statement handle.
 my $sth = $conn->sql->{queryReconPvuInfo};

 #bind fields.
 my $swLparId;
 my $custId;
 my $prcBrand;
 my $prcModel;

 $sth->bind_columns( \$swLparId, \$custId, \$prcBrand, \$prcModel );
 $sth->execute;
 $sth->fetchrow_arrayref;

 #build the test recon::om::reconPvu.
 my $reconPvu = new Recon::OM::ReconPvu;
 $reconPvu->processorBrand($prcBrand);
 $reconPvu->processorModel($prcModel);
 $reconPvu->action('ADD');
 $reconPvu->save( $self->getBravoConnection );

 #store the recon pvu as in memory.
 $self->{reconPvu} = $reconPvu;

 my $reconSwlpar = new Recon::OM::ReconSoftwareLpar;
 $reconSwlpar->softwareLparId($swLparId);
 $reconSwlpar->customerId($custId);
 $reconSwlpar->action('DEEP');

 $self->{reconSwlpar} = $reconSwlpar;

}

sub shutdown01_removeTestData : Test(shutdown) {
 my $self = shift;

 #remove the built test recon::om::reconPvu.
 $self->{reconPvu}->delete( $self->getBravoConnection );

}

sub queryReconPvuInfo {
 my $query = "
select
             sl.id
            ,sl.customer_id
            ,h.processor_type
            ,h.model
        from
             software_lpar sl join
             hw_sw_composite hsc on 
                hsc.software_lpar_id = sl.id
            left outer join hardware_lpar hl on 
                hl.id = hsc.hardware_lpar_id
            left outer join hardware h on 
                h.id = hl.hardware_id
         where 
              h.processor_type!='' and h.model!=''
fetch first 1 rows only
   ";
 return ( 'queryReconPvuInfo', $query );
}
1;
