package com.ibm.asset.trails.domain;


public class ProcessorValueUnitDisplay {
	private Long id;

	private String processorBrand;

	private String processorModel;
	
	
	
	public ProcessorValueUnitDisplay(Long id, String processorBrand,
			String processorModel) {
		super();
		this.id = id;
		this.processorBrand = processorBrand;
		this.processorModel = processorModel;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getProcessorBrand() {
		return processorBrand;
	}

	public void setProcessorBrand(String processorBrand) {
		this.processorBrand = processorBrand;
	}

	public String getProcessorModel() {
		return processorModel;
	}

	public void setProcessorModel(String processorModel) {
		this.processorModel = processorModel;
	}
	
}
