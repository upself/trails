/*
 * Created on Feb 8, 2005
 *
 *  go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.cndb;

import java.util.Date;

/**
 * @author denglers
 * 
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class OutsourceProfile {

	private Long id;

	private Customer customer;

	private AssetProcess assetProcess;

	private Country country;

	private String outsourceable;

	private String comment;

	private String approver;

	private Date recordTime;

	private String current;

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
	 * @return Returns the assetProcess.
	 */
	public AssetProcess getAssetProcess() {
		return assetProcess;
	}

	/**
	 * @param assetProcess
	 *            The assetProcess to set.
	 */
	public void setAssetProcess(AssetProcess assetProcess) {
		this.assetProcess = assetProcess;
	}

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
	 * @return Returns the country.
	 */
	public Country getCountry() {
		return country;
	}

	/**
	 * @param country
	 *            The country to set.
	 */
	public void setCountry(Country country) {
		this.country = country;
	}

	/**
	 * @return Returns the current.
	 */
	public String getCurrent() {
		return current;
	}

	/**
	 * @param current
	 *            The current to set.
	 */
	public void setCurrent(String current) {
		this.current = current;
	}

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
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return Returns the outsourceable.
	 */
	public String getOutsourceable() {
		return outsourceable;
	}

	/**
	 * @param outsourceable
	 *            The outsourceable to set.
	 */
	public void setOutsourceable(String outsourceable) {
		this.outsourceable = outsourceable;
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
}
