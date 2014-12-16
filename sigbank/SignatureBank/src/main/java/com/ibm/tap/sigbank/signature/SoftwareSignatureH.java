/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.signature;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.asset.swkbt.domain.Product;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareSignatureH extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long softwareSignatureHId;

	private SoftwareSignature softwareSignature;

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

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public SoftwareSignature getSoftwareSignature() {
		return softwareSignature;
	}

	public void setSoftwareSignature(SoftwareSignature softwareSignature) {
		this.softwareSignature = softwareSignature;
	}

	public Long getSoftwareSignatureHId() {
		return softwareSignatureHId;
	}

	public void setSoftwareSignatureHId(Long softwareSignatureHId) {
		this.softwareSignatureHId = softwareSignatureHId;
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

}