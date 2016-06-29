package com.ibm.asset.trails.action;

import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.service.DataExceptionService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.ibm.tap.trails.framework.DisplayTagList;
import com.opensymphony.xwork2.Action;

public class InstalledSwExpAction extends AccountBaseAction {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private DataExceptionService alertInstalledSwService;
	private String alertTypeCode;
	public String getAlertTypeCode() {
		return alertTypeCode;
	}
	
	public void setAlertTypeCode(String alertTypeCode)
	{
		this.alertTypeCode = alertTypeCode;
		alertInstalledSwService.setAlertTypeCode(alertTypeCode);
	}
	
	public void setInstalledSwExpService(DataExceptionService alertInstalledSwService) {
		this.alertInstalledSwService = alertInstalledSwService;
	}

	@UserRole(userRole = UserRoleType.READER)
	public void prepare() {
		super.prepare();
	}

	private AlertType getAlertType() {
		return alertInstalledSwService.getAlertType();
	}

	@Override
	public String input() {
		return Action.INPUT;
	}

}
