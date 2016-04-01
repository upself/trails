/*
 * Created on Mar 24, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.filter;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareFilterForm extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String softwareFilterId;

	private String softwareId;

	private String softwareName;

	private String softwareVersion;

	private String mapSoftwareVersion;

	private String endOfSupport;

	private String osType;

	private String changeJustification;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	private String[] selectedItems;

	private String action;
	
	private String catalogType;

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

	public String getEndOfSupport() {
		return endOfSupport;
	}

	public void setEndOfSupport(String endOfSupport) {
		this.endOfSupport = endOfSupport;
	}

	public String getMapSoftwareVersion() {
		return mapSoftwareVersion;
	}

	public void setMapSoftwareVersion(String mapSoftwareVersion) {
		this.mapSoftwareVersion = mapSoftwareVersion;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
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

	public String getSoftwareFilterId() {
		return softwareFilterId;
	}

	public void setSoftwareFilterId(String softwareFilterId) {
		this.softwareFilterId = softwareFilterId;
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

	public String getSoftwareVersion() {
		return softwareVersion;
	}

	public void setSoftwareVersion(String softwareVersion) {
		this.softwareVersion = softwareVersion;
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

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getCatalogType() {
		return catalogType;
	}

	public void setCatalogType(String catalogType) {
		this.catalogType = catalogType;
	}

}
