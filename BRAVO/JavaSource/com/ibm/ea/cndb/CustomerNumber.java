package com.ibm.ea.cndb;

import java.io.Serializable;

public class CustomerNumber implements Serializable {

	private static final long serialVersionUID = 1L;
	private Long customerNumberId;
	private Customer customer;
	private String customerNumber;
	private Lpid lpid;
	private Contact contactCNO;
	private Contact contactDock;
	private Contact contactCustomerPool;
	private String centralReceivingSupport;
	private String igfCustomerNumber;
	private String status;

	/**
	 * @return Returns the centralReceivingSupport.
	 */
	public String getCentralReceivingSupport() {
		return centralReceivingSupport;
	}

	/**
	 * @param centralReceivingSupport
	 *            The centralReceivingSupport to set.
	 */
	public void setCentralReceivingSupport(String centralReceivingSupport) {
		this.centralReceivingSupport = centralReceivingSupport;
	}

	/**
	 * @return Returns the contactCNO.
	 */
	public Contact getContactCNO() {
		return contactCNO;
	}

	/**
	 * @param contactCNO
	 *            The contactCNO to set.
	 */
	public void setContactCNO(Contact contactCNO) {
		this.contactCNO = contactCNO;
	}

	/**
	 * @return Returns the contactCustomerPool.
	 */
	public Contact getContactCustomerPool() {
		return contactCustomerPool;
	}

	/**
	 * @param contactCustomerPool
	 *            The contactCustomerPool to set.
	 */
	public void setContactCustomerPool(Contact contactCustomerPool) {
		this.contactCustomerPool = contactCustomerPool;
	}

	/**
	 * @return Returns the contactDock.
	 */
	public Contact getContactDock() {
		return contactDock;
	}

	/**
	 * @param contactDock
	 *            The contactDock to set.
	 */
	public void setContactDock(Contact contactDock) {
		this.contactDock = contactDock;
	}

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return customer;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	/**
	 * @return Returns the customerNumber.
	 */
	public String getCustomerNumber() {
		return customerNumber;
	}
	/**
	 * @param customerNumber The customerNumber to set.
	 */
	public void setCustomerNumber(String customerNumber) {
		this.customerNumber = customerNumber;
	}
	/**
	 * @return Returns the customerNumberId.
	 */
	public Long getCustomerNumberId() {
		return customerNumberId;
	}
	/**
	 * @param customerNumberId The customerNumberId to set.
	 */
	public void setCustomerNumberId(Long customerNumberId) {
		this.customerNumberId = customerNumberId;
	}

	/**
	 * @return Returns the igfCustomerNumber.
	 */
	public String getIgfCustomerNumber() {
		return igfCustomerNumber;
	}

	/**
	 * @param igfCustomerNumber
	 *            The igfCustomerNumber to set.
	 */
	public void setIgfCustomerNumber(String igfCustomerNumber) {
		this.igfCustomerNumber = igfCustomerNumber;
	}

	/**
	 * @return Returns the lpid.
	 */
	public Lpid getLpid() {
		return lpid;
	}

	/**
	 * @param lpid
	 *            The lpid to set.
	 */
	public void setLpid(Lpid lpid) {
		this.lpid = lpid;
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
