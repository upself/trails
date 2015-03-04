package Recon::ReconEnginePvu;

use strict;
use Base::Utils;
use Carp qw( croak );

use Database::Connection;
use Recon::Pvu;
use Recon::OM::ReconPvu;
use Recon::Delegate::ReconDelegate;

###Object constructor.
sub new {
 my ($class) = @_;
 my $self = {
  _connection => Database::Connection->new('trails'),
  _queue      => undef,
  _isUnitTest => 0
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
  $self->loadQueue;

  foreach my $reconPvuId ( @{ $self->queue } ) {
   my $queue = new Recon::OM::ReconPvu;
   $queue->id($reconPvuId);
   $queue->getById( $self->connection );
   
   dlog("Spawning recon job for PVU job ID $reconPvuId");

   my $recon = Recon::Pvu->new( $self->connection, $queue );
   $recon->recon;

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
 dlog('Begin loadQueue method of ReconEnginePvu');

 my @queue;

 ###Prepare the query
 $self->connection->prepareSqlQueryAndFields( $self->queryReconPvuQueue() );

 ###Acquire the statement handle
 my $sth = $self->connection->sql->{reconPvuQueue};

 ###Bind our columns
 my %rec;
 $sth->bind_columns( map { \$rec{$_} }
    @{ $self->connection->sql->{reconPvuQueueFields} } );

 ###Excute the query
 $sth->execute;

 ###Loop over query result set.
 while ( $sth->fetchrow_arrayref ) {

  ###Clean record values
  cleanValues( \%rec );

  ###Upper case record values
  upperValues( \%rec );

  ###Add to our queue hash
  push @queue, $rec{id};
 }
 $sth->finish;

 ###Set our queue attribute
 $self->queue( \@queue );
}

sub queryReconPvuQueue {
 my @fields = qw(
   id
 );
 my $query = '
        select
            a.id
        from
            recon_pvu a
        order by 
            a.record_time asc
        fetch first 1 rows only with ur
    ';
 dlog("queryReconPvuQueue=$query");
 return ( 'reconPvuQueue', $query, \@fields );
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
