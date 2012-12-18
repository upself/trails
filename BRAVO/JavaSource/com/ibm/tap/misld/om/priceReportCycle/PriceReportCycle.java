/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.priceReportCycle;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 *  
 */
public class PriceReportCycle extends ValidatorActionForm {

	private Long priceReportCycleId;

	private Customer customer;

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String approver;

	private Date approvalTime;

	private String poUser;

	private Date poEntryTime;

	private String remoteUser;

	private Date recordTime;

	private String cycleStatus;

	private String status;

	private Long customerId;
	
	private String priceReportStatus;
	
	private String priceReportStatusUser;
	
	private Date priceReportStatusTimestamp;

	/**
	 * @return Returns the approvalDate.
	 */
	public Date getApprovalTime() {
		return approvalTime;
	}

	/**
	 * @param approvalDate
	 *            The approvalDate to set.
	 */
	public void setApprovalTime(Date approvalTime) {
		this.approvalTime = approvalTime;
	}

	/**
	 * @return Returns the approver.
	 */
	public String getApprover() {
		return approver;
	}

	/**
	 * @param approver
	 *            The approver to set.
	 */
	public void setApprover(String approver) {
		this.approver = approver;
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return customer;
	}

	/**
	 * @param customer2
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer2) {
		this.customer = customer2;
	}

	/**
	 * @return Returns the cycleStatus.
	 */
	public String getCycleStatus() {
		return cycleStatus;
	}

	/**
	 * @param cycleStatus
	 *            The cycleStatus to set.
	 */
	public void setCycleStatus(String cycleStatus) {
		this.cycleStatus = cycleStatus;
	}

	/**
	 * @return Returns the poEntryDate.
	 */
	public Date getPoEntryTime() {
		return poEntryTime;
	}

	/**
	 * @param poEntryDate
	 *            The poEntryDate to set.
	 */
	public void setPoEntryTime(Date poEntryTime) {
		this.poEntryTime = poEntryTime;
	}

	/**
	 * @return Returns the poUser.
	 */
	public String getPoUser() {
		return poUser;
	}

	/**
	 * @param poUser
	 *            The poUser to set.
	 */
	public void setPoUser(String poUser) {
		this.poUser = poUser;
	}

	/**
	 * @return Returns the priceReportCycleId.
	 */
	public Long getPriceReportCycleId() {
		return priceReportCycleId;
	}

	/**
	 * @param priceReportCycleId
	 *            The priceReportCycleId to set.
	 */
	public void setPriceReportCycleId(Long priceReportCycleId) {
		this.priceReportCycleId = priceReportCycleId;
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
	 * @return Returns the customerId.
	 */
	public Long getCustomerId() {
		return customerId;
	}

	/**
	 * @param customerId
	 *            The customerId to set.
	 */
	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}
	
	/**
	 * @return Returns the priceReportStatus.
	 */
	public String getPriceReportStatus() {
		return priceReportStatus;
	}

	/**
	 * @param status
	 *            The priceReportStatus to set.
	 */
	public void setPriceReportStatus(String priceReportStatus) {
		this.priceReportStatus = priceReportStatus;
	}

	/**
	 * @return Returns the priceReportStatusUser.
	 */
	public String getPriceReportStatusUser() {
		return priceReportStatusUser;
	}

	/**
	 * @param priceReportStatusUser
	 *            The priceReportStatusUser to set.
	 */
	public void setPriceReportStatusUser(String priceReportStatusUser) {
		this.priceReportStatusUser = priceReportStatusUser;
	}

	/**
	 * @return Returns the priceReportStatusTimestamp.
	 */
	public Date getPriceReportStatusTimestamp() {
		return priceReportStatusTimestamp;
	}

	/**
	 * @param priceReportStatusTimestamp
	 *            The priceReportStatusTimestamp to set.
	 */
	public void setPriceReportStatusTimestamp(Date priceReportStatusTimestamp) {
		this.priceReportStatusTimestamp = priceReportStatusTimestamp;
	}
	
}