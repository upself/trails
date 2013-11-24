package com.ibm.asset.trails.form;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.opensymphony.xwork2.validator.annotations.RequiredStringValidator;
import com.opensymphony.xwork2.validator.annotations.StringLengthFieldValidator;
import com.opensymphony.xwork2.validator.annotations.ValidatorType;

import edu.emory.mathcs.backport.java.util.Arrays;

public class DataExceptionCauseForm {

	@SuppressWarnings("unchecked")
	private List<String> status = new ArrayList<String>(
			Arrays.asList(new String[] { "ACTIVE", "INACTIVE" }));
	private List<AlertType> alertTypes;
	private String alertCauseName;
	private List<AlertCauseResponsibility> alertCauseResponsibilities;
	private AlertTypeCause alertTypeCause;

	private long alertTypeId;
	private String state;
	private long alertCauseResponsibilityId;

	public List<String> getStatus() {
		return status;
	}

	public void setStatus(List<String> status) {
		this.status = status;
	}

	public List<AlertType> getAlertTypes() {
		return alertTypes;
	}

	public void setAlertTypes(List<AlertType> alertTypes) {
		this.alertTypes = alertTypes;
	}

	public String getAlertCauseName() {
		return alertCauseName;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Name is required")
	@StringLengthFieldValidator(type = ValidatorType.FIELD, trim = true, maxLength = "128", message = "Name cannot be more than 128 characters")
	public void setAlertCauseName(String alertCauseName) {
		this.alertCauseName = alertCauseName.toUpperCase();
	}

	public List<AlertCauseResponsibility> getAlertCauseResponsibilities() {
		return alertCauseResponsibilities;
	}

	public void setAlertCauseResponsibilities(
			List<AlertCauseResponsibility> alertCauseResponsibilities) {
		this.alertCauseResponsibilities = alertCauseResponsibilities;
	}

	public AlertTypeCause getAlertTypeCause() {
		return alertTypeCause;
	}

	public void setAlertTypeCause(AlertTypeCause alertTypeCause) {
		this.alertTypeCause = alertTypeCause;
	}

	public void init() {
		String curAlrtTypNm = this.alertTypeCause.getPk().getAlertType()
				.getName();
		for (AlertType altTyp : alertTypes) {
			if (curAlrtTypNm.equals(altTyp.getName())) {
				altTyp.setName("!" + altTyp.getName());
			}
		}

		String curAlrtCusRspbtyNm = this.alertTypeCause.getPk().getAlertCause()
				.getAlertCauseResponsibility().getName();
		for (AlertCauseResponsibility alrtCusRspbty : alertCauseResponsibilities) {
			if (curAlrtCusRspbtyNm.equals(alrtCusRspbty.getName())) {
				alrtCusRspbty.setName("!" + alrtCusRspbty.getName());
			}
		}

		String curStus = this.alertTypeCause.getStatus();
		for (int i = 0; i < status.size(); i++) {
			String stut = status.get(i);
			if (curStus.equals(stut)) {
				status.set(i, "!" + stut);
			}
		}

	}

	public long getAlertTypeId() {
		return alertTypeId;
	}

	public void setAlertTypeId(long alertTypeId) {
		this.alertTypeId = alertTypeId;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		if (state.indexOf("!") != -1) {
			this.state = state.substring(1);
			return;
		}
		this.state = state;
	}

	public long getAlertCauseResponsibilityId() {
		return alertCauseResponsibilityId;
	}

	public void setAlertCauseResponsibilityId(long alertCauseResponsibilityId) {
		this.alertCauseResponsibilityId = alertCauseResponsibilityId;
	}
}
