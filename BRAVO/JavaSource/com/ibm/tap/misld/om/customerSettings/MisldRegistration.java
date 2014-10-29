/*
 * Created on Feb 18, 2005
 *
 */
package com.ibm.tap.misld.om.customerSettings;

import java.util.Date;

import org.apache.struts.validator.ValidatorActionForm;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 *  
 */
public class MisldRegistration extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Long misldRegistrationId;

	private Customer customer;

	private boolean inScope;

	private String notInScopeJustification;

	private String justificationOther;

	private String remoteUser;

	private Date recordTime;

	private String status;

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
	 * @return Returns the inScope.
	 */
	public boolean isInScope() {
		return inScope;
	}

	/**
	 * @param inScope
	 *            The inScope to set.
	 */
	public void setInScope(boolean inScope) {
		this.inScope = inScope;
	}

	/**
	 * @return Returns the misldRegistrationId.
	 */
	public Long getMisldRegistrationId() {
		return misldRegistrationId;
	}

	/**
	 * @param misldRegistrationId
	 *            The misldRegistrationId to set.
	 */
	public void setMisldRegistrationId(Long misldRegistrationId) {
		this.misldRegistrationId = misldRegistrationId;
	}

	/**
	 * @return Returns the notInScopeJustification.
	 */
	public String getNotInScopeJustification() {
		return notInScopeJustification;
	}

	/**
	 * @param notInScopeJustification
	 *            The notInScopeJustification to set.
	 */
	public void setNotInScopeJustification(String notInScopeJustification) {
		this.notInScopeJustification = notInScopeJustification;
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
	 * @return Returns the justificationOther.
	 */
	public String getJustificationOther() {
		return justificationOther;
	}

	/**
	 * @param justificationOther
	 *            The justificationOther to set.
	 */
	public void setJustificationOther(String justificationOther) {
		this.justificationOther = justificationOther;
	}
}