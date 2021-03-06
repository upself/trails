package com.ibm.asset.trails.form;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertType;

public class DataExceptionReportActionForm {

	private Long id;

	private String name;

	private Long assigned;

	private Long total;

	private AlertType alertType;

	private Account account;

	private String url;

	public DataExceptionReportActionForm(Long id, String name, Long assigned,
			Long total, AlertType alertType) {
		this.id = id;
		this.name = name;
		this.assigned = assigned;
		this.total = total;
		this.alertType = alertType;
		initUrl();
	}

	public DataExceptionReportActionForm(Account account, Long assigned,
			Long total, AlertType alertType) {
		this.account = account;
		this.assigned = assigned;
		this.total = total;
		this.alertType = alertType;
		initUrl();
	}

	private void initUrl() {
		this.url = "lpar" + alertType.getCode();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setAssigned(Long assigned) {
		this.assigned = assigned;
	}

	public Long getAssigned() {
		return assigned;
	}

	public Long getTotal() {
		return total;
	}

	public void setTotal(Long total) {
		this.total = total;
	}

	public AlertType getAlertType() {
		return alertType;
	}

	public void setAlertType(AlertType alertType) {
		this.alertType = alertType;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public Account getAccount() {
		return account;
	}

	public String getUrl() {
		return url;
	}

}
