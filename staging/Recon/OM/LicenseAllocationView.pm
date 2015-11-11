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
        ,_rAllocMethodology => undef
        ,_isId => undef
        ,_isSoftwareId => undef
        ,_slCustomerId => undef
        ,_slName => undef
        ,_hId => undef
        ,_hSerial => undef
        ,_hProcessorCount => undef
        ,_hCpuMIPS => undef
        ,_hCpuGartnerMIPS => undef
        ,_hCpuMSU => undef
        ,_hServerType => undef
        ,_hlName => undef
        ,_hlPartMIPS => undef
        ,_hlPartGartnerMIPS => undef
        ,_hlPartMSU => undef
        ,_mtType => undef
        ,_scopeName => undef
        ,_slComplianceMgmt => undef
        ,_guid => undef
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
    if (defined $self->rAllocMethodology && defined $object->rAllocMethodology) {
        $equal = 1 if $self->rAllocMethodology eq $object->rAllocMethodology;
    }
    $equal = 1 if (!defined $self->rAllocMethodology && !defined $object->rAllocMethodology);
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
    if (defined $self->hProcessorCount && defined $object->hProcessorCount) {
        $equal = 1 if $self->hProcessorCount eq $object->hProcessorCount;
    }
    $equal = 1 if (!defined $self->hProcessorCount && !defined $object->hProcessorCount);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuMIPS && defined $object->hCpuMIPS) {
        $equal = 1 if $self->hCpuMIPS eq $object->hCpuMIPS;
    }
    $equal = 1 if (!defined $self->hCpuMIPS && !defined $object->hCpuMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuGartnerMIPS && defined $object->hCpuGartnerMIPS) {
        $equal = 1 if $self->hCpuGartnerMIPS eq $object->hCpuGartnerMIPS;
    }
    $equal = 1 if (!defined $self->hCpuGartnerMIPS && !defined $object->hCpuGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hCpuMSU && defined $object->hCpuMSU) {
        $equal = 1 if $self->hCpuMSU eq $object->hCpuMSU;
    }
    $equal = 1 if (!defined $self->hCpuMSU && !defined $object->hCpuMSU);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hServerType && defined $object->hServerType) {
        $equal = 1 if $self->hServerType eq $object->hServerType;
    }
    $equal = 1 if (!defined $self->hServerType && !defined $object->hServerType);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlName && defined $object->hlName) {
        $equal = 1 if $self->hlName eq $object->hlName;
    }
    $equal = 1 if (!defined $self->hlName && !defined $object->hlName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartMIPS && defined $object->hlPartMIPS) {
        $equal = 1 if $self->hlPartMIPS eq $object->hlPartMIPS;
    }
    $equal = 1 if (!defined $self->hlPartMIPS && !defined $object->hlPartMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartGartnerMIPS && defined $object->hlPartGartnerMIPS) {
        $equal = 1 if $self->hlPartGartnerMIPS eq $object->hlPartGartnerMIPS;
    }
    $equal = 1 if (!defined $self->hlPartGartnerMIPS && !defined $object->hlPartGartnerMIPS);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->hlPartMSU && defined $object->hlPartMSU) {
        $equal = 1 if $self->hlPartMSU eq $object->hlPartMSU;
    }
    $equal = 1 if (!defined $self->hlPartMSU && !defined $object->hlPartMSU);
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

sub rAllocMethodology {
    my $self = shift;
    $self->{_rAllocMethodology} = shift if scalar @_ == 1;
    return $self->{_rAllocMethodology};
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

sub hProcessorCount {
    my $self = shift;
    $self->{_hProcessorCount} = shift if scalar @_ == 1;
    return $self->{_hProcessorCount};
}

sub hCpuMIPS {
    my $self = shift;
    $self->{_hCpuMIPS} = shift if scalar @_ == 1;
    return $self->{_hCpuMIPS};
}

sub hCpuGartnerMIPS {
    my $self = shift;
    $self->{_hCpuGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_hCpuGartnerMIPS};
}

sub hCpuMSU {
    my $self = shift;
    $self->{_hCpuMSU} = shift if scalar @_ == 1;
    return $self->{_hCpuMSU};
}

sub hServerType {
    my $self = shift;
    $self->{_hServerType} = shift if scalar @_ == 1;
    return $self->{_hServerType};
}

sub hlName {
    my $self = shift;
    $self->{_hlName} = shift if scalar @_ == 1;
    return $self->{_hlName};
}

sub hlPartMIPS {
    my $self = shift;
    $self->{_hlPartMIPS} = shift if scalar @_ == 1;
    return $self->{_hlPartMIPS};
}

sub hlPartGartnerMIPS {
    my $self = shift;
    $self->{_hlPartGartnerMIPS} = shift if scalar @_ == 1;
    return $self->{_hlPartGartnerMIPS};
}

sub hlPartMSU {
    my $self = shift;
    $self->{_hlPartMSU} = shift if scalar @_ == 1;
    return $self->{_hlPartMSU};
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

sub guid {
    my $self = shift;
    $self->{_guid} = shift if scalar @_ == 1;
    return $self->{_guid};
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
    $s .= "rAllocMethodology=";
    if (defined $self->{_rAllocMethodology}) {
        $s .= $self->{_rAllocMethodology};
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
    $s .= "hProcessorCount=";
    if (defined $self->{_hProcessorCount}) {
        $s .= $self->{_hProcessorCount};
    }
    $s .= ",";
    $s .= "hCpuMIPS=";
    if (defined $self->{_hCpuMIPS}) {
        $s .= $self->{_hCpuMIPS};
    }
    $s .= ",";
    $s .= "hCpuGartnerMIPS=";
    if (defined $self->{_hCpuGartnerMIPS}) {
        $s .= $self->{_hCpuGartnerMIPS};
    }
    $s .= ",";
    $s .= "hCpuMSU=";
    if (defined $self->{_hCpuMSU}) {
        $s .= $self->{_hCpuMSU};
    }
    $s .= ",";
    $s .= "hServerType=";
    if (defined $self->{_hServerType}) {
        $s .= $self->{_hServerType};
    }
    $s .= ",";
    $s .= "hlName=";
    if (defined $self->{_hlName}) {
        $s .= $self->{_hlName};
    }
    $s .= ",";
    $s .= "hlPartMIPS=";
    if (defined $self->{_hlPartMIPS}) {
        $s .= $self->{_hlPartMIPS};
    }
    $s .= ",";
    $s .= "hlPartGartnerMIPS=";
    if (defined $self->{_hlPartGartnerMIPS}) {
        $s .= $self->{_hlPartGartnerMIPS};
    }
    $s .= ",";
    $s .= "hlPartMSU=";
    if (defined $self->{_hlPartMSU}) {
        $s .= $self->{_hlPartMSU};
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
    $s .= "guid=";
    if (defined $self->{_guid}) {
        $s .= $self->{_guid};
    }
    $s .= ",";
    chop $s;
    return $s;
}


1;
