package Recon::AlertHwLparNoCpuModel;

use strict;
use Recon::AlertHWLpar;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::Alert;
use Recon::OM::AlertHistory;
use Recon::OM::AlertSoftwareLparNew;

our @ISA = qw(Recon::AlertHWLpar);

sub needOpenAlert(){
  my $self = shift;
 
   my $query = "
select 
h.model 
from 
hardware h, hardware_lpar hl 
where 
h.id  = hl.hardware_id 
and hl.id  = ?
   ";
   
    my $cpuModel=undef;
    $self->connection->prepareSqlQuery(('queryCpuModel',$query));
	my $sth = $self->connection->sql->{queryCpuModel};
	$sth->bind_columns( \$cpuModel );
	$sth->execute( $self->hardwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;
	
	
	$cpuModel = trim($cpuModel);
	if(defined $cpuModel && '' ne $cpuModel){
	 return 0;
	}else{
	 return 1;
	}
 
}

sub getAlertTypeId(){
  return 16;
}

1;
