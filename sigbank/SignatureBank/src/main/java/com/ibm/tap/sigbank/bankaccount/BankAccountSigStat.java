/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.bankaccount;

import com.ibm.tap.sigbank.signature.SoftwareSignature;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BankAccountSigStat {
	private Long bankAccountSigStatId;

	private BankAccount bankAccount;

	private SoftwareSignature softwareSignature;

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
	 * @return Returns the bankAccountSigStatId.
	 */
	public Long getBankAccountSigStatId() {
		return bankAccountSigStatId;
	}

	/**
	 * @param bankAccountSigStatId
	 *            The bankAccountSigStatId to set.
	 */
	public void setBankAccountSigStatId(Long bankAccountSigStatId) {
		this.bankAccountSigStatId = bankAccountSigStatId;
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
	 * @return Returns the softwareSignature.
	 */
	public SoftwareSignature getSoftwareSignature() {
		return softwareSignature;
	}

	/**
	 * @param softwareSignature
	 *            The softwareSignature to set.
	 */
	public void setSoftwareSignature(SoftwareSignature softwareSignature) {
		this.softwareSignature = softwareSignature;
	}
}
