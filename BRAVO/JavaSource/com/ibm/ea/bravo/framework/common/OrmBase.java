package com.ibm.ea.bravo.framework.common;

import java.io.Serializable;
import java.util.Date;

public class OrmBase implements Serializable {

	private static final long serialVersionUID = 1L;
	protected String remoteUser;
	protected Date recordTime = new Date();
	protected String status = Constants.ACTIVE;
	
	public String getStatusImage() {
		if (this.status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_OK + "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_NA + "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (this.status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}

	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return this.recordTime;
	}
	/**
	 * @param recordTime The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}
	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return this.remoteUser;
	}
	/**
	 * @param remoteUser The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return this.status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
