package Recon::OM::LicenseView;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _lId => undef
        ,_cId => undef
        ,_sId => undef
        ,_ibmOwned => undef
        ,_cpuSerial => undef
        ,_expireAge => undef
        ,_quantity => undef
        ,_pool => undef
        ,_capType => undef
        ,_licenseType => undef
        ,_usedQuantity => undef
        ,_lparName => undef
        ,_environment => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->lId && defined $object->lId) {
        $equal = 1 if $self->lId eq $object->lId;
    }
    $equal = 1 if (!defined $self->lId && !defined $object->lId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cId && defined $object->cId) {
        $equal = 1 if $self->cId eq $object->cId;
    }
    $equal = 1 if (!defined $self->cId && !defined $object->cId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->sId && defined $object->sId) {
        $equal = 1 if $self->sId eq $object->sId;
    }
    $equal = 1 if (!defined $self->sId && !defined $object->sId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->ibmOwned && defined $object->ibmOwned) {
        $equal = 1 if $self->ibmOwned eq $object->ibmOwned;
    }
    $equal = 1 if (!defined $self->ibmOwned && !defined $object->ibmOwned);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->cpuSerial && defined $object->cpuSerial) {
        $equal = 1 if $self->cpuSerial eq $object->cpuSerial;
    }
    $equal = 1 if (!defined $self->cpuSerial && !defined $object->cpuSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->expireAge && defined $object->expireAge) {
        $equal = 1 if $self->expireAge eq $object->expireAge;
    }
    $equal = 1 if (!defined $self->expireAge && !defined $object->expireAge);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->quantity && defined $object->quantity) {
        $equal = 1 if $self->quantity eq $object->quantity;
    }
    $equal = 1 if (!defined $self->quantity && !defined $object->quantity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->pool && defined $object->pool) {
        $equal = 1 if $self->pool eq $object->pool;
    }
    $equal = 1 if (!defined $self->pool && !defined $object->pool);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->capType && defined $object->capType) {
        $equal = 1 if $self->capType eq $object->capType;
    }
    $equal = 1 if (!defined $self->capType && !defined $object->capType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->licenseType && defined $object->licenseType) {
        $equal = 1 if $self->licenseType eq $object->licenseType;
    }
    $equal = 1 if (!defined $self->licenseType && !defined $object->licenseType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->usedQuantity && defined $object->usedQuantity) {
        $equal = 1 if $self->usedQuantity eq $object->usedQuantity;
    }
    $equal = 1 if (!defined $self->usedQuantity && !defined $object->usedQuantity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lparName && defined $object->lparName) {
        $equal = 1 if $self->lparName eq $object->lparName;
    }
    $equal = 1 if (!defined $self->lparName && !defined $object->lparName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->environment && defined $object->environment) {
        $equal = 1 if $self->environment eq $object->environment;
    }
    $equal = 1 if (!defined $self->environment && !defined $object->environment);
    return 0 if $equal == 0;

    return 1;
}

sub lId {
    my $self = shift;
    $self->{_lId} = shift if scalar @_ == 1;
    return $self->{_lId};
}

sub cId {
    my $self = shift;
    $self->{_cId} = shift if scalar @_ == 1;
    return $self->{_cId};
}

sub sId {
    my $self = shift;
    $self->{_sId} = shift if scalar @_ == 1;
    return $self->{_sId};
}

sub ibmOwned {
    my $self = shift;
    $self->{_ibmOwned} = shift if scalar @_ == 1;
    return $self->{_ibmOwned};
}

sub cpuSerial {
    my $self = shift;
    $self->{_cpuSerial} = shift if scalar @_ == 1;
    return $self->{_cpuSerial};
}

sub expireAge {
    my $self = shift;
    $self->{_expireAge} = shift if scalar @_ == 1;
    return $self->{_expireAge};
}

sub quantity {
    my $self = shift;
    $self->{_quantity} = shift if scalar @_ == 1;
    return $self->{_quantity};
}

sub pool {
    my $self = shift;
    $self->{_pool} = shift if scalar @_ == 1;
    return $self->{_pool};
}

sub capType {
    my $self = shift;
    $self->{_capType} = shift if scalar @_ == 1;
    return $self->{_capType};
}

sub licenseType {
    my $self = shift;
    $self->{_licenseType} = shift if scalar @_ == 1;
    return $self->{_licenseType};
}

sub usedQuantity {
    my $self = shift;
    $self->{_usedQuantity} = shift if scalar @_ == 1;
    return $self->{_usedQuantity};
}

sub lparName {
    my $self = shift;
    $self->{_lparName} = shift if scalar @_ == 1;
    return $self->{_lparName};
}

sub environment {
    my $self = shift;
    $self->{_environment} = shift if scalar @_ == 1;
    return $self->{_environment};
}

sub toString {
    my ($self) = @_;
    my $s = "[LicenseView] ";
    $s .= "lId=";
    if (defined $self->{_lId}) {
        $s .= $self->{_lId};
    }
    $s .= ",";
    $s .= "cId=";
    if (defined $self->{_cId}) {
        $s .= $self->{_cId};
    }
    $s .= ",";
    $s .= "sId=";
    if (defined $self->{_sId}) {
        $s .= $self->{_sId};
    }
    $s .= ",";
    $s .= "ibmOwned=";
    if (defined $self->{_ibmOwned}) {
        $s .= $self->{_ibmOwned};
    }
    $s .= ",";
    $s .= "cpuSerial=";
    if (defined $self->{_cpuSerial}) {
        $s .= $self->{_cpuSerial};
    }
    $s .= ",";
    $s .= "expireAge=";
    if (defined $self->{_expireAge}) {
        $s .= $self->{_expireAge};
    }
    $s .= ",";
    $s .= "quantity=";
    if (defined $self->{_quantity}) {
        $s .= $self->{_quantity};
    }
    $s .= ",";
    $s .= "pool=";
    if (defined $self->{_pool}) {
        $s .= $self->{_pool};
    }
    $s .= ",";
    $s .= "capType=";
    if (defined $self->{_capType}) {
        $s .= $self->{_capType};
    }
    $s .= ",";
    $s .= "licenseType=";
    if (defined $self->{_licenseType}) {
        $s .= $self->{_licenseType};
    }
    $s .= ",";
    $s .= "usedQuantity=";
    if (defined $self->{_usedQuantity}) {
        $s .= $self->{_usedQuantity};
    }
    $s .= ",";
    $s .= "lparName=";
    if (defined $self->{_lparName}) {
        $s .= $self->{_lparName};
    }
    $s .= ",";
    $s .= "environment=";
    if (defined $self->{_environment}) {
        $s .= $self->{_environment};
    }
    $s .= ",";
    chop $s;
    return $s;
}


1;
