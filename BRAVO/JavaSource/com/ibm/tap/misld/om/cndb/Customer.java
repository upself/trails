/*
 * Created on Feb 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.cndb;

import java.io.Serializable;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.cndb.Contact;
import com.ibm.ea.cndb.CountryCode;
import com.ibm.ea.cndb.CustomerType;
import com.ibm.ea.cndb.Industry;
import com.ibm.ea.cndb.Pod;
import com.ibm.ea.cndb.Sector;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;
import com.ibm.tap.misld.om.customerSettings.MisldRegistration;
import com.ibm.tap.misld.om.notification.Notification;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Customer extends ValidatorActionForm implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Sector sector;
	
	private Long customerId;

	private CustomerType customerType;

	private Pod pod;

	private Industry industry;

	private MisldRegistration misldRegistration;

	private MisldAccountSettings misldAccountSettings;

	private Long accountNumber;

	private String customerName;

	private Contact contactDPE;

	private Contact contactFA;

	private Contact contactFocalAsset;

	private Contact contactHW;

	private Contact contactSW;

	private Contact contactTransition;

	private String assetToolsBillingCode;
	
	private CountryCode countryCode;

	private String status;

	private Notification priceReportNotification;

	private Notification scanNotification;

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
	 * @return Returns the assetToolsBillingCode.
	 */
	public String getAssetToolsBillingCode() {
		return assetToolsBillingCode;
	}

	/**
	 * @param assetToolsBillingCode
	 *            The assetToolsBillingCode to set.
	 */
	public void setAssetToolsBillingCode(String assetToolsBillingCode) {
		this.assetToolsBillingCode = assetToolsBillingCode;
	}

	/**
	 * @return Returns the contactDPE.
	 */
	public Contact getContactDPE() {
		return contactDPE;
	}

	/**
	 * @param contactDPE
	 *            The contactDPE to set.
	 */
	public void setContactDPE(Contact contactDPE) {
		this.contactDPE = contactDPE;
	}

	/**
	 * @return Returns the contactFA.
	 */
	public Contact getContactFA() {
		return contactFA;
	}

	/**
	 * @param contactFA
	 *            The contactFA to set.
	 */
	public void setContactFA(Contact contactFA) {
		this.contactFA = contactFA;
	}

	/**
	 * @return Returns the contactFocalAsset.
	 */
	public Contact getContactFocalAsset() {
		return contactFocalAsset;
	}

	/**
	 * @param contactFocalAsset
	 *            The contactFocalAsset to set.
	 */
	public void setContactFocalAsset(Contact contactFocalAsset) {
		this.contactFocalAsset = contactFocalAsset;
	}

	/**
	 * @return Returns the contactHW.
	 */
	public Contact getContactHW() {
		return contactHW;
	}

	/**
	 * @param contactHW
	 *            The contactHW to set.
	 */
	public void setContactHW(Contact contactHW) {
		this.contactHW = contactHW;
	}

	/**
	 * @return Returns the contactSW.
	 */
	public Contact getContactSW() {
		return contactSW;
	}

	/**
	 * @param contactSW
	 *            The contactSW to set.
	 */
	public void setContactSW(Contact contactSW) {
		this.contactSW = contactSW;
	}

	/**
	 * @return Returns the contactTransition.
	 */
	public Contact getContactTransition() {
		return contactTransition;
	}

	/**
	 * @param contactTransition
	 *            The contactTransition to set.
	 */
	public void setContactTransition(Contact contactTransition) {
		this.contactTransition = contactTransition;
	}

	/**
	 * @return Returns the customerId.
	 */
	public Long getCustomerId() {
		return customerId;
	}

	/**
	 * @param customerId
	 *            The customerId to set.
	 */
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
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
	public CustomerType getCustomerType() {
		return customerType;
	}

	/**
	 * @param customerType
	 *            The customerType to set.
	 */
	public void setCustomerType(CustomerType customerType) {
		this.customerType = customerType;
	}

	/**
	 * @return Returns the industry.
	 */
	public Industry getIndustry() {
		return industry;
	}

	/**
	 * @param industry
	 *            The industry to set.
	 */
	public void setIndustry(Industry industry) {
		this.industry = industry;
	}

	/**
	 * @return Returns the pod.
	 */
	public Pod getPod() {
		return pod;
	}

	/**
	 * @param pod
	 *            The pod to set.
	 */
	public void setPod(Pod pod) {
		this.pod = pod;
	}

	public CountryCode getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(CountryCode countryCode) {
		this.countryCode = countryCode;
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
	 * @return Returns the misldAccountSettings.
	 */
	public MisldAccountSettings getMisldAccountSettings() {
		return misldAccountSettings;
	}

	/**
	 * @param misldAccountSettings
	 *            The misldAccountSettings to set.
	 */
	public void setMisldAccountSettings(
			MisldAccountSettings misldAccountSettings) {
		this.misldAccountSettings = misldAccountSettings;
	}

	/**
	 * @return Returns the misldRegistration.
	 */
	public MisldRegistration getMisldRegistration() {
		return misldRegistration;
	}

	/**
	 * @param misldRegistration
	 *            The misldRegistration to set.
	 */
	public void setMisldRegistration(MisldRegistration misldRegistration) {
		this.misldRegistration = misldRegistration;
	}

	/**
	 * @return Returns the priceReportNotification.
	 */
	public Notification getPriceReportNotification() {
		return priceReportNotification;
	}

	/**
	 * @param priceReportNotification
	 *            The priceReportNotification to set.
	 */
	public void setPriceReportNotification(Notification priceReportNotification) {
		this.priceReportNotification = priceReportNotification;
	}

	/**
	 * @param notification
	 */
	public void setScanNotification(Notification notification) {
		// TODO Auto-generated method stub

	}

	/**
	 * @return Returns the scanNotification.
	 */
	public Notification getScanNotification() {
		return scanNotification;
	}

	public Sector getSector() {
		return sector;
	}

	public void setSector(Sector sector) {
		this.sector = sector;
	}
}