package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class WorkstationAccountsReport extends ReportBase {

	public WorkstationAccountsReport(ReportService pReportService,
			OutputStream pOutputStream) {
		super(pReportService, pOutputStream);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws Exception {
		super.getReportService().getWorkstationAccountsReport(
				new PrintWriter(super.getOutputStream(), true));
	}
}
