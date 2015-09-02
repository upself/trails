package Recon::ReconEnginePriorityISVSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use Database::Connection;
use Recon::OM::ReconPriorityISVSoftware;
use BRAVO::OM::InstalledSoftware;
use BRAVO::OM::Customer;
use Recon::Queue;
use BRAVO::OM::SoftwareLpar;

###Object constructor.
sub new {
	my ( $class) = @_;
	my $self = {
		_connection => Database::Connection->new('trails'),
		_queue      => undef,
		_installedSoftwares => {}
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

	eval {
	    #Load records from RECON_PRIORITY_ISV_SW db table
		$self->loadReconPISVSWQueue;

        #Find all the related installed software instances and add them into the memory
		foreach my $id ( @{ $self->queue } ) {
		    #Get the Recon Priority ISV Software record based on id value
		    my $reconPISVSW = new Recon::OM::ReconPriorityISVSoftware();
			$reconPISVSW->id($id);
		    $reconPISVSW->getById( $self->connection );
		    
		    my $customerId =  $reconPISVSW->customerId();
		    my $manufacturerId = $reconPISVSW->manufacturerId();
		    dlog("Customer Id: {$customerId} + Manufacturer Id: {$manufacturerId} for Recon Priority ISV SW Id: {$id}.");
		    
	        #Get all the related installed software instances based on customerId and manufacturerId values
		    $self->retrieveInstalledSoftwareRecordsByConditions($customerId,$manufacturerId);
		        
		    #Remove the Recon Priority ISV Software Record from DB Queue
			$reconPISVSW->delete( $self->connection);
		}
		
		#Generate recon_installed_sw records based on installed ids and insert into RECON_INSTALLED_SW db table
		$self->queueReconInSWs;
		
	};
	if ($@) {
		###Something died in the eval, set dieMsg so
		###we know to die after closing the db connections.
		elog($@);
		$dieMsg = $@;
	}

	###Close the bravo connection
	ilog("disconnecting bravo db connection");
	$self->connection->disconnect;
	ilog("disconnected bravo db connection");

	###die if dieMsg is defined
	die $dieMsg if defined $dieMsg;
}

sub loadReconPISVSWQueue {
	my $self = shift;
	dlog('Begin loadReconPISVSWQueue method of ReconEnginePriorityISVSoftware');

	my @queue;
	
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
		push @queue, $rec{id};
	}
	$sth->finish;

	###Set our queue attribute
	$self->queue( \@queue );
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
        with ur
    ';
	dlog("queryReconPriorityISVSoftwareQueue=$query");
	return ( 'reconPriorityISVSoftwareQueue', $query, \@fields );
}


sub retrieveInstalledSoftwareRecordsByConditions {
    my ($self,$customerId,$manufacturerId) = @_;
   
    if(defined $customerId){
       $self->connection->prepareSqlQueryAndFields(
	            queryInstalledSoftwareRecordsByManufacturerIdAndCustomerId() );
	    my $sth = $self->connection->sql
	        ->{installedSoftwareRecordsByManufacturerIdAndCustomerId};
	    my %rec;
	    $sth->bind_columns(
	           map { \$rec{$_} } @{
	               $self->connection->sql
	                   ->{installedSoftwareRecordsByManufacturerIdAndCustomerIdFields}
	               }
	    );
	    $sth->execute($customerId, $manufacturerId);
	    while ( $sth->fetchrow_arrayref ) {
	        my $inswId = $rec{installedSoftwareId};
	        $self->addToInstalledSoftwaresCache($inswId);
	        dlog("Installed Software Id: {$inswId} has been stored into memory cache.");
	    }
	    $sth->finish;
    }
    else
    {
        $self->connection->prepareSqlQueryAndFields(
	            queryInstalledSoftwareRecordsByManufacturerId() );
	    my $sth = $self->connection->sql
	        ->{installedSoftwareRecordsByManufacturerId};
	    my %rec;
	    $sth->bind_columns(
	           map { \$rec{$_} } @{
	               $self->connection->sql
	                   ->{installedSoftwareRecordsByManufacturerIdFields}
	               }
	    );
	    $sth->execute($manufacturerId);
	    while ( $sth->fetchrow_arrayref ) {
	        my $inswId = $rec{installedSoftwareId};
	        $self->addToInstalledSoftwaresCache($inswId);
	        dlog("Installed Software Id: {$inswId} has been stored into memory cache.");
	    }
	    $sth->finish;
    }

}

