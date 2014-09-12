/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.signature;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.framework.common.Constants;

/**
 * @@author Thomas
 * 
 *          TODO To change the template for this generated type comment go to
 *          Window - Preferences - Java - Code Style - Code Templates
 */
public class SoftwareSignature implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareSignatureId;

	private Product product;

	private String tcmId;

	private String fileName;

	private Integer fileSize;

	private String softwareVersion;

	private String signatureSource;

	private String checksumQuick;

	private String checksumCrc32;

	private String checksumMd5;

	private Date endOfSupport;

	private String osType;

	private String changeJustification;

	private String comments;

	private String remoteUser;

	private Date recordTime;

	private String status;

	private Set history;

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

	public Date getEndOfSupport() {
		return endOfSupport;
	}

	public void setEndOfSupport(Date endOfSupport) {
		this.endOfSupport = endOfSupport;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Integer getFileSize() {
		return fileSize;
	}

	public void setFileSize(Integer fileSize) {
		this.fileSize = fileSize;
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

	public String getSignatureSource() {
		return signatureSource;
	}

	public void setSignatureSource(String signatureSource) {
		this.signatureSource = signatureSource;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public Product getProduct() {
		return product;
	}

	public Long getSoftwareSignatureId() {
		return softwareSignatureId;
	}

	public void setSoftwareSignatureId(Long softwareSignatureId) {
		this.softwareSignatureId = softwareSignatureId;
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

	public String getTcmId() {
		return tcmId;
	}

	public void setTcmId(String tcmId) {
		this.tcmId = tcmId;
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
}