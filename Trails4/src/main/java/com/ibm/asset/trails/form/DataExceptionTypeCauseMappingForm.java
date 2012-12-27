package com.ibm.asset.trails.form;

import java.util.List;

import com.ibm.asset.trails.domain.DataExceptionCause;

public class DataExceptionTypeCauseMappingForm {
	private String alertTypeName;
	private List<DataExceptionCause> availableAlertCauseList;
	private Long[] mappedAlertCauseIdArray;
	private List<DataExceptionCause> mappedAlertCauseList;

	public String getAlertTypeName() {
		return alertTypeName;
	}

	public void setAlertTypeName(String alertTypeName) {
		this.alertTypeName = alertTypeName;
	}

	public List<DataExceptionCause> getAvailableAlertCauseList() {
		return availableAlertCauseList;
	}

	public void setAvailableAlertCauseList(List<DataExceptionCause> availableAlertCauseList) {
		this.availableAlertCauseList = availableAlertCauseList;
	}

	public Long[] getMappedAlertCauseIdArray() {
		return mappedAlertCauseIdArray;
	}

	public void setMappedAlertCauseIdArray(Long[] mappedAlertCauseIdArray) {
		this.mappedAlertCauseIdArray = mappedAlertCauseIdArray;
	}

	public List<DataExceptionCause> getMappedAlertCauseList() {
		return mappedAlertCauseList;
	}

	public void setMappedAlertCauseList(List<DataExceptionCause> mappedAlertCauseList) {
		this.mappedAlertCauseList = mappedAlertCauseList;
	}
}
