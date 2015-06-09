package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "NON_INSTANCE_H")
public class NonInstanceH extends AbstractDomainEntity {
	private static final long serialVersionUID = -1570160658765275811L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;
	
	@Column(name = "NON_INSTANCE_ID", nullable  = false)
	private Long nonInstanceId;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "SOFTWARE_ID" , nullable  = false)
	private Software software;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MANUFACTURER_ID" , nullable  = false)
	private Manufacturer manufacturer;

	@Column(name = "RESTRICTION", length=8, nullable  = false)
	private String restriction;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "CAPACITY_TYPE_CODE", nullable = false)
	private CapacityType capacityType;
	
	@Column(name = "BASE_ONLY", nullable = false)
	private Integer baseOnly;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "STATUS_ID", nullable = false)
	private Status status;
	
	@Column(name="REMOTE_USER", nullable = false)
	private String remoteUser;
	
	@Column(name="RECORD_TIME", nullable = false)
	private Date recordTime;

	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getNonInstanceId() {
		return nonInstanceId;
	}

	public void setNonInstanceId(Long nonInstanceId) {
		this.nonInstanceId = nonInstanceId;
	}

	public Software getSoftware() {
		return software;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}

	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getRestriction() {
		return restriction;
	}

	public void setRestriction(String restriction) {
		this.restriction = restriction;
	}

	public CapacityType getCapacityType() {
		return capacityType;
	}

	public void setCapacityType(CapacityType capacityType) {
		this.capacityType = capacityType;
	}

	public Integer getBaseOnly() {
		return baseOnly;
	}

	public void setBaseOnly(Integer baseOnly) {
		this.baseOnly = baseOnly;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int hashCode() {
		// TODO Auto-generated method stub
		return 0;
	}
}
