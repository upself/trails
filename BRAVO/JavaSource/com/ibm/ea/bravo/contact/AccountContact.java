package com.ibm.ea.bravo.contact;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.cndb.Customer;

public class AccountContact extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -5831019404514955290L;
    private Long id;
	private ContactSupport contact;
	private Customer customer;
	

	/**
	 * @return Returns the contact.
	 */
	public ContactSupport getContact() {
		return this.contact;
	}
	/**
	 * @param contact The contact to set.
	 */
	public void setContact(ContactSupport contact) {
		this.contact = contact;
	}
	/**
	 * @return Returns the customer.
	 */
	public Customer getCustomer() {
		return this.customer;
	}
	/**
	 * @param customer The customer to set.
	 */
	public void setCustomer(Customer customer) {
		this.customer = customer;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
}
