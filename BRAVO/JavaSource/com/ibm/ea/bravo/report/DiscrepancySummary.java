package com.ibm.ea.bravo.report;

public class DiscrepancySummary {
	private Long softwareId;
	private String softwareName;
	private String discrepancyTypeName;
	private Long numProducts;
	
	public DiscrepancySummary() {
	
	}

	public DiscrepancySummary (Long softwareId, String softwareName, 
			String discrepancyTypeName, Long numProducts) {
		this.softwareId = softwareId;
		this.softwareName = softwareName;
		this.discrepancyTypeName = discrepancyTypeName;
		this.numProducts = numProducts;
	}

	public String getDiscrepancyTypeName() {
		return discrepancyTypeName;
	}
	
	public void setDiscrepancyTypeName(String discrepancyTypeName) {
		this.discrepancyTypeName = discrepancyTypeName;
	}
	
	public String getSoftwareName() {
		return softwareName;
	}
	
	public void setSoftwareName(String softwareName) {
		this.softwareName = softwareName;
	}

	public Long getNumProducts() {
		return numProducts;
	}

	public void setNumProducts(Long numProducts) {
		this.numProducts = numProducts;
	}

	public Long getSoftwareId() {
		return softwareId;
	}

	public void setSoftwareId(Long softwareId) {
		this.softwareId = softwareId;
	}
}
