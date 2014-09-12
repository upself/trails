//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v3.0-03/04/2009 09:20 AM(valikov)-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.15 at 05:31:23 PM EST 
//

package com.ibm.asset.swkbt.domain;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity(name = "PartNumber")
@org.hibernate.annotations.Entity(mutable = false)
@Table(name = "PART_NUMBER")
public class PartNumber extends KbDefinition implements Serializable {

	private static final long serialVersionUID = 2296523896900061054L;

	@Basic
	@Column(name = "PART_NUMBER")
	private String partNumber;

	@Basic
	@Column(name = "NAME")
	private String name;

	@Basic
	@Column(name = "IS_SUB_CAP")
	private boolean isSubCap;

	@Basic
	@Column(name = "IS_PVU")
	private boolean isPVU;

	@Basic
	@Column(name = "READ_ONLY")
	private Boolean readOnly;

	@OneToMany(targetEntity = Pid.class, cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "PART_NUMBER_PID", joinColumns = { @JoinColumn(name = "PART_NUMBER_ID") }, inverseJoinColumns = { @JoinColumn(name = "PID_ID") })
	private Set<Pid> pids = new HashSet<Pid>();

	public String getPartNumber() {
		return partNumber;
	}

	public void setPartNumber(String partNumber) {
		this.partNumber = partNumber;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean isSubCap() {
		return isSubCap;
	}

	public void setSubCap(boolean isSubCap) {
		this.isSubCap = isSubCap;
	}

	public boolean isPVU() {
		return isPVU;
	}

	public void setPVU(boolean isPVU) {
		this.isPVU = isPVU;
	}

	public Boolean getReadOnly() {
		return readOnly;
	}

	public void setReadOnly(Boolean readOnly) {
		this.readOnly = readOnly;
	}

	public Set<Pid> getPids() {
		return pids;
	}

	public void setPids(Set<Pid> pids) {
		this.pids = pids;
	}
}