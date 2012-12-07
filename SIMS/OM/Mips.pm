package SIMS::OM::Mips;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _type => undef
        ,_model => undef
        ,_group => undef
        ,_vendor => undef
        ,_mipsVendor => undef
        ,_mips => undef
        ,_updUser => undef
        ,_updStamp => undef
        ,_updIntranetID => undef
        ,_status => undef
        ,_table => 'mips'
        ,_idField => 'type|model|group|vendor|mipsVendor'
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
    
    $equal = 0;
    if ( defined $self->mipsVendor && defined $object->mipsVendor ) {
        $equal = 1 if $self->mipsVendor eq $object->mipsVendor;
    }
    $equal = 1 if ( !defined $self->mipsVendor && !defined $object->mipsVendor );
    return 0 if $equal == 0;
    
    $equal = 0;
    if ( defined $self->mips && defined $object->mips ) {
        $equal = 1 if $self->mips eq $object->mips;
    }
    $equal = 1 if ( !defined $self->mips && !defined $object->mips );
    return 0 if $equal == 0;    
    
    $equal = 0;
    if ( defined $self->updUser && defined $object->updUser ) {
        $equal = 1 if $self->updUser eq $object->updUser;
    }
    $equal = 1 if ( !defined $self->updUser && !defined $object->updUser );
    return 0 if $equal == 0;
    
    $equal = 0;
    if ( defined $self->updStamp && defined $object->updStamp ) {
        $equal = 1 if $self->updStamp eq $object->updStamp;
    }
    $equal = 1 if ( !defined $self->updStamp && !defined $object->updStamp );
    return 0 if $equal == 0;
    
    $equal = 0;
    if ( defined $self->updIntranetID && defined $object->updIntranetID ) {
        $equal = 1 if $self->updIntranetID eq $object->updIntranetID;
    }
    $equal = 1 if ( !defined $self->updIntranetID && !defined $object->updIntranetID );
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

sub mipsVendor {
    my $self = shift;
    $self->{_mipsVendor} = shift if scalar @_ == 1;
    return $self->{_mipsVendor};
}

sub mips {
    my $self = shift;
    $self->{_mips} = shift if scalar @_ == 1;
    return $self->{_mips};
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
    my $s = "[Mips] ";
    $s .= "type=";
    if (defined $self->{_type}) {
        $s .= $self->{_type};
    }
    $s .= ",";
    $s .= "model=";
    if (defined $self->{_model}) {
        $s .= $self->{_model};
    }
    $s .= ",";
    $s .= "group=";
    if (defined $self->{_group}) {
        $s .= $self->{_group};
    }
    $s .= ",";
    $s .= "vendor=";
    if (defined $self->{_vendor}) {
        $s .= $self->{_vendor};
    }
    $s .= ",";
    $s .= "mipsVendor=";
    if (defined $self->{_mipsVendor}) {
        $s .= $self->{_mipsVendor};
    }
    $s .= ",";
    $s .= "mips=";
    if (defined $self->{_mips}) {
        $s .= $self->{_mips};
    }
    $s .= ",";
    $s .= "updUser=";
    if (defined $self->{_updUser}) {
        $s .= $self->{_updUser};
    }
    $s .= ",";
    $s .= "updStamp=";
    if (defined $self->{_updStamp}) {
        $s .= $self->{_updStamp};
    }
    $s .= ",";
    $s .= "updIntranetID=";
    if (defined $self->{_updIntranetID}) {
        $s .= $self->{_updIntranetID};
    } 
    $s .= ",";
    $s .= "status=";
    if (defined $self->{_status}) {
        $s .= $self->{_status};
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

sub update {
    my ( $self, $connection ) = @_;
    ilog( "Updating: " . $self->toString() );    
    $connection->prepareSqlQuery( $self->queryUpdate );
    my $sth = $connection->sql->{updateMips};
    $sth->execute( $self->mips, $self->updUser, $self->updStamp, $self->updIntranetID,
                        $self->status, $self->type, $self->model, $self->group, $self->vendor, $self->mipsVendor);
    $sth->finish;

}

sub insert {
    my ( $self, $connection ) = @_;
    ilog( "Inserting: " . $self->toString() );    
    $connection->prepareSqlQuery( $self->queryInsert() );
    my $sth = $connection->sql->{insertMips};
    $sth->execute( $self->type, $self->model, $self->group, $self->vendor, $self->mipsVendor, $self->mips, 
                        $self->updUser, $self->updStamp, $self->updIntranetID, $self->status );
    $sth->finish;
}

sub queryInsert {
    my $query = '
        insert into eaadmin.mips (
            machine_type_id
            ,model
            ,mips_group
            ,vendor
            ,mipsvendor
            ,mips
            ,upduser
            ,updstamp
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
        )
    ';
    return ( 'insertMips', $query );
}

sub queryUpdate {
    my $query = '
        update eaadmin.mips
        set
            mips = ?
            ,upduser = ?
            ,updstamp = ?
            ,upd_intranet_id = ?
            ,status = ?
        where
            machine_type_id = ?
            and model = ?
            and mips_group = ?
            and vendor = ?
            and mipsvendor = ?
    ';
    return ( 'updateMips', $query );
}

sub delete {
    my ( $self, $connection ) = @_;
    ilog( "deleting: " . $self->toString() );
    if ( ( defined $self->type) && (defined $self->model) 
                && (defined $self->group) && (defined $self->vendor) 
                && (defined $self->mipsVendor) ) {
        $connection->prepareSqlQuery( $self->queryDelete() );
        my $sth = $connection->sql->{deleteMips};
        $sth->execute( $self->status, $self->type, $self->model, $self->group, $self->vendor, $self->mipsVendor );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        update eaadmin.mips
        set
            status = ?
        where
            machine_type_id = ?
            and model = ?
            and mips_group = ?
            and vendor = ?
            and mipsvendor = ?
    ';
    return ( 'deleteMips', $query );
}

1;
