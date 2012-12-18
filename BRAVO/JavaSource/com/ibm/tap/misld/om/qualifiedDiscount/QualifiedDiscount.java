/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.qualifiedDiscount;

import java.io.Serializable;
import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class QualifiedDiscount implements Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long   qualifiedDiscountId;

    private String qualifiedDiscount;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the qualifiedDiscount.
     */
    public String getQualifiedDiscount() {
        return qualifiedDiscount;
    }

    /**
     * @param qualifiedDiscount
     *            The qualifiedDiscount to set.
     */
    public void setQualifiedDiscount(String qualifiedDiscount) {
        this.qualifiedDiscount = qualifiedDiscount;
    }

    /**
     * @return Returns the qualifiedDiscountId.
     */
    public Long getQualifiedDiscountId() {
        return qualifiedDiscountId;
    }

    /**
     * @param qualifiedDiscountId
     *            The qualifiedDiscountId to set.
     */
    public void setQualifiedDiscountId(Long qualifiedDiscountId) {
        this.qualifiedDiscountId = qualifiedDiscountId;
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