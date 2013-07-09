package com.ibm.asset.trails.form;

import com.opensymphony.xwork2.validator.annotations.RegexFieldValidator;
import com.opensymphony.xwork2.validator.annotations.RequiredStringValidator;
import com.opensymphony.xwork2.validator.annotations.StringLengthFieldValidator;
import com.opensymphony.xwork2.validator.annotations.ValidatorType;

public class DataExceptionCauseForm {
	private String alertCauseName;

	public String getAlertCauseName() {
		return alertCauseName;
	}

	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "Name is required")
	@StringLengthFieldValidator(type = ValidatorType.FIELD, trim = true, maxLength = "64", message = "Name cannot be more than 64 characters")
	@RegexFieldValidator(type = ValidatorType.FIELD, expression = "[\\w\\,\\.\\(\\)\\*\\-:\\s]+", message = "Name must contain only letters and numbers")
	public void setAlertCauseName(String alertCauseName) {
		this.alertCauseName = alertCauseName.toUpperCase();
	}
}
