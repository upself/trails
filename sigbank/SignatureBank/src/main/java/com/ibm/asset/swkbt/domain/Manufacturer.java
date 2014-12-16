package com.ibm.asset.swkbt.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.NamedQueries;

@NamedQueries( {
	@NamedQuery(name = "manufacturers", query = "FROM Manufacturer ORDER BY manufacturerName"),
	@NamedQuery(name = "manufacturerById", query = "FROM Manufacturer where id = :manufacturerId"), 
	@NamedQuery(name = "listManufacturerName", query = "SELECT m.manufacturerName FROM Manufacturer m ORDER BY manufacturerName")
})
@Entity
@Table(name = "MANUFACTURER")
@org.hibernate.annotations.Entity(mutable = false)
public class Manufacturer  implements Serializable {

	private static final long serialVersionUID = -417163770297864632L;

	@Id
	@Column(name = "ID")
	private Long manufacturerId;
	
	@Basic
	@Column(name = "NAME")
	private String manufacturerName;

	public Long getManufacturerId() {
		return manufacturerId;
	}

	public String getManufacturerName() {
		return manufacturerName;
	}

	public void setManufacturerId(Long manufacturerId) {
		this.manufacturerId = manufacturerId;
	}

	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}
}