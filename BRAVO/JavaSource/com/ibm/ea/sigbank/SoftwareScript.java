
package com.ibm.ea.sigbank;

import java.util.Date;

public class SoftwareScript {
	private Long softwareScriptId;

	private Software software;

	private String softwareName;

	private String softwareVersion;

	private String mapSoftwareVersion;

	private String remoteUser;

	private Date recordTime;

	private String status;
	
	private String changeJustification;
	
	private String catalogType;
	
	private String comments;

	public Long getSoftwareScriptId() {
		return softwareScriptId;
	}

	public void setSoftwareScriptId(Long softwareScriptId) {
		this.softwareScriptId = softwareScriptId;
	}

	public Software getSoftware() {
		return software;
	}

	public void setSoftware(Software software) {
		this.software = software;
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

	public String getMapSoftwareVersion() {
		return mapSoftwareVersion;
	}

	public void setMapSoftwareVersion(String mapSoftwareVersion) {
		this.mapSoftwareVersion = mapSoftwareVersion;
	}

	public String getRemoteUser() {
		return remoteUser;
	}

	public void setRemoteUser(String remoteUser) {
		this.remoteUser = remoteUser;
	}

	public Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(Date recordTime) {
		this.recordTime = recordTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getCatalogType() {
		return catalogType;
	}

	public void setCatalogType(String catalogType) {
		this.catalogType = catalogType;
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}
}
