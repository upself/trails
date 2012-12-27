package com.ibm.asset.trails.form;

import com.opensymphony.xwork2.validator.annotations.RequiredStringValidator;
import com.opensymphony.xwork2.validator.annotations.ValidatorType;

public class ScheduleFForm {

	private String softwareTitle;

	private String softwareName;

	private String manufacturer;

	private Long scopeId;

	private String complianceReporting;

	private Long sourceId;

	private String sourceLocation;

	private Long statusId;

	private String businessJustification;

	public String getBusinessJustification() {
		return businessJustification;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Business justification is required.")
	public void setBusinessJustification(String businessJustification) {
		this.businessJustification = businessJustification;
	}

	public String getComplianceReporting() {
		return complianceReporting;
	}

	public void setComplianceReporting(String complianceReporting) {
		this.complianceReporting = complianceReporting;
	}

	public String getManufacturer() {
		return manufacturer;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Manufacturer is required.")
	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}

	public Long getScopeId() {
		return scopeId;
	}

	public void setScopeId(Long scopeId) {
		this.scopeId = scopeId;
	}

	public String getSoftwareName() {
		return softwareName;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Software name is required.")
	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public String getSoftwareTitle() {
		return softwareTitle;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Software title is required.")
	public void setSoftwareTitle(String softwareTitle) {
		this.softwareTitle = softwareTitle;
	}

	public Long getSourceId() {
		return sourceId;
	}

	public void setSourceId(Long sourceId) {
		this.sourceId = sourceId;
	}

	public String getSourceLocation() {
		return sourceLocation;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Source location is required.")
	public void setSourceLocation(String sourceLocation) {
		this.sourceLocation = sourceLocation;
	}

	public Long getStatusId() {
		return statusId;
	}

	public void setStatusId(Long statusId) {
		this.statusId = statusId;
	}
}
