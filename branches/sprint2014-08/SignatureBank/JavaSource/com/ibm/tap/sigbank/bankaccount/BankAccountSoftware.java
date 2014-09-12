/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.bankaccount;

import java.util.Date;

import com.ibm.tap.sigbank.software.Software;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BankAccountSoftware {
	private Long bankAccountSoftwareId;

	private BankAccount bankAccount;

	private Software software;

	private String softwareOwner;

	private String remoteUser;

	private Date recordTime;

	private String status;

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
	 * @return Returns the bankAccountSoftwareId.
	 */
	public Long getBankAccountSoftwareId() {
		return bankAccountSoftwareId;
	}

	/**
	 * @param bankAccountSoftwareId
	 *            The bankAccountSoftwareId to set.
	 */
	public void setBankAccountSoftwareId(Long bankAccountSoftwareId) {
		this.bankAccountSoftwareId = bankAccountSoftwareId;
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
	 * @return Returns the software.
	 */
	public Software getSoftware() {
		return software;
	}

	/**
	 * @param software
	 *            The software to set.
	 */
	public void setSoftware(Software software) {
		this.software = software;
	}

	/**
	 * @return Returns the softwareOwner.
	 */
	public String getSoftwareOwner() {
		return softwareOwner;
	}

	/**
	 * @param softwareOwner
	 *            The softwareOwner to set.
	 */
	public void setSoftwareOwner(String softwareOwner) {
		this.softwareOwner = softwareOwner;
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
