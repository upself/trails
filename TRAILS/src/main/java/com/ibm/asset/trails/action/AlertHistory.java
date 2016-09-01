package com.ibm.asset.trails.action;

import java.util.List;

import com.ibm.asset.trails.service.AlertService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;

public class AlertHistory extends BaseListAction {

	private static final long serialVersionUID = 1L;

	private AlertService alertService;
	
	private List historyList;

	private Long id;
	 
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {

		getData().setList(getAlertService().getAlertHistory(id));
		
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.READER)
	public String excuteV17e() {

		historyList = getAlertService().getAlertHistory(id);

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

	public List getHistoryList() {
		return historyList;
	}

	public void setHistoryList(List historyList) {
		this.historyList = historyList;
	}
}
