package com.ibm.asset.trails.form;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class PendingCustomerDecisionSummaryReport extends ReportBase {

	public PendingCustomerDecisionSummaryReport(ReportService pReportService,
			OutputStream pOutputStream) {
		super(pReportService, pOutputStream);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest,
			Account pAccount, String remoteUser, String lsName)
			throws HibernateException, Exception {

	}
}
