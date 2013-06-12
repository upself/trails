package AlertHwLparNoProcType;

use strict;
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
h.processor_type
from 
hardware h, hardware_lpar hl 
where 
h.id  = hl.hardware_id 
and hl.id  = ?
   ";
   
    my $procType=undef;
    $self->connection->prepareSqlQuery(('queryProcType',$query));
	my $sth = $self->connection->sql->{queryProcType};
	$sth->bind_columns( \$procType );
	$sth->execute( $self->hardwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;
	
	if(defined $procType && '' ne $procType){
	 return 0;
	}else{
	 return 1;
	}
 
}

sub getAlertTypeId(){
  return 15;
}

1;
