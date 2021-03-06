package com.ibm.ea.bravo.systemstatus;

import java.io.Serializable;
import java.sql.Timestamp;

import com.ibm.ea.sigbank.BankAccount;

public class BankAccountJob implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long id;

	private BankAccount bankAccount;

	private String name;

	private String comments;

	private Timestamp startTime;

	private Timestamp endTime;

	private String status;
	
	private Timestamp firstErrorTime;

	public String getElapsedTime() {
		if (this.getEndTime() == null) {
			return "";
		} else {
			return new StringBuffer(String
					.valueOf((getEndTime().getTime() - getStartTime().getTime())
							/ (1000 * 60))).append(" minutes").toString(); 
		}
	}

	public BankAccount getBankAccount() {
		return bankAccount;
	}

	public void setBankAccount(BankAccount bankAccount) {
		this.bankAccount = bankAccount;
	}

	public String getComments() {
//		return comments.replaceAll("\'","").replaceAll("\"", "").replaceAll("\n","");
		return comments.replaceAll("[\'|\"|\n]","");
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public Timestamp getFirstErrorTime() {
		return firstErrorTime;
	}

	public void setFirstErrorTime(Timestamp firstErrorTime) {
		this.firstErrorTime = firstErrorTime;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public void setStartTime(Timestamp startTime) {
		this.startTime = startTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
