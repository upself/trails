package Recon::Pvu;

use strict;
use Base::Utils;
use Carp qw( croak );

use Recon::OM::PvuInfo;
use Recon::OM::ReconPvu;
use Recon::Delegate::ReconDelegate;
use Recon::Queue;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::SoftwareLpar;
## use Recon::OM::ReconSoftwareLpar;

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

 #Buffer the installed software info
 my @iSWQueue = $self->getInsSwList;

 #Persist the sw lpar info in queue.
 foreach my $iSW ( @iSWQueue ) {
  my %hashiSW = %{$iSW};
  
  my %reIDsbroken;
  my %ISWadded; # hashes of reconciles broken and ISWs added, to make sure duplicite rows won't be operated
  
  next unless defined $hashiSW{isId};
  
  if (( defined $hashiSW{rId} ) && ( defined $hashiSW{rTypeId} ) && ( $hashiSW{rTypeId} == 1 )) { # manual license allocation, should be broken and alert open
	
	my $curr_rId=$hashiSW{rId};
	
	next if ( exists $reIDsbroken{$curr_rId} );
	
	dlog("Breaking reconcile $curr_rId");
	
	Recon::Delegate::ReconDelegate->breakReconcileById( $self->connection, $hashiSW{rId} );
	
	$reIDsbroken{$curr_rId} = 1;
	
	# todo: open alert? ( searching for "IBM" or "ISV" would be difficult, and both iSW and License and in recon queue anyway )

  } elsif ( (( defined $hashiSW{rId} ) && ( defined $hashiSW{rTypeId} ) && ( $hashiSW{rTypeId} == 5 )) or (( defined $hashiSW{aOpen} ) && ( $hashiSW{aOpen} == 1 )) )
  {   # automatic license allocation or open alert on unlicensed SW, we're adding to recon queue
	my $curr_ISWId=$hashiSW{isId};
  
	next if ( exists $ISWadded{$curr_ISWId} );
  
	dlog("Adding ISW to queue $curr_ISWId");
	
		my $instSw = new BRAVO::OM::InstalledSoftware();
		$instSw->id($hashiSW{isId});
		$instSw->getById( $self->connection );
		dlog( "instSw=" . $instSw->toString() );

		my $swLpar = new BRAVO::OM::SoftwareLpar();
		$swLpar->id( $hashiSW{slId} );
		$swLpar->getById( $self->connection );
		dlog( "swLpar=" . $swLpar->toString() );

		my $queue = Recon::Queue->new( $self->connection, $instSw, $swLpar );
			$queue->add;
			
	$ISWadded{$curr_ISWId} = 1;
	
  }
  
 }

}

sub getInsSwList {
 my $self = shift;

 #Prepare the query.
 $self->connection->prepareSqlQueryAndFields( $self->queryInsSwByBrandModel( $self->reconPvuQueue->action ) );

 #Acquire the statement handle.
 my $sth = $self->connection->sql->{queryInsSwByBrandModel};

 #Bind fields.
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{queryInsSwByBrandModelFields} } );

 #Fetch correspond sw recon infor.
 $sth->execute( $self->reconPvuQueue->processorBrand,
  $self->reconPvuQueue->processorModel,$self->reconPvuQueue->machineTypeId);
  
 my @result;
 while ( $sth->fetchrow_arrayref ) {
  my %reconInsSw = (
   customerId     => $rec{customerId},
   slId => $rec{slId},
   isId => $rec{isId},
   rId => $rec{rId},
   rTypeId => $rec{rTypeId},
   aOpen => $rec{aOpen}
  );
  push @result, \%reconInsSw;
 }
 $sth->finish;

 return @result;
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


sub queryInsSwByBrandModel {
 my $self=shift;	
 my $action=shift;
 
 #h.processor_type means processor brand.
 #h.model means processor model.

 my @fields = qw(
   isId
   slId
   customerId
   rId
   rTypeId
   aOpen
 );

 my $query = '
select
   is.id
   ,sl.id
   ,sl.customer_id
   ,r.id
   ,r.reconcile_type_id
   ,aus.open
  from
			installed_software is inner join
			software_lpar sl on is.software_lpar_id = sl.id
			inner join customer c on c.customer_id = sl.customer_id
			inner join software vs on is.software_id = vs.software_id
			inner join hw_sw_composite hsc on hsc.software_lpar_id = sl.id
			inner join hardware_lpar hl on hl.id = hsc.hardware_lpar_id
			inner join hardware h on h.id = hl.hardware_id
			left outer join reconcile r on r.installed_software_id = is.id
			left outer join reconcile_used_license rul on rul.reconcile_id = r.id
			left outer join used_license ul on rul.used_license_id = ul.id
			left outer join alert_unlicensed_sw aus on aus.installed_software_id = is.id

  where
			vs.level = \'LICENSABLE\' and
			is.status = \'ACTIVE\' and
			sl.status = \'ACTIVE\' and
			is.discrepancy_type_id in ( 1, 2, 4 ) and
			c.status = \'ACTIVE\' and
			c.sw_license_mgmt = \'YES\' and
			h.mast_processor_type= ? and 
			h.model= ? and
			h.machine_type_id= ? and
			(';
			
$query.='      ( aus.open = 1 )
                 or
' if ( uc($action) eq 'ADD' );
$query.='					( ( r.reconcile_type_id = 5 ) and ( ul.capacity_type_id = 17 ) )
					or
							( ( r.reconcile_type_id = 1 ) and ( r.allocation_methodology_id = 6 ) )
			)';
			
 dlog($query);

 return ( 'queryInsSwByBrandModel', $query, \@fields );
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
