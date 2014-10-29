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
	
	private boolean ibmO3rdMSearchChecked = false;
	
	private boolean custO3rdMSearchChecked = false;
	
	private boolean ibmOibmMSWCOSearchChecked = false;
	
	private boolean custOibmMSWCOSearchChecked = false;

	private boolean titlesNotSpecifiedInContractScopeSearchChecked = false;
	
	private boolean selectAllChecked = false;

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
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked) {
		super();

		setReportService(pReportService);
		setOutputStream(pOutputStream);
		setCustomerOwnedCustomerManagedSearchChecked(pbCustomerOwnedCustomerManagedSearchChecked);
		setCustomerOwnedIBMManagedSearchChecked(pbCustomerOwnedIBMManagedSearchChecked);
		setIbmOwnedIBMManagedSearchChecked(pbIBMOwnedIBMManagedSearchChecked);
		setIbmO3rdMSearchChecked(pbIBMO3rdMSearchChecked);
		setCustO3rdMSearchChecked(pbCustO3rdMSearchChecked);
	    setIbmOibmMSWCOSearchChecked(pbIBMOibmMSWCOSearchChecked);
		setCustOibmMSWCOSearchChecked(pbCustOibmMSWCOSearchChecked);
		setTitlesNotSpecifiedInContractScopeSearchChecked(pbTitlesNotSpecifiedInContractScopeSearchChecked);
		setSelectAllChecked(pbSelectAllChecked);
	}

	public abstract void execute(HttpServletRequest pHttpServletRequest,
			Account pAccount, String remoteUser, String lsName) throws HibernateException, Exception;

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

	public boolean isIbmO3rdMSearchChecked() {
		return ibmO3rdMSearchChecked;
	}

	public void setIbmO3rdMSearchChecked(boolean ibmO3rdMSearchChecked) {
		this.ibmO3rdMSearchChecked = ibmO3rdMSearchChecked;
	}

	public boolean isCustO3rdMSearchChecked() {
		return custO3rdMSearchChecked;
	}

	public void setCustO3rdMSearchChecked(boolean custO3rdMSearchChecked) {
		this.custO3rdMSearchChecked = custO3rdMSearchChecked;
	}

	public boolean isIbmOibmMSWCOSearchChecked() {
		return ibmOibmMSWCOSearchChecked;
	}

	public void setIbmOibmMSWCOSearchChecked(boolean ibmOibmMSWCOSearchChecked) {
		this.ibmOibmMSWCOSearchChecked = ibmOibmMSWCOSearchChecked;
	}

	public boolean isCustOibmMSWCOSearchChecked() {
		return custOibmMSWCOSearchChecked;
	}

	public void setCustOibmMSWCOSearchChecked(boolean custOibmMSWCOSearchChecked) {
		this.custOibmMSWCOSearchChecked = custOibmMSWCOSearchChecked;
	}

	public boolean isSelectAllChecked() {
		return selectAllChecked;
	}

	public void setSelectAllChecked(boolean selectAllChecked) {
		this.selectAllChecked = selectAllChecked;
	}
}
