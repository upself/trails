package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class AccountDataExceptionsReport extends ReportBase {

	public AccountDataExceptionsReport(ReportService pReportService, String pCode,
			OutputStream pOutputStream) {
		super(pReportService, pOutputStream, pCode);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws HibernateException, Exception {
		super.getReportService().getAccountDataExceptionReport(pAccount, super.getAlertCode(),
				new PrintWriter(super.getOutputStream(), true));
	}
}
