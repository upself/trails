/*
 * Created on Nov 25, 2008
 *
 */
package com.ibm.tap.misld.om.holiday;

import java.util.Date;


/**
 * @author keneikirk
 *  
 */
public class Holiday {

	private Date holiday;

	private String remoteUser;

	private Date recordTime;


	/**
	 * @return Returns the holiday.
	 */
	public Date getHoliday() {
		return holiday;
	}

	/**
	 * @param notificationId
	 *            The holiday to set.
	 */
	public void setHoliday(Date holiday) {
		this.holiday = holiday;
	}

	/**
	 * @return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @param recordTime
	 *            The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

}