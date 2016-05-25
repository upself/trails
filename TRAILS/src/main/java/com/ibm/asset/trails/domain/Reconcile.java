package com.ibm.asset.trails.domain;

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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "RECONCILE")
@Inheritance(strategy = InheritanceType.JOINED)
public class Reconcile extends AbstractDomainEntity {
	private static final long serialVersionUID = -1570160658765275811L;

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

	@ManyToMany(fetch = FetchType.LAZY, cascade = CascadeType.MERGE)
	@JoinTable(name = "RECONCILE_USED_LICENSE", joinColumns = @JoinColumn(name = "RECONCILE_ID"), inverseJoinColumns = @JoinColumn(name = "USED_LICENSE_ID"))
	private Set<UsedLicense> usedLicenses = new HashSet<UsedLicense>();

	@Column(name = "COMMENTS")
	private String comments;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "MACHINE_LEVEL")
	private Integer machineLevel;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ALLOCATION_METHODOLOGY_ID")
	private AllocationMethodology allocationMethodology;

	public String getMachineLevelAsString() {
		return getMachineLevel().intValue() == 1 ? "Yes" : "No";
	}

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

	public Integer getMachineLevel() {
		return machineLevel;
	}

	public void setMachineLevel(Integer machineLevel) {
		this.machineLevel = machineLevel;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof Reconcile))
			return false;
		Reconcile castOther = (Reconcile) other;
		return new EqualsBuilder().append(installedSoftware,
				castOther.installedSoftware).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(installedSoftware).toHashCode();
	}

	public void setUsedLicenses(Set<UsedLicense> usedLicenses) {
		this.usedLicenses = usedLicenses;
	}

	public Set<UsedLicense> getUsedLicenses() {
		return usedLicenses;
	}

	public AllocationMethodology getAllocationMethodology() {
		return allocationMethodology;
	}

	public void setAllocationMethodology(
			AllocationMethodology allocationMethodology) {
		this.allocationMethodology = allocationMethodology;
	}

}
