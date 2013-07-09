package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "INDUSTRY")
@org.hibernate.annotations.Entity(mutable = false)
public class Industry {

	@Id
	@Column(name = "INDUSTRY_ID")
	private Long id;

	@Column(name = "INDUSTRY_NAME")
	private String name;

	@ManyToOne
	@JoinColumn(name = "SECTOR_ID")
	private Sector sector;

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public Sector getSector() {
		return sector;
	}

}