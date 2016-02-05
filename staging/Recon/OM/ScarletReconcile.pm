package Recon::OM::ScarletReconcile;

use strict;
use Base::Utils;

sub new {
 my ($class) = @_;
 my $self = {
  _id               => undef,
  _lastValidateTime => undef,
  _reconcileMd5Hex  => undef
 };
 bless $self, $class;
 return $self;
}

sub equals {
 my ( $self, $object ) = @_;
 my $equal;

 return 1;
}

sub id {
 my $self = shift;
 $self->{_id} = shift if scalar @_ == 1;
 return $self->{_id};
}

sub lastValidateTime {
 my $self = shift;
 $self->{_lastValidateTime} = shift if scalar @_ == 1;
 return $self->{_lastValidateTime};
}

sub reconcileMd5Hex {
 my $self = shift;
 $self->{_reconcileMd5Hex} = shift if scalar @_ == 1;
 return $self->{_reconcileMd5Hex};
}

sub toString {
 my ($self) = @_;
 my $s = "[ScarletReconcile] ";
 $s .= "id=";
 if ( defined $self->{_id} ) {
  $s .= $self->{_id};
 }
 $s .= ",";
 $s .= "lastValidateTime=";
 if ( defined $self->{_lastValidateTime} ) {
  $s .= $self->{_lastValidateTime};
 }
 $s .= ",";
 $s .= "reconcileMd5Hex=";
 if ( defined $self->{_reconcileMd5Hex} ) {
  $s .= $self->{_reconcileMd5Hex};
 }
 $s .= ",";
 chop $s;
 return $s;
}

sub save {
 my ( $self, $connection ) = @_;
 ilog( "saving: " . $self->toString() );

 $connection->prepareSqlQuery( $self->queryInsert() );
 my $sth = $connection->sql->{insertScarletReconcile};
 $sth->execute( $self->id, $self->reconcileMd5Hex );
 $sth->finish;
}

sub queryInsert {
 my $query = '
        insert into scarlet_reconcile (
            id,
            last_validate_time,
            reconcile_md5_hex
        ) values (
            ?, current timestamp,? 
        )
    ';
 return ( 'insertScarletReconcile', $query );
}

sub update {
 my ( $self, $connection ) = @_;
 ilog( "updating: " . $self->toString() );

 $connection->prepareSqlQuery( $self->queryUpdate );
 my $sth = $connection->sql->{updateScarletReconcile};
 $sth->execute( $self->reconcileMd5Hex, $self->id );
 $sth->finish;
}

sub queryUpdate {
 my $query = '
        update scarlet_reconcile
        set
            last_validate_time = current timestamp,
            reconcile_md5_hex = ?
        where
          id =? 
    ';
 return ( 'updateScarletReconcile', $query );
}

sub delete {
 my ( $self, $connection ) = @_;
 ilog( "deleting: " . $self->toString() );
 if ( defined $self->id ) {
  $connection->prepareSqlQuery( $self->queryDelete() );
  my $sth = $connection->sql->{deleteScarletReconcile};
  $sth->execute( $self->id );
  $sth->finish;
 }
}

sub queryDelete {
 my $query = '
        delete from scarlet_reconcile
        where
        id =?
    ';
 return ( 'deleteScarletReconcile', $query );
}

sub getByBizKey {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryGetByBizKey() );
 my $sth = $connection->sql->{getByBizKeyScarletReconcile};
 my $lastValidateTime;
 my $reconcileMd5Hex;
 $sth->bind_columns( \$lastValidateTime, \$reconcileMd5Hex );
 $sth->execute( $self->id );
 $sth->fetchrow_arrayref;
 $sth->finish;
 $self->lastValidateTime($lastValidateTime);
 $self->reconcileMd5Hex($reconcileMd5Hex);    
}

sub queryGetByBizKey {
 my $query = '
        select
            last_validate_time,
            reconcile_md5_hex
        from
            scarlet_reconcile
        where
            id = ?
     with ur';
 return ( 'getByBizKeyScarletReconcile', $query );
}

1;
