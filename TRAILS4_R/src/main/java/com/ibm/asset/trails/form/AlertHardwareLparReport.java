package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class AlertHardwareLparReport extends ReportBase {

	public AlertHardwareLparReport(ReportService pReportService,
			OutputStream pOutputStream) {
		super(pReportService, pOutputStream);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws HibernateException, Exception {
		super.getReportService().getAlertHardwareLparReport(pAccount,
				new PrintWriter(super.getOutputStream(), true));
	}
}
