/*
 * Created on Mar 9, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software.parser;

import com.ibm.ea.bravo.software.InstalledSoftware;

/**
 * @author dbryson@us.ibm.com
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ParserInstalledSoftware extends InstalledSoftware {
	
	/**
     * 
     */
    private static final long serialVersionUID = 1985501981964046509L;
    /* Below here is data in the file and parsed for checking purposes
	 * But will not be stored to the database
	 */
	private String softwareId;
	private String productName;	
	private String vendorId;
	private String vendorName;
	private String cpuSysName;
	private String cpuSerialNumber;
	private String cpuModelNumber;
	private String versionGroupId;
	private String productVersion;
	private String productRelease;
	private Long accountId;
	private Integer processorCount;
	private Integer users;
	

	/**
	 * @return Returns the processorCount.
	 */
	public Integer getProcessorCount() {
		return processorCount;
	}
	/**
	 * @param processorCount The processorCount to set.
	 */
	public void setProcessorCount(Integer processorCount) {
		this.processorCount = processorCount;
	}
	/**
	 * @return Returns the users.
	 */
	public Integer getUsers() {
		return users;
	}
	/**
	 * @param users The users to set.
	 */
	public void setUsers(Integer users) {
		this.users = users;
	}
	/**
	 * @return Returns the cpuModelNumber.
	 */
	public String getCpuModelNumber() {
		return cpuModelNumber;
	}
	/**
	 * @param cpuModelNumber The cpuModelNumber to set.
	 */
	public void setCpuModelNumber(String cpuModelNumber) {
		this.cpuModelNumber = cpuModelNumber;
	}
	/**
	 * @return Returns the cpuSerialNumber.
	 */
	public String getCpuSerialNumber() {
		return cpuSerialNumber;
	}
	/**
	 * @param cpuSerialNumber The cpuSerialNumber to set.
	 */
	public void setCpuSerialNumber(String cpuSerialNumber) {
		this.cpuSerialNumber = cpuSerialNumber;
	}
	/**
	 * @return Returns the cpuSysName.
	 */
	public String getCpuSysName() {
		return cpuSysName;
	}
	/**
	 * @param cpuSysName The cpuSysName to set.
	 */
	public void setCpuSysName(String cpuSysName) {
		this.cpuSysName = cpuSysName;
	}
	/**
	 * @return Returns the productName.
	 */
	public String getProductName() {
		return productName;
	}
	/**
	 * @param productName The productName to set.
	 */
	public void setProductName(String productName) {
		this.productName = productName;
	}
	/**
	 * @return Returns the productRelease.
	 */
	public String getProductRelease() {
		return productRelease;
	}
	/**
	 * @param productRelease The productRelease to set.
	 */
	public void setProductRelease(String productRelease) {
		this.productRelease = productRelease;
	}
	/**
	 * @return Returns the productVersion.
	 */
	public String getProductVersion() {
		return productVersion;
	}
	/**
	 * @param productVersion The productVersion to set.
	 */
	public void setProductVersion(String productVersion) {
		this.productVersion = productVersion;
	}
	/**
	 * @return Returns the softwareId.
	 */
	public String getSoftwareId() {
		return softwareId;
	}
	/**
	 * @param softwareId The softwareId to set.
	 */
	public void setSoftwareId(String softwareId) {
		this.softwareId = softwareId;
	}
	/**
	 * @return Returns the vendorId.
	 */
	public String getVendorId() {
		return vendorId;
	}
	/**
	 * @param vendorId The vendorId to set.
	 */
	public void setVendorId(String vendorId) {
		this.vendorId = vendorId;
	}
	/**
	 * @return Returns the vendorName.
	 */
	public String getVendorName() {
		return vendorName;
	}
	/**
	 * @param vendorName The vendorName to set.
	 */
	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}
	/**
	 * @return Returns the versionGroupId.
	 */
	public String getVersionGroupId() {
		return versionGroupId;
	}
	/**
	 * @param versionGroupId The versionGroupId to set.
	 */
	public void setVersionGroupId(String versionGroupId) {
		this.versionGroupId = versionGroupId;
	}
	/**
	 * @return Returns the accountId.
	 */
	public Long getAccountId() {
		return accountId;
	}
	/**
	 * @param accountId The accountId to set.
	 */
	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}
}
