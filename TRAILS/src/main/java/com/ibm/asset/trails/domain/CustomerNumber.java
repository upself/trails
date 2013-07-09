package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "CUSTOMER_NUMBER")
@org.hibernate.annotations.Entity(mutable = false)
public class CustomerNumber {

	@Id
	@Column(name = "CUSTOMER_NUMBER_ID")
	private Long id;

	@Column(name = "CUSTOMER_NUMBER")
	private String name;

	@ManyToOne
	@JoinColumn(name = "CUSTOMER_ID")
	private Account account;

	@Column(name = "STATUS")
	private String status;

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
