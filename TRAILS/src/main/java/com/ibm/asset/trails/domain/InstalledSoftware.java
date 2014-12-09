package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;


@Entity
@Table(name = "INSTALLED_SOFTWARE")
@org.hibernate.annotations.Entity(mutable = false)
public class InstalledSoftware extends AbstractDomainEntity {
	private static final long serialVersionUID = -8152553219663818453L;

	@Id
	@Column(name = "ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_LPAR_ID")
	private VSoftwareLpar softwareLpar;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID")
	private Software software;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DISCREPANCY_TYPE_ID")
	private DiscrepancyType discrepancyType;

	@Column(name = "USERS")
	private Integer users;

	@Column(name = "PROCESSOR_COUNT")
	private Integer processorCount;

	@Column(name = "REMOTE_USER")
	private String remoteUser;

	@Column(name = "RECORD_TIME")
	private Date recordTime;

	@Column(name = "STATUS")
	private String status;

	@OneToOne(fetch = FetchType.LAZY, mappedBy = "installedSoftware", optional = true)
	private AlertUnlicensedSwRecon alert;

	public Long getId() {
		return id;
	}

	public Integer getProcessorCount() {
		return processorCount;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public Software getSoftware() {
		return software;
	}

	public String getStatus() {
		return status;
	}

	public Integer getUsers() {
		return users;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public void setUsers(Integer users) {
		this.users = users;
	}

	public VSoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	public void setSoftwareLpar(VSoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

	public DiscrepancyType getDiscrepancyType() {
		return discrepancyType;
	}

	public void setDiscrepancyType(DiscrepancyType discrepancyType) {
		this.discrepancyType = discrepancyType;
	}

	public AlertUnlicensedSwRecon getAlert() {
		return alert;
	}

	public void setAlert(AlertUnlicensedSwRecon alert) {
		this.alert = alert;
	}

	@Override
	public boolean equals(final Object other) {
		if (!(other instanceof InstalledSoftware))
			return false;
		InstalledSoftware castOther = (InstalledSoftware) other;
		return new EqualsBuilder().append(softwareLpar, castOther.softwareLpar)
				.append(software, castOther.software).isEquals();
	}

	@Override
	public int hashCode() {
		return new HashCodeBuilder().append(softwareLpar).append(software)
				.toHashCode();
	}

}
