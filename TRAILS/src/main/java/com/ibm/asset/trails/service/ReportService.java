package com.ibm.asset.trails.service;

import java.io.PrintWriter;
import java.io.OutputStream;

import org.hibernate.HibernateException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.asset.trails.domain.Account;

public interface ReportService {
	void getAlertExpiredMaintReport(Account pAccount, PrintWriter pPrintWriter)
			throws Exception;

	void getAlertExpiredScanReport(Account pAccount,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws Exception;

	void getAlertHardwareLparReport(Account pAccount, HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertHardwareReport(Account pAccount, HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertSoftwareLparReport(Account pAccount,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertUnlicensedIbmSwReport(Account pAccount,
			 HSSFWorkbook phwb, OutputStream pOutputStream) throws HibernateException, Exception;
	
	void getAccountDataExceptionReport(Account pAccount, String pAlertCode,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getAlertUnlicensedIsvSwReport(Account pAccount,
			 HSSFWorkbook phwb, OutputStream pOutputStream) throws HibernateException, Exception;

	void getFreeLicensePoolReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getFullReconciliationReport(Account pAccount,
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked)
			throws HibernateException, Exception;

	void getHardwareBaselineReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getInstalledSoftwareBaselineReport(Account pAccount,
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked)
			throws HibernateException, Exception;

	void getLicenseBaselineReport(Account pAccount, PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked)
			throws HibernateException, Exception;

	void getNonWorkstationAccountsReport(PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getPendingCustomerDecisionDetailReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getPendingCustomerDecisionSummaryReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getReconciliationSummaryReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;
	
	void getCauseCodeSummaryReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getSoftwareComplianceSummaryReport(Account pAccount,
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked)
			throws HibernateException, Exception;

	void getSoftwareLparBaselineReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getSoftwareVarianceReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getWorkstationAccountsReport(PrintWriter pPrintWriter)
			throws HibernateException, Exception;
}
