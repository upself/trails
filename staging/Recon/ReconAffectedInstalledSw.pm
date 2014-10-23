package Recon::ReconAffectedInstalledSw;

use strict;
use Base::Utils;
use Database::Connection;
use Recon::OM::ReconInstalledSoftware;
use Recon::OM::ReconSoftwareLpar;

sub new {
 my ($class) = @_;
 my $self = { _connection => Database::Connection->new('trails') };
 bless $self, $class;
 return $self;
}

sub execute {
 my ( $self, $operateOnLpar ) = @_;
 my $conn = $self->connection;
 my $ref;
 if ($operateOnLpar) {
  $ref = $self->getAffectedInstalledSwlpars($conn);
 }
 else {
  $ref = $self->getAffectedInstalledSws($conn);
 }
 foreach my $data ( @{$ref} ) {
  my $bufferId = $data->customerId;
  $data->getByBizKey($conn);
  if ( !defined $data->id ) {
   $data->customerId($bufferId);
   $data->save($conn);
  }
 }

}

sub getAffectedInstalledSws {
 my ( $self, $connection ) = @_;

 $connection->prepareSqlQueryAndFields( $self->getMappedInstalledSwQuery() );
 my $sth = $connection->sql->{pvuMappedInstalledSw};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $connection->sql->{pvuMappedInstalledSwFields} } );
 $sth->execute;
 my @result;
 while ( $sth->fetchrow_arrayref ) {
  my $reconInstalledSw = new Recon::OM::ReconInstalledSoftware;
  $reconInstalledSw->customerId( $rec{customerId} );
  $reconInstalledSw->installedSoftwareId( $rec{installedSwId} );
  $reconInstalledSw->action('UPDATE');
  push @result, $reconInstalledSw;
 }
 $sth->finish;

 return \@result;
}

sub getAffectedInstalledSwlpars {
 my ( $self, $connection ) = @_;

 $connection->prepareSqlQueryAndFields( $self->getMappedInstalledSwlpar() );
 my $sth = $connection->sql->{pvuMappedInstalledSwlpar};
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $connection->sql->{pvuMappedInstalledSwlparFields} } );
 $sth->execute;
 my @result;
 while ( $sth->fetchrow_arrayref ) {
  my $reconInstalledSwlpar = new Recon::OM::ReconSoftwareLpar;
  $reconInstalledSwlpar->softwareLparId( $rec{installedSwlparId} );
  $reconInstalledSwlpar->customerId( $rec{customerId} );
  $reconInstalledSwlpar->action('DEEP');

  push @result, $reconInstalledSwlpar;
 }
 $sth->finish;

 return \@result;
}

sub getMappedInstalledSwQuery {
 my @fileds = (
  qw(
    customerId
    installedSwId
    )
 );

 my $query = '
 select
    hw.customer_id,
    is.id
  from 
   hw_sw_composite hsc,
   hardware_lpar hl,
  hardware hw,
   pvu_map pvuMap,
   installed_software is
  where 
   hl.id = hsc.hardware_lpar_id
   and hw.id = hl.hardware_id
   and pvuMap.processor_brand = hw.mast_processor_type
   and pvuMap.processor_model = hw.model
   and hsc.software_lpar_id =  is.software_lpar_id
   ';

 return ( 'pvuMappedInstalledSw', $query, \@fileds );

}

sub getMappedInstalledSwlpar {
 my @fileds = (
  qw(
    installedSwlparId
    customerId
    )
 );

 my $query = '
  select 
    distinct is.software_lpar_id,
    hw.customer_id
  from 
   hw_sw_composite hsc,
   hardware_lpar hl,
   hardware hw,
   pvu_map pvuMap,
   installed_software is
  where 
   hl.id = hsc.hardware_lpar_id
   and hw.id = hl.hardware_id
   and pvuMap.processor_brand = hw.mast_processor_type
   and pvuMap.processor_model = hw.model
   and hsc.software_lpar_id =  is.software_lpar_id
   ';

 return ( 'pvuMappedInstalledSwlpar', $query, \@fileds );
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

1;
