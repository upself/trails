package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

public class DataExceptionHistoryView implements Serializable {

	private static final long serialVersionUID = 7786268700391190471L;

	private Long customerId;
	private Long accountNumber;
	private Long dataExpHistoryId;
	private Long dataExpId;
	private Long dataExpTypeId;
	private String dataExpTypeName;
	private Date creationTime;
	private Date recordTime;
	private String remoteUser;
	private String assignee;
	private String comment;
	public Long getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	public Long getDataExpHistoryId() {
		return dataExpHistoryId;
	}
	public void setDataExpHistoryId(Long dataExpHistoryId) {
		this.dataExpHistoryId = dataExpHistoryId;
	}
	public Long getDataExpId() {
		return dataExpId;
	}
	public void setDataExpId(Long dataExpId) {
		this.dataExpId = dataExpId;
	}
	public Long getDataExpTypeId() {
		return dataExpTypeId;
	}
	public void setDataExpTypeId(Long dataExpTypeId) {
		this.dataExpTypeId = dataExpTypeId;
	}
	public String getDataExpTypeName() {
		return dataExpTypeName;
	}
	public void setDataExpTypeName(String dataExpTypeName) {
		this.dataExpTypeName = dataExpTypeName;
	}
	public Date getCreationTime() {
		return creationTime;
	}
	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
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
	public String getAssignee() {
		return assignee;
	}
	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}	
	public Long getAccountNumber() {
		return accountNumber;
	}
	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}
}
