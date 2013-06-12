package Recon::AlertZeroHWProcessorCount;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::Alert;
use Recon::OM::AlertHistory;
use Recon::OM::AlertHardwareLparNew;

our @ISA = qw(Recon::AlertHWLpar);

sub needOpenAlert(){
  my $self = shift;
 
   my $query = "
select 
h.processor_count 
from 
hardware h, hardware_lpar hl 
where 
h.id  = hl.hardware_id 
and hl.id  = ?
   ";
   
    my $procCount=undef;
    $self->connection->prepareSqlQuery(('isProcessorCountZero',$query));
	my $sth = $self->connection->sql->{isProcessorCountZero};
	$sth->bind_columns( \$procCount );
	$sth->execute( $self->hardwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;
	
	if(defined $procCount && $procCount>0){
	 return 0;
	}else{
	 return 1;
	}
 
}

sub getAlertTypeId(){
  return 13;
}



1;
