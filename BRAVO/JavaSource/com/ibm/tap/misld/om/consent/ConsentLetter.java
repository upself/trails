/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.consent;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.priceLevel.PriceLevel;

/**
 * @author alexmois
 *  
 */
public class ConsentLetter
        extends ValidatorActionForm {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long        consentLetterId;

    private Customer    customer;

    private ConsentType consentType;

    private PriceLevel  priceLevel;

    private String      priceLevelValue;

    private String      esplaEnrollmentNumber;

    private Date        respondDate;

    private String      respondDateStr;

    private String      accountStatus;

    private String      assetStatus;

    private String      microsoftStatus;

    private String      remoteUser;

    private Date        recordTime;

    private String      status;

    /**
     * @return Returns the priceLevelValue.
     */
    public String getPriceLevelValue() {
        return priceLevelValue;
    }

    /**
     * @param priceLevelValue
     *            The priceLevelValue to set.
     */
    public void setPriceLevelValue(String priceLevelValue) {
        this.priceLevelValue = priceLevelValue;
    }

    /**
     * @return Returns the consentLetterId.
     */
    public Long getConsentLetterId() {
        return consentLetterId;
    }

    /**
     * @param consentLetterId
     *            The consentLetterId to set.
     */
    public void setConsentLetterId(Long consentLetterId) {
        this.consentLetterId = consentLetterId;
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
     * @return Returns the respondDate.
     */
    public Date getRespondDate() {
        return respondDate;
    }

    /**
     * @param respondDate
     *            The respondDate to set.
     */
    public void setRespondDate(Date respondDate) {
        this.respondDate = respondDate;
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
     * @return Returns the consentType.
     */
    public ConsentType getConsentType() {
        return consentType;
    }

    /**
     * @param consentType
     *            The consentType to set.
     */
    public void setConsentType(ConsentType consentType) {
        this.consentType = consentType;
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
     * @return Returns the esplaEnrollmentNumber.
     */
    public String getEsplaEnrollmentNumber() {
        return esplaEnrollmentNumber;
    }

    /**
     * @param esplaEnrollmentNumber
     *            The esplaEnrollmentNumber to set.
     */
    public void setEsplaEnrollmentNumber(String esplaEnrollmentNumber) {
        this.esplaEnrollmentNumber = esplaEnrollmentNumber;
    }

    /**
     * @return Returns the priceLevel.
     */
    public PriceLevel getPriceLevel() {
        return priceLevel;
    }

    /**
     * @param priceLevel
     *            The priceLevel to set.
     */
    public void setPriceLevel(PriceLevel priceLevel) {
        this.priceLevel = priceLevel;
    }

    /**
     * @return Returns the accountStatus.
     */
    public String getAccountStatus() {
        return accountStatus;
    }

    /**
     * @param accountStatus
     *            The accountStatus to set.
     */
    public void setAccountStatus(String accountStatus) {
        this.accountStatus = accountStatus;
    }

    /**
     * @return Returns the assetStatus.
     */
    public String getAssetStatus() {
        return assetStatus;
    }

    /**
     * @param assetStatus
     *            The assetStatus to set.
     */
    public void setAssetStatus(String assetStatus) {
        this.assetStatus = assetStatus;
    }

    /**
     * @return Returns the microsoftStatus.
     */
    public String getMicrosoftStatus() {
        return microsoftStatus;
    }

    /**
     * @param microsoftStatus
     *            The microsoftStatus to set.
     */
    public void setMicrosoftStatus(String microsoftStatus) {
        this.microsoftStatus = microsoftStatus;
    }

    /**
     * @return Returns the respondDateStr.
     */
    public String getRespondDateStr() {
        if (this.respondDate != null) {
            return Util.parseDateString(this.respondDate);
        }
        return respondDateStr;
    }

    /**
     * @param respondDateStr
     *            The respondDateStr to set.
     */
    public void setRespondDateStr(String respondDateStr) {
        this.respondDateStr = respondDateStr;
    }
}