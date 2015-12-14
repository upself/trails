package integration::reconEngine::ReconInstalledSoftware;

use strict;
use Base::Utils;

sub new {
 my ($class) = @_;
 my $self = {
  _id                  => undef,
  _installedSoftwareId => undef,
  _customerId          => undef,
  _action              => undef,
  _remoteUser          => 'STAGING',
  _recordTime          => undef,
  _table               => 'recon_installed_sw',
  _idField             => 'id'
 };
 bless $self, $class;
 return $self;
}

sub equals {
 my ( $self, $object ) = @_;
 my $equal;

 $equal = 0;
 if (defined $self->installedSoftwareId
  && defined $object->installedSoftwareId )
 {
  $equal = 1 if $self->installedSoftwareId eq $object->installedSoftwareId;
 }
 $equal = 1
   if ( !defined $self->installedSoftwareId
  && !defined $object->installedSoftwareId );
 return 0 if $equal == 0;

 $equal = 0;
 if ( defined $self->customerId && defined $object->customerId ) {
  $equal = 1 if $self->customerId eq $object->customerId;
 }
 $equal = 1 if ( !defined $self->customerId && !defined $object->customerId );
 return 0 if $equal == 0;

 $equal = 0;
 if ( defined $self->action && defined $object->action ) {
  $equal = 1 if $self->action eq $object->action;
 }
 $equal = 1 if ( !defined $self->action && !defined $object->action );
 return 0 if $equal == 0;

 $equal = 0;
 if ( defined $self->table && defined $object->table ) {
  $equal = 1 if $self->table eq $object->table;
 }
 $equal = 1 if ( !defined $self->table && !defined $object->table );
 return 0 if $equal == 0;

 $equal = 0;
 if ( defined $self->idField && defined $object->idField ) {
  $equal = 1 if $self->idField eq $object->idField;
 }
 $equal = 1 if ( !defined $self->idField && !defined $object->idField );
 return 0 if $equal == 0;

 return 1;
}

sub id {
 my $self = shift;
 $self->{_id} = shift if scalar @_ == 1;
 return $self->{_id};
}

sub installedSoftwareId {
 my $self = shift;
 $self->{_installedSoftwareId} = shift if scalar @_ == 1;
 return $self->{_installedSoftwareId};
}

sub customerId {
 my $self = shift;
 $self->{_customerId} = shift if scalar @_ == 1;
 return $self->{_customerId};
}

sub action {
 my $self = shift;
 $self->{_action} = shift if scalar @_ == 1;
 return $self->{_action};
}

sub remoteUser {
 my $self = shift;
 $self->{_remoteUser} = shift if scalar @_ == 1;
 return $self->{_remoteUser};
}

sub recordTime {
 my $self = shift;
 $self->{_recordTime} = shift if scalar @_ == 1;
 return $self->{_recordTime};
}

sub table {
 my $self = shift;
 $self->{_table} = shift if scalar @_ == 1;
 return $self->{_table};
}

sub idField {
 my $self = shift;
 $self->{_idField} = shift if scalar @_ == 1;
 return $self->{_idField};
}

sub toString {
 my ($self) = @_;
 my $s = "[ReconInstalledSoftware] ";
 $s .= "id=";
 if ( defined $self->{_id} ) {
  $s .= $self->{_id};
 }
 $s .= ",";
 $s .= "installedSoftwareId=";
 if ( defined $self->{_installedSoftwareId} ) {
  $s .= $self->{_installedSoftwareId};
 }
 $s .= ",";
 $s .= "customerId=";
 if ( defined $self->{_customerId} ) {
  $s .= $self->{_customerId};
 }
 $s .= ",";
 $s .= "action=";
 if ( defined $self->{_action} ) {
  $s .= $self->{_action};
 }
 $s .= ",";
 $s .= "remoteUser=";
 if ( defined $self->{_remoteUser} ) {
  $s .= $self->{_remoteUser};
 }
 $s .= ",";
 $s .= "recordTime=";
 if ( defined $self->{_recordTime} ) {
  $s .= $self->{_recordTime};
 }
 $s .= ",";
 $s .= "table=";
 if ( defined $self->{_table} ) {
  $s .= $self->{_table};
 }
 $s .= ",";
 $s .= "idField=";
 if ( defined $self->{_idField} ) {
  $s .= $self->{_idField};
 }
 $s .= ",";
 chop $s;
 return $s;
}

