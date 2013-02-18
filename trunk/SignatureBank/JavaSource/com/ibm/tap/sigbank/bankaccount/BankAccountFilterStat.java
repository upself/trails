/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.bankaccount;

import com.ibm.tap.sigbank.filter.SoftwareFilter;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BankAccountFilterStat {
	private Long bankAccountFilterStatId;

	private BankAccount bankAccount;

	private SoftwareFilter softwareFilter;

	private Long count;

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
	 * @return Returns the bankAccountFilterStatId.
	 */
	public Long getBankAccountFilterStatId() {
		return bankAccountFilterStatId;
	}

	/**
	 * @param bankAccountFilterStatId
	 *            The bankAccountFilterStatId to set.
	 */
	public void setBankAccountFilterStatId(Long bankAccountFilterStatId) {
		this.bankAccountFilterStatId = bankAccountFilterStatId;
	}

	/**
	 * @return Returns the count.
	 */
	public Long getCount() {
		return count;
	}

	/**
	 * @param count
	 *            The count to set.
	 */
	public void setCount(Long count) {
		this.count = count;
	}

	/**
	 * @return Returns the softwareFilter.
	 */
	public SoftwareFilter getSoftwareFilter() {
		return softwareFilter;
	}

	/**
	 * @param softwareFilter
	 *            The softwareFilter to set.
	 */
	public void setSoftwareFilter(SoftwareFilter softwareFilter) {
		this.softwareFilter = softwareFilter;
	}
}
