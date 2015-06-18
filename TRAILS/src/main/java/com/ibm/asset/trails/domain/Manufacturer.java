package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "MANUFACTURER")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQuery(name = "listManufacturerName", query = "SELECT m.manufacturerName FROM Manufacturer m ORDER BY manufacturerName")
public class Manufacturer extends KbDefinition implements Serializable {

	private static final long serialVersionUID = -417163770297864632L;

	@Basic
	@Column(name = "NAME")
	private String manufacturerName;

	public String getManufacturerName() {
		return manufacturerName;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}
}
