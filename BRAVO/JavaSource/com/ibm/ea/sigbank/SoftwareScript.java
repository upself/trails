package com.ibm.ea.sigbank;

public class SoftwareScript {

	private String softwareName;
    private String softwareVersion;

    private String mapSoftwareVersion;
    private String remoteUser;
    private java.util.Date recordTime;
    private String status;
    private String changeJustification;
    private String catalogType;
    private String comments;

    private com.ibm.ea.sigbank.Software software;

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

	public java.util.Date getRecordTime() {
		return recordTime;
	}

	public void setRecordTime(java.util.Date recordTime) {
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

	public com.ibm.ea.sigbank.Software getSoftware() {
		return software;
	}

	public void setSoftware(com.ibm.ea.sigbank.Software software) {
		this.software = software;
	}

}
