/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.customerSettings;

import java.util.Date;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 *  
 */
public class CustomerAgreement {

	private Long customerAgreementId;

	private Customer customer;

	private CustomerAgreementType customerAgreementType;

	private String remoteUser;

	private Date recordTime;

	private String status;

	/**
	 * @return Returns the customerAgreementId.
	 */
	public Long getCustomerAgreementId() {
		return customerAgreementId;
	}

	/**
	 * @param customerAgreementId
	 *            The customerAgreementId to set.
	 */
	public void setCustomerAgreementId(Long customerAgreementId) {
		this.customerAgreementId = customerAgreementId;
	}

	/**
	 * @return Returns the customerAgreementType.
	 */
	public CustomerAgreementType getCustomerAgreementType() {
		return customerAgreementType;
	}

	/**
	 * @param customerAgreementType
	 *            The customerAgreementType to set.
	 */
	public void setCustomerAgreementType(
			CustomerAgreementType customerAgreementType) {
		this.customerAgreementType = customerAgreementType;
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
}