package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class AlertHardwareLparReport extends ReportBase {

	public AlertHardwareLparReport(ReportService pReportService,
			OutputStream pOutputStream, HSSFWorkbook phwb) {
		super(pReportService, pOutputStream, phwb);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount, String remoteUser, String lsName)
			throws HibernateException, Exception {
		super.getReportService().getAlertHardwareLparReport(pAccount, remoteUser, lsName,
				super.getHSSFWorkbook(), super.getOutputStream());
	}
}
