/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.licenseAgreementType;

import java.io.Serializable;
import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class LicenseAgreementType implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long   licenseAgreementTypeId;

    private String licenseAgreementTypeName;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the licenseAgreementTypeId.
     */
    public Long getLicenseAgreementTypeId() {
        return licenseAgreementTypeId;
    }

    /**
     * @param licenseAgreementTypeId
     *            The licenseAgreementTypeId to set.
     */
    public void setLicenseAgreementTypeId(Long licenseAgreementTypeId) {
        this.licenseAgreementTypeId = licenseAgreementTypeId;
    }

    /**
     * @return Returns the licenseAgreementTypeName.
     */
    public String getLicenseAgreementTypeName() {
        return licenseAgreementTypeName;
    }

    /**
     * @param licenseAgreementTypeName
     *            The licenseAgreementTypeName to set.
     */
    public void setLicenseAgreementTypeName(String licenseAgreementTypeName) {
        this.licenseAgreementTypeName = licenseAgreementTypeName;
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