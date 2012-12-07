package Recon::OM::LicenseAllocationView;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _expireAge => undef
        ,_lrmId => undef
        ,_lrmCapType => undef
        ,_lrmUsedQuantity => undef
        ,_machineLevel => undef
        ,_rId => undef
        ,_rtName => undef
        ,_rtIsManual => undef
        ,_isId => undef
        ,_isSoftwareId => undef
        ,_slCustomerId => undef
        ,_slName => undef
        ,_hId => undef
        ,_hSerial => undef
        ,_hlName => undef
        ,_mtType => undef
        ,_scopeName => undef
        ,_slComplianceMgmt => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->expireAge && defined $object->expireAge) {
        $equal = 1 if $self->expireAge eq $object->expireAge;
    }
    $equal = 1 if (!defined $self->expireAge && !defined $object->expireAge);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lrmId && defined $object->lrmId) {
        $equal = 1 if $self->lrmId eq $object->lrmId;
    }
    $equal = 1 if (!defined $self->lrmId && !defined $object->lrmId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lrmCapType && defined $object->lrmCapType) {
        $equal = 1 if $self->lrmCapType eq $object->lrmCapType;
    }
    $equal = 1 if (!defined $self->lrmCapType && !defined $object->lrmCapType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->lrmUsedQuantity && defined $object->lrmUsedQuantity) {
        $equal = 1 if $self->lrmUsedQuantity eq $object->lrmUsedQuantity;
    }
    $equal = 1 if (!defined $self->lrmUsedQuantity && !defined $object->lrmUsedQuantity);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->machineLevel && defined $object->machineLevel) {
        $equal = 1 if $self->machineLevel eq $object->machineLevel;
    }
    $equal = 1 if (!defined $self->machineLevel && !defined $object->machineLevel);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rId && defined $object->rId) {
        $equal = 1 if $self->rId eq $object->rId;
    }
    $equal = 1 if (!defined $self->rId && !defined $object->rId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rtName && defined $object->rtName) {
        $equal = 1 if $self->rtName eq $object->rtName;
    }
    $equal = 1 if (!defined $self->rtName && !defined $object->rtName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->rtIsManual && defined $object->rtIsManual) {
        $equal = 1 if $self->rtIsManual eq $object->rtIsManual;
    }
    $equal = 1 if (!defined $self->rtIsManual && !defined $object->rtIsManual);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isId && defined $object->isId) {
        $equal = 1 if $self->isId eq $object->isId;
    }
    $equal = 1 if (!defined $self->isId && !defined $object->isId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->isSoftwareId && defined $object->isSoftwareId) {
        $equal = 1 if $self->isSoftwareId eq $object->isSoftwareId;
    }
    $equal = 1 if (!defined $self->isSoftwareId && !defined $object->isSoftwareId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slCustomerId && defined $object->slCustomerId) {
        $equal = 1 if $self->slCustomerId eq $object->slCustomerId;
    }
    $equal = 1 if (!defined $self->slCustomerId && !defined $object->slCustomerId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slName && defined $object->slName) {
        $equal = 1 if $self->slName eq $object->slName;
    }
    $equal = 1 if (!defined $self->slName && !defined $object->slName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hId && defined $object->hId) {
        $equal = 1 if $self->hId eq $object->hId;
    }
    $equal = 1 if (!defined $self->hId && !defined $object->hId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hSerial && defined $object->hSerial) {
        $equal = 1 if $self->hSerial eq $object->hSerial;
    }
    $equal = 1 if (!defined $self->hSerial && !defined $object->hSerial);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlName && defined $object->hlName) {
        $equal = 1 if $self->hlName eq $object->hlName;
    }
    $equal = 1 if (!defined $self->hlName && !defined $object->hlName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->mtType && defined $object->mtType) {
        $equal = 1 if $self->mtType eq $object->mtType;
    }
    $equal = 1 if (!defined $self->mtType && !defined $object->mtType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->scopeName && defined $object->scopeName) {
        $equal = 1 if $self->scopeName eq $object->scopeName;
    }
    $equal = 1 if (!defined $self->scopeName && !defined $object->scopeName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->slComplianceMgmt && defined $object->slComplianceMgmt) {
        $equal = 1 if $self->slComplianceMgmt eq $object->slComplianceMgmt;
    }
    $equal = 1 if (!defined $self->slComplianceMgmt && !defined $object->slComplianceMgmt);
    return 0 if $equal == 0;

    return 1;
}

sub expireAge {
    my $self = shift;
    $self->{_expireAge} = shift if scalar @_ == 1;
    return $self->{_expireAge};
}

sub lrmId {
    my $self = shift;
    $self->{_lrmId} = shift if scalar @_ == 1;
    return $self->{_lrmId};
}

sub lrmCapType {
    my $self = shift;
    $self->{_lrmCapType} = shift if scalar @_ == 1;
    return $self->{_lrmCapType};
}

sub lrmUsedQuantity {
    my $self = shift;
    $self->{_lrmUsedQuantity} = shift if scalar @_ == 1;
    return $self->{_lrmUsedQuantity};
}

sub machineLevel {
    my $self = shift;
    $self->{_machineLevel} = shift if scalar @_ == 1;
    return $self->{_machineLevel};
}

sub rId {
    my $self = shift;
    $self->{_rId} = shift if scalar @_ == 1;
    return $self->{_rId};
}

sub rtName {
    my $self = shift;
    $self->{_rtName} = shift if scalar @_ == 1;
    return $self->{_rtName};
}

sub rtIsManual {
    my $self = shift;
    $self->{_rtIsManual} = shift if scalar @_ == 1;
    return $self->{_rtIsManual};
}

sub isId {
    my $self = shift;
    $self->{_isId} = shift if scalar @_ == 1;
    return $self->{_isId};
}

sub isSoftwareId {
    my $self = shift;
    $self->{_isSoftwareId} = shift if scalar @_ == 1;
    return $self->{_isSoftwareId};
}

sub slCustomerId {
    my $self = shift;
    $self->{_slCustomerId} = shift if scalar @_ == 1;
    return $self->{_slCustomerId};
}

sub slName {
    my $self = shift;
    $self->{_slName} = shift if scalar @_ == 1;
    return $self->{_slName};
}

sub hId {
    my $self = shift;
    $self->{_hId} = shift if scalar @_ == 1;
    return $self->{_hId};
}

sub hSerial {
    my $self = shift;
    $self->{_hSerial} = shift if scalar @_ == 1;
    return $self->{_hSerial};
}

sub hlName {
    my $self = shift;
    $self->{_hlName} = shift if scalar @_ == 1;
    return $self->{_hlName};
}

sub mtType {
    my $self = shift;
    $self->{_mtType} = shift if scalar @_ == 1;
    return $self->{_mtType};
}

sub scopeName {
    my $self = shift;
    $self->{_scopeName} = shift if scalar @_ == 1;
    return $self->{_scopeName};
}

sub slComplianceMgmt {
    my $self = shift;
    $self->{_slComplianceMgmt} = shift if scalar @_ == 1;
    return $self->{_slComplianceMgmt};
}

sub toString {
    my ($self) = @_;
    my $s = "[LicenseAllocationView] ";
    $s .= "expireAge=";
    if (defined $self->{_expireAge}) {
        $s .= $self->{_expireAge};
    }
    $s .= ",";
    $s .= "lrmId=";
    if (defined $self->{_lrmId}) {
        $s .= $self->{_lrmId};
    }
    $s .= ",";
    $s .= "lrmCapType=";
    if (defined $self->{_lrmCapType}) {
        $s .= $self->{_lrmCapType};
    }
    $s .= ",";
    $s .= "lrmUsedQuantity=";
    if (defined $self->{_lrmUsedQuantity}) {
        $s .= $self->{_lrmUsedQuantity};
    }
    $s .= ",";
    $s .= "machineLevel=";
    if (defined $self->{_machineLevel}) {
        $s .= $self->{_machineLevel};
    }
    $s .= ",";
    $s .= "rId=";
    if (defined $self->{_rId}) {
        $s .= $self->{_rId};
    }
    $s .= ",";
    $s .= "rtName=";
    if (defined $self->{_rtName}) {
        $s .= $self->{_rtName};
    }
    $s .= ",";
    $s .= "rtIsManual=";
    if (defined $self->{_rtIsManual}) {
        $s .= $self->{_rtIsManual};
    }
    $s .= ",";
    $s .= "isId=";
    if (defined $self->{_isId}) {
        $s .= $self->{_isId};
    }
    $s .= ",";
    $s .= "isSoftwareId=";
    if (defined $self->{_isSoftwareId}) {
        $s .= $self->{_isSoftwareId};
    }
    $s .= ",";
    $s .= "slCustomerId=";
    if (defined $self->{_slCustomerId}) {
        $s .= $self->{_slCustomerId};
    }
    $s .= ",";
    $s .= "slName=";
    if (defined $self->{_slName}) {
        $s .= $self->{_slName};
    }
    $s .= ",";
    $s .= "hId=";
    if (defined $self->{_hId}) {
        $s .= $self->{_hId};
    }
    $s .= ",";
    $s .= "hSerial=";
    if (defined $self->{_hSerial}) {
        $s .= $self->{_hSerial};
    }
    $s .= ",";
    $s .= "hlName=";
    if (defined $self->{_hlName}) {
        $s .= $self->{_hlName};
    }
    $s .= ",";
    $s .= "mtType=";
    if (defined $self->{_mtType}) {
        $s .= $self->{_mtType};
    }
    $s .= ",";
    $s .= "scopeName=";
    if (defined $self->{_scopeName}) {
        $s .= $self->{_scopeName};
    }
    $s .= ",";
    $s .= "slComplianceMgmt=";
    if (defined $self->{_slComplianceMgmt}) {
        $s .= $self->{_slComplianceMgmt};
    }
    $s .= ",";
    chop $s;
    return $s;
}


1;

