package com.ibm.asset.trails.action;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.trails.service.DataExceptionReportService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class AccountDataExceptionAction extends AccountBaseAction {
	private static final long serialVersionUID = 1L;

	@Autowired
	private DataExceptionReportService service;

	@UserRole(userRole = UserRoleType.READER)
	public String doOverview() throws Exception {
		getData().setList(service.getAlertsOverview(getAccount()));

		return Action.SUCCESS;
	}

	public DataExceptionReportService getService() {
		return service;
	}

	public void setService(DataExceptionReportService service) {
		this.service = service;
	}

}
