/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.signature;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareSignatureInput {
	private String fileName;

	private String fileSize;

	private String softwareVersion;

	private String signatureSource;

	private String checksumQuick;

	private String checksumCrc32;

	private String checksumMd5;

	private String endOfSupportDate;

	private String osType;

	/**
	 * @return Returns the fileSize.
	 */
	public String getFileSize() {
		return fileSize;
	}

	/**
	 * @param fileSize
	 *            The fileSize to set.
	 */
	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	/**
	 * @return Returns the endOfSupportDate.
	 */
	public String getEndOfSupportDate() {
		return endOfSupportDate;
	}

	/**
	 * @param endOfSupportDate
	 *            The endOfSupportDate to set.
	 */
	public void setEndOfSupportDate(String endOfSupportDate) {
		this.endOfSupportDate = endOfSupportDate;
	}

	/**
	 * @return Returns the checksumCrc32.
	 */
	public String getChecksumCrc32() {
		return checksumCrc32;
	}

	/**
	 * @param checksumCrc32
	 *            The checksumCrc32 to set.
	 */
	public void setChecksumCrc32(String checksumCrc32) {
		this.checksumCrc32 = checksumCrc32;
	}

	/**
	 * @return Returns the checksumMd5.
	 */
	public String getChecksumMd5() {
		return checksumMd5;
	}

	/**
	 * @param checksumMd5
	 *            The checksumMd5 to set.
	 */
	public void setChecksumMd5(String checksumMd5) {
		this.checksumMd5 = checksumMd5;
	}

	/**
	 * @return Returns the checksumQuick.
	 */
	public String getChecksumQuick() {
		return checksumQuick;
	}

	/**
	 * @param checksumQuick
	 *            The checksumQuick to set.
	 */
	public void setChecksumQuick(String checksumQuick) {
		this.checksumQuick = checksumQuick;
	}

	/**
	 * @return Returns the fileName.
	 */
	public String getFileName() {
		return fileName;
	}

	/**
	 * @param fileName
	 *            The fileName to set.
	 */
	public void setFileName(String fileName) {
		this.fileName = fileName;
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
	 * @return Returns the signatureSource.
	 */
	public String getSignatureSource() {
		return signatureSource;
	}

	/**
	 * @param signatureSource
	 *            The signatureSource to set.
	 */
	public void setSignatureSource(String signatureSource) {
		this.signatureSource = signatureSource;
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

}
