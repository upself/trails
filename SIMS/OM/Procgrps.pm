package SIMS::OM::Procgrps;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
                 _type          => undef,
                 _model         => undef,
                 _group         => undef,
                 _vendor        => undef,
                 _description   => undef,
                 _updUser       => undef,
                 _updStamp      => undef,
                 _msu           => undef,
                 _pslcInd       => undef,
                 _wlcInd        => undef,
                 _totalEngines  => undef,
                 _zosEngines    => undef,
                 _ewlcInd       => undef,
                 _updIntranetID => undef,
                 _status        => undef,
                 _table         => 'procgrps',
                 _idField       => 'type|model|group|vendor'
    };

    bless $self, $class;
    return $self;
}

sub equals {
    my ( $self, $object ) = @_;
    my $equal;

    $equal = 0;
    if ( defined $self->type && defined $object->type ) {
        $equal = 1 if $self->type eq $object->type;
    }
    $equal = 1 if ( !defined $self->type && !defined $object->type );
    return 0 if $equal == 0;

    $equal = 0;
    if ( defined $self->model && defined $object->model ) {
        $equal = 1 if $self->model eq $object->model;
    }
    $equal = 1 if ( !defined $self->model && !defined $object->model );
    return 0 if $equal == 0;

    $equal = 0;
    if ( defined $self->group && defined $object->group ) {
        $equal = 1 if $self->group eq $object->group;
    }
    $equal = 1 if ( !defined $self->group && !defined $object->group );
    return 0 if $equal == 0;

    $equal = 0;
    if ( defined $self->vendor && defined $object->vendor ) {
        $equal = 1 if $self->vendor eq $object->vendor;
    }
    $equal = 1 if ( !defined $self->vendor && !defined $object->vendor );
    return 0 if $equal == 0;

    return 1;
}

sub type {
    my $self = shift;
    $self->{_type} = shift if scalar @_ == 1;
    return $self->{_type};
}

sub model {
    my $self = shift;
    $self->{_model} = shift if scalar @_ == 1;
    return $self->{_model};
}

sub group {
    my $self = shift;
    $self->{_group} = shift if scalar @_ == 1;
    return $self->{_group};
}

sub vendor {
    my $self = shift;
    $self->{_vendor} = shift if scalar @_ == 1;
    return $self->{_vendor};
}

sub description {
    my $self = shift;
    $self->{_description} = shift if scalar @_ == 1;
    return $self->{_description};
}

sub updUser {
    my $self = shift;
    $self->{_updUser} = shift if scalar @_ == 1;
    return $self->{_updUser};
}

sub updStamp {
    my $self = shift;
    $self->{_updStamp} = shift if scalar @_ == 1;
    return $self->{_updStamp};
}

sub msu {
    my $self = shift;
    $self->{_msu} = shift if scalar @_ == 1;
    return $self->{_msu};
}

sub pslcInd {
    my $self = shift;
    $self->{_pslcInd} = shift if scalar @_ == 1;
    return $self->{_pslcInd};
}

sub wlcInd {
    my $self = shift;
    $self->{_wlcInd} = shift if scalar @_ == 1;
    return $self->{_wlcInd};
}

sub totalEngines {
    my $self = shift;
    $self->{_totalEngines} = shift if scalar @_ == 1;
    return $self->{_totalEngines};
}

sub zosEngines {
    my $self = shift;
    $self->{_zosEngines} = shift if scalar @_ == 1;
    return $self->{_zosEngines};
}

sub ewlcInd {
    my $self = shift;
    $self->{_ewlcInd} = shift if scalar @_ == 1;
    return $self->{_ewlcInd};
}

sub updIntranetID {
    my $self = shift;
    $self->{_updIntranetID} = shift if scalar @_ == 1;
    return $self->{_updIntranetID};
}

