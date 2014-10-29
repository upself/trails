package com.ibm.asset.trails.action;

import com.ibm.asset.trails.service.DataExceptionHistoryService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class AlertHistoryAction extends BaseListAction {

	private static final long serialVersionUID = 1L;

	private DataExceptionHistoryService historyService;

	private Long alertId;

	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		
		getData().setList(getHistoryService().getHistory(getAlertId()));

		return SUCCESS;
	}

	public DataExceptionHistoryService getHistoryService() {
		return historyService;
	}

	public void setHistoryService(DataExceptionHistoryService historyService) {
		this.historyService = historyService;
	}

	public Long getAlertId() {
		return alertId;
	}

	public void setAlertId(Long alertId) {
		this.alertId = alertId;
	}

}
