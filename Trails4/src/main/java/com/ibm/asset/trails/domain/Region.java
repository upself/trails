package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "REGION")
public class Region {

	@Id
	@Column(name = "ID")
	private Long id;

	@Column(name = "NAME")
	private String name;

	@ManyToOne
	@JoinColumn(name = "GEOGRAPHY_ID")
	private Geography geography;

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Geography getGeography() {
		return geography;
	}

}
