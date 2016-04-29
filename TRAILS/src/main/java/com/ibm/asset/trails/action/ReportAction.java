package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.Report;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;

public class ReportAction extends AccountReportBaseAction {

	private static final long serialVersionUID = 1L;

	@Override
	public void prepare() {
		super.prepare();

		List<Report> lReport = new ArrayList<Report>();

		lReport.add(new Report("Full reconciliation", "fullReconciliation"));
		lReport.add(new Report("Installed software baseline", "installedSoftwareBaseline"));
		lReport.add(new Report("License baseline", "licenseBaseline"));
		lReport.add(new Report("Component compliance summary", "softwareComplianceSummary"));
		super.setReportList(lReport);
	}

	@UserRole(userRole = UserRoleType.REPORTSREADER)
	public String doHome() {
		return Action.SUCCESS;
	}
}
