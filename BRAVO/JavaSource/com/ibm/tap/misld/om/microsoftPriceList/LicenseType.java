/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.microsoftPriceList;

import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class LicenseType {

    private Long   licenseTypeId;

    private String licenseTypeName;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the licenseTypeId.
     */
    public Long getLicenseTypeId() {
        return licenseTypeId;
    }

    /**
     * @param licenseTypeId
     *            The licenseTypeId to set.
     */
    public void setLicenseTypeId(Long licenseTypeId) {
        this.licenseTypeId = licenseTypeId;
    }

    /**
     * @return Returns the licenseTypeName.
     */
    public String getLicenseTypeName() {
        return licenseTypeName;
    }

    /**
     * @param licenseTypeName
     *            The licenseTypeName to set.
     */
    public void setLicenseTypeName(String licenseTypeName) {
        this.licenseTypeName = licenseTypeName;
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