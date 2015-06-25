package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "MANUFACTURER")
@org.hibernate.annotations.Entity(mutable = false)
@NamedQueries({
	@NamedQuery(name = "listManufacturerName", query = "SELECT m.manufacturerName FROM Manufacturer m ORDER BY manufacturerName"),
	@NamedQuery(name = "manufacturerByName", query = "FROM Manufacturer m where UCASE(m.manufacturerName) = :name"),
	@NamedQuery(name = "manufacturerByNameLike", query = "FROM Manufacturer m where UCASE(m.manufacturerName) like :name")
})

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
