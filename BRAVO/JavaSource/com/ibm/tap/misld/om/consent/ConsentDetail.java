/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.consent;

import java.util.Date;

import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftPriceList;

/**
 * @author alexmois
 *  
 */
public class ConsentDetail {

    private Long               consentDetailId;

    private int                quantity;

    private MicrosoftPriceList microsoftPriceList;

    private ConsentLetter      consentLetter;

    private String             remoteUser;

    private Date               recordTime;

    private String             status;

    /**
     * @return Returns the consentDetailId.
     */
    public Long getConsentDetailId() {
        return consentDetailId;
    }

    /**
     * @param consentDetailId
     *            The consentDetailId to set.
     */
    public void setConsentDetailId(Long consentDetailId) {
        this.consentDetailId = consentDetailId;
    }

    /**
     * @return Returns the consentLetter.
     */
    public ConsentLetter getConsentLetter() {
        return consentLetter;
    }

    /**
     * @param consentLetter
     *            The consentLetter to set.
     */
    public void setConsentLetter(ConsentLetter consentLetter) {
        this.consentLetter = consentLetter;
    }

    /**
     * @return Returns the microsoftPriceList.
     */
    public MicrosoftPriceList getMicrosoftPriceList() {
        return microsoftPriceList;
    }

    /**
     * @param microsoftPriceList
     *            The microsoftPriceList to set.
     */
    public void setMicrosoftPriceList(MicrosoftPriceList microsoftPriceList) {
        this.microsoftPriceList = microsoftPriceList;
    }

    /**
     * @return Returns the quantity.
     */
    public int getQuantity() {
        return quantity;
    }

    /**
     * @param quantity
     *            The quantity to set.
     */
    public void setQuantity(int quantity) {
        this.quantity = quantity;
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
}