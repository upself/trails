/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.asset.swkbt.domain.Manufacturer;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Software extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareId;

	private String softwareName;

	private Manufacturer manufacturer;

	private SoftwareCategory softwareCategory;

	private Integer priority;

	private String level;

	private String type;

	private Boolean vendorManaged;

	private String changeJustification;

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

	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Manufacturer manufacturer) {
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

	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}

	public Long getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
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

	public Boolean getVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(Boolean vendorManaged) {
		this.vendorManaged = vendorManaged;
	}
}