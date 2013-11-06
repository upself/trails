package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "ALERT_CAUSE_RESPONSIBILITY")
public class AlertCauseResponsibility {

	@Id
	@Column(name = "ID")
	private long id;

	@Column(name = "NAME")
	private String name;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

}
