package com.ibm.asset.trails.domain;

import java.util.Date;

public class PriorityISVSoftwareDisplay {
	
	private Long id;
	
	private String level;
	
	private Long customerId;
	
	private String accountName;
	
	private Long accountNumber;
	
	private Long manufacturerId;
	
	private String manufacturerName;
	
	private String evidenceLocation;
	
	private Long statusId;
	
	private String statusDesc;
	
	private String businessJustification;
	
	private String remoteUser;
	
	private Date recordTime;
	
	public PriorityISVSoftwareDisplay() {
	}

	public PriorityISVSoftwareDisplay(Long id, String level,
		    Long customerId, String accountName, Long accountNumber,
			Long manufacturerId, String manufacturerName,
			String evidenceLocation, Long statusId,
			String statusDesc, String businessJustification, String remoteUser, Date recordTime) {
		this.id = id;
		this.level = level;
		this.customerId = customerId;
		this.accountName = accountName;
		this.accountNumber = accountNumber;
		this.manufacturerId = manufacturerId;
		this.manufacturerName = manufacturerName;
		this.evidenceLocation = evidenceLocation;
		this.statusId = statusId;
		this.statusDesc = statusDesc;
		this.businessJustification = businessJustification;
		this.remoteUser = remoteUser;
		this.recordTime = recordTime;
	}


	public Long getId() {
		return id;
	}


	public void setId(Long id) {
		this.id = id;
	}


	public String getLevel() {
		return level;
	}


	public void setLevel(String level) {
		this.level = level;
	}


	public Long getCustomerId() {
		return customerId;
	}


	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}


	public String getAccountName() {
		return accountName;
	}


	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}


	public Long getAccountNumber() {
		return accountNumber;
	}


	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}


	public Long getManufacturerId() {
		return manufacturerId;
	}


	public void setManufacturerId(Long manufacturerId) {
		this.manufacturerId = manufacturerId;
	}


	public String getManufacturerName() {
		return manufacturerName;
	}


	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}


	public String getEvidenceLocation() {
		return evidenceLocation;
	}


	public void setEvidenceLocation(String evidenceLocation) {
		this.evidenceLocation = evidenceLocation;
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


	public String getBusinessJustification() {
		return businessJustification;
	}


	public void setBusinessJustification(String businessJustification) {
		this.businessJustification = businessJustification;
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
