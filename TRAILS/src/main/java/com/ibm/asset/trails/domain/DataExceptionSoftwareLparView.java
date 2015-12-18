package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

public class DataExceptionSoftwareLparView implements Serializable {
	private static final long serialVersionUID = 4408421318829272538L;
	
	private Long dataExpId;
	private String dataExpAssignee;
	private Date dataExpCreationTime;
	private Long swLparId;
	private String swLparName;
	private Date swLparScanTime;
	private String swLparSerial;
	private String swLparOSName;
	private Long swLparAccountNumber;
	 
	public Long getDataExpId() {
		return dataExpId;
	}
	public void setDataExpId(Long dataExpId) {
		this.dataExpId = dataExpId;
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
	public Long getSwLparId() {
		return swLparId;
	}
	public void setSwLparId(Long swLparId) {
		this.swLparId = swLparId;
	}
	public String getSwLparName() {
		return swLparName;
	}
	public void setSwLparName(String swLparName) {
		this.swLparName = swLparName;
	}
	public Date getSwLparScanTime() {
		return swLparScanTime;
	}
	public void setSwLparScanTime(Date swLparScanTime) {
		this.swLparScanTime = swLparScanTime;
	}
	public String getSwLparSerial() {
		return swLparSerial;
	}
	public void setSwLparSerial(String swLparSerial) {
		this.swLparSerial = swLparSerial;
	}
	public String getSwLparOSName() {
		return swLparOSName;
	}
	public void setSwLparOSName(String swLparOSName) {
		this.swLparOSName = swLparOSName;
	}
	public Long getSwLparAccountNumber() {
		return swLparAccountNumber;
	}
	public void setSwLparAccountNumber(Long swLparAccountNumber) {
		this.swLparAccountNumber = swLparAccountNumber;
	}
}
