package BRAVO::OM::MemMod;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_instMemId => undef
        ,_moduleSizeMb => undef
        ,_maxModuleSizeMb => undef
        ,_socketName => undef
        ,_packaging => undef
        ,_memType => undef
        ,_table => 'software_lpar_mem_mod'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

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

sub softwareLparId {
    my $self = shift;
    $self->{_softwareLparId} = shift if scalar @_ == 1;
    return $self->{_softwareLparId};
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
    $s .= "softwareLparId=";
    if (defined $self->{_softwareLparId}) {
        $s .= $self->{_softwareLparId};
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
            $self->softwareLparId
            ,$self->instMemId
            ,$self->moduleSizeMb
            ,$self->maxModuleSizeMb
            ,$self->socketName
            ,$self->packaging
            ,$self->memType
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateMemMod};
        $sth->execute(
            $self->softwareLparId
            ,$self->instMemId
            ,$self->moduleSizeMb
            ,$self->maxModuleSizeMb
            ,$self->socketName
            ,$self->packaging
            ,$self->memType
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
        insert into software_lpar_mem_mod (
            software_lpar_id
            ,inst_mem_id
            ,module_size_mb
            ,max_module_size_mb
            ,socket_name
            ,packaging
            ,mem_type
        ) values (
            ?
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
        update software_lpar_mem_mod
        set
            software_lpar_id = ?
            ,inst_mem_id = ?
            ,module_size_mb = ?
            ,max_module_size_mb = ?
            ,socket_name = ?
            ,packaging = ?
            ,mem_type = ?
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
        delete from software_lpar_mem_mod
        where
            id = ?
    ';
    return ('deleteMemMod', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyMemMod};
    my $id;
    my $moduleSizeMb;
    my $maxModuleSizeMb;
    my $socketName;
    my $packaging;
    my $memType;
    $sth->bind_columns(
        \$id
        ,\$moduleSizeMb
        ,\$maxModuleSizeMb
        ,\$socketName
        ,\$packaging
        ,\$memType
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->instMemId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->moduleSizeMb($moduleSizeMb);
    $self->maxModuleSizeMb($maxModuleSizeMb);
    $self->socketName($socketName);
    $self->packaging($packaging);
    $self->memType($memType);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,module_size_mb
            ,max_module_size_mb
            ,socket_name
            ,packaging
            ,mem_type
        from
            software_lpar_mem_mod
        where
            software_lpar_id = ?
            and inst_mem_id = ?
     with ur';
    return ('getByBizKeyMemMod', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyMemMod};
    my $softwareLparId;
    my $instMemId;
    my $moduleSizeMb;
    my $maxModuleSizeMb;
    my $socketName;
    my $packaging;
    my $memType;
    $sth->bind_columns(
        \$softwareLparId
        ,\$instMemId
        ,\$moduleSizeMb
        ,\$maxModuleSizeMb
        ,\$socketName
        ,\$packaging
        ,\$memType
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->instMemId($instMemId);
    $self->moduleSizeMb($moduleSizeMb);
    $self->maxModuleSizeMb($maxModuleSizeMb);
    $self->socketName($socketName);
    $self->packaging($packaging);
    $self->memType($memType);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,inst_mem_id
            ,module_size_mb
            ,max_module_size_mb
            ,socket_name
            ,packaging
            ,mem_type
        from
            software_lpar_mem_mod
        where
            id = ?
     with ur';
    return ('getByIdKeyMemMod', $query);
}

1;
