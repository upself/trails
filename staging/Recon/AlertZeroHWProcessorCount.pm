package Recon::AlertZeroHWProcessorCount;

use strict;
use Recon::AlertHWLpar;
use Base::Utils;
use Carp qw( croak );

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
with ur
   ";
    dlog("query=$query");
    my $procCount=undef;
    $self->connection->prepareSqlQuery(('isHwProcessorCountZero',$query));
	my $sth = $self->connection->sql->{isHwProcessorCountZero};
	$sth->bind_columns( \$procCount );
	$sth->execute( $self->hardwareLpar->id );
	$sth->fetchrow_arrayref;
	$sth->finish;
	
	dlog("process count $procCount");
	
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
