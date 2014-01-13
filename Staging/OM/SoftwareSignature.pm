package Staging::OM::SoftwareSignature;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
        ,_softwareSignatureId => undef
        ,_softwareId => undef
        ,_action => undef
        ,_path => undef
        ,_table => 'software_signature'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->scanRecordId && defined $object->scanRecordId) {
        $equal = 1 if $self->scanRecordId eq $object->scanRecordId;
    }
    $equal = 1 if (!defined $self->scanRecordId && !defined $object->scanRecordId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareSignatureId && defined $object->softwareSignatureId) {
        $equal = 1 if $self->softwareSignatureId eq $object->softwareSignatureId;
    }
    $equal = 1 if (!defined $self->softwareSignatureId && !defined $object->softwareSignatureId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->softwareId && defined $object->softwareId) {
        $equal = 1 if $self->softwareId eq $object->softwareId;
    }
    $equal = 1 if (!defined $self->softwareId && !defined $object->softwareId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
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

sub softwareId {
    my $self = shift;
    $self->{_softwareId} = shift if scalar @_ == 1;
    return $self->{_softwareId};
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
    my $s = "[SoftwareSignature] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "scanRecordId=";
    if (defined $self->{_scanRecordId}) {
        $s .= $self->{_scanRecordId};
    }
    $s .= ",";
    $s .= "softwareSignatureId=";
    if (defined $self->{_softwareSignatureId}) {
        $s .= $self->{_softwareSignatureId};
    }
    $s .= ",";
    $s .= "softwareId=";
    if (defined $self->{_softwareId}) {
        $s .= $self->{_softwareId};
    }
    $s .= ",";
    $s .= "action=";
    if (defined $self->{_action}) {
        $s .= $self->{_action};
    }
    $s .= ",";
    $s .= "path=";
    if (defined $self->{_path}) {
        $s .= $self->{_path};
    }
    $s .= ",";
    $s .= "table=";
    if (defined $self->{_table}) {
        $s .= $self->{_table};
    }
    $s .= ",";
    $s .= "idField=";
    if (defined $self->{_idField}) {
        $s .= $self->{_idField};
    }
    $s .= ",";
    chop $s;
    return $s;
}

sub save {
    my($self, $connection) = @_;
    ilog("saving: ".$self->toString());
    if( ! defined $self->id ) {
        $connection->prepareSqlQuery($self->queryInsert());
        my $sth = $connection->sql->{insertSoftwareSignature};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
            ,$self->softwareSignatureId
            ,$self->softwareId
            ,$self->action
            ,$self->path
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftwareSignature};
        $sth->execute(
            $self->scanRecordId
            ,$self->softwareSignatureId
            ,$self->softwareId
            ,$self->action
            ,$self->path
            ,$self->id
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
        insert into software_signature (
            scan_record_id
            ,software_signature_id
            ,software_id
            ,action
            ,path
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertSoftwareSignature', $query);
}

sub queryUpdate {
    my $query = '
        update software_signature
        set
            scan_record_id = ?
            ,software_signature_id = ?
            ,software_id = ?
            ,action = ?
            ,path = ?
        where
            id = ?
    ';
    return ('updateSoftwareSignature', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftwareSignature};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_signature a where
            a.id = ?
    ';
    return ('deleteSoftwareSignature', $query);
}

1;
