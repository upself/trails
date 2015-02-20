package Recon::AlertZeroHwChipCount;

use strict;
use Recon::AlertHWLpar;
use Base::Utils;
use Carp qw( croak );

our @ISA = qw(Recon::AlertHWLpar);

sub needOpenAlert(){
  my $self = shift;
 
   my $query = "
select 
h.chips 
from 
hardware h, hardware_lpar hl 
where 
h.id  = hl.hardware_id 
and hl.id  = ?
with ur
   ";
   
    my $procCount=undef;
    $self->connection->prepareSqlQuery(('isChipsCountZero',$query));
	my $sth = $self->connection->sql->{isChipsCountZero};
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
  return 14;
}

1;
