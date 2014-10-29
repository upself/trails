package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "ACCOUNT_POOL")
@org.hibernate.annotations.Entity(mutable = false)
public class AccountPool {

	@Id
	@Column(name = "ACCOUNT_POOL_ID")
	private Long id;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MASTER_ACCOUNT_ID")
	private Account masterAccount;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "MEMBER_ACCOUNT_ID")
	private Account memberAccount;

	@Column(name = "LOGICAL_DELETE_IND")
	private boolean deleted;

	public boolean isDeleted() {
		return deleted;
	}

	public void setDeleted(boolean deleted) {
		this.deleted = deleted;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Account getMasterAccount() {
		return masterAccount;
	}

	public void setMasterAccount(Account masterAccount) {
		this.masterAccount = masterAccount;
	}

	public Account getMemberAccount() {
		return memberAccount;
	}

	public void setMemberAccount(Account memberAccount) {
		this.memberAccount = memberAccount;
	}

}
