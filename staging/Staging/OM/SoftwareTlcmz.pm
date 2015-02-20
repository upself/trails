package Staging::OM::SoftwareTlcmz;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
        ,_softwareTlcmzId => undef
        ,_softwareId => undef
        ,_action => undef
        ,_table => 'software_tlcmz'
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
    if (defined $self->softwareTlcmzId && defined $object->softwareTlcmzId) {
        $equal = 1 if $self->softwareTlcmzId eq $object->softwareTlcmzId;
    }
    $equal = 1 if (!defined $self->softwareTlcmzId && !defined $object->softwareTlcmzId);
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

sub softwareTlcmzId {
    my $self = shift;
    $self->{_softwareTlcmzId} = shift if scalar @_ == 1;
    return $self->{_softwareTlcmzId};
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
    my $s = "[SoftwareTlcmz] ";
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
    $s .= "softwareTlcmzId=";
    if (defined $self->{_softwareTlcmzId}) {
        $s .= $self->{_softwareTlcmzId};
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
        my $sth = $connection->sql->{insertSoftwareTlcmz};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
            ,$self->softwareTlcmzId
            ,$self->softwareId
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateSoftwareTlcmz};
        $sth->execute(
            $self->scanRecordId
            ,$self->softwareTlcmzId
            ,$self->softwareId
            ,$self->action
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
        insert into software_tlcmz (
            scan_record_id
            ,sa_product_id
            ,software_id
            ,action
        ) values (
            ?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertSoftwareTlcmz', $query);
}

sub queryUpdate {
    my $query = '
        update software_tlcmz
        set
            scan_record_id = ?
            ,sa_product_id = ?
            ,software_id = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateSoftwareTlcmz', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteSoftwareTlcmz};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_tlcmz
        where
            id = ?
    ';
    return ('deleteSoftwareTlcmz', $query);
}

1;
