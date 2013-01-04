package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "RECONCILE_H")
@NamedQuery(name = "reconcileHistoryByInstalledSoftwareId", query = "FROM ReconcileH WHERE installedSoftware.id = :instSwId")
public class ReconcileH implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "ID")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RECONCILE_TYPE_ID")
    private ReconcileType reconcileType;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "INSTALLED_SOFTWARE_ID")
    private InstalledSoftware installedSoftware;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PARENT_INSTALLED_SOFTWARE_ID")
    private InstalledSoftware parentInstalledSoftware;

    @ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinTable(name = "H_RECONCILE_USED_LICENSE", joinColumns = @JoinColumn(name = "H_RECONCILE_ID"), inverseJoinColumns = @JoinColumn(name = "H_USED_LICENSE_ID"))
    private Set<UsedLicenseHistory> usedLicenses = new HashSet<UsedLicenseHistory>();

    @Column(name = "COMMENTS")
    private String comments;

    @Column(name = "REMOTE_USER")
    private String remoteUser;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    @Column(name = "MACHINE_LEVEL")
    private Integer machineLevel;

    @Column(name = "MANUAL_BREAK")
    private boolean manualBreak;

    public String getComments() {
        return comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public InstalledSoftware getInstalledSoftware() {
        return installedSoftware;
    }

    public void setInstalledSoftware(InstalledSoftware installedSoftware) {
        this.installedSoftware = installedSoftware;
    }

    public InstalledSoftware getParentInstalledSoftware() {
        return parentInstalledSoftware;
    }

    public void setParentInstalledSoftware(
            InstalledSoftware parentInstalledSoftware) {
        this.parentInstalledSoftware = parentInstalledSoftware;
    }

    public ReconcileType getReconcileType() {
        return reconcileType;
    }

    public void setReconcileType(ReconcileType reconcileType) {
        this.reconcileType = reconcileType;
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
    public boolean equals(Object other) {
        if (this == other)
            return true;
        if (!(other instanceof ReconcileH))
            return false;
        final ReconcileH that = (ReconcileH) other;
        return this.installedSoftware.getId().equals(
                that.getInstalledSoftware().getId());
    }

    @Override
    public int hashCode() {
        return installedSoftware.getId().hashCode();
    }

    public Integer getMachineLevel() {
        return machineLevel;
    }

    public void setMachineLevel(Integer machineLevel) {
        this.machineLevel = machineLevel;
    }

    public boolean isManualBreak() {
        return manualBreak;
    }

    public void setManualBreak(boolean manualBreak) {
        this.manualBreak = manualBreak;
    }

    public void setUsedLicenses(Set<UsedLicenseHistory> usedLicenses) {
        this.usedLicenses = usedLicenses;
    }

    public Set<UsedLicenseHistory> getUsedLicenses() {
        return usedLicenses;
    }
}
