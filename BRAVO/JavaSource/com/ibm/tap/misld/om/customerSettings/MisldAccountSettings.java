/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.customerSettings;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import com.ibm.ea.cndb.Lpid;
import com.ibm.tap.misld.framework.CommandDispatchForm;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.licenseAgreementType.LicenseAgreementType;
import com.ibm.tap.misld.om.qualifiedDiscount.QualifiedDiscount;

/**
 * @author alexmois
 *  
 */
public class MisldAccountSettings extends CommandDispatchForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long misldAccountSettingsId;

	private Customer customer;

	private LicenseAgreementType licenseAgreementType;

	private boolean releaseInformation;

	private boolean contractEnd;

	private String microsoftSoftwareOwner;

	private String microsoftSoftwareBuyer;

	private QualifiedDiscount qualifiedDiscount;

	private Long qualifiedDiscountLong;

	private boolean usMachines;

	private Long customerAgreementLongs[] = new Long[0];

	private String remoteUser;

	private Date recordTime;

	private String status;

	private Set customerAgreement = new HashSet();

	private Long defaultLpidLong;

	private Lpid defaultLpid;
	
	private String priceReportStatus;
	
	private String priceReportStatusUser;
	
	private Date priceReportTimestamp;

	/**
	 * @return Returns the contractEnd.
	 */
	public boolean isContractEnd() {
		return contractEnd;
	}

	/**
	 * @param contractEnd
	 *            The contractEnd to set.
	 */
	public void setContractEnd(boolean contractEnd) {
		this.contractEnd = contractEnd;
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return customer;
	}

	/**
	 * @param customer2
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer2) {
		this.customer = customer2;
	}

	/**
	 * @return Returns the licenseAgreementType.
	 */
	public LicenseAgreementType getLicenseAgreementType() {
		return licenseAgreementType;
	}

	/**
	 * @param licenseAgreementType
	 *            The licenseAgreementType to set.
	 */
	public void setLicenseAgreementType(
			LicenseAgreementType licenseAgreementType) {
		this.licenseAgreementType = licenseAgreementType;
	}

	/**
	 * @return Returns the microsoftSoftwareBuyer.
	 */
	public String getMicrosoftSoftwareBuyer() {
		return microsoftSoftwareBuyer;
	}

	/**
	 * @param microsoftSoftwareBuyer
	 *            The microsoftSoftwareBuyer to set.
	 */
	public void setMicrosoftSoftwareBuyer(String microsoftSoftwareBuyer) {
		this.microsoftSoftwareBuyer = microsoftSoftwareBuyer;
	}

	/**
	 * @return Returns the microsoftSoftwareOwner.
	 */
	public String getMicrosoftSoftwareOwner() {
		return microsoftSoftwareOwner;
	}

	/**
	 * @param microsoftSoftwareOwner
	 *            The microsoftSoftwareOwner to set.
	 */
	public void setMicrosoftSoftwareOwner(String microsoftSoftwareOwner) {
		this.microsoftSoftwareOwner = microsoftSoftwareOwner;
	}

	/**
	 * @return Returns the misldAccountSettingsId.
	 */
	public Long getMisldAccountSettingsId() {
		return misldAccountSettingsId;
	}

	/**
	 * @param misldAccountSettingsId
	 *            The misldAccountSettingsId to set.
	 */
	public void setMisldAccountSettingsId(Long misldAccountSettingsId) {
		this.misldAccountSettingsId = misldAccountSettingsId;
	}

	/**
	 * @return Returns the qualifiedDiscount.
	 */
	public QualifiedDiscount getQualifiedDiscount() {
		return qualifiedDiscount;
	}

	/**
	 * @param qualifiedDiscount
	 *            The qualifiedDiscount to set.
	 */
	public void setQualifiedDiscount(QualifiedDiscount qualifiedDiscount) {
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
	 * @return Returns the releaseInformation.
	 */
	public boolean isReleaseInformation() {
		return releaseInformation;
	}

	/**
	 * @param releaseInformation
	 *            The releaseInformation to set.
	 */
	public void setReleaseInformation(boolean releaseInformation) {
		this.releaseInformation = releaseInformation;
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
	 * @return Returns the usMachines.
	 */
	public boolean isUsMachines() {
		return usMachines;
	}

	/**
	 * @param usMachines
	 *            The usMachines to set.
	 */
	public void setUsMachines(boolean usMachines) {
		this.usMachines = usMachines;
	}

	/**
	 * @return Returns the qualifiedDiscountLong.
	 */
	public Long getQualifiedDiscountLong() {
		return qualifiedDiscountLong;
	}

	/**
	 * @param qualifiedDiscountLong
	 *            The qualifiedDiscountLong to set.
	 */
	public void setQualifiedDiscountLong(Long qualifiedDiscountLong) {
		this.qualifiedDiscountLong = qualifiedDiscountLong;
	}

	/**
	 * @return Returns the customerLicenseAgreementLongs.
	 */
	public Long[] getCustomerAgreementLongs() {
		return customerAgreementLongs;
	}

	/**
	 * @param customerAgreementLongs
	 *            The customerAgreementLongs to set.
	 */
	public void setCustomerAgreementLongs(Long[] customerAgreementLongs) {
		this.customerAgreementLongs = customerAgreementLongs;
	}

	/**
	 * @return Returns the customerAgreement.
	 */
	public Set getCustomerAgreement() {
		return customerAgreement;
	}

	/**
	 * @param customerAgreement
	 *            The customerAgreement to set.
	 */
	public void setCustomerAgreement(Set customerAgreement) {
		this.customerAgreement = customerAgreement;
	}

	/**
	 * @return Returns the defaultLpid.
	 */
	public Lpid getDefaultLpid() {
		return defaultLpid;
	}

	/**
	 * @param defaultLpid
	 *            The defaultLpid to set.
	 */
	public void setDefaultLpid(Lpid defaultLpid) {
		this.defaultLpid = defaultLpid;
	}

	/**
	 * @return Returns the defaultLpidLong.
	 */
	public Long getDefaultLpidLong() {
		return defaultLpidLong;
	}

	/**
	 * @param defaultLpidLong
	 *            The defaultLpidLong to set.
	 */
	public void setDefaultLpidLong(Long defaultLpidLong) {
		this.defaultLpidLong = defaultLpidLong;
	}

	/**
	 * @return Returns the priceReportStatus.
	 */
	public String getPriceReportStatus() {
		return priceReportStatus;
	}

	/**
	 * @param status
	 *            The priceReportStatus to set.
	 */
	public void setPriceReportStatus(String priceReportStatus) {
		this.priceReportStatus = priceReportStatus;
	}

	/**
	 * @return Returns the priceReportStatusUser.
	 */
	
	public String getPriceReportStatusUser() {
		return priceReportStatusUser;
	}

	/**
	 * @param priceReportStatusUser
	 *            The priceReportStatusUser to set.
	 */
	public void setPriceReportStatusUser(String priceReportStatusUser) {
		this.priceReportStatusUser = priceReportStatusUser;
	}

	/**
	 * @return Returns the priceReportTimestamp.
	 */
	public Date getPriceReportTimestamp() {
		return priceReportTimestamp;
	}

	/**
	 * @param priceReportTimestamp
	 *            The priceReportTimestamp to set.
	 */
	public void setPriceReportTimestamp(Date priceReportTimestamp) {
		this.priceReportTimestamp = priceReportTimestamp;
	}

}