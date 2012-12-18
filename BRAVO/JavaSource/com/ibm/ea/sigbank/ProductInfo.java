/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;


/**
 * @author donnie
 *
 */
public class ProductInfo
	extends ValidatorActionForm {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Long productId;
	private Long softwareCategoryId;
	private Integer priority;
	private Boolean licensable;
	private String changeJustification;
	private String comments;
	private String remoteUser;
	private Date recordTime;
	private SoftwareCategory softwareCategory;
	private String licenseLevel;
	
	public String getLicenseLevel() {
		return licenseLevel;
	}
	public void setLicenseLevel(String licenseLevel) {
		this.licenseLevel = licenseLevel;
	}
	public SoftwareCategory getSoftwareCategory() {
		return softwareCategory;
	}
	public void setSoftwareCategory(SoftwareCategory softwareCategory) {
		this.softwareCategory = softwareCategory;
	}
	public Long getProductId() {
		return productId;
	}
	public void setProductId(Long productId) {
		this.productId = productId;
	}
	public Long getSoftwareCategoryId() {
		return softwareCategoryId;
	}
	public void setSoftwareCategoryId(Long softwareCategoryId) {
		this.softwareCategoryId = softwareCategoryId;
	}
	public Integer getPriority() {
		return priority;
	}
	public void setPriority(Integer priority) {
		this.priority = priority;
	}
	public Boolean getLicensable() {
		return licensable;
	}
	public void setLicensable(Boolean licensable) {
		this.licensable = licensable;
	}
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

}