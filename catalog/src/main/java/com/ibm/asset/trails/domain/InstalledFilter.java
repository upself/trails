package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "INSTALLED_FILTER")
public class InstalledFilter extends DomainEntity implements Serializable {

	private static final long serialVersionUID = -1857501204321240469L;

	@Id
	@Column(name = "ID")
	protected Long id;

	@Basic
	@Column(name = "SOFTWARE_FILTER_ID")
	protected Long softwareFilterId;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getSoftwareFilterId() {
		return softwareFilterId;
	}

	public void setSoftwareFilterId(Long softwareFilterId) {
		this.softwareFilterId = softwareFilterId;
	}

}
