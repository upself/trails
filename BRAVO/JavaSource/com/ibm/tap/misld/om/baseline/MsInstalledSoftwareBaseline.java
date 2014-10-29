/*
 * Created on Feb 8, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.baseline;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.ea.sigbank.Product;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsInstalledSoftwareBaseline
        extends ValidatorActionForm {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long               msInstalledSoftwareBaselineId;

    private MsHardwareBaseline msHardwareBaseline;

    private Product           software;

    private Integer            userCount;

    private String             softwareOwner;

    private String             softwareBuyer;

    private Date               purchaseEndDate;

    private String             authenticated;

    private String             osUnauthenticatedJust;

    private Date               scanTime;

    private String             comment;

    private String             remoteUser;

    private Date               recordTime;

    private String             status;

    private Long               softwareLong;

    private int                msHardwareBaselineId;

    private String             softwareCategoryName;

    private int                softwareCategoryId;

    private String             loader;

    /**
     * @return Returns the comment.
     */
    public String getComment() {
        return comment;
    }

    /**
     * @param comment
     *            The comment to set.
     */
    public void setComment(String comment) {
        this.comment = comment;
    }

    /**
     * @return Returns the msHardwareBaseline.
     */
    public MsHardwareBaseline getMsHardwareBaseline() {
        return msHardwareBaseline;
    }

    /**
     * @param msHardwareBaseline
     *            The msHardwareBaseline to set.
     */
    public void setMsHardwareBaseline(MsHardwareBaseline msHardwareBaseline) {
        this.msHardwareBaseline = msHardwareBaseline;
    }

    /**
     * @return Returns the msInstalledSoftwareBaselineId.
     */
    public Long getMsInstalledSoftwareBaselineId() {
        return msInstalledSoftwareBaselineId;
    }

    /**
     * @param msInstalledSoftwareBaselineId
     *            The msInstalledSoftwareBaselineId to set.
     */
    public void setMsInstalledSoftwareBaselineId(
            Long msInstalledSoftwareBaselineId) {
        this.msInstalledSoftwareBaselineId = msInstalledSoftwareBaselineId;
    }

    /**
     * @return Returns the osUnAuthenticatedJust.
     */
    public String getOsUnauthenticatedJust() {
        return osUnauthenticatedJust;
    }

    /**
     * @param osUnAuthenticatedJust
     *            The osUnAuthenticatedJust to set.
     */
    public void setOsUnauthenticatedJust(String osUnauthenticatedJust) {
        this.osUnauthenticatedJust = osUnauthenticatedJust;
    }

    /**
     * @return Returns the purchaseEndDate.
     */
    public Date getPurchaseEndDate() {
        return purchaseEndDate;
    }

    /**
     * @param purchaseEndDate
     *            The purchaseEndDate to set.
     */
    public void setPurchaseEndDate(Date purchaseEndDate) {
        this.purchaseEndDate = purchaseEndDate;
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
     * @return Returns the software.
     */
    public Product getSoftware() {
        return software;
    }

    /**
     * @param software
     *            The software to set.
     */
    public void setSoftware(Product software) {
        this.software = software;
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
     * @return Returns the scanTime.
     */
    public Date getScanTime() {
        return scanTime;
    }

    /**
     * @param scanTime
     *            The scanTime to set.
     */
    public void setScanTime(Date scanTime) {
        this.scanTime = scanTime;
    }

    /**
     * @return Returns the softwareLong.
     */
    public Long getSoftwareLong() {
        return softwareLong;
    }

    /**
     * @param softwareLong
     *            The softwareLong to set.
     */
    public void setSoftwareLong(Long softwareLong) {
        this.softwareLong = softwareLong;
    }

    /**
     * @return Returns the msHardwareBaselineId.
     */
    public int getMsHardwareBaselineId() {
        return msHardwareBaselineId;
    }

    /**
     * @param msHardwareBaselineId
     *            The msHardwareBaselineId to set.
     */
    public void setMsHardwareBaselineId(int msHardwareBaselineId) {
        this.msHardwareBaselineId = msHardwareBaselineId;
    }

    /**
     * @return Returns the softwareCategoryName.
     */
    public String getSoftwareCategoryName() {
        return softwareCategoryName;
    }

    /**
     * @param softwareCategoryName
     *            The softwareCategoryName to set.
     */
    public void setSoftwareCategoryName(String softwareCategoryName) {
        this.softwareCategoryName = softwareCategoryName;
    }

    /**
     * @return Returns the softwareCategorId.
     */
    public int getSoftwareCategoryId() {
        return softwareCategoryId;
    }

    /**
     * @param softwareCategorId
     *            The softwareCategorId to set.
     */
    public void setSoftwareCategoryId(int softwareCategoryId) {
        this.softwareCategoryId = softwareCategoryId;
    }

    /**
     * @return Returns the loader.
     */
    public String getLoader() {
        return loader;
    }

    /**
     * @param loader
     *            The loader to set.
     */
    public void setLoader(String loader) {
        this.loader = loader;
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
     * @return Returns the userCount.
     */
    public Integer getUserCount() {
        return userCount;
    }

    /**
     * @param userCount
     *            The userCount to set.
     */
    public void setUserCount(Integer userCount) {
        this.userCount = userCount;
    }
}