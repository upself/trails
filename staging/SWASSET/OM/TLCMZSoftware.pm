package SWASSET::OM::TLCMZSoftware;

use strict;
use Base::Utils;

sub new {
    my ($class) = @_;
    my $self = {
        _id => undef
        ,_tlcmzProductId => undef
        ,_tlcmzProductName => undef
        ,_vendorId => undef
        ,_vendorName => undef
        ,_versionGroupId => undef
        ,_productVersion => undef
        ,_productRelease => undef
        ,_productEblmtElgFlag => undef
        ,_ibmFeatureCode => undef
        ,_productDelIndicator => undef
    };
    bless $self, $class;
    return $self;
}

sub equals {
    my ($self, $object) = @_;
    my $equal;

    $equal = 0;
    if (defined $self->id && defined $object->id) {
        $equal = 1 if $self->id eq $object->id;
    }
    $equal = 1 if (!defined $self->id && !defined $object->id);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tlcmzProductId && defined $object->tlcmzProductId) {
        $equal = 1 if $self->tlcmzProductId eq $object->tlcmzProductId;
    }
    $equal = 1 if (!defined $self->tlcmzProductId && !defined $object->tlcmzProductId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->tlcmzProductName && defined $object->tlcmzProductName) {
        $equal = 1 if $self->tlcmzProductName eq $object->tlcmzProductName;
    }
    $equal = 1 if (!defined $self->tlcmzProductName && !defined $object->tlcmzProductName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->vendorId && defined $object->vendorId) {
        $equal = 1 if $self->vendorId eq $object->vendorId;
    }
    $equal = 1 if (!defined $self->vendorId && !defined $object->vendorId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->vendorName && defined $object->vendorName) {
        $equal = 1 if $self->vendorName eq $object->vendorName;
    }
    $equal = 1 if (!defined $self->vendorName && !defined $object->vendorName);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->versionGroupId && defined $object->versionGroupId) {
        $equal = 1 if $self->versionGroupId eq $object->versionGroupId;
    }
    $equal = 1 if (!defined $self->versionGroupId && !defined $object->versionGroupId);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->productVersion && defined $object->productVersion) {
        $equal = 1 if $self->productVersion eq $object->productVersion;
    }
    $equal = 1 if (!defined $self->productVersion && !defined $object->productVersion);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->productRelease && defined $object->productRelease) {
        $equal = 1 if $self->productRelease eq $object->productRelease;
    }
    $equal = 1 if (!defined $self->productRelease && !defined $object->productRelease);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->productEblmtElgFlag && defined $object->productEblmtElgFlag) {
        $equal = 1 if $self->productEblmtElgFlag eq $object->productEblmtElgFlag;
    }
    $equal = 1 if (!defined $self->productEblmtElgFlag && !defined $object->productEblmtElgFlag);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->ibmFeatureCode && defined $object->ibmFeatureCode) {
        $equal = 1 if $self->ibmFeatureCode eq $object->ibmFeatureCode;
    }
    $equal = 1 if (!defined $self->ibmFeatureCode && !defined $object->ibmFeatureCode);
    return 0 if $equal == 0;

    $equal = 0;
    if (defined $self->productDelIndicator && defined $object->productDelIndicator) {
        $equal = 1 if $self->productDelIndicator eq $object->productDelIndicator;
    }
    $equal = 1 if (!defined $self->productDelIndicator && !defined $object->productDelIndicator);
    return 0 if $equal == 0;

    return 1;
}

sub id {
    my $self = shift;
    $self->{_id} = shift if scalar @_ == 1;
    return $self->{_id};
}

sub tlcmzProductId {
    my $self = shift;
    $self->{_tlcmzProductId} = shift if scalar @_ == 1;
    return $self->{_tlcmzProductId};
}

sub tlcmzProductName {
    my $self = shift;
    $self->{_tlcmzProductName} = shift if scalar @_ == 1;
    return $self->{_tlcmzProductName};
}

