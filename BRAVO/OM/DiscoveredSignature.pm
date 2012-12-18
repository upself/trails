package BRAVO::OM::DiscoveredSignature;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_path => undef
        ,_type => undef
        ,_signatureId => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->path && defined $object->path) {
        $equal = 1 if $self->path eq $object->path;
    }
    $equal = 1 if (!defined $self->path && !defined $object->path);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->type && defined $object->type) {
        $equal = 1 if $self->type eq $object->type;
    }
    $equal = 1 if (!defined $self->type && !defined $object->type);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->signatureId && defined $object->signatureId) {
        $equal = 1 if $self->signatureId eq $object->signatureId;
    }
    $equal = 1 if (!defined $self->signatureId && !defined $object->signatureId);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub path {
    my $self = shift;
    $self->{_path} = shift if scalar @_ == 1;
    return $self->{_path};
}

sub type {
    my $self = shift;
    $self->{_type} = shift if scalar @_ == 1;
    return $self->{_type};
}

sub signatureId {
    my $self = shift;
    $self->{_signatureId} = shift if scalar @_ == 1;
    return $self->{_signatureId};
}

sub toString {
    my ($self) = @_;
    my $s = "[DiscoveredSignature] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "path=";
    if (defined $self->{_path}) {
        $s .= $self->{_path};
    }
    $s .= ",";
    $s .= "type=";
    if (defined $self->{_type}) {
        $s .= $self->{_type};
    }
    $s .= ",";
    $s .= "signatureId=";
    if (defined $self->{_signatureId}) {
        $s .= $self->{_signatureId};
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
        my $sth = $connection->sql->{insertDiscoveredSignature};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->path
            ,$self->type
            ,$self->signatureId
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateDiscoveredSignature};
        $sth->execute(
            $self->path
            ,$self->type
            ,$self->signatureId
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
        insert into discovered_signature (
            path
            ,type
            ,signature_id
        ) values (
            ?
            ,?
            ,?
        ))
    ';
    return ('insertDiscoveredSignature', $query);
}

sub queryUpdate {
    my $query = '
        update discovered_signature
        set
            path = ?
            ,type = ?
            ,signature_id = ?
        where
            id = ?
    ';
    return ('updateDiscoveredSignature', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteDiscoveredSignature};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from discovered_signature
        where
            id = ?
    ';
    return ('deleteDiscoveredSignature', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyDiscoveredSignature};
    my $path;
    my $type;
    my $signatureId;
    $sth->bind_columns(
        \$path
        ,\$type
        ,\$signatureId
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->path($path);
    $self->type($type);
    $self->signatureId($signatureId);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            path
            ,type
            ,signature_id
        from
            discovered_signature
        where
            id = ?
    ';
    return ('getByIdKeyDiscoveredSignature', $query);
}

1;
