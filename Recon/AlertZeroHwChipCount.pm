package Recon::AlertZeroHwChipCount;

use strict;
use Base::Utils;
use Carp qw( croak );
use BRAVO::OM::Customer;
use Recon::Validation;
use Recon::OM::Alert;
use Recon::OM::AlertHistory;
use Recon::OM::AlertHardwareLparNew;

sub new {
    my ( $class, $connection, $hardware, $hardwareLpar ) = @_;
    my $self = {
                 _connection   => $connection,
                 _hardware     => $hardware,
                 _hardwareLpar => $hardwareLpar
    };
    bless $self, $class;

    $self->validate;

    return $self;
}

sub validate {
    my $self = shift;

    croak 'Connection is undefined'
      unless defined $self->connection;

    croak 'Hardware is undefined'
      unless defined $self->hardware;

    croak 'HardwareLpar is undefined'
      unless defined $self->hardwareLpar;
}

sub recon {
    my $self = shift;

    dlog("Acquiring customer");
    my $customer = new BRAVO::OM::Customer();
    $customer->id($self->hardwareLpar->customerId);
    $customer->getById( $self->connection );
    dlog("Customer acquired");

    my $validation = new Recon::Validation();
    $validation->customer( $customer );
    $validation->hardware( $self->hardware );
    $validation->hardwareLpar( $self->hardwareLpar );

    if (    $validation->isValidCustomer == 0
         || $validation->isValidHardware == 0
         || $validation->isValidHardwareLpar == 0 )
    {
        $self->closeAlert();
    }
    elsif ($self->isZeroHwChipsCount==0) {
        $self->closeAlert();
    }
    else {
        $self->openAlert;
    }
}

sub isZeroHwChipsCount(){
 	my $self = shift;
 
   my $query = "
select 
h.chips 
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

sub openAlert {
    my $self = shift;

    dlog("Acquiring hardware lpar");
    
    my $alertHwLpar = new Recon::OM::AlertHardwareLparNew();
    $alertHwLpar->hardwareLparId( $self->hardwareLpar->id );
    $alertHwLpar->getByBizKey( $self->connection );
    
    my $alert=undef;
    if(defined $alertHwLpar->id){
     $alert = new Recon::OM::Alert();
     $alert->id($alertHwLpar->id);
     $alert->getByKey($self->connection);
    }
    
     return if(defined $alert && $alert->open==1);    
     $self->recordHistory($alert) if(defined $alert);

     $alert = new Recon::OM::Alert () if(!defined $alert);
     $alert->customerId( $self->hardwareLpar->customerId );
	 $alert->alertTypeId(14);
	 $alert->alertCauseId(1);
	 $alert->open(1);
	 $alert->creationTime( currentTimeStamp() ) if(!defined $alert->id);
	 $alert->recordTime( currentTimeStamp() );
	 $alert->remoteUser('STAGING');
	 $alert->assignee(undef);
	 $alert->comment('Auto Open');
	 $alert->save( $self->connection );
	 
	 if(!defined $alertHwLpar->id ){
	  $alertHwLpar->id($alert->id);
	  $alertHwLpar->save($self->connection);
	 }
}


sub closeAlert {
    my $self = @_;

    my $alertHwLpar = new Recon::OM::AlertHardwareLparNew();
    $alertHwLpar->hardwareLparId( $self->hardwareLpar->id );
    $alertHwLpar->getByBizKey( $self->connection );
    
    #alert not exists. 
    return if(!defined $alertHwLpar->id);
    
    my $alert = new Recon::OM::Alert();
    $alert->id($alertHwLpar->id);
    $alert->getById($self->connection);

    return if ( defined $alert->id && $alert->open == 0 );
    $self->recordHistory($alert) if(defined $alert->id);

	$alert->open(0);
	$alert->recordTime( currentTimeStamp() );
	$alert->remoteUser('STAGING');
	$alert->assignee(undef);
	$alert->comment('Auto close');
	$alert->save( $self->connection );
    
}

sub recordHistory {
    my ( $self, $alert ) = @_;

	my $history = new Recon::OM::AlertHistory();
	$history->alertId( $alert->id );
	$history->customerId( $alert->customerId );
	$history->alertTypeId( $alert->alertTypeId );
	$history->alertCauseId( $alert->alertCauseId );
	$history->open( $alert->open );
	$history->creationTime( $alert->creationTime );
	$history->recordTime( $alert->recordTime );
	$history->remoteUser( $alert->remoteUser );
	$history->assignee( $alert->assignee );
	$history->comment( $alert->comment );
	$history->save( $self->connection );
}

sub connection {
    my $self = shift;
    $self->{_connection} = shift if scalar @_ == 1;
    return $self->{_connection};
}

sub hardware {
    my $self = shift;
    $self->{_hardware} = shift if scalar @_ == 1;
    return $self->{_hardware};
}

sub hardwareLpar {
    my $self = shift;
    $self->{_hardwareLpar} = shift if scalar @_ == 1;
    return $self->{_hardwareLpar};
}


1;
