package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class FreeLicensePoolReport extends ReportBase {

	public FreeLicensePoolReport(ReportService pReportService,
			OutputStream pOutputStream) {
		super(pReportService, pOutputStream);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws HibernateException, Exception {
		super.getReportService().getFreeLicensePoolReport(pAccount,
				new PrintWriter(super.getOutputStream(), true));
	}
}
