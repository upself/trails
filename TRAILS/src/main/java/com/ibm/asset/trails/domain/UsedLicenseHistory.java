package com.ibm.asset.trails.domain;

import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "H_USED_LICENSE")
public class UsedLicenseHistory extends AbstractDomainEntity {
    private static final long serialVersionUID = 8342685666521355487L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Long id;

    @Basic
    @Column(name = "USED_QUANTITY")
    private Integer usedQuantity;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "LICENSE_ID")
    private License license;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CAPACITY_TYPE_ID")
    private CapacityType capacityType;

    @ManyToMany(fetch = FetchType.LAZY, mappedBy = "usedLicenses")
    private Set<ReconcileH> reconciles;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getUsedQuantity() {
        return usedQuantity;
    }

    public void setUsedQuantity(Integer usedQuantity) {
        this.usedQuantity = usedQuantity;
    }

    public License getLicense() {
        return license;
    }

    public void setLicense(License license) {
        this.license = license;
    }

    public CapacityType getCapacityType() {
        return capacityType;
    }

    public void setCapacityType(CapacityType capacityType) {
        this.capacityType = capacityType;
    }

    @Override
    public boolean equals(final Object other) {
        if (!(other instanceof UsedLicenseHistory))
            return false;
        UsedLicenseHistory castOther = (UsedLicenseHistory) other;
        return new EqualsBuilder().append(license, castOther.license)
                .append(reconciles, castOther.reconciles).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder().append(license).append(reconciles)
                .toHashCode();
    }

    public Set<ReconcileH> getReconciles() {
        return reconciles;
    }

    public void setReconciles(Set<ReconcileH> reconciles) {
        this.reconciles = reconciles;
    }

}
