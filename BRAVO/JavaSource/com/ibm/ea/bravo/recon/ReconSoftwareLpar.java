package com.ibm.ea.bravo.recon;

import java.util.Date;

public class ReconSoftwareLpar {
	private Long id;
	private Long softwareLparId;
	private Long customerId;
	private String action;
	private String remoteUser;
	private Date recordTime;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Long getSoftwareLparId() {
		return softwareLparId;
	}
	public void setSoftwareLparId(Long softwareLparId) {
		this.softwareLparId = softwareLparId;
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
