package Recon::ReconEnginePriorityISVSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use Database::Connection;
use Recon::OM::ReconPriorityISVSoftware;
use BRAVO::OM::Customer;
use BRAVO::OM::Software;
use Recon::Queue;

###Object constructor.
sub new {
	my ($class) = @_;
	my $self = {
		_connection => Database::Connection->new('trails')
	};
	bless $self, $class;
	dlog("instantiated self");

	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Connection is undefined'
		if !defined $self->connection;
}

###Primary method used by calling clients.
sub recon {
	my $self = shift;

	my $dieMsg;
	my $prioID; # the ID of job in the table PRIORITY_ISV_SW, which needs to be checked by Recon
	
	eval {
	    #Load records from RECON_PRIORITY_ISV_SW db table
		$prioID=$self->loadReconPISVSWQueue;
		
		exit unless defined($prioID);

        #Find all the related installed software instances and add them into the memory
	    #Get the Recon Priority ISV Software record based on id value
	    my $reconPISVSW = new Recon::OM::ReconPriorityISVSoftware();
		$reconPISVSW->id($prioID);
	    $reconPISVSW->getById( $self->connection );
		    
	    my @softwareIds=$self->retrieveSoftwareIds($reconPISVSW->manufacturerId() );
		    
        # push the software records to queue RECON_CUSTOMER_SOFTWARE or RECON_SOFTWARE
	    $self->pushToReconCustomerSoftware($reconPISVSW->customerId() ,@softwareIds) if ( defined $reconPISVSW->customerId() );
	    $self->pushToReconSoftware(@softwareIds) unless ( defined $reconPISVSW->customerId() );
		        
	    #Remove the Recon Priority ISV Software Record from DB Queue
		$reconPISVSW->delete( $self->connection);
	};
	if ($@) {
		###Something died in the eval, set dieMsg so
		###we know to die after closing the db connections.
		elog($@);
		$dieMsg = $@;
	}

#	###Close the bravo connection
#	ilog("disconnecting bravo db connection");
#	$self->connection->disconnect;
#	ilog("disconnected bravo db connection");

	###die if dieMsg is defined
	die $dieMsg if defined $dieMsg;
}

sub loadReconPISVSWQueue {
	my $self = shift;
	dlog('Begin loadReconPISVSWQueue method of ReconEnginePriorityISVSoftware');

	my @queue;
	my $toreturn=undef;
	
	###Prepare the query
	$self->connection->prepareSqlQueryAndFields(
		$self->queryReconPriorityISVSoftwareQueue() );

	###Acquire the statement handle
	my $sth = $self->connection->sql->{reconPriorityISVSoftwareQueue};

	###Bind our columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
			@{ $self->connection->sql->{reconPriorityISVSoftwareQueueFields} } );

	###Excute the query
	$sth->execute();

	###Loop over query result set.
	while ( $sth->fetchrow_arrayref ) {

		###Clean record values
		cleanValues( \%rec );

		###Upper case record values
		upperValues( \%rec );

		###Add to our queue hash
		dlog("Recon Priority ISV Software Id :{$rec{id}} has been found from queue");
		$toreturn=$rec{id};
	}
	$sth->finish;

	return $toreturn;
}

sub queryReconPriorityISVSoftwareQueue {
	my @fields = qw(
		id
	);
	my $query = '
        select
            r.id
        from
            recon_priority_isv_sw r
        order by r.record_time
        fetch first 1 rows only
        with ur
    ';
	dlog("queryReconPriorityISVSoftwareQueue=$query");
	return ( 'reconPriorityISVSoftwareQueue', $query, \@fields );
}


sub retrieveSoftwareIds {
	my $self = shift;
    my $manufacturerId = @_;
    my @toreturn=();
   
    $self->connection->prepareSqlQueryAndFields(querySoftwareByManufacturerId() );
    my $sth = $self->connection->sql->{SoftwareByManufacturerId};
    my %rec;
    $sth->bind_columns(
           map { \$rec{$_} } @{ $self->connection->sql->{SoftwareByManufacturerIdFields} }
    );
	$sth->execute($manufacturerId);
	while ( $sth->fetchrow_arrayref ) {
		push ( @toreturn, $rec{softwareId} );
    }
    $sth->finish;
    
    return @toreturn;
}

sub querySoftwareByManufacturerId {
    my @fields = ( 'softwareId' );
    my $query  = qq{
        select
        	s.software_id
        from
            software s
            join manufacturer m on m.id = s.manufacturer_id
        where
            m.name in ( select mm.name from manufacturer mm where mm.id = ? )
        with ur
    };
    
    dlog("querySoftwareByManufacturerId = $query");
    return ( 'SoftwareByManufacturerId',
             $query, \@fields );
}

sub pushToReconCustomerSoftware {
	my $self=shift;
	my $customerId=shift;
	my @softwareIds=@_;
	
	my $customer = new BRAVO::OM::Customer();
	$customer->id($customerId);
	$customer->getById( $self->connection );
	
	foreach my $swId (@softwareIds) {
		my $software = new BRAVO::OM::Software();
		$software->id($swId);
		$software->getById($self->connection);

		my $queue = Recon::Queue->(new $self->connection, $customer, $software);
		$queue->add;
	}	
}

sub pushToReconSoftware {
	my $self=shift;
	my @softwareIds=@_;
	
	foreach my $swId (@softwareIds) {
		my $software = new BRAVO::OM::Software();
		$software->id($swId);
		$software->getById($self->connection);

		my $queue = Recon::Queue->(new $self->connection, $software);
		$queue->add;
	}	
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

1;
