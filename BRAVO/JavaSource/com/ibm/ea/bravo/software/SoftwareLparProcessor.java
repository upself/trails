package com.ibm.ea.bravo.software;

import org.apache.log4j.Logger;

public class SoftwareLparProcessor {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(SoftwareLparProcessor.class);

	private Long id;
	private Integer busSpeed;
	private String cache;
	private Integer currentSpeed;
	private String isActive;
	private String manufacturer;
	private Integer maxSpeed;
	private String model;
	private Integer numBoards;
	private Integer numModules;
	private Integer processorNum;
	private Long pvu;
	private String serialNumber;
	
	private SoftwareLpar softwareLpar;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}
	public static Logger getLogger() {
		return logger;
	}
	public Integer getBusSpeed() {
		return busSpeed;
	}
	public void setBusSpeed(Integer busSpeed) {
		this.busSpeed = busSpeed;
	}
	public String getCache() {
		return cache;
	}
	public void setCache(String cache) {
		this.cache = cache;
	}
	public Integer getCurrentSpeed() {
		return currentSpeed;
	}
	public void setCurrentSpeed(Integer currentSpeed) {
		this.currentSpeed = currentSpeed;
	}
	public String getIsActive() {
		return isActive;
	}
	public void setIsActive(String isActive) {
		this.isActive = isActive;
	}
	public String getManufacturer() {
		return manufacturer;
	}
	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}
	public Integer getMaxSpeed() {
		return maxSpeed;
	}
	public void setMaxSpeed(Integer maxSpeed) {
		this.maxSpeed = maxSpeed;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public Integer getNumBoards() {
		return numBoards;
	}
	public void setNumBoards(Integer numBoards) {
		this.numBoards = numBoards;
	}
	public Integer getNumModules() {
		return numModules;
	}
	public void setNumModules(Integer numModules) {
		this.numModules = numModules;
	}
	public Integer getProcessorNum() {
		return processorNum;
	}
	public void setProcessorNum(Integer processorNum) {
		this.processorNum = processorNum;
	}
	public Long getPvu() {
		return pvu;
	}
	public void setPvu(Long pvu) {
		this.pvu = pvu;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
}
