package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "INSTALLED_SIGNATURE")
public class InstalledSignature extends DomainEntity implements Serializable {

	private static final long serialVersionUID = 2724771271668584149L;

	@Id
	@Column(name = "ID")
	protected Long id;

	@Basic
	@Column(name = "SOFTWARE_SIGNATURE_ID")
	protected Long softwareSignatureId;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getSoftwareSignatureId() {
		return softwareSignatureId;
	}

	public void setSoftwareSignatureId(Long softwareSignatureId) {
		this.softwareSignatureId = softwareSignatureId;
	}
}
