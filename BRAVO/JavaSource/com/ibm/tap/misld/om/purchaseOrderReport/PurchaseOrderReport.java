/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.om.purchaseOrderReport;

import java.math.BigDecimal;
import java.util.Date;

import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.licenseAgreementType.LicenseAgreementType;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PurchaseOrderReport {

    private Long                 purchaseOrderReportId;

    private Customer             customer;

    private LicenseAgreementType licenseAgreementType;

    private BigDecimal           totalPrice;

    private String               remoteUser;

    private Date                 recordTime;

    private String               status;

    /**
     * @return Returns the customer.
     */
    public Customer getCustomer() {
        return customer;
    }

    /**
     * @param customer
     *            The customer to set.
     */
    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    /**
     * @return Returns the licenseAgreementType.
     */
    public LicenseAgreementType getLicenseAgreementType() {
        return licenseAgreementType;
    }

    /**
     * @param licenseAgreementType
     *            The licenseAgreementType to set.
     */
    public void setLicenseAgreementType(
            LicenseAgreementType licenseAgreementType) {
        this.licenseAgreementType = licenseAgreementType;
    }

    /**
     * @return Returns the purchaseOrderReportId.
     */
    public Long getPurchaseOrderReportId() {
        return purchaseOrderReportId;
    }

    /**
     * @param purchaseOrderReportId
     *            The purchaseOrderReportId to set.
     */
    public void setPurchaseOrderReportId(Long purchaseOrderReportId) {
        this.purchaseOrderReportId = purchaseOrderReportId;
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

    /**
     * @return Returns the totalPrice.
     */
    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    /**
     * @param totalPrice
     *            The totalPrice to set.
     */
    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }
}