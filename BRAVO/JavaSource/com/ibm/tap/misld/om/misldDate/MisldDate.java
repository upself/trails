/*
 * Created on Nov 25, 2008
 *
 */
package com.ibm.tap.misld.om.misldDate;

import java.util.Date;


/**
 * @author keneikirk
 *  
 */
public class MisldDate {

	private Long misldDateId;
	
	private String dateType;
	
	private String dateValue;

	private String remoteUser;

	private Date recordTime;


	/**
	 * @return Returns the misld date id.
	 */
	public Long getMisldDateId() {
		return misldDateId;
	}

	/**
	 * @param
	 *            The misld date id to set.
	 */
	public void setMisldDateId(Long misldDateId) {
		this.misldDateId = misldDateId;
	}

	/**
	 * @return Returns the date type.
	 */
	public String getDateType() {
		return dateType;
	}

	/**
	 * @param
	 *            The date type to set.
	 */
	public void setDateType(String dateType) {
		this.dateType = dateType;
	}
	
	/**
	 * @return Returns the date value.
	 */
	public String getDateValue() {
		return dateValue;
	}

	/**
	 * @param
	 *            The date value to set.
	 */
	public void setDateValue(String dateValue) {
		this.dateValue = dateValue;
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