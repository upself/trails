package com.ibm.asset.trails.domain;

import java.io.Serializable;
import java.util.Date;

public class DataExceptionInstalledSwView implements Serializable {
	private static final long serialVersionUID = 4408421318829272538L;

	private Long dataExpId;
	private String dataExpType;
	private String dataExpAssignee;
	private Date dataExpCreationTime;

	private String swLparName; // Hostname
	private Date discrepancyRecordTime;
	private String swComponentName;
	private Long installedSwId;

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

	public String getSwLparName() {
		return swLparName;
	}

	public void setSwLparName(String swLparName) {
		this.swLparName = swLparName;
	}

	public Date getDiscrepancyRecordTime() {
		return discrepancyRecordTime;
	}

	public void setDiscrepancyRecordTime(Date discrepancyRecordTime) {
		this.discrepancyRecordTime = discrepancyRecordTime;
	}

	public String getSwComponentName() {
		return swComponentName;
	}

	public void setSwComponentName(String swComponentName) {
		this.swComponentName = swComponentName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Long getInstalledSwId() {
		return installedSwId;
	}

	public void setInstalledSwId(Long installedSwId) {
		this.installedSwId = installedSwId;
	}

}