sub vendorId {
    my $self = shift;
    $self->{_vendorId} = shift if scalar @_ == 1;
    return $self->{_vendorId};
}

sub vendorName {
    my $self = shift;
    $self->{_vendorName} = shift if scalar @_ == 1;
    return $self->{_vendorName};
}

sub versionGroupId {
    my $self = shift;
    $self->{_versionGroupId} = shift if scalar @_ == 1;
    return $self->{_versionGroupId};
}

sub productVersion {
    my $self = shift;
    $self->{_productVersion} = shift if scalar @_ == 1;
    return $self->{_productVersion};
}

sub productRelease {
    my $self = shift;
    $self->{_productRelease} = shift if scalar @_ == 1;
    return $self->{_productRelease};
}

sub productEblmtElgFlag {
    my $self = shift;
    $self->{_productEblmtElgFlag} = shift if scalar @_ == 1;
    return $self->{_productEblmtElgFlag};
}

sub ibmFeatureCode {
    my $self = shift;
    $self->{_ibmFeatureCode} = shift if scalar @_ == 1;
    return $self->{_ibmFeatureCode};
}

sub productDelIndicator {
    my $self = shift;
    $self->{_productDelIndicator} = shift if scalar @_ == 1;
    return $self->{_productDelIndicator};
}

sub toString {
    my ($self) = @_;
    my $s = "[TLCMZSoftware] ";
    $s .= "id=";
    if (defined $self->{_id}) {
        $s .= $self->{_id};
    }
    $s .= ",";
    $s .= "tlcmzProductId=";
    if (defined $self->{_tlcmzProductId}) {
        $s .= $self->{_tlcmzProductId};
    }
    $s .= ",";
    $s .= "tlcmzProductName=";
    if (defined $self->{_tlcmzProductName}) {
        $s .= $self->{_tlcmzProductName};
    }
    $s .= ",";
    $s .= "vendorId=";
    if (defined $self->{_vendorId}) {
        $s .= $self->{_vendorId};
    }
    $s .= ",";
    $s .= "vendorName=";
    if (defined $self->{_vendorName}) {
        $s .= $self->{_vendorName};
    }
    $s .= ",";
    $s .= "versionGroupId=";
    if (defined $self->{_versionGroupId}) {
        $s .= $self->{_versionGroupId};
    }
    $s .= ",";
    $s .= "productVersion=";
    if (defined $self->{_productVersion}) {
        $s .= $self->{_productVersion};
    }
    $s .= ",";
    $s .= "productRelease=";
    if (defined $self->{_productRelease}) {
        $s .= $self->{_productRelease};
    }
    $s .= ",";
    $s .= "productEblmtElgFlag=";
    if (defined $self->{_productEblmtElgFlag}) {
        $s .= $self->{_productEblmtElgFlag};
    }
    $s .= ",";
    $s .= "ibmFeatureCode=";
    if (defined $self->{_ibmFeatureCode}) {
        $s .= $self->{_ibmFeatureCode};
    }
    $s .= ",";
    $s .= "productDelIndicator=";
    if (defined $self->{_productDelIndicator}) {
        $s .= $self->{_productDelIndicator};
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
        my $sth = $connection->sql->{insertTLCMZSoftware};
        my $id;
        $sth->bind_columns(\$id);
        $sth->execute(
            $self->tlcmzProductId
            ,$self->tlcmzProductName
            ,$self->vendorId
            ,$self->vendorName
            ,$self->versionGroupId
            ,$self->productVersion
            ,$self->productRelease
            ,$self->productEblmtElgFlag
            ,$self->ibmFeatureCode
            ,$self->productDelIndicator
        );
        $sth->fetchrow_arrayref;
        $sth->finish;
        $self->id($id);
    }
    else {
        $connection->prepareSqlQuery($self->queryUpdate);
        my $sth = $connection->sql->{updateTLCMZSoftware};
        $sth->execute(
            $self->tlcmzProductName
            ,$self->vendorId
            ,$self->vendorName
            ,$self->versionGroupId
            ,$self->productVersion
            ,$self->productRelease
            ,$self->productEblmtElgFlag
            ,$self->ibmFeatureCode
            ,$self->productDelIndicator
            ,$self->tlcmzProductId
        );
        $sth->finish;
    }
}

sub queryInsert {
    my $query = '
        select
            rtrim(ltrim(cast(char(tlcmz_prod_id) as varchar(255))))
        from
            final table (
        insert into tlcmz_sware (
            tlcmz_prod_id
            ,tlcmz_prod_name
            ,vendor_id
            ,vendor_name
            ,version_group_id
            ,prod_version
            ,prod_release
            ,prod_eblmt_elg_flag
            ,ibm_ftr_code
            ,prod_del_indctr
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
        ))
    ';
    return ('insertTLCMZSoftware', $query);
}

sub queryUpdate {
    my $query = '
        update tlcmz_sware
        set
            tlcmz_prod_name = ?
            ,vendor_id = ?
            ,vendor_name = ?
            ,version_group_id = ?
            ,prod_version = ?
            ,prod_release = ?
            ,prod_eblmt_elg_flag = ?
            ,ibm_ftr_code = ?
            ,prod_del_indctr = ?
        where
            tlcmz_prod_id = ?
    ';
    return ('updateTLCMZSoftware', $query);
}

sub delete {
    my($self, $connection) = @_;
    ilog("deleting: ".$self->toString());
    if( defined $self->id ) {
        $connection->prepareSqlQuery($self->queryDelete());
        my $sth = $connection->sql->{deleteTLCMZSoftware};
        $sth->execute(
            $self->tlcmzProductId
        );
        $sth->finish;
    }
}

sub queryDelete {
    my $query = '
        delete from tlcmz_sware
        where
            tlcmz_prod_id = ?
    ';
    return ('deleteTLCMZSoftware', $query);
}

sub getByBizKey {
    my($self, $connection) = @_;
    $connection->prepareSqlQuery($self->queryGetByBizKey());
    my $sth = $connection->sql->{getByBizKeyTLCMZSoftware};
    my $id;
    my $tlcmzProductName;
    my $vendorId;
    my $vendorName;
    my $versionGroupId;
    my $productVersion;
    my $productRelease;
    my $productEblmtElgFlag;
    my $ibmFeatureCode;
    my $productDelIndicator;
    $sth->bind_columns(
        \$id
        ,\$tlcmzProductName
        ,\$vendorId
        ,\$vendorName
        ,\$versionGroupId
        ,\$productVersion
        ,\$productRelease
        ,\$productEblmtElgFlag
        ,\$ibmFeatureCode
        ,\$productDelIndicator
    );
    $sth->execute(
        $self->tlcmzProductId
    );
    $sth->fetchrow_arrayref;
    $sth->finish;
    $self->id($id);
    $self->tlcmzProductName($tlcmzProductName);
    $self->vendorId($vendorId);
    $self->vendorName($vendorName);
    $self->versionGroupId($versionGroupId);
    $self->productVersion($productVersion);
    $self->productRelease($productRelease);
    $self->productEblmtElgFlag($productEblmtElgFlag);
    $self->ibmFeatureCode($ibmFeatureCode);
    $self->productDelIndicator($productDelIndicator);
}

sub queryGetByBizKey {
    my $query = '
        select
            rtrim(ltrim(cast(char(tlcmz_prod_id) as varchar(255))))
            ,tlcmz_prod_name
            ,vendor_id
            ,vendor_name
            ,version_group_id
            ,prod_version
            ,prod_release
            ,prod_eblmt_elg_flag
            ,ibm_ftr_code
            ,prod_del_indctr
        from
            tlcmz_sware
        where
            tlcmz_prod_id = ?
     with ur';
    return ('getByBizKeyTLCMZSoftware', $query);
}

1;
