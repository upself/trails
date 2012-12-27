package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "RECON_LICENSE")
public class ReconLicense extends AbstractDomainEntity {
    private static final long serialVersionUID = 835189371182579732L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "LICENSE_ID")
    private License license;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "CUSTOMER_ID")
    private Account account;

    @Basic
    @Column(name = "ACTION")
    private String action;

    @Basic
    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Basic
    @Column(name = "RECORD_TIME")
    private Date recordTime;

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public License getLicense() {
        return license;
    }

    public void setLicense(License license) {
        this.license = license;
    }

    public Date getRecordTime() {
        return recordTime;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    @Override
    public boolean equals(final Object other) {
        if (!(other instanceof ReconLicense))
            return false;
        ReconLicense castOther = (ReconLicense) other;
        return new EqualsBuilder().append(license, castOther.license)
                .isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder().append(license).toHashCode();
    }

}
