package com.ibm.asset.trails.form;

import java.util.List;

import com.ibm.asset.trails.domain.AlertCause;

public class DataExceptionTypeCauseMappingForm {
	private String alertTypeName;
	private List<AlertCause> availableAlertCauseList;
	private Long[] mappedAlertCauseIdArray;
	private List<AlertCause> mappedAlertCauseList;

	public String getAlertTypeName() {
		return alertTypeName;
	}

	public void setAlertTypeName(String alertTypeName) {
		this.alertTypeName = alertTypeName;
	}

	public List<AlertCause> getAvailableAlertCauseList() {
		return availableAlertCauseList;
	}

	public void setAvailableAlertCauseList(List<AlertCause> availableAlertCauseList) {
		this.availableAlertCauseList = availableAlertCauseList;
	}

	public Long[] getMappedAlertCauseIdArray() {
		return mappedAlertCauseIdArray;
	}

	public void setMappedAlertCauseIdArray(Long[] mappedAlertCauseIdArray) {
		this.mappedAlertCauseIdArray = mappedAlertCauseIdArray;
	}

	public List<AlertCause> getMappedAlertCauseList() {
		return mappedAlertCauseList;
	}

	public void setMappedAlertCauseList(List<AlertCause> mappedAlertCauseList) {
		this.mappedAlertCauseList = mappedAlertCauseList;
	}
}
