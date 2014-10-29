/*
 * Created on Jun 3, 2006
 * 
 * TODO To change the template for this generated file go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.sigbank;

import java.io.Serializable;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.cndb.Customer;

public class BankAccountInclusion extends OrmBase implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Customer customer;

	private BankAccount bankAccount;
	private Long id;

	private Long customerId;
	private Long bankAccountId;
	
	



	public Long getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Long customerId) {
		this.customerId = customerId;
	}

	public Long getBankAccountId() {
		return bankAccountId;
	}

	public void setBankAccountId(Long bankAccountId) {
		this.bankAccountId = bankAccountId;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return Returns the bankAccount.
	 */
	public BankAccount getBankAccount() {
		return bankAccount;
	}

	/**
	 * @param bankAccount
	 *            The bankAccount to set.
	 */
	public void setBankAccount(BankAccount bankAccount) {
		this.bankAccount = bankAccount;
	}

	public Customer getCustomer() {
		return customer;
	}

	public void setCustomer(Customer customer) {
		this.customer = customer;
	}


}
