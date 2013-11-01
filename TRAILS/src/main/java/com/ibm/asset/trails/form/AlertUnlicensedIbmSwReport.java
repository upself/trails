package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class AlertUnlicensedIbmSwReport extends ReportBase {

	public AlertUnlicensedIbmSwReport(ReportService pReportService,
			OutputStream pOutputStream, HSSFWorkbook phwb) {
		super(pReportService, pOutputStream, phwb);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws HibernateException, Exception {
		super.getReportService().getAlertUnlicensedIbmSwReport(pAccount,
				super.getHSSFWorkbook(), super.getOutputStream());
	}
}
