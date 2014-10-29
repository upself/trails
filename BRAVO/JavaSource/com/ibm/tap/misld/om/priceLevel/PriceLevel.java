/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.priceLevel;

import java.util.Date;

/**
 * @author alexmois
 *  
 */
public class PriceLevel {

    private Long   priceLevelId;

    private String priceLevel;

    private String remoteUser;

    private Date   recordTime;

    private String status;

    /**
     * @return Returns the priceLevel.
     */
    public String getPriceLevel() {
        return priceLevel;
    }

    /**
     * @param priceLevel
     *            The priceLevel to set.
     */
    public void setPriceLevel(String priceLevel) {
        this.priceLevel = priceLevel;
    }

    /**
     * @return Returns the priceLevelId.
     */
    public Long getPriceLevelId() {
        return priceLevelId;
    }

    /**
     * @param priceLevelId
     *            The priceLevelId to set.
     */
    public void setPriceLevelId(Long priceLevelId) {
        this.priceLevelId = priceLevelId;
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