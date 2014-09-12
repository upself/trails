//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v3.0-03/04/2009 09:20 AM(valikov)-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.15 at 05:31:23 PM EST 
//

package com.ibm.asset.swkbt.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity(name = "Version")
@org.hibernate.annotations.Entity(mutable = false)
@Table(name = "VERSION")
public class Version extends SoftwareItem implements Serializable {

	private static final long serialVersionUID = 6368420982342970533L;

	@ManyToOne
	private Manufacturer manufacturer;

	@Basic
	@Column(name = "IDENTIFIER")
	private String identifier;

	@Basic
	@Column(name = "VERSION")
	private int version;

	@ManyToOne
	private Product product;

	public Manufacturer getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(Manufacturer manufacturer) {
		this.manufacturer = manufacturer;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public int getVersion() {
		return version;
	}

	public void setVersion(int version) {
		this.version = version;
	}

	public Product getProduct() {
		return product;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

}