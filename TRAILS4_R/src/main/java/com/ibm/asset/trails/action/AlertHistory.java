package com.ibm.asset.trails.action;

import com.ibm.asset.trails.service.AlertService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class AlertHistory extends BaseListAction {

	private static final long serialVersionUID = 1L;

	private AlertService alertService;

	private Long id;

	@UserRole(userRole = UserRoleType.READER)
	public String execute() {

		getData().setList(getAlertService().getAlertHistory(id));

		return SUCCESS;
	}

	public AlertService getAlertService() {
		return alertService;
	}

	public void setAlertService(AlertService alertService) {
		this.alertService = alertService;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

}