sub status {
    my $self = shift;
    $self->{_status} = shift if scalar @_ == 1;
    return $self->{_status};
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
    my $s = "[Procgrps] ";
    $s .= "type=";
    if ( defined $self->{_type} ) {
        $s .= $self->{_type};
    }
    $s .= ",";
    $s .= "model=";
    if ( defined $self->{_model} ) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "group=";
    if ( defined $self->{_group} ) {
        $s .= $self->{_group};
    }
    $s .= ",";
    $s .= "vendor=";
    if ( defined $self->{_vendor} ) {
        $s .= $self->{_vendor};
    }
    $s .= ",";
    $s .= "description=";
    if ( defined $self->{_description} ) {
        $s .= $self->{_description};
    }
    $s .= ",";
    $s .= "updUser=";
    if ( defined $self->{_updUser} ) {
        $s .= $self->{_updUser};
    }
    $s .= ",";
    $s .= "updStamp=";
    if ( defined $self->{_updStamp} ) {
        $s .= $self->{_updStamp};
    }
    $s .= ",";
    $s .= "msu=";
    if ( defined $self->{_msu} ) {
        $s .= $self->{_msu};
    }
    $s .= ",";
    $s .= "pslcInd=";
    if ( defined $self->{_pslcInd} ) {
        $s .= $self->{_pslcInd};
    }
    $s .= ",";
    $s .= "wlcInd=";
    if ( defined $self->{_wlcInd} ) {
        $s .= $self->{_wlcInd};
    }
    $s .= ",";
    $s .= "totalEngines=";
    if ( defined $self->{_totalEngines} ) {
        $s .= $self->{_totalEngines};
    }
    $s .= ",";
    $s .= "zosEngines=";
    if ( defined $self->{_zosEngines} ) {
        $s .= $self->{_zosEngines};
    }
    $s .= ",";
    $s .= "ewlcInd=";
    if ( defined $self->{_ewlcInd} ) {
        $s .= $self->{_ewlcInd};
    }
    $s .= ",";
    $s .= "updIntranetID=";
    if ( defined $self->{_updIntranetID} ) {
        $s .= $self->{_updIntranetID};
    }
    $s .= ",";
    $s .= "status=";
    if ( defined $self->{_status} ) {
        $s .= $self->{_status};
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

sub update {
    my ( $self, $connection ) = @_;
    ilog( "Updating: " . $self->toString() );    
    $connection->prepareSqlQuery( $self->queryUpdate );
    my $sth = $connection->sql->{updateProcgrps};
    $sth->execute(  $self->description,
                        $self->updUser, $self->updStamp, $self->msu, $self->pslcInd, $self->wlcInd,
                        $self->totalEngines, $self->zosEngines, $self->ewlcInd, $self->updIntranetID,
                        $self->status, $self->type, $self->model, $self->group, $self->vendor, );
    $sth->finish;

}

sub insert {
    my ( $self, $connection ) = @_;
    ilog( "Inserting: " . $self->toString() );    
    $connection->prepareSqlQuery( $self->queryInsert() );
    my $sth = $connection->sql->{insertProcgrps};
    $sth->execute( $self->type, $self->model, $self->group, $self->vendor, $self->description,
                        $self->updUser, $self->updStamp, $self->msu, $self->pslcInd, $self->wlcInd,
                        $self->totalEngines, $self->zosEngines, $self->ewlcInd, $self->updIntranetID,
                        $self->status );
    $sth->finish;
}

sub queryInsert {
    my $query = '
        insert into eaadmin.procgrps (
            machine_type_id
            ,model
            ,procgrps_group
            ,vendor
            ,description
            ,upduser
            ,updstamp
            ,msu
            ,pslc_ind
            ,wlc_ind
            ,total_engines
            ,zos_engines
            ,ewlc_ind
            ,upd_intranet_id
            ,status
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
            ,?
            ,?         
        )
    ';
    return ( 'insertProcgrps', $query );
}

sub queryUpdate {
    my $query = '
        update eaadmin.procgrps
        set
            description = ?
            ,upduser = ?
            ,updstamp = ?
            ,msu = ?
            ,pslc_ind = ?
            ,wlc_ind = ?
            ,total_engines = ?
            ,zos_engines = ?
            ,ewlc_ind = ?
            ,upd_intranet_id = ?
            ,status = ?
        where
            machine_type_id = ?
            and model = ?
            and procgrps_group = ?
            and vendor = ?
    ';
    return ( 'updateProcgrps', $query );
}

sub delete {
    my ( $self, $connection ) = @_;
    ilog( "deleting: " . $self->toString() );
    if ( (defined $self->type) && (defined $self->model) 
                && (defined $self->group) && (defined $self->vendor) ) {
        $connection->prepareSqlQuery( $self->queryDelete() );
        my $sth = $connection->sql->{deleteProcgrps};
        $sth->execute( $self->status, $self->type, $self->model, $self->group, $self->vendor );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        update eaadmin.procgrps
        set
            status = ?
        where
            machine_type_id = ?
            and model = ?
            and procgrps_group = ?
            and vendor = ?
    ';
    return ( 'deleteProcgrps', $query );
}

1;