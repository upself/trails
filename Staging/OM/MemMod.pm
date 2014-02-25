package Staging::OM::MemMod;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_scanRecordId => undef
        ,_instMemId => undef
        ,_moduleSizeMb => undef
        ,_maxModuleSizeMb => undef
        ,_socketName => undef
        ,_packaging => undef
        ,_memType => undef
        ,_action => undef
        ,_table => 'mem_mod'
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
    if (defined $self->instMemId && defined $object->instMemId) {
        $equal = 1 if $self->instMemId eq $object->instMemId;
    }
    $equal = 1 if (!defined $self->instMemId && !defined $object->instMemId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->moduleSizeMb && defined $object->moduleSizeMb) {
        $equal = 1 if $self->moduleSizeMb eq $object->moduleSizeMb;
    }
    $equal = 1 if (!defined $self->moduleSizeMb && !defined $object->moduleSizeMb);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->maxModuleSizeMb && defined $object->maxModuleSizeMb) {
        $equal = 1 if $self->maxModuleSizeMb eq $object->maxModuleSizeMb;
    }
    $equal = 1 if (!defined $self->maxModuleSizeMb && !defined $object->maxModuleSizeMb);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->socketName && defined $object->socketName) {
        $equal = 1 if $self->socketName eq $object->socketName;
    }
    $equal = 1 if (!defined $self->socketName && !defined $object->socketName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->packaging && defined $object->packaging) {
        $equal = 1 if $self->packaging eq $object->packaging;
    }
    $equal = 1 if (!defined $self->packaging && !defined $object->packaging);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->memType && defined $object->memType) {
        $equal = 1 if $self->memType eq $object->memType;
    }
    $equal = 1 if (!defined $self->memType && !defined $object->memType);
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

sub instMemId {
    my $self = shift;
    $self->{_instMemId} = shift if scalar @_ == 1;
    return $self->{_instMemId};
}

sub moduleSizeMb {
    my $self = shift;
    $self->{_moduleSizeMb} = shift if scalar @_ == 1;
    return $self->{_moduleSizeMb};
}

sub maxModuleSizeMb {
    my $self = shift;
    $self->{_maxModuleSizeMb} = shift if scalar @_ == 1;
    return $self->{_maxModuleSizeMb};
}

sub socketName {
    my $self = shift;
    $self->{_socketName} = shift if scalar @_ == 1;
    return $self->{_socketName};
}

sub packaging {
    my $self = shift;
    $self->{_packaging} = shift if scalar @_ == 1;
    return $self->{_packaging};
}

sub memType {
    my $self = shift;
    $self->{_memType} = shift if scalar @_ == 1;
    return $self->{_memType};
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
    my $s = "[MemMod] ";
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
    $s .= "instMemId=";
    if (defined $self->{_instMemId}) {
        $s .= $self->{_instMemId};
    }
    $s .= ",";
    $s .= "moduleSizeMb=";
    if (defined $self->{_moduleSizeMb}) {
        $s .= $self->{_moduleSizeMb};
    }
    $s .= ",";
    $s .= "maxModuleSizeMb=";
    if (defined $self->{_maxModuleSizeMb}) {
        $s .= $self->{_maxModuleSizeMb};
    }
    $s .= ",";
    $s .= "socketName=";
    if (defined $self->{_socketName}) {
        $s .= $self->{_socketName};
    }
    $s .= ",";
    $s .= "packaging=";
    if (defined $self->{_packaging}) {
        $s .= $self->{_packaging};
    }
    $s .= ",";
    $s .= "memType=";
    if (defined $self->{_memType}) {
        $s .= $self->{_memType};
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
        my $sth = $connection->sql->{insertMemMod};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->scanRecordId
            ,$self->instMemId
            ,$self->moduleSizeMb
            ,$self->maxModuleSizeMb
            ,$self->socketName
            ,$self->packaging
            ,$self->memType
            ,$self->action
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateMemMod};
        $sth->execute(
            $self->scanRecordId
            ,$self->instMemId
            ,$self->moduleSizeMb
            ,$self->maxModuleSizeMb
            ,$self->socketName
            ,$self->packaging
            ,$self->memType
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
        insert into mem_mod (
            scan_record_id
            ,inst_mem_id
            ,module_size_mb
            ,max_module_size_mb
            ,socket_name
            ,packaging
            ,mem_type
            ,action
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertMemMod', $query);
}

sub queryUpdate {
    my $query = '
        update mem_mod
        set
            scan_record_id = ?
            ,inst_mem_id = ?
            ,module_size_mb = ?
            ,max_module_size_mb = ?
            ,socket_name = ?
            ,packaging = ?
            ,mem_type = ?
            ,action = ?
        where
            id = ?
    ';
    return ('updateMemMod', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteMemMod};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from mem_mod
        where
            id = ?
    ';
    return ('deleteMemMod', $query);
}

1;
