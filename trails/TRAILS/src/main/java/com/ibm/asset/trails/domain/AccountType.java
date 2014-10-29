package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "CUSTOMER_TYPE")
@org.hibernate.annotations.Entity(mutable = false)
public class AccountType {
	@Id
	@Column(name = "CUSTOMER_TYPE_ID")
	private Long id;

	@Column(name = "CUSTOMER_TYPE_NAME")
	private String name;

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}
}
