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

	public static final String SHOW_V17E = "SHOW_V17E"; 
	 
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {

		getData().setList(getAlertService().getAlertHistory(id));
		
        if(null!=gotoV17e && gotoV17e.equalsIgnoreCase("y")){
        	return SHOW_V17E;
        }
		return SUCCESS;
	}
	
	private String gotoV17e;
	
    public String getGotoV17e() {
		return gotoV17e;
	}

	public void setGotoV17e(String gotoV17e) {
		this.gotoV17e = gotoV17e;
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
