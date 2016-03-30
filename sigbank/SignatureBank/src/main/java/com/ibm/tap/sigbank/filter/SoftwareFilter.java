/*
 * Created on Mar 24, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.filter;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.asset.swkbt.domain.Product;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareFilter implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareFilterId;

	private Product product;

	private String softwareName;

	private String softwareVersion;

	private String mapSoftwareVersion;

	private Date endOfSupport;

	private String osType;

	private String changeJustification;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	private Set history;
	
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

	public Date getEndOfSupport() {
		return endOfSupport;
	}

	public void setEndOfSupport(Date endOfSupport) {
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

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public Long getSoftwareFilterId() {
		return softwareFilterId;
	}

	public void setSoftwareFilterId(Long softwareFilterId) {
		this.softwareFilterId = softwareFilterId;
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

	public Set getHistory() {
		return history;
	}

	public void setHistory(Set history) {
		this.history = history;
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

	public String getCatalogType() {
		return catalogType;
	}

	public void setCatalogType(String catalogType) {
		this.catalogType = catalogType;
	}
}