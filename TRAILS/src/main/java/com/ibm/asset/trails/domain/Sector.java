package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "SECTOR")
@org.hibernate.annotations.Entity(mutable = false)
public class Sector {

	@Id
	@Column(name = "SECTOR_ID")
	private Long id;

	@Column(name = "SECTOR_NAME")
	private String name;

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

}
