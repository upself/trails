package BRAVO::OM::Processor;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_softwareLparId => undef
        ,_processorNum => undef
        ,_manufacturer => undef
        ,_model => undef
        ,_maxSpeed => undef
        ,_busSpeed => undef
        ,_serialNumber => undef
        ,_isActive => undef
        ,_numBoards => undef
        ,_numModules => undef
        ,_pvu => undef
        ,_cache => undef
        ,_currentSpeed => undef
        ,_table => 'software_lpar_processor'
        ,_idField => 'id'
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->softwareLparId && defined $object->softwareLparId) {
        $equal = 1 if $self->softwareLparId eq $object->softwareLparId;
    }
    $equal = 1 if (!defined $self->softwareLparId && !defined $object->softwareLparId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorNum && defined $object->processorNum) {
        $equal = 1 if $self->processorNum eq $object->processorNum;
    }
    $equal = 1 if (!defined $self->processorNum && !defined $object->processorNum);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->manufacturer && defined $object->manufacturer) {
        $equal = 1 if $self->manufacturer eq $object->manufacturer;
    }
    $equal = 1 if (!defined $self->manufacturer && !defined $object->manufacturer);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->model && defined $object->model) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if (!defined $self->model && !defined $object->model);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->maxSpeed && defined $object->maxSpeed) {
        $equal = 1 if $self->maxSpeed eq $object->maxSpeed;
    }
    $equal = 1 if (!defined $self->maxSpeed && !defined $object->maxSpeed);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->busSpeed && defined $object->busSpeed) {
        $equal = 1 if $self->busSpeed eq $object->busSpeed;
    }
    $equal = 1 if (!defined $self->busSpeed && !defined $object->busSpeed);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->serialNumber && defined $object->serialNumber) {
        $equal = 1 if $self->serialNumber eq $object->serialNumber;
    }
    $equal = 1 if (!defined $self->serialNumber && !defined $object->serialNumber);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isActive && defined $object->isActive) {
        $equal = 1 if $self->isActive eq $object->isActive;
    }
    $equal = 1 if (!defined $self->isActive && !defined $object->isActive);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->numBoards && defined $object->numBoards) {
        $equal = 1 if $self->numBoards eq $object->numBoards;
    }
    $equal = 1 if (!defined $self->numBoards && !defined $object->numBoards);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->numModules && defined $object->numModules) {
        $equal = 1 if $self->numModules eq $object->numModules;
    }
    $equal = 1 if (!defined $self->numModules && !defined $object->numModules);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->pvu && defined $object->pvu) {
        $equal = 1 if $self->pvu eq $object->pvu;
    }
    $equal = 1 if (!defined $self->pvu && !defined $object->pvu);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cache && defined $object->cache) {
        $equal = 1 if $self->cache eq $object->cache;
    }
    $equal = 1 if (!defined $self->cache && !defined $object->cache);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->currentSpeed && defined $object->currentSpeed) {
        $equal = 1 if $self->currentSpeed eq $object->currentSpeed;
    }
    $equal = 1 if (!defined $self->currentSpeed && !defined $object->currentSpeed);
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

sub processorNum {
    my $self = shift;
    $self->{_processorNum} = shift if scalar @_ == 1;
    return $self->{_processorNum};
}

sub manufacturer {
    my $self = shift;
    $self->{_manufacturer} = shift if scalar @_ == 1;
    return $self->{_manufacturer};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub maxSpeed {
    my $self = shift;
    $self->{_maxSpeed} = shift if scalar @_ == 1;
    return $self->{_maxSpeed};
}

sub busSpeed {
    my $self = shift;
    $self->{_busSpeed} = shift if scalar @_ == 1;
    return $self->{_busSpeed};
}

sub serialNumber {
    my $self = shift;
    $self->{_serialNumber} = shift if scalar @_ == 1;
    return $self->{_serialNumber};
}

sub isActive {
    my $self = shift;
    $self->{_isActive} = shift if scalar @_ == 1;
    return $self->{_isActive};
}

sub numBoards {
    my $self = shift;
    $self->{_numBoards} = shift if scalar @_ == 1;
    return $self->{_numBoards};
}

sub numModules {
    my $self = shift;
    $self->{_numModules} = shift if scalar @_ == 1;
    return $self->{_numModules};
}

sub pvu {
    my $self = shift;
    $self->{_pvu} = shift if scalar @_ == 1;
    return $self->{_pvu};
}

sub cache {
    my $self = shift;
    $self->{_cache} = shift if scalar @_ == 1;
    return $self->{_cache};
}

sub currentSpeed {
    my $self = shift;
    $self->{_currentSpeed} = shift if scalar @_ == 1;
    return $self->{_currentSpeed};
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
    my $s = "[Processor] ";
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
    $s .= "processorNum=";
    if (defined $self->{_processorNum}) {
        $s .= $self->{_processorNum};
    }
    $s .= ",";
    $s .= "manufacturer=";
    if (defined $self->{_manufacturer}) {
        $s .= $self->{_manufacturer};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "maxSpeed=";
    if (defined $self->{_maxSpeed}) {
        $s .= $self->{_maxSpeed};
    }
    $s .= ",";
    $s .= "busSpeed=";
    if (defined $self->{_busSpeed}) {
        $s .= $self->{_busSpeed};
    }
    $s .= ",";
    $s .= "serialNumber=";
    if (defined $self->{_serialNumber}) {
        $s .= $self->{_serialNumber};
    }
    $s .= ",";
    $s .= "isActive=";
    if (defined $self->{_isActive}) {
        $s .= $self->{_isActive};
    }
    $s .= ",";
    $s .= "numBoards=";
    if (defined $self->{_numBoards}) {
        $s .= $self->{_numBoards};
    }
    $s .= ",";
    $s .= "numModules=";
    if (defined $self->{_numModules}) {
        $s .= $self->{_numModules};
    }
    $s .= ",";
    $s .= "pvu=";
    if (defined $self->{_pvu}) {
        $s .= $self->{_pvu};
    }
    $s .= ",";
    $s .= "cache=";
    if (defined $self->{_cache}) {
        $s .= $self->{_cache};
    }
    $s .= ",";
    $s .= "currentSpeed=";
    if (defined $self->{_currentSpeed}) {
        $s .= $self->{_currentSpeed};
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
        my $sth = $connection->sql->{insertProcessor};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->softwareLparId
            ,$self->processorNum
            ,$self->manufacturer
            ,$self->model
            ,$self->maxSpeed
            ,$self->busSpeed
            ,$self->serialNumber
            ,$self->isActive
            ,$self->numBoards
            ,$self->numModules
            ,$self->pvu
            ,$self->cache
            ,$self->currentSpeed
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateProcessor};
        $sth->execute(
            $self->softwareLparId
            ,$self->processorNum
            ,$self->manufacturer
            ,$self->model
            ,$self->maxSpeed
            ,$self->busSpeed
            ,$self->serialNumber
            ,$self->isActive
            ,$self->numBoards
            ,$self->numModules
            ,$self->pvu
            ,$self->cache
            ,$self->currentSpeed
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
        insert into software_lpar_processor (
            software_lpar_id
            ,processor_num
            ,manufacturer
            ,model
            ,max_speed
            ,bus_speed
            ,serial_number
            ,is_active
            ,num_boards
            ,num_modules
            ,pvu
            ,cache
            ,current_speed
        ) values (
            ?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
            ,?
        ))
    ';
    return ('insertProcessor', $query);
}

sub queryUpdate {
    my $query = '
        update software_lpar_processor
        set
            software_lpar_id = ?
            ,processor_num = ?
            ,manufacturer = ?
            ,model = ?
            ,max_speed = ?
            ,bus_speed = ?
            ,serial_number = ?
            ,is_active = ?
            ,num_boards = ?
            ,num_modules = ?
            ,pvu = ?
            ,cache = ?
            ,current_speed = ?
        where
            id = ?
    ';
    return ('updateProcessor', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteProcessor};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from software_lpar_processor
        where
            id = ?
    ';
    return ('deleteProcessor', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyProcessor};
    my $id;
    my $manufacturer;
    my $model;
    my $maxSpeed;
    my $busSpeed;
    my $serialNumber;
    my $isActive;
    my $numBoards;
    my $numModules;
    my $pvu;
    my $cache;
    my $currentSpeed;
    $sth->bind_columns(
        \$id
        ,\$manufacturer
        ,\$model
        ,\$maxSpeed
        ,\$busSpeed
        ,\$serialNumber
        ,\$isActive
        ,\$numBoards
        ,\$numModules
        ,\$pvu
        ,\$cache
        ,\$currentSpeed
    );
    $sth->execute(
        $self->softwareLparId
        ,$self->processorNum
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->manufacturer($manufacturer);
    $self->model($model);
    $self->maxSpeed($maxSpeed);
    $self->busSpeed($busSpeed);
    $self->serialNumber($serialNumber);
    $self->isActive($isActive);
    $self->numBoards($numBoards);
    $self->numModules($numModules);
    $self->pvu($pvu);
    $self->cache($cache);
    $self->currentSpeed($currentSpeed);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
            ,manufacturer
            ,model
            ,max_speed
            ,bus_speed
            ,serial_number
            ,is_active
            ,num_boards
            ,num_modules
            ,pvu
            ,cache
            ,current_speed
        from
            software_lpar_processor
        where
            software_lpar_id = ?
            and processor_num = ?
    ';
    return ('getByBizKeyProcessor', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyProcessor};
    my $softwareLparId;
    my $processorNum;
    my $manufacturer;
    my $model;
    my $maxSpeed;
    my $busSpeed;
    my $serialNumber;
    my $isActive;
    my $numBoards;
    my $numModules;
    my $pvu;
    my $cache;
    my $currentSpeed;
    $sth->bind_columns(
        \$softwareLparId
        ,\$processorNum
        ,\$manufacturer
        ,\$model
        ,\$maxSpeed
        ,\$busSpeed
        ,\$serialNumber
        ,\$isActive
        ,\$numBoards
        ,\$numModules
        ,\$pvu
        ,\$cache
        ,\$currentSpeed
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->softwareLparId($softwareLparId);
    $self->processorNum($processorNum);
    $self->manufacturer($manufacturer);
    $self->model($model);
    $self->maxSpeed($maxSpeed);
    $self->busSpeed($busSpeed);
    $self->serialNumber($serialNumber);
    $self->isActive($isActive);
    $self->numBoards($numBoards);
    $self->numModules($numModules);
    $self->pvu($pvu);
    $self->cache($cache);
    $self->currentSpeed($currentSpeed);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            software_lpar_id
            ,processor_num
            ,manufacturer
            ,model
            ,max_speed
            ,bus_speed
            ,serial_number
            ,is_active
            ,num_boards
            ,num_modules
            ,pvu
            ,cache
            ,current_speed
        from
            software_lpar_processor
        where
            id = ?
    ';
    return ('getByIdKeyProcessor', $query);
}

1;
