package Recon::Pvu;

use strict;
use Base::Utils;
use Carp qw( croak );

use Recon::OM::PvuInfo;
use Recon::OM::ReconPvu;
use Recon::OM::ReconSoftwareLpar;

sub new {
 my ( $class, $connection, $reconPvuQueue ) = @_;
 my $self = {
  _connection    => $connection,
  _reconPvuQueue => $reconPvuQueue,
  _isUnitTest    => 0
 };
 bless $self, $class;
 dlog("Recon::Pvu instantiated");

 $self->validate(1);
 return $self;
}

#1 - avoid check the queue.
#0 - check the queue.
sub validate {
 my ( $self, $avoidQueue ) = @_;

 croak 'Connection is undefined'
   if !defined $self->connection;

 if ( !$avoidQueue ) {
  croak 'Pvu recon queue undefined'
    if !defined $self->reconPvuQueue;
 }

}

sub recon {
 my $self = shift;

 #need to check the queue.
 $self->validate(0);

 #Buffer the sw lpar info in memory.
 my $simpleReconSwlparQueue = $self->getSwlparList;

 #This fields is used for unit test tracing.
 my @savedReconSwlparIds;

 #Persist the sw lpar info in queue.
 foreach my $reconSwlpars ( @{$simpleReconSwlparQueue} ) {
  my %hashSwlpars = %{$reconSwlpars};

  my $reconSwlpar = new Recon::OM::ReconSoftwareLpar;
  $reconSwlpar->customerId( $hashSwlpars{customerId} );
  $reconSwlpar->softwareLparId( $hashSwlpars{softwareLparId} );
  $reconSwlpar->action('DEEP');

  $reconSwlpar->getByBizKey( $self->connection );

  #persist current sw lpar.
  if ( !defined $reconSwlpar->id ) {
   ilog('Recon sw lpar not exist in the queue...saving');

   $reconSwlpar->customerId( $hashSwlpars{customerId} );
   $reconSwlpar->save( $self->connection );

   push @savedReconSwlparIds, $reconSwlpar->id
     if ( $self->isUnitTest );
   ilog('Recon sw lpar inserted into queue');
  }
  else {
   ilog('Recon sw lpar already exist in queue');
  }
 }

 $self->savedReconSwlparIds( \@savedReconSwlparIds )
   if ( $self->isUnitTest );

}

sub getSwlparList {
 my $self = shift;

 #Prepare the query.
 $self->connection->prepareSqlQueryAndFields( $self->querySwLparByBrandModel );

 #Acquire the statement handle.
 my $sth = $self->connection->sql->{querySwLparByBrandModel};

 #Bind fields.
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{querySwLparByBrandModelFields} } );

 #Fetch correspond sw recon infor.
 $sth->execute( $self->reconPvuQueue->processorBrand,
  $self->reconPvuQueue->processorModel,$self->reconPvuQueue->machineTypeId);

 my @result;
 while ( $sth->fetchrow_arrayref ) {
  my %reconSwLpar = (
   customerId     => $rec{customerId},
   softwareLparId => $rec{swLparId}
  );
  push @result, \%reconSwLpar;
 }
 $sth->finish;

 return \@result;
}

sub getMinimumPvuValue {
 my $self = shift;

 my $conn = $self->connection;
 $conn->prepareSqlQuery( 'getMinValue',
  'select min(value_units_per_core) from pvu_info' );
 my $sth = $conn->sql->{getMinValue};
 $sth->execute;
 my ($result) = $sth->fetchrow_array;
 $sth->finish;

 return $result;
}

sub querySwLparByBrandModel {

 #h.processor_type means processor brand.
 #h.model means processor model.

 my @fields = qw(
   swLparId
   customerId
 );

 my $query = '
 select
   sl.id
   ,sl.customer_id
  from
   software_lpar sl join
   hw_sw_composite hsc on 
   hsc.software_lpar_id = sl.id
   left outer join hardware_lpar hl on 
   hl.id = hsc.hardware_lpar_id
   left outer join hardware h on 
   h.id = hl.hardware_id
  where 
   h.processor_type=?  and 
   h.model=? and
   h.machine_type_id=?';

 return ( 'querySwLparByBrandModel', $query, \@fields );
}

sub connection {
 my $self = shift;
 $self->{_connection} = shift if scalar @_ == 1;
 return $self->{_connection};
}

sub reconPvuQueue {
 my $self = shift;
 $self->{_reconPvuQueue} = shift if scalar @_ == 1;
 return $self->{_reconPvuQueue};
}

sub savedReconSwlparIds {
 my $self = shift;
 $self->{_savedReconSwlparIds} = shift if scalar @_ == 1;
 return $self->{_savedReconSwlparIds};
}

sub isUnitTest {
 my $self = shift;
 $self->{_isUnitTest} = shift if scalar @_ == 1;
 return $self->{_isUnitTest};
}
1;
