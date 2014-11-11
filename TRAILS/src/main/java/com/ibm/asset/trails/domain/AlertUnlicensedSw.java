package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "ALERT_UNLICENSED_SW")
@NamedQueries({
        @NamedQuery(name = "alertUnlicensedSwTotalByAccountAndType", query = "SELECT COUNT(DISTINCT AUS.installedSoftware.software) FROM AlertUnlicensedSw AUS WHERE AUS.installedSoftware.softwareLpar.account = :account AND AUS.type = :type AND AUS.open = 1"),
        @NamedQuery(name = "alertUnlicensedSwListSelected", query = "select aus.id FROM AlertUnlicensedSw AUS WHERE AUS.open = 1 AND AUS.id IN (:alertUnlicensedSwIdList)"),
        @NamedQuery(name = "alertUnlicensedSwListAll", query = "select aus.id FROM AlertUnlicensedSw AUS WHERE AUS.open = 1 AND AUS.installedSoftware.softwareLpar.account = :account AND AUS.installedSoftware.software.softwareId IN (:softwareIdList)"),
        @NamedQuery(name = "alertUnlicensedSwListById", query = "FROM AlertUnlicensedSw WHERE id IN (:idList) ORDER BY creationTime"),
        @NamedQuery(name = "alertUnlicensedSwListByOwner", query = "select aus.id FROM AlertUnlicensedSw AUS WHERE AUS.open = 1 AND AUS.installedSoftware.softwareLpar.account = :account AND AUS.installedSoftware.software.softwareId IN (:softwareIdList) AND AUS.installedSoftware.softwareLpar.hardwareLpar.hardware.owner = :owner") })
public class AlertUnlicensedSw extends AbstractDomainEntity {
    private static final long serialVersionUID = 483944361386206605L;

    @Id
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "INSTALLED_SOFTWARE_ID")
    private InstalledSoftware installedSoftware;

    @Column(name = "COMMENTS")
    private String comments;

    @Column(name = "TYPE")
    private String type;

    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Column(name = "CREATION_TIME")
    private Date creationTime;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    @Column(name = "OPEN")
    private boolean open;

    @OneToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "INSTALLED_SOFTWARE_ID", referencedColumnName = "INSTALLED_SOFTWARE_ID", insertable = false, updatable = false)
    private Reconcile reconcile;

    @OneToOne(fetch = FetchType.LAZY, optional = true)
    @JoinColumn(name = "INSTALLED_SOFTWARE_ID", referencedColumnName = "INSTALLED_SOFTWARE_ID", insertable = false, updatable = false)
    private ReconcileH reconcileH;

    public String getComments() {
        return comments;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public Long getId() {
        return id;
    }

    public InstalledSoftware getInstalledSoftware() {
        return installedSoftware;
    }

    public boolean isOpen() {
        return open;
    }

    public Date getRecordTime() {
        return recordTime;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public String getType() {
        return type;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setInstalledSoftware(InstalledSoftware installedSoftware) {
        this.installedSoftware = installedSoftware;
    }

    public void setOpen(boolean open) {
        this.open = open;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Reconcile getReconcile() {
        return reconcile;
    }

    public void setReconcile(Reconcile reconcile) {
        this.reconcile = reconcile;
    }

    @Override
    public boolean equals(final Object other) {
        if (!(other instanceof AlertUnlicensedSw))
            return false;
        AlertUnlicensedSw castOther = (AlertUnlicensedSw) other;
        return new EqualsBuilder().append(installedSoftware,
                castOther.installedSoftware).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder().append(installedSoftware).toHashCode();
    }

    public ReconcileH getReconcileH() {
        return reconcileH;
    }

    public void setReconcileH(ReconcileH reconcileH) {
        this.reconcileH = reconcileH;
    }

}
