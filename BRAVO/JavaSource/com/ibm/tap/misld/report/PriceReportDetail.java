/*
 * Created on Dec 6, 2004
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PriceReportDetail {

	private String country;

	private String nodeName;

	private String serialNumber;

	private String machineType;

	private String machineModel;

	private Date scanDate;

	private String nodeOwner;
	
	private String nodeOwnerFlag = "";

	private String softwareOwner;

	private String softwareOwnerFlag = "";

	private String softwareBuyer;

	private int processorCount;

	private String processorFlag = "";

	private int userCount;

	private String userFlag = "";

	private String authenticated = "";

	private String authenticatedFlag = "";

	private String noOsFlag = "";

	private String sku;

	private String licenseType;

	private String productDescription;

	private String licenseAgreementType;

	private String licenseAgreementTypeFlag = "";

	private BigDecimal splaQuarterlyPrice = new BigDecimal(0);

	private BigDecimal esplaYearlyPrice = new BigDecimal(0);

	private String poNumber;

	private String lpid;

	/**
	 * @return Returns the authenticated.
	 */
	public String getAuthenticated() {
		return authenticated;
	}

	/**
	 * @param authenticated
	 *            The authenticated to set.
	 */
	public void setAuthenticated(String authenticated) {
		this.authenticated = authenticated;
	}

	/**
	 * @return Returns the authenticatedFlag.
	 */
	public String getAuthenticatedFlag() {
		return authenticatedFlag;
	}

	/**
	 * @param authenticatedFlag
	 *            The authenticatedFlag to set.
	 */
	public void setAuthenticatedFlag(String authenticatedFlag) {
		this.authenticatedFlag = authenticatedFlag;
	}

	/**
	 * @return Returns the country.
	 */
	public String getCountry() {
		return country;
	}

	/**
	 * @param country
	 *            The country to set.
	 */
	public void setCountry(String country) {
		this.country = country;
	}

	/**
	 * @return Returns the esplaYearlyPrice.
	 */
	public BigDecimal getEsplaYearlyPrice() {
		return esplaYearlyPrice.setScale(2,BigDecimal.ROUND_HALF_UP);
	}

	/**
	 * @param esplaYearlyPrice
	 *            The esplaYearlyPrice to set.
	 */
	public void setEsplaYearlyPrice(BigDecimal esplaYearlyPrice) {
		this.esplaYearlyPrice = esplaYearlyPrice;
	}

	/**
	 * @return Returns the hostname.
	 */
	public String getNodeName() {
		return nodeName;
	}

	/**
	 * @param hostname
	 *            The hostname to set.
	 */
	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}

	/**
	 * @return Returns the licenseAgreementType.
	 */
	public String getLicenseAgreementType() {
		return licenseAgreementType;
	}

	/**
	 * @param licenseAgreementType
	 *            The licenseAgreementType to set.
	 */
	public void setLicenseAgreementType(String licenseAgreementType) {
		this.licenseAgreementType = licenseAgreementType;
	}

	/**
	 * @return Returns the licenseAgreementTypeFlag.
	 */
	public String getLicenseAgreementTypeFlag() {
		return licenseAgreementTypeFlag;
	}

	/**
	 * @param licenseAgreementTypeFlag
	 *            The licenseAgreementTypeFlag to set.
	 */
	public void setLicenseAgreementTypeFlag(String licenseAgreementTypeFlag) {
		this.licenseAgreementTypeFlag = licenseAgreementTypeFlag;
	}

	/**
	 * @return Returns the licenseType.
	 */
	public String getLicenseType() {
		return licenseType;
	}

	/**
	 * @param licenseType
	 *            The licenseType to set.
	 */
	public void setLicenseType(String licenseType) {
		this.licenseType = licenseType;
	}

	/**
	 * @return Returns the machineModel.
	 */
	public String getMachineModel() {
		return machineModel;
	}

	/**
	 * @param machineModel
	 *            The machineModel to set.
	 */
	public void setMachineModel(String machineModel) {
		this.machineModel = machineModel;
	}

	/**
	 * @return Returns the machineType.
	 */
	public String getMachineType() {
		return machineType;
	}

	/**
	 * @param machineType
	 *            The machineType to set.
	 */
	public void setMachineType(String machineType) {
		this.machineType = machineType;
	}

	/**
	 * @return Returns the nodeOwner.
	 */
	public String getNodeOwner() {
		return nodeOwner;
	}

	/**
	 * @param nodeOwner
	 *            The nodeOwner to set.
	 */
	public void setNodeOwner(String nodeOwner) {
		this.nodeOwner = nodeOwner;
	}

	/**
	 * @return Returns the noOsFlag.
	 */
	public String getNoOsFlag() {
		return noOsFlag;
	}

	/**
	 * @param noOsFlag
	 *            The noOsFlag to set.
	 */
	public void setNoOsFlag(String noOsFlag) {
		this.noOsFlag = noOsFlag;
	}

	/**
	 * @return Returns the processorCount.
	 */
	public int getProcessorCount() {
		return processorCount;
	}

	/**
	 * @param processorCount
	 *            The processorCount to set.
	 */
	public void setProcessorCount(int processorCount) {
		this.processorCount = processorCount;
	}

	/**
	 * @return Returns the processorFlag.
	 */
	public String getProcessorFlag() {
		return processorFlag;
	}

	/**
	 * @param processorFlag
	 *            The processorFlag to set.
	 */
	public void setProcessorFlag(String processorFlag) {
		this.processorFlag = processorFlag;
	}

	/**
	 * @return Returns the productDescription.
	 */
	public String getProductDescription() {
		return productDescription;
	}

	/**
	 * @param productDescription
	 *            The productDescription to set.
	 */
	public void setProductDescription(String productDescription) {
		this.productDescription = productDescription;
	}

	/**
	 * @return Returns the scanDate.
	 */
	public Date getScanDate() {
		return scanDate;
	}

	/**
	 * @param scanDate
	 *            The scanDate to set.
	 */
	public void setScanDate(Date scanDate) {
		this.scanDate = scanDate;
	}

	/**
	 * @return Returns the serialNumber.
	 */
	public String getSerialNumber() {
		return serialNumber;
	}

	/**
	 * @param serialNumber
	 *            The serialNumber to set.
	 */
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

	/**
	 * @return Returns the sku.
	 */
	public String getSku() {
		return sku;
	}

	/**
	 * @param sku
	 *            The sku to set.
	 */
	public void setSku(String sku) {
		this.sku = sku;
	}

	/**
	 * @return Returns the softwareBuyer.
	 */
	public String getSoftwareBuyer() {
		return softwareBuyer;
	}

	/**
	 * @param softwareBuyer
	 *            The softwareBuyer to set.
	 */
	public void setSoftwareBuyer(String softwareBuyer) {
		this.softwareBuyer = softwareBuyer;
	}

	/**
	 * @return Returns the softwareOwner.
	 */
	public String getSoftwareOwner() {
		return softwareOwner;
	}

	/**
	 * @param softwareOwner
	 *            The softwareOwner to set.
	 */
	public void setSoftwareOwner(String softwareOwner) {
		this.softwareOwner = softwareOwner;
	}

	/**
	 * @return Returns the softwareOwnerFlag.
	 */
	public String getSoftwareOwnerFlag() {
		return softwareOwnerFlag;
	}

	/**
	 * @param softwareOwnerFlag
	 *            The softwareOwnerFlag to set.
	 */
	public void setSoftwareOwnerFlag(String softwareOwnerFlag) {
		this.softwareOwnerFlag = softwareOwnerFlag;
	}

	/**
	 * @return Returns the splaQuarterlyPrice.
	 */
	public BigDecimal getSplaQuarterlyPrice() {
		return splaQuarterlyPrice.setScale(2,BigDecimal.ROUND_HALF_UP);
	}

	/**
	 * @param splaQuarterlyPrice
	 *            The splaQuarterlyPrice to set.
	 */
	public void setSplaQuarterlyPrice(BigDecimal splaQuarterlyPrice) {
		this.splaQuarterlyPrice = splaQuarterlyPrice;
	}

	/**
	 * @return Returns the userCount.
	 */
	public int getUserCount() {
		return userCount;
	}

	/**
	 * @param userCount
	 *            The userCount to set.
	 */
	public void setUserCount(int userCount) {
		this.userCount = userCount;
	}

	/**
	 * @return Returns the userFlag.
	 */
	public String getUserFlag() {
		return userFlag;
	}

	/**
	 * @param userFlag
	 *            The userFlag to set.
	 */
	public void setUserFlag(String userFlag) {
		this.userFlag = userFlag;
	}

	/**
	 * @return Returns the poNumber.
	 */
	public String getPoNumber() {
		return poNumber;
	}

	/**
	 * @param poNumber
	 *            The poNumber to set.
	 */
	public void setPoNumber(String poNumber) {
		this.poNumber = poNumber;
	}

	/**
	 * @return Returns the lpid.
	 */
	public String getLpid() {
		return lpid;
	}

	/**
	 * @param lpid
	 *            The lpid to set.
	 */
	public void setLpid(String lpid) {
		this.lpid = lpid;
	}
	/**
	 * @return Returns the nodeOwnerFlag.
	 */
	public String getNodeOwnerFlag() {
		return nodeOwnerFlag;
	}
	/**
	 * @param nodeOwnerFlag The nodeOwnerFlag to set.
	 */
	public void setNodeOwnerFlag(String nodeOwnerFlag) {
		this.nodeOwnerFlag = nodeOwnerFlag;
	}
}