package com.ibm.ea.bravo.software;

import org.apache.log4j.Logger;

public class SoftwareLparHDisk {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(SoftwareLparHDisk.class);

	private Long id;
	private Integer size;
	private String manufacturer;
	private String model;
	private String serialNumber;
	private String storageType;
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
	public Integer getSize() {
		return size;
	}
	public void setSize(Integer diskSizeMb) {
		size = diskSizeMb;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public String getManufacturer() {
		return manufacturer;
	}
	public void setManufacturer(String manufacturer) {
		this.manufacturer = manufacturer;
	}
	public String getSerialNumber() {
		return serialNumber;
	}
	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}
	public String getStorageType() {
		return storageType;
	}
	public void setStorageType(String storageType) {
		this.storageType = storageType;
	}
}
