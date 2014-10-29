package com.ibm.asset.trails.form;

import java.util.Date;

public class AlertHistoryReport {

	private String comments;

	private String remoteUser;

	private Date creationTime;

	private Date recordTime;

	private boolean open;

	public AlertHistoryReport(String comments, String remoteUser,
			Date creationTime, Date recordTime, boolean open) {
		this.comments = comments;
		this.remoteUser = remoteUser;
		this.creationTime = creationTime;
		this.recordTime = recordTime;
		this.open = open;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public Date getCreationTime() {
		return creationTime;
	}

	public void setCreationTime(Date creationTime) {
		this.creationTime = creationTime;
	}

	public boolean isOpen() {
		return open;
	}

	public void setOpen(boolean open) {
		this.open = open;
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

}