sub addToInstalledSoftwaresCache {
    my ( $self, $id) = @_;
    $self->installedSoftwares->{$id} = 1;
}

sub installedSoftwares {
    my $self = shift;
    $self->{_installedSoftwares} = shift if scalar @_ == 1;
    return $self->{_installedSoftwares};
}

sub queryInstalledSoftwareRecordsByManufacturerIdAndCustomerId {
    my @fields = (qw( installedSoftwareId ));
    my $query  = qq{
        select
        	is.id
        from
            customer c
            ,software_lpar sl
        	,installed_software is
        	,software s
        where
            c.customer_id = ?
            and c.status = 'ACTIVE'
            and c.sw_license_mgmt = 'YES'
            and c.customer_id = sl.customer_id
            and sl.id = is.software_lpar_id
            and sl.status = 'ACTIVE'
        	and is.status = 'ACTIVE'
        	and s.manufacturer_id = ?
        	and s.status = 'ACTIVE'
        	and s.software_id = is.software_id       	
        with ur
    };
    
    dlog("queryInstalledSoftwareRecordsByManufacturerIdAndCustomerId = $query");
    return ( 'installedSoftwareRecordsByManufacturerIdAndCustomerId',
             $query, \@fields );
}

sub queryInstalledSoftwareRecordsByManufacturerId {
    my @fields = (qw( installedSoftwareId ));
    my $query  = qq{
        select
        	is.id
        from
            software_lpar sl
        	,installed_software is
        	,software s
        where
            sl.id = is.software_lpar_id
            and sl.status = 'ACTIVE'
        	and is.status = 'ACTIVE'
        	and s.manufacturer_id = ?
        	and s.status = 'ACTIVE'
        	and s.software_id = is.software_id       	
        with ur
    };
    
    dlog("queryInstalledSoftwareRecordsByManufacturerId = $query");
    return ( 'installedSoftwareRecordsByManufacturerId',
             $query, \@fields );
}

sub queueReconInSWs{
    my $self = shift;
    dlog('Begin queueReconInSWs method of ReconEnginePriorityISVSoftware');
    
    foreach my $installedSoftwareId ( keys %{ $self->installedSoftwares } ) {
        dlog("Get Installed Software Id: {$installedSoftwareId} from memory cache.");
        ##Get the installed software
        my $installedSoftware = new BRAVO::OM::InstalledSoftware();
        $installedSoftware->id($installedSoftwareId);
        $installedSoftware->getById($self->connection);
        
        #Get the software lpar
        my $softwareLpar = new BRAVO::OM::SoftwareLpar();
        $softwareLpar->id($installedSoftware->softwareLparId);
        $softwareLpar->getById($self->connection);
        
        ###Get the customer
        my $customer = new BRAVO::OM::Customer();
        my $customerId = $softwareLpar->customerId;
        dlog("Customer Id: {$customerId} for installed software id: {$installedSoftwareId}.");
        $customer->id($customerId);
        $customer->getById( $self->connection );
        
        my $queue = Recon::Queue->new( $self->connection, $installedSoftware, $customer);
        $queue->add;
    }
}

sub queue {
	my $self = shift;
	$self->{_queue} = shift if scalar @_ == 1;
	return $self->{_queue};
}

sub connection {
	my $self = shift;
	$self->{_connection} = shift if scalar @_ == 1;
	return $self->{_connection};
}

1;
