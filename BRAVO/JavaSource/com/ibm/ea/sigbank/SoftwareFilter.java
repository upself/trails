/*
 * Created on Mar 24, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareFilter {
	private Long softwareFilterId;

	private Software software;

	private String softwareName;

	private String softwareVersion;

	private String mapSoftwareVersion;

	private Date endOfSupport;

	private String osType;

	private String registryKey;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @return Returns the endOfSupport.
	 */
	public Date getEndOfSupport() {
		return endOfSupport;
	}

	/**
	 * @param endOfSupport
	 *            The endOfSupport to set.
	 */
	public void setEndOfSupport(Date endOfSupport) {
		this.endOfSupport = endOfSupport;
	}

	/**
	 * @return Returns the mapSoftwareVersion.
	 */
	public String getMapSoftwareVersion() {
		return mapSoftwareVersion;
	}

	/**
	 * @param mapSoftwareVersion
	 *            The mapSoftwareVersion to set.
	 */
	public void setMapSoftwareVersion(String mapSoftwareVersion) {
		this.mapSoftwareVersion = mapSoftwareVersion;
	}

	/**
	 * @return Returns the osType.
	 */
	public String getOsType() {
		return osType;
	}

	/**
	 * @param osType
	 *            The osType to set.
	 */
	public void setOsType(String osType) {
		this.osType = osType;
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

	/**
	 * @return Returns the software.
	 */
	public Software getSoftware() {
		return software;
	}

	/**
	 * @param software
	 *            The software to set.
	 */
	public void setSoftware(Software software) {
		this.software = software;
	}

	/**
	 * @return Returns the softwareFilterId.
	 */
	public Long getSoftwareFilterId() {
		return softwareFilterId;
	}

	/**
	 * @param softwareFilterId
	 *            The softwareFilterId to set.
	 */
	public void setSoftwareFilterId(Long softwareFilterId) {
		this.softwareFilterId = softwareFilterId;
	}

	/**
	 * @return Returns the softwareName.
	 */
	public String getSoftwareName() {
		return softwareName;
	}

	/**
	 * @param softwareName
	 *            The softwareName to set.
	 */
	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	/**
	 * @return Returns the softwareVersion.
	 */
	public String getSoftwareVersion() {
		return softwareVersion;
	}

	/**
	 * @param softwareVersion
	 *            The softwareVersion to set.
	 */
	public void setSoftwareVersion(String softwareVersion) {
		this.softwareVersion = softwareVersion;
	}

	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}

	/**
	 * @return Returns the registryKey.
	 */
	public String getRegistryKey() {
		return registryKey;
	}

	/**
	 * @param registryKey
	 *            The registryKey to set.
	 */
	public void setRegistryKey(String registryKey) {
		this.registryKey = registryKey;
	}
}
