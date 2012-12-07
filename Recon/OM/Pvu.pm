package Recon::OM::Pvu;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_processorBrand => undef
        ,_processorModel => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->processorBrand && defined $object->processorBrand) {
        $equal = 1 if $self->processorBrand eq $object->processorBrand;
    }
    $equal = 1 if (!defined $self->processorBrand && !defined $object->processorBrand);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->processorModel && defined $object->processorModel) {
        $equal = 1 if $self->processorModel eq $object->processorModel;
    }
    $equal = 1 if (!defined $self->processorModel && !defined $object->processorModel);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub processorBrand {
    my $self = shift;
    $self->{_processorBrand} = shift if scalar @_ == 1;
    return $self->{_processorBrand};
}

sub processorModel {
    my $self = shift;
    $self->{_processorModel} = shift if scalar @_ == 1;
    return $self->{_processorModel};
}

sub toString {
    my ($self) = @_;
    my $s = "[Pvu] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "processorBrand=";
    if (defined $self->{_processorBrand}) {
        $s .= $self->{_processorBrand};
    }
    $s .= ",";
    $s .= "processorModel=";
    if (defined $self->{_processorModel}) {
        $s .= $self->{_processorModel};
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
        my $sth = $connection->sql->{insertPvu};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updatePvu};
        $sth->execute(
            $self->processorBrand
            ,$self->processorModel
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
        insert into pvu (
            processor_brand
            ,processor_model
        ) values (
            ?
            ,?
        ))
    ';
    return ('insertPvu', $query);
}

sub queryUpdate {
    my $query = '
        update pvu
        set
            processor_brand = ?
            ,processor_model = ?
        where
            id = ?
    ';
    return ('updatePvu', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deletePvu};
        $sth->execute(
            $self->id
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from pvu
        where
            id = ?
    ';
    return ('deletePvu', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyPvu};
    my $id;
    $sth->bind_columns(
        \$id
    );
    $sth->execute(
        $self->processorBrand
        ,$self->processorModel
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
}

sub queryGetByBizKey {
    my $query = '
        select
            id
        from
            pvu
        where
            processor_brand = ?
            and processor_model = ?
    ';
    return ('getByBizKeyPvu', $query);
}

sub getById {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetById());
    my $sth = $connection->sql->{getByIdKeyPvu};
    my $processorBrand;
    my $processorModel;
    $sth->bind_columns(
        \$processorBrand
        ,\$processorModel
    );
    $sth->execute(
        $self->id
    );
    my $found = $sth->fetchrow_arrayref;
    $sth->finish;
    $self->processorBrand($processorBrand);
    $self->processorModel($processorModel);
    return (defined $found) ? 1 : 0;
}

sub queryGetById {
    my $query = '
        select
            processor_brand
            ,processor_model
        from
            pvu
        where
            id = ?
    ';
    return ('getByIdKeyPvu', $query);
}

1;
