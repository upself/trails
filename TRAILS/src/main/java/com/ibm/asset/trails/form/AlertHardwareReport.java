package com.ibm.asset.trails.form;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class AlertHardwareReport extends ReportBase {

	public AlertHardwareReport(ReportService pReportService,
			OutputStream pOutputStream, HSSFWorkbook phwb) {
		super(pReportService, pOutputStream, phwb);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount)
			throws HibernateException, Exception {
		super.getReportService().getAlertHardwareReport(pAccount,
				super.getHSSFWorkbook(), super.getOutputStream());
	}
}
