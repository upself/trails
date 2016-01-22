package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

public class DataExceptionHardwareLparView implements Serializable {
	private static final long serialVersionUID = 4408421318829272538L;
	
	private Long dataExpId;
	private String dataExpType;
	private String dataExpAssignee;
	private Date dataExpCreationTime;
	private Long hwLparId;
	
	private String hwLparName;
	private String hwSerial;
	private String hwChips;
	private String hwLparExtId;
	private String hwProcessors;
	private Long hwLparAccountNumber;
	 
	public Long getDataExpId() {
		return dataExpId;
	}
	public void setDataExpId(Long dataExpId) {
		this.dataExpId = dataExpId;
	}
	public String getDataExpType() {
		return dataExpType;
	}
	public void setDataExpType(String dataExpType) {
		this.dataExpType = dataExpType;
	}
	public String getDataExpAssignee() {
		return dataExpAssignee;
	}
	public void setDataExpAssignee(String dataExpAssignee) {
		this.dataExpAssignee = dataExpAssignee;
	}
	public Date getDataExpCreationTime() {
		return dataExpCreationTime;
	}
	public void setDataExpCreationTime(Date dataExpCreationTime) {
		this.dataExpCreationTime = dataExpCreationTime;
	}
	public Long getHwLparId() {
		return hwLparId;
	}
	public void setHwLparId(Long hwLparId) {
		this.hwLparId = hwLparId;
	}
	public String getHwLparName() {
		return hwLparName;
	}
	public void setHwLparName(String hwLparName) {
		this.hwLparName = hwLparName;
	}
	public String getHwSerial() {
		return hwSerial;
	}
	public void setHwSerial(String hwSerial) {
		this.hwSerial = hwSerial;
	}
	public String getHwChips() {
		return hwChips;
	}
	public void setHwChips(String hwChips) {
		this.hwChips = hwChips;
	}
	public String getHwLparExtId() {
		return hwLparExtId;
	}
	public void setHwLparExtId(String hwLparExtId) {
		this.hwLparExtId = hwLparExtId;
	}
	public Long getHwLparAccountNumber() {
		return hwLparAccountNumber;
	}
	public void setHwLparAccountNumber(Long hwLparAccountNumber) {
		this.hwLparAccountNumber = hwLparAccountNumber;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getHwProcessors() {
		return hwProcessors;
	}
	public void setHwProcessors(String hwProcessors) {
		this.hwProcessors = hwProcessors;
	}
	
}
