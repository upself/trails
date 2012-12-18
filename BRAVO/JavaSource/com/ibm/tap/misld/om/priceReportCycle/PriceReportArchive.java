/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.priceReportCycle;

import java.math.BigDecimal;
import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * @author alexmois
 *  
 */
public class PriceReportArchive extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long priceReportArchiveId;

	private PriceReportCycle priceReportCycle;

	private String splaNumber;

	private String esplaNumber;

	private String poNumber;

	private Date poDate;

	private Date usageDate;

	private String orderType;

	private String offeringType;

	private Long accountNumber;

	private String customerName;

	private String customerType;

	private String pod;

	private String industry;

	private String sector;

	private String customerLicenseAgreementType;

	private String priceLevel;

	private String qualifiedDiscount;

	private String country;

	private String nodeName;

	private String serialNumber;

	private String machineType;

	private String machineModel;

	private Date scanDate;

	private String nodeOwner;

	private String softwareOwner;

	private int processorCount;

	private int userCount;

	private String authenticated;

	private String sku;

	private String licenseType;

	private String productDescription;

	private String licenseAgreementType;

	private BigDecimal splaQuarterlyPrice = new BigDecimal(0);

	private BigDecimal esplaYearlyPrice = new BigDecimal(0);

	private String remoteUser;

	private Date recordTime;

	private String status;

	private String lpid;

	private String major;

	/**
	 * @return Returns the accountNumber.
	 */
	public Long getAccountNumber() {
		return accountNumber;
	}

	/**
	 * @param accountNumber
	 *            The accountNumber to set.
	 */
	public void setAccountNumber(Long accountNumber) {
		this.accountNumber = accountNumber;
	}

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
	 * @return Returns the customerLicenseAgreementType.
	 */
	public String getCustomerLicenseAgreementType() {
		return customerLicenseAgreementType;
	}

	/**
	 * @param customerLicenseAgreementType
	 *            The customerLicenseAgreementType to set.
	 */
	public void setCustomerLicenseAgreementType(
			String customerLicenseAgreementType) {
		this.customerLicenseAgreementType = customerLicenseAgreementType;
	}

	/**
	 * @return Returns the customerName.
	 */
	public String getCustomerName() {
		return customerName;
	}

	/**
	 * @param customerName
	 *            The customerName to set.
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	/**
	 * @return Returns the customerType.
	 */
	public String getCustomerType() {
		return customerType;
	}

	/**
	 * @param customerType
	 *            The customerType to set.
	 */
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	/**
	 * @return Returns the esplaNumber.
	 */
	public String getEsplaNumber() {
		return esplaNumber;
	}

	/**
	 * @param esplaNumber
	 *            The esplaNumber to set.
	 */
	public void setEsplaNumber(String esplaNumber) {
		this.esplaNumber = esplaNumber;
	}

	/**
	 * @return Returns the esplaYearlyPrice.
	 */
	public BigDecimal getEsplaYearlyPrice() {
		return esplaYearlyPrice;
	}

	/**
	 * @param esplaYearlyPrice
	 *            The esplaYearlyPrice to set.
	 */
	public void setEsplaYearlyPrice(BigDecimal esplaYearlyPrice) {
		this.esplaYearlyPrice = esplaYearlyPrice;
	}

	/**
	 * @return Returns the industry.
	 */
	public String getIndustry() {
		return industry;
	}

	/**
	 * @param industry
	 *            The industry to set.
	 */
	public void setIndustry(String industry) {
		this.industry = industry;
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
	 * @return Returns the nodeName.
	 */
	public String getNodeName() {
		return nodeName;
	}

	/**
	 * @param nodeName
	 *            The nodeName to set.
	 */
	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
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
	 * @return Returns the pod.
	 */
	public String getPod() {
		return pod;
	}

	/**
	 * @param pod
	 *            The pod to set.
	 */
	public void setPod(String pod) {
		this.pod = pod;
	}

	/**
	 * @return Returns the poDate.
	 */
	public Date getPoDate() {
		return poDate;
	}

	/**
	 * @param poDate
	 *            The poDate to set.
	 */
	public void setPoDate(Date poDate) {
		this.poDate = poDate;
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
	 * @return Returns the priceLevel.
	 */
	public String getPriceLevel() {
		return priceLevel;
	}

	/**
	 * @param priceLevel
	 *            The priceLevel to set.
	 */
	public void setPriceLevel(String priceLevel) {
		this.priceLevel = priceLevel;
	}

	/**
	 * @return Returns the priceReportArchiveId.
	 */
	public Long getPriceReportArchiveId() {
		return priceReportArchiveId;
	}

	/**
	 * @param priceReportArchiveId
	 *            The priceReportArchiveId to set.
	 */
	public void setPriceReportArchiveId(Long priceReportArchiveId) {
		this.priceReportArchiveId = priceReportArchiveId;
	}

	/**
	 * @return Returns the priceReportCycle.
	 */
	public PriceReportCycle getPriceReportCycle() {
		return priceReportCycle;
	}

	/**
	 * @param priceReportCycle
	 *            The priceReportCycle to set.
	 */
	public void setPriceReportCycle(PriceReportCycle priceReportCycle) {
		this.priceReportCycle = priceReportCycle;
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
	 * @return Returns the qualifiedDiscount.
	 */
	public String getQualifiedDiscount() {
		return qualifiedDiscount;
	}

	/**
	 * @param qualifiedDiscount
	 *            The qualifiedDiscount to set.
	 */
	public void setQualifiedDiscount(String qualifiedDiscount) {
		this.qualifiedDiscount = qualifiedDiscount;
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
	 * @return Returns the sector.
	 */
	public String getSector() {
		return sector;
	}

	/**
	 * @param sector
	 *            The sector to set.
	 */
	public void setSector(String sector) {
		this.sector = sector;
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
	 * @return Returns the splaNumber.
	 */
	public String getSplaNumber() {
		return splaNumber;
	}

	/**
	 * @param splaNumber
	 *            The splaNumber to set.
	 */
	public void setSplaNumber(String splaNumber) {
		this.splaNumber = splaNumber;
	}

	/**
	 * @return Returns the splaQuarterlyPrice.
	 */
	public BigDecimal getSplaQuarterlyPrice() {
		return splaQuarterlyPrice;
	}

	/**
	 * @param splaQuarterlyPrice
	 *            The splaQuarterlyPrice to set.
	 */
	public void setSplaQuarterlyPrice(BigDecimal splaQuarterlyPrice) {
		this.splaQuarterlyPrice = splaQuarterlyPrice;
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
	 * @return Returns the usageDate.
	 */
	public Date getUsageDate() {
		return usageDate;
	}

	/**
	 * @param usageDate
	 *            The usageDate to set.
	 */
	public void setUsageDate(Date usageDate) {
		this.usageDate = usageDate;
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
	 * @return Returns the offeringType.
	 */
	public String getOfferingType() {
		return offeringType;
	}

	/**
	 * @param offeringType
	 *            The offeringType to set.
	 */
	public void setOfferingType(String offeringType) {
		this.offeringType = offeringType;
	}

	/**
	 * @return Returns the orderType.
	 */
	public String getOrderType() {
		return orderType;
	}

	/**
	 * @param orderType
	 *            The orderType to set.
	 */
	public void setOrderType(String orderType) {
		this.orderType = orderType;
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
	 * @return Returns the major.
	 */
	public String getMajor() {
		return major;
	}

	/**
	 * @param major
	 *            The major to set.
	 */
	public void setMajor(String major) {
		this.major = major;
	}
}