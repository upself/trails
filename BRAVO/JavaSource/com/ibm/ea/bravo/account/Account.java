package com.ibm.ea.bravo.account;

import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.cndb.Customer;

public class Account extends FormBase {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Customer customer;

	private boolean multiReport;

	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return this.customer;
	}

	/**
	 * @param customer
	 *            The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}

	/**
	 * @return Returns the multiReport.
	 */
	public boolean isMultiReport() {
		return this.multiReport;
	}

	/**
	 * @param multiReport
	 *            The multiReport to set.
	 */
	public void setMultiReport(boolean multiReport) {
		this.multiReport = multiReport;
	}
}
