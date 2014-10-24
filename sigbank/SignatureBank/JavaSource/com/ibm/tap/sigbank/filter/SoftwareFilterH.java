/*
 * Created on Mar 24, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.filter;

import java.io.Serializable;
import java.util.Date;

import com.ibm.asset.swkbt.domain.Product;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareFilterH implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareFilterHId;

	private SoftwareFilter softwareFilter;

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

	public SoftwareFilter getSoftwareFilter() {
		return softwareFilter;
	}

	public void setSoftwareFilter(SoftwareFilter softwareFilter) {
		this.softwareFilter = softwareFilter;
	}

	public Long getSoftwareFilterHId() {
		return softwareFilterHId;
	}

	public void setSoftwareFilterHId(Long softwareFilterHId) {
		this.softwareFilterHId = softwareFilterHId;
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

}