sub save {
 my ( $self, $connection ) = @_;
 ilog( "saving: " . $self->toString() );
 if ( !defined $self->id ) {
  $connection->prepareSqlQuery( $self->queryInsert() );
  my $sth = $connection->sql->{insertReconInstalledSoftware};
  my $id;
  $sth->bind_columns( \$id );
  $sth->execute( $self->installedSoftwareId, $self->customerId, $self->action,
   $self->remoteUser, $self->recordTime );
  $sth->fetchrow_arrayref;
  $sth->finish;
  $self->id($id);
 }
 else {
  $connection->prepareSqlQuery( $self->queryUpdate );
  my $sth = $connection->sql->{updateReconInstalledSoftware};
  $sth->execute(
   $self->installedSoftwareId, $self->customerId, $self->action,
   $self->remoteUser,          $self->recordTime, 
   $self->id
  );
  $sth->finish;
 }
}

sub queryInsert {
 my $query = '
        select
            id
        from
            final table (
        insert into recon_installed_sw (
            installed_software_id
            ,customer_id
            ,action
            ,remote_user
            ,record_time
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
 return ( 'insertReconInstalledSoftware', $query );
}

sub queryUpdate {
 my $query = '
        update recon_installed_sw
        set
            installed_software_id = ?
            ,customer_id = ?
            ,action = ?
            ,remote_user = ?
            ,record_time = ?
        where
            id = ?
    ';
 return ( 'updateReconInstalledSoftware', $query );
}

sub delete {
 my ( $self, $connection ) = @_;
 ilog( "deleting: " . $self->toString() );
 if ( defined $self->id ) {
  $connection->prepareSqlQuery( $self->queryDelete() );
  my $sth = $connection->sql->{deleteReconInstalledSoftware};
  $sth->execute( $self->id );
  $sth->finish;
 }
}

sub queryDelete {
 my $query = '
        delete from recon_installed_sw
        where
            id = ?
    ';
 return ( 'deleteReconInstalledSoftware', $query );
}

sub getByBizKey {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryGetByBizKey() );
 my $sth = $connection->sql->{getByBizKeyReconInstalledSoftware};
 my $id;
 my $customerId;
 my $remoteUser;
 my $recordTime;
 $sth->bind_columns( \$id, \$customerId, \$remoteUser, \$recordTime );
 $sth->execute( $self->installedSoftwareId, $self->action );
 $sth->fetchrow_arrayref;
 $sth->finish;
 $self->id($id);
 $self->customerId($customerId);
 $self->remoteUser($remoteUser);
 $self->recordTime($recordTime);
}

sub queryGetByBizKey {
 my $query = '
        select
            id
            ,customer_id
            ,remote_user
            ,record_time
        from
            recon_installed_sw
        where
            installed_software_id = ?
            and action = ?
     with ur';
 return ( 'getByBizKeyReconInstalledSoftware', $query );
}

sub getById {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryGetById() );
 my $sth = $connection->sql->{getByIdKeyReconInstalledSoftware};
 my $installedSoftwareId;
 my $customerId;
 my $action;
 my $remoteUser;
 my $recordTime;
 $sth->bind_columns( \$installedSoftwareId, \$customerId, \$action,
  \$remoteUser, \$recordTime );
 $sth->execute( $self->id );
 my $found = $sth->fetchrow_arrayref;
 $sth->finish;
 $self->installedSoftwareId($installedSoftwareId);
 $self->customerId($customerId);
 $self->action($action);
 $self->remoteUser($remoteUser);
 $self->recordTime($recordTime);
 return ( defined $found ) ? 1 : 0;
}

sub queryGetById {
 my $query = '
        select
            installed_software_id
            ,customer_id
            ,action
            ,remote_user
            ,record_time
        from
            recon_installed_sw
        where
            id = ?
     with ur';
 return ( 'getByIdKeyReconInstalledSoftware', $query );
}

1;
