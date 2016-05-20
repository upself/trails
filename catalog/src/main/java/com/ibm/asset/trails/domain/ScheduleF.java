package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity
@Table(name = "SCHEDULE_F")
@org.hibernate.annotations.Entity
@NamedQueries({@NamedQuery(name = "findScheduleFBySwId",query="SELECT h FROM ScheduleF h where h.softwareId = :swid"),
	@NamedQuery(name = "findScheduleFById", query = "FROM ScheduleF  WHERE id = :sfid")})
public class ScheduleF extends DomainEntity implements Serializable{

	private static final long serialVersionUID = 4588816967938233569L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Column(name = "SOFTWARE_ID")
	private Long softwareId;

	@Column(name = "SOFTWARE_TITLE")
	private String softwareTitle;

	@Column(name = "SOFTWARE_NAME")
	private String softwareName;

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

