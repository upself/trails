/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.util.Date;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class SoftwareCategory {
    private Long softwareCategoryId;
    private String softwareCategoryName;
    private String comments;
    private String remoteUser;
    private Date recordTime;
    private String status;

    /**
     * @return Returns the comments.
     */
    public String getComments() {
        return comments;
    }

    /**
     * @param comments
     *            The comments to set.
     */
    public void setComments(String comments) {
        this.comments = comments;
    }

    /**
     * @return Returns the recordTime.
     */
    public Date getRecordTime() {
        return recordTime;
    }
    /**
     * @param recordTime The recordTime to set.
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
     * @return Returns the softwareCategoryId.
     */
    public Long getSoftwareCategoryId() {
        return softwareCategoryId;
    }

    /**
     * @param softwareCategoryId
     *            The softwareCategoryId to set.
     */
    public void setSoftwareCategoryId(Long softwareCategoryId) {
        this.softwareCategoryId = softwareCategoryId;
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