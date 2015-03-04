package Recon::ReconEngineSoftware;

use strict;
use Base::Utils;
use Carp qw( croak );
use Recon::Software;
use BRAVO::OM::Software;
use Database::Connection;
use Recon::SoftwareLpar;

###Object constructor.
sub new {
	my ( $class, $softwareId ) = @_;
	my $self = {
		_softwareId => $softwareId,
		_connection => Database::Connection->new('trails'),
		_queue      => undef
	};
	bless $self, $class;
	dlog("instantiated self");

	$self->validate;

	return $self;
}

sub validate {
	my $self = shift;

	croak 'Software ID is invalid'
		if $self->softwareId !~ /^\d+$/;

	croak 'Connection is undefined'
		if !defined $self->connection;
}

###Primary method used by calling clients.
sub recon {
	my $self = shift;

	my $dieMsg;

	eval {
		my %actionQueue = $self->loadQueue;

		if (   exists( $actionQueue{'OS'} )
			|| exists( $actionQueue{'LICENSABLE'} ) )
		{
			my @softwareLpars = $self->retrieveSwLparRecords;
			my $softwareLpar  = new BRAVO::OM::SoftwareLpar();
			foreach my $softwareLparId (@softwareLpars) {
				$softwareLpar->id($softwareLparId);
				$softwareLpar->getById( $self->connection );
				my $recon = Recon::SoftwareLpar->new( $self->connection,
					$softwareLpar, undef );
				if ( exists( $actionQueue{'OS'} ) ) {
					$recon->action('OS');
					$recon->recon;
				}
				if ( exists( $actionQueue{'LICENSABLE'} ) ) {
					$recon->action('LICENSABLE');
					$recon->recon;
				}
			}
		}
		my $software = new BRAVO::OM::Software();
		$software->id( $self->softwareId );
		$software->getById( $self->connection );
		my $recon = Recon::Software->new( $self->connection, $software );
		$recon->recon;
		
		foreach my $id ( @{ $self->queue } ) {
			my $queue = new Recon::OM::ReconSoftware();
			$queue->id($id);
			$queue->delete( $self->connection );
		}
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

sub loadQueue {
	my $self = shift;
	dlog('Begin loadQueue method of ReconEngineSoftware');

	my @queue;
	my %actions;

	###Prepare the query
	$self->connection->prepareSqlQueryAndFields(
		$self->queryReconQueueBySoftwareId() );

	###Acquire the statement handle
	my $sth = $self->connection->sql->{reconQueueBySoftwareId};

	###Bind our columns
	my %rec;
	$sth->bind_columns( map { \$rec{$_} }
			@{ $self->connection->sql->{reconQueueBySoftwareIdFields} } );

	###Excute the query
	$sth->execute( $self->softwareId );

	###Loop over query result set.
	while ( $sth->fetchrow_arrayref ) {

		###Clean record values
		cleanValues( \%rec );

		###Upper case record values
		upperValues( \%rec );

		###Add to our queue hash
		push @queue, $rec{id};

		if ( !exists( $actions{ $rec{action} } ) ) {
			$actions{ $rec{action} } = 1;
		}

	}
	$sth->finish;

	###Set our queue attribute
	$self->queue( \@queue );
	return %actions;
}

sub queryReconQueueBySoftwareId {
	my @fields = qw(
		id
		action
	);
	my $query = '
        select
            a.id,
            a.action
        from
            recon_software a
        where
            a.software_id = ?
        with ur
    ';
	dlog("queryReconQueueBySoftwareId=$query");
	return ( 'reconQueueBySoftwareId', $query, \@fields );
}

sub retrieveSwLparRecords {
	my $self = shift;

	$self->connection->prepareSqlQueryAndFields(
		$self->querySwLparRecordsBySoftwareId() );
	my $sth = $self->connection->sql->{swLparRecordsBySoftwareId};
	my %rec;
	my @softwareLpars;
	$sth->bind_columns( map { \$rec{$_} }
			@{ $self->connection->sql->{swLparRecordsBySoftwareIdFields} } );
	$sth->execute( $self->softwareId );
	while ( $sth->fetchrow_arrayref ) {
		push @softwareLpars, $rec{softwareLparId};
	}
	$sth->finish;
	return @softwareLpars;
}

sub querySwLparRecordsBySoftwareId {
	my @fields = qw( softwareLparId );
	my $query  = qq{
        select 
            distinct sl.id 
        from 
            installed_software is,
            software_lpar sl
        where 
            is.software_id=?
            and is.software_lpar_id= sl.id   
            and sl.status='ACTIVE'  
            and is.status='ACTIVE'           
        with ur
    };
	dlog("querySwLparRecordsBySoftwareId=$query");
	return ( 'swLparRecordsBySoftwareId', $query, \@fields );
}

sub softwareId {
	my ( $self, $value ) = @_;
	$self->{_softwareId} = $value if defined($value);
	return ( $self->{_softwareId} );
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
