package com.ibm.ea.bravo.software;

import org.apache.log4j.Logger;

public class SoftwareLparMemMod {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(SoftwareLparMemMod.class);

	private Long id;
	private Integer instMemId;
	private Integer moduleSize;
	private Integer maxModuleSize;
	private String socketName;
	private String packaging;
	private String memoryType;
	
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
	public Integer getInstMemId() {
		return instMemId;
	}
	public void setInstMemId(Integer instMemId) {
		this.instMemId = instMemId;
	}
	public Integer getMaxModuleSize() {
		return maxModuleSize;
	}
	public void setMaxModuleSize(Integer maxModuleSize) {
		this.maxModuleSize = maxModuleSize;
	}
	public String getMemoryType() {
		return memoryType;
	}
	public void setMemoryType(String memoryType) {
		this.memoryType = memoryType;
	}
	public Integer getModuleSize() {
		return moduleSize;
	}
	public void setModuleSize(Integer moduleSize) {
		this.moduleSize = moduleSize;
	}
	public String getPackaging() {
		return packaging;
	}
	public void setPackaging(String packaging) {
		this.packaging = packaging;
	}
	public String getSocketName() {
		return socketName;
	}
	public void setSocketName(String socketName) {
		this.socketName = socketName;
	}
}
