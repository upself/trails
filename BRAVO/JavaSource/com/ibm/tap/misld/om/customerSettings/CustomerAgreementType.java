/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.customerSettings;

import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class CustomerAgreementType {

    private Long   customerAgreementTypeId;

    private String customerAgreementType;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the customerAgreementType.
     */
    public String getCustomerAgreementType() {
        return customerAgreementType;
    }

    /**
     * @param customerAgreementType
     *            The customerAgreementType to set.
     */
    public void setCustomerAgreementType(String customerAgreementType) {
        this.customerAgreementType = customerAgreementType;
    }

    /**
     * @return Returns the customerAgreementTypeId.
     */
    public Long getCustomerAgreementTypeId() {
        return customerAgreementTypeId;
    }

    /**
     * @param customerAgreementTypeId
     *            The customerAgreementTypeId to set.
     */
    public void setCustomerAgreementTypeId(Long customerAgreementTypeId) {
        this.customerAgreementTypeId = customerAgreementTypeId;
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