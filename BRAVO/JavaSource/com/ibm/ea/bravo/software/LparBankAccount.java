/*
 * Created on Jun 3, 2006
 * 
 * TODO To change the template for this generated file go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.OrmBase;
import com.ibm.ea.sigbank.BankAccount;

public class LparBankAccount extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -3937790373350965795L;

    private String id;

	private SoftwareLpar softwareLpar;

	private BankAccount bankAccount;

	/**
	 * @return Returns the id.
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(String id) {
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

	/**
	 * @return Returns the softwareLpar.
	 */
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	/**
	 * @param softwareLpar
	 *            The softwareLpar to set.
	 */
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

}
