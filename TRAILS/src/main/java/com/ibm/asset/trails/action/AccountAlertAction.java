package com.ibm.asset.trails.action;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.service.AlertReportService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

@Controller
public class AccountAlertAction extends AccountBaseAction {
	private static final long serialVersionUID = -8324446034344315902L;
	private Date reportTimestamp;
	private Integer reportMinutesOld;

	@Autowired
	private AlertReportService service;

	@UserRole(userRole = UserRoleType.READER)
	public String doOverview() throws Exception {
		retrieveReportInfo();
		getData().setList(service.getAlertsOverview(getAccount()));

		return Action.SUCCESS;
	}

	private void retrieveReportInfo() {
		setReportTimestamp(service.selectReportTimestamp());
		setReportMinutesOld(service.selectReportMinutesOld());
	}

	public Integer getReportMinutesOld() {
		return reportMinutesOld;
	}

	public Date getReportTimestamp() {
		return reportTimestamp;
	}

	public void setReportMinutesOld(Integer reportMinutesOld) {
		this.reportMinutesOld = reportMinutesOld;
	}

	public void setReportTimestamp(Date reportTimestamp) {
		this.reportTimestamp = reportTimestamp;
	}
}
