/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import java.io.Serializable;
import java.util.Date;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareH implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareHId;

	private Software software;

	private String softwareName;

	private String manufacturer;

	private String softwareCategory;

	private Integer priority;

	private String level;

	private String changeJustification;

	private String type;

	private boolean vendorManaged;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	public static long getSerialVersionUID() {
		return serialVersionUID;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public String getLevel() {
		return level;
	}

	public void setLevel(String level) {
		this.level = level;
	}

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public Integer getPriority() {
		return priority;
	}

	public void setPriority(Integer priority) {
		this.priority = priority;
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

	public Software getSoftware() {
		return software;
	}

	public void setSoftware(Software software) {
		this.software = software;
	}

	public String getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(String softwareCategory) {
		this.softwareCategory = softwareCategory;
	}

	public Long getSoftwareHId() {
		return softwareHId;
	}

	public void setSoftwareHId(Long softwareHId) {
		this.softwareHId = softwareHId;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean isVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(boolean vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

}