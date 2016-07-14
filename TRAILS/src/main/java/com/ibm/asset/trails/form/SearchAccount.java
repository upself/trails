package com.ibm.asset.trails.form;

import com.opensymphony.xwork2.validator.annotations.ExpressionValidator;
import com.opensymphony.xwork2.validator.annotations.RegexFieldValidator;
import com.opensymphony.xwork2.validator.annotations.RequiredStringValidator;
import com.opensymphony.xwork2.validator.annotations.StringLengthFieldValidator;
import com.opensymphony.xwork2.validator.annotations.ValidatorType;

public class SearchAccount {
	private String searchString;

	private boolean nameSearch;

	private boolean accountNumberSearch;
	
	public boolean isAccountNumberSearch() {
		return accountNumberSearch;
	}

	public void setAccountNumberSearch(boolean accountNumberSearch) {
		this.accountNumberSearch = accountNumberSearch;
	}

	public boolean isNameSearch() {
		return nameSearch;
	}

	public void setNameSearch(boolean nameSearch) {
		this.nameSearch = nameSearch;
	}

	public String getSearchString() {
		return searchString;
	}

	@ExpressionValidator(expression = "accountNumberSearch || nameSearch", message = "The search type is required")
	@RequiredStringValidator(type = ValidatorType.FIELD, trim = true, message = "The search string is required")
	@StringLengthFieldValidator(type = ValidatorType.FIELD, trim = true, minLength = "2", message = "The search string must contain at least 2 characters.")
	@RegexFieldValidator(type = ValidatorType.FIELD, expression = "[\\w\\,\\.\\(\\)\\*\\-:\\s]+", message = "The search string must contain only numbers and letters")
	public void setSearchString(String searchString) {
		this.searchString = searchString;
	}
}
