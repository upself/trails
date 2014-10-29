/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.consent;

import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class ConsentType {

    private Long   consentTypeId;

    private String consentTypeName;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the consentTypeId.
     */
    public Long getConsentTypeId() {
        return consentTypeId;
    }

    /**
     * @param consentTypeId
     *            The consentTypeId to set.
     */
    public void setConsentTypeId(Long consentTypeId) {
        this.consentTypeId = consentTypeId;
    }

    /**
     * @return Returns the consentTypeName.
     */
    public String getConsentTypeName() {
        return consentTypeName;
    }

    /**
     * @param consentTypeName
     *            The consentTypeName to set.
     */
    public void setConsentTypeName(String consentTypeName) {
        this.consentTypeName = consentTypeName;
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