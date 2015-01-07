/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.softwarecategory;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.sigbank.framework.common.Constants;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareCategory extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareCategoryId;

	private String softwareCategoryName;

	private String changeJustification;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @@return Returns the comments.
	 */
	public String getComments() {
		return comments;
	}

	/**
	 * @@param comments
	 *            The comments to set.
	 */
	public void setComments(String comments) {
		this.comments = comments;
	}

	/**
	 * @@return Returns the recordTime.
	 */
	public Date getRecordTime() {
		return recordTime;
	}

	/**
	 * @@param recordTime
	 *            The recordTime to set.
	 */
	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	/**
	 * @@return Returns the remoteUser.
	 */
	public String getRemoteUser() {
		return remoteUser;
	}

	/**
	 * @@param remoteUser
	 *            The remoteUser to set.
	 */
	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	/**
	 * @@return Returns the softwareCategoryId.
	 */
	public Long getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	/**
	 * @@param softwareCategoryId
	 *            The softwareCategoryId to set.
	 */
	public void setSoftwareCategoryId(Long softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

	/**
	 * @@return Returns the softwareCategoryName.
	 */
	public String getSoftwareCategoryName() {
		return softwareCategoryName;
	}

	/**
	 * @@param softwareCategoryName
	 *            The softwareCategoryName to set.
	 */
	public void setSoftwareCategoryName(String softwareCategoryName) {
		this.softwareCategoryName = softwareCategoryName;
	}

	/**
	 * @@return Returns the status.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @@param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getStatusImage() {
		if (status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_OK
					+ "\" width=\"12\" height=\"10\"/>";
		else if (status.equals(Constants.INACTIVE)) {
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_NA
					+ "\" width=\"12\" height=\"10\"/>";
		} else {
			return "<img alt=\"" + Constants.ALERT + "\" src=\""
					+ Constants.ICON_SYSTEM_STATUS_ALERT
					+ "\" width=\"12\" height=\"10\"/>";
		}
	}
}