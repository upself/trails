package com.ibm.ea.bravo.recon;

import java.util.Date;

public class ReconInstalledSoftware {
	private Long id;
	private Long installedSoftwareId;
	private Long customerId;
	private String action;
	private String remoteUser;
	private Date recordTime;
	
	public Long getInstalledSoftwareId() {
		return installedSoftwareId;
	}
	public void setInstalledSoftwareId(Long installedSoftwareId) {
		this.installedSoftwareId = installedSoftwareId;
	}
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	public String getAction() {
		return action;
	}
	public void setAction(String action) {
		this.action = action;
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
