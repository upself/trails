//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v3.0-03/04/2009 09:20 AM(valikov)-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.15 at 05:31:23 PM EST 
//

package com.ibm.asset.swkbt.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@org.hibernate.annotations.Entity(mutable = false)
@Table(name = "KB_DEFINITION")
@Inheritance(strategy = InheritanceType.JOINED)
public class KbDefinition implements Serializable {

	private static final long serialVersionUID = -46584272552649508L;

	@Id
	@Column(name = "ID")
	private Long id;

	@Basic
	@Column(name = "EXTERNAL_ID")
	private String externalId;

	@Basic
	@Column(name = "GUID")
	private String guid;

	@Basic
	@Column(name = "ACTIVE")
	private Boolean active;

	@Basic
	@Column(name = "DATA_INPUT")
	private Integer dataInput;

	@Basic
	@Column(name = "DELETED")
	private Boolean deleted;

	@Basic
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFICATION_TIME")
	private Date modified;

	@Basic
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATION_TIME")
	private Date created;

	@Basic
	@Column(name = "CUSTOM_1")
	private String customField1;

	@Basic
	@Column(name = "CUSTOM_2")
	private String vendorManaged;

	@Basic
	@Column(name = "CUSTOM_3")
	private String customField3;

	@Basic
	@Column(name = "DESCRIPTION")
	private String description;

	@Basic
	@Column(name = "DEFINITION_SOURCE")
	private String definitionSource;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getExternalId() {
		return externalId;
	}

	public void setExternalId(String externalId) {
		this.externalId = externalId;
	}

	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}

	public Boolean getActive() {
		return active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}

	public Integer getDataInput() {
		return dataInput;
	}

	public void setDataInput(Integer dataInput) {
		this.dataInput = dataInput;
	}

	public Boolean getDeleted() {
		return deleted;
	}

	public void setDeleted(Boolean deleted) {
		this.deleted = deleted;
	}

	public Date getModified() {
		return modified;
	}

	public void setModified(Date modified) {
		this.modified = modified;
	}

	public Date getCreated() {
		return created;
	}

	public void setCreated(Date created) {
		this.created = created;
	}

	public String getCustomField1() {
		return customField1;
	}

	public void setCustomField1(String customField1) {
		this.customField1 = customField1;
	}

	public String getVendorManaged() {
		return vendorManaged;
	}

	public void setVendorManaged(String vendorManaged) {
		this.vendorManaged = vendorManaged;
	}

	public String getCustomField3() {
		return customField3;
	}

	public void setCustomField3(String customField3) {
		this.customField3 = customField3;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDefinitionSource() {
		return definitionSource;
	}

	public void setDefinitionSource(String definitionSource) {
		this.definitionSource = definitionSource;
	}

}