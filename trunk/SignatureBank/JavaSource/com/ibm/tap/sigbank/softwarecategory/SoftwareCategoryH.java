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
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareCategoryH extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareCategoryHId;

	private SoftwareCategory softwareCategory;

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

	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}

	public Long getSoftwareCategoryHId() {
		return softwareCategoryHId;
	}

	public void setSoftwareCategoryHId(Long softwareCategoryHId) {
		this.softwareCategoryHId = softwareCategoryHId;
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