/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.signature;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareSignatureForm extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String softwareSignatureId;

	private String softwareId;

	private String tcmId;

	private String fileName;

	private String fileSize;

	private String softwareVersion;

	private String signatureSource;

	private String checksumQuick;

	private String checksumCrc32;

	private String checksumMd5;

	private String endOfSupport;

	private String osType;

	private String status;

	private String changeJustification;

	private String comments;

	private String[] selectedItems;

	public String getChangeJustification() {
		return changeJustification;
	}

	public void setChangeJustification(String changeJustification) {
		this.changeJustification = changeJustification;
	}

	public String getChecksumCrc32() {
		return checksumCrc32;
	}

	public void setChecksumCrc32(String checksumCrc32) {
		this.checksumCrc32 = checksumCrc32;
	}

	public String getChecksumMd5() {
		return checksumMd5;
	}

	public void setChecksumMd5(String checksumMd5) {
		this.checksumMd5 = checksumMd5;
	}

	public String getChecksumQuick() {
		return checksumQuick;
	}

	public void setChecksumQuick(String checksumQuick) {
		this.checksumQuick = checksumQuick;
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

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public String getOsType() {
		return osType;
	}

	public void setOsType(String osType) {
		this.osType = osType;
	}

	public String getSignatureSource() {
		return signatureSource;
	}

	public void setSignatureSource(String signatureSource) {
		this.signatureSource = signatureSource;
	}

	public String getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(String softwareId) {
		this.softwareId = softwareId;
	}

	public String getSoftwareSignatureId() {
		return softwareSignatureId;
	}

	public void setSoftwareSignatureId(String softwareSignatureId) {
		this.softwareSignatureId = softwareSignatureId;
	}

	public String getSoftwareVersion() {
		return softwareVersion;
	}

	public void setSoftwareVersion(String softwareVersion) {
		this.softwareVersion = softwareVersion;
	}

	public String getTcmId() {
		return tcmId;
	}

	public void setTcmId(String tcmId) {
		this.tcmId = tcmId;
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

}
