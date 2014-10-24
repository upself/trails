/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareForm extends ValidatorActionForm {

	private static final long serialVersionUID = 1L;

	private String softwareId;

	private String manufacturer;

	private String softwareCategory;

	private String softwareName;

	private String level;

	private String changeJustification;

	private String type;

	private String vendorManaged;

	private String comments;

	private String priority;

	private String status;

	private String[] selectedItems;

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		if (comments == null) {
			this.comments = comments;
		} else {
			this.comments = comments.replaceAll("\t", " ").replaceAll("\n", " ")
					.replaceAll("\r", " ");
		}
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
		if (changeJustification == null) {
			this.changeJustification = changeJustification;
		} else {
			this.changeJustification = changeJustification.replaceAll("\t", " ")
					.replaceAll("\n", " ").replaceAll("\r", " ");
		}
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getSoftwareCategory() {
		return softwareCategory;
	}

	public void setSoftwareCategory(String softwareCategory) {
		this.softwareCategory = softwareCategory;
	}

	public String getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(String softwareId) {
		this.softwareId = softwareId;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getPriority() {
		return priority;
	}

	public void setPriority(String priority) {
		this.priority = priority;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String[] getSelectedItems() {
		return selectedItems;
	}

	public void setSelectedItems(String[] selectedItems) {
		this.selectedItems = selectedItems;
	}

	public String getVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(String vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

}