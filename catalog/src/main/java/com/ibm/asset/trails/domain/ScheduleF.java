package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "SCHEDULE_F")
@Cacheable
public class ScheduleF extends DomainEntity implements Serializable{

	private static final long serialVersionUID = 4588816967938233569L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;
	
	@Basic
	@Column(name = "SOFTWARE_ID")
	private Long softwareId;
	
	@Basic
	@Column(name = "SOFTWARE_TITLE")
	private String softwareTitle;
	
	@Basic
	@Column(name = "SOFTWARE_NAME")
	private String softwareName;
	
	@Basic
	@Column(name = "MANUFACTURER")
	private String manufacturer;
		
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}

	public String getSoftwareTitle() {
		return softwareTitle;
	}

	public void setSoftwareTitle(String softwareTitle) {
		this.softwareTitle = softwareTitle;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}
   
	
}

