package com.ibm.asset.trails.form;

import java.util.List;

import com.ibm.asset.trails.domain.AlertTypeCause;

public class DataExceptionTypeCauseMappingForm {
	private String alertTypeName;
	private List<AlertTypeCause> availableAlertCauseList;
	private Long[] mappedAlertCauseIdArray;
	private List<AlertTypeCause> mappedAlertCauseList;

	public String getAlertTypeName() {
		return alertTypeName;
	}

	public void setAlertTypeName(String alertTypeName) {
		this.alertTypeName = alertTypeName;
	}

	public List<AlertTypeCause> getAvailableAlertCauseList() {
		return availableAlertCauseList;
	}

	public void setAvailableAlertCauseList(
			List<AlertTypeCause> availableAlertCauseList) {
		this.availableAlertCauseList = availableAlertCauseList;
	}

	public Long[] getMappedAlertCauseIdArray() {
		return mappedAlertCauseIdArray;
	}

	public void setMappedAlertCauseIdArray(Long[] mappedAlertCauseIdArray) {
		this.mappedAlertCauseIdArray = mappedAlertCauseIdArray;
	}

	public List<AlertTypeCause> getMappedAlertCauseList() {
		return mappedAlertCauseList;
	}

	public void setMappedAlertCauseList(
			List<AlertTypeCause> mappedAlertCauseList) {
		this.mappedAlertCauseList = mappedAlertCauseList;
	}
}
