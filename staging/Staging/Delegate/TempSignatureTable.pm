package Staging::Delegate::TempSignatureTable;

use strict;
use Base::Utils;

sub new {
 my ($class) = @_;
 my $self = {
  _softwareId          => undef,
  _scanRecordId        => undef,
  _softwareSignatureId => undef,
  _action              => undef,
  _path                => undef,
  _id                  => undef,
  _bankAccount         => undef
 };
 bless $self, $class;
 return $self;
}

sub softwareId {
 my $self = shift;
 $self->{_softwareId} = shift if scalar @_ == 1;
 return $self->{_softwareId};
}

sub scanRecordId {
 my $self = shift;
 $self->{_scanRecordId} = shift if scalar @_ == 1;
 return $self->{_scanRecordId};
}

sub softwareSignatureId {
 my $self = shift;
 $self->{_softwareSignatureId} = shift if scalar @_ == 1;
 return $self->{_softwareSignatureId};
}

sub action {
 my $self = shift;
 $self->{_action} = shift if scalar @_ == 1;
 return $self->{_action};
}

sub path {
 my $self = shift;
 $self->{_path} = shift if scalar @_ == 1;
 return $self->{_path};
}

sub id {
 my $self = shift;
 $self->{_id} = shift if scalar @_ == 1;
 return $self->{_id};
}

sub bankAccount {
 my $self = shift;
 $self->{_bankAccount} = shift if scalar @_ == 1;
 return $self->{_bankAccount};
}

sub save {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryInsert() );
 my $sth = $connection->sql->{insertTEMP_SIGNATURE};
 $sth->execute( $self->softwareId, $self->scanRecordId,
  $self->softwareSignatureId, $self->action, $self->path,$self->id );
 $sth->finish;

}

sub queryInsert {
 my $self  = shift;
 my $query = '
         insert into TEMP_SIGNATURE_' . $self->bankAccount->name . ' (
            software_id
            ,scan_record_id
            ,software_signature_id
            ,action
            ,path
            ,id
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
        )
    ';
 return ( 'insertTEMP_SIGNATURE', $query );
}

sub update {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryUpdate );
 my $sth = $connection->sql->{updateTEMP_SIGNATURE};
 $sth->execute( $self->action, $self->path, $self->id, $self->scanRecordId,
  $self->softwareSignatureId, $self->softwareId );
 $sth->finish;
}

sub queryUpdate {
 my $self  = shift;
 my $query = '
        update TEMP_SIGNATURE_' . $self->bankAccount->name . '
        set           
             action = ?
            ,path = ?
            ,id = ?
        where
            scan_record_id = ?
            and software_signature_id = ?
            and software_id = ?
    ';
 return ( 'updateTEMP_SIGNATURE', $query );
}

sub delete {
 my ( $self, $connection ) = @_;
 if ( defined $self->id ) {
  $connection->prepareSqlQuery( $self->queryDelete() );
  my $sth = $connection->sql->{deleteTEMP_SIGNATURE};
  $sth->execute( $self->softwareId, $self->scanRecordId,
   $self->softwareSignatureId );
  $sth->finish;
 }
}

sub queryDelete {
 my $self  = shift;
 my $query = '
        delete from TEMP_SIGNATURE_' . $self->bankAccount->name . '
        where 
            software_id = ?
            and scan_record_id = ?
            and software_signature_id =?
    ';
 return ( 'deleteTEMP_SIGNATURE', $query );
}

sub getByBizKey {
 my ( $self, $connection ) = @_;
 $connection->prepareSqlQuery( $self->queryGetByBizKey() );
 my $sth = $connection->sql->{getByBizKeyTEMP_SIGNATURE};
 my $action;
 my $path;
 my $id;
 $sth->bind_columns( \$action, \$path, \$id );
 $sth->execute( $self->softwareId, $self->scanRecordId,
  $self->softwareSignatureId );
 $sth->fetchrow_arrayref;
 $sth->finish;
 $self->action($action);
 $self->path($path);
 $self->id($id);
}

sub queryGetByBizKey {
 my $self = shift;

 my $query = '
        select
            action
            ,path
            ,id
        from
            TEMP_SIGNATURE_' . $self->bankAccount->name . '
        where
            software_id = ?
            and scan_record_id = ?
            and software_signature_id = ?
    ';
 return ( 'getByBizKeyTEMP_SIGNATURE', $query );
}

1;
