/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.softwarecategory;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareCategoryForm extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String softwareCategoryId;

	private String softwareCategoryName;

	private String changeJustification;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
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

	public String getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	public void setSoftwareCategoryId(String softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}

	public String getSoftwareCategoryName() {
		return softwareCategoryName;
	}

	public void setSoftwareCategoryName(String softwareCategoryName) {
		this.softwareCategoryName = softwareCategoryName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}