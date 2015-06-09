package com.ibm.asset.trails.domain;
public class NonInstanceDisplay {
	
	private Long id;
	private Long softwareId;
	private String softwareName;
	
	private String manufacturerName;
	
	private String restriction;
	
	private Integer capacityCode;
	private String capacityDesc;
	
	private Integer baseOnly;

	private Long statusId;
	private String statusDesc;
	
	
	
	public NonInstanceDisplay() {

	}

	
	
	public NonInstanceDisplay(Long id, String softwareName, String restriction) {
		super();
		this.id = id;
		this.softwareName = softwareName;
		this.restriction = restriction;
	}



	public NonInstanceDisplay(Long id, Long softwareId, String softwareName,
			String manufacturerName, String restriction, Integer capacityCode,
			String capacityDesc, Integer baseOnly, Long statusId,
			String statusDesc) {
		super();
		this.id = id;
		this.softwareId = softwareId;
		this.softwareName = softwareName;
		this.manufacturerName = manufacturerName;
		this.restriction = restriction;
		this.capacityCode = capacityCode;
		this.capacityDesc = capacityDesc;
		this.baseOnly = baseOnly;
		this.statusId = statusId;
		this.statusDesc = statusDesc;
	}



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



	public String getSoftwareName() {
		return softwareName;
	}



	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}



	public String getManufacturerName() {
		return manufacturerName;
	}



	public void setManufacturerName(String manufacturerName) {
		this.manufacturerName = manufacturerName;
	}



	public String getRestriction() {
		return restriction;
	}



	public void setRestriction(String restriction) {
		this.restriction = restriction;
	}



	public Integer getCapacityCode() {
		return capacityCode;
	}



	public void setCapacityCode(Integer capacityCode) {
		this.capacityCode = capacityCode;
	}



	public String getCapacityDesc() {
		return capacityDesc;
	}



	public void setCapacityDesc(String capacityDesc) {
		this.capacityDesc = capacityDesc;
	}



	public Integer getBaseOnly() {
		return baseOnly;
	}



	public void setBaseOnly(Integer baseOnly) {
		this.baseOnly = baseOnly;
	}



	public Long getStatusId() {
		return statusId;
	}



	public void setStatusId(Long statusId) {
		this.statusId = statusId;
	}



	public String getStatusDesc() {
		return statusDesc;
	}



	public void setStatusDesc(String statusDesc) {
		this.statusDesc = statusDesc;
	}
	
	
}
