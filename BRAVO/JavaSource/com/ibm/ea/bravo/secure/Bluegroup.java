/*
 * Created on Sep 26, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.secure;

import java.util.Set;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Bluegroup extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = 6099790790173284186L;

    private Long id;

	private String name;

	private String description;

	private Set<Customer> Customers;

	/**
	 * @return Returns the customers.
	 */
	public Set<Customer> getCustomers() {
		return Customers;
	}

	/**
	 * @param customers
	 *            The customers to set.
	 */
	public void setCustomers(Set<Customer> customers) {
		Customers = customers;
	}

	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description
	 *            The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
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
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name
	 *            The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
}
