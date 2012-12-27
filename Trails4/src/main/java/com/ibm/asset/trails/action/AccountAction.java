package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.Report;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class AccountAction extends AccountReportBaseAction {

	private static final long serialVersionUID = 1L;

	@Override
	public void prepare() {
		super.prepare();

		List<Report> lReport = new ArrayList<Report>();

		lReport.add(new Report("Installed software baseline",
				"installedSoftwareBaseline"));
		super.setReportList(lReport);
	}

	@UserRole(userRole = UserRoleType.READER)
	public String doHome() {
		return Action.SUCCESS;
	}
}
