package com.ibm.asset.trails.form;

import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public abstract class ReportBase {
	
	private ReportService reportService;

	private OutputStream outputStream;
	
	private HSSFWorkbook hssfWorkBook;
	
	private String alertCode;

	private boolean customerOwnedCustomerManagedSearchChecked = false;

	private boolean customerOwnedIBMManagedSearchChecked = false;

	private boolean ibmOwnedIBMManagedSearchChecked = false;

	private boolean titlesNotSpecifiedInContractScopeSearchChecked = false;

	public ReportBase(ReportService pReportService, OutputStream pOutputStream) {
		super();

		setReportService(pReportService);
		setOutputStream(pOutputStream);
	}
	
	public ReportBase(ReportService pReportService, OutputStream pOutputStream, HSSFWorkbook phssfWorkBook) {
		super();

		setReportService(pReportService);
		setOutputStream(pOutputStream);
		setHSSFWorkbook(phssfWorkBook);
	}
	
	public ReportBase(ReportService pReportService, OutputStream pOutputStream, String pAlertCode) {
		super();

		setReportService(pReportService);
		setOutputStream(pOutputStream);
		setAlertCode(pAlertCode);
	}

	public ReportBase(ReportService pReportService, OutputStream pOutputStream,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked) {
		super();

		setReportService(pReportService);
		setOutputStream(pOutputStream);
		setCustomerOwnedCustomerManagedSearchChecked(pbCustomerOwnedCustomerManagedSearchChecked);
		setCustomerOwnedIBMManagedSearchChecked(pbCustomerOwnedIBMManagedSearchChecked);
		setIbmOwnedIBMManagedSearchChecked(pbIBMOwnedIBMManagedSearchChecked);
		setTitlesNotSpecifiedInContractScopeSearchChecked(pbTitlesNotSpecifiedInContractScopeSearchChecked);
	}

	public abstract void execute(HttpServletRequest pHttpServletRequest,
			Account pAccount) throws HibernateException, Exception;

	public HSSFWorkbook getHSSFWorkbook() {
		return hssfWorkBook;
	}
	
	public void setHSSFWorkbook(HSSFWorkbook hssfWorkBook) {
		this.hssfWorkBook = hssfWorkBook;
	}
	
	public OutputStream getOutputStream() {
		return outputStream;
	}
	
	public String getAlertCode() {
		return alertCode;
	}

	public ReportService getReportService() {
		return reportService;
	}

	public void setOutputStream(OutputStream outputStream) {
		this.outputStream = outputStream;
	}

	public void setReportService(ReportService reportService) {
		this.reportService = reportService;
	}
	
	public void setAlertCode(String alertCode) {
		this.alertCode = alertCode;
	}

	public boolean isCustomerOwnedCustomerManagedSearchChecked() {
		return customerOwnedCustomerManagedSearchChecked;
	}

	public void setCustomerOwnedCustomerManagedSearchChecked(
			boolean customerOwnedCustomerManagedSearchChecked) {
		this.customerOwnedCustomerManagedSearchChecked = customerOwnedCustomerManagedSearchChecked;
	}

	public boolean isCustomerOwnedIBMManagedSearchChecked() {
		return customerOwnedIBMManagedSearchChecked;
	}

	public void setCustomerOwnedIBMManagedSearchChecked(
			boolean customerOwnedIBMManagedSearchChecked) {
		this.customerOwnedIBMManagedSearchChecked = customerOwnedIBMManagedSearchChecked;
	}

	public boolean isIbmOwnedIBMManagedSearchChecked() {
		return ibmOwnedIBMManagedSearchChecked;
	}

	public void setIbmOwnedIBMManagedSearchChecked(
			boolean ibmOwnedIBMManagedSearchChecked) {
		this.ibmOwnedIBMManagedSearchChecked = ibmOwnedIBMManagedSearchChecked;
	}

	public boolean isTitlesNotSpecifiedInContractScopeSearchChecked() {
		return titlesNotSpecifiedInContractScopeSearchChecked;
	}

	public void setTitlesNotSpecifiedInContractScopeSearchChecked(
			boolean titlesNotSpecifiedInContractScopeSearchChecked) {
		this.titlesNotSpecifiedInContractScopeSearchChecked = titlesNotSpecifiedInContractScopeSearchChecked;
	}
}
