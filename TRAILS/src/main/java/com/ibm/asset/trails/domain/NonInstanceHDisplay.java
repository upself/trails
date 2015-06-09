package com.ibm.asset.trails.domain;

import java.util.Date;

public class NonInstanceHDisplay {
	
	private Long id;
	private Long nonInstanceId;
	
	private Long softwareId;
	private String softwareName;
	
	private String manufacturerName;
	
	private String restriction;
	
	private Integer capacityCode;
	private String capacityDesc;
	
	private Integer baseOnly;

	private Long statusId;
	private String statusDesc;
	
	private String remoteUser;
	
	private Date recordTime;

	
	public NonInstanceHDisplay() {
		
	}


	public NonInstanceHDisplay(Long id, Long nonInstanceId, Long softwareId,
			String softwareName, String manufacturerName, String restriction,
			Integer capacityCode, String capacityDesc, Integer baseOnly,
			Long statusId, String statusDesc, String remoteUser, Date recordTime) {
		super();
		this.id = id;
		this.nonInstanceId = nonInstanceId;
		this.softwareId = softwareId;
		this.softwareName = softwareName;
		this.manufacturerName = manufacturerName;
		this.restriction = restriction;
		this.capacityCode = capacityCode;
		this.capacityDesc = capacityDesc;
		this.baseOnly = baseOnly;
		this.statusId = statusId;
		this.statusDesc = statusDesc;
		this.remoteUser = remoteUser;
		this.recordTime = recordTime;
	}


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


	public Long getSoftwareId() {
		return softwareId;
	}


	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}


	public String getSoftwareName() {
		return softwareName;
	}


	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}


	public String getManufacturerName() {
		return manufacturerName;
	}


	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}


	public String getRestriction() {
		return restriction;
	}


	public void setRestriction(String restriction) {
		this.restriction = restriction;
	}


	public Integer getCapacityCode() {
		return capacityCode;
	}


	public void setCapacityCode(Integer capacityCode) {
		this.capacityCode = capacityCode;
	}


	public String getCapacityDesc() {
		return capacityDesc;
	}


	public void setCapacityDesc(String capacityDesc) {
		this.capacityDesc = capacityDesc;
	}


	public Integer getBaseOnly() {
		return baseOnly;
	}


	public void setBaseOnly(Integer baseOnly) {
		this.baseOnly = baseOnly;
	}


	public Long getStatusId() {
		return statusId;
	}


	public void setStatusId(Long statusId) {
		this.statusId = statusId;
	}


	public String getStatusDesc() {
		return statusDesc;
	}


	public void setStatusDesc(String statusDesc) {
		this.statusDesc = statusDesc;
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
}
