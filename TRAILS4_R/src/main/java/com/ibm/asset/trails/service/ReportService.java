package com.ibm.asset.trails.service;

import java.io.PrintWriter;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;

public interface ReportService {
	void getAlertExpiredMaintReport(Account pAccount, PrintWriter pPrintWriter)
			throws Exception;

	void getAlertExpiredScanReport(Account pAccount, PrintWriter pPrintWriter)
			throws Exception;

	void getAlertHardwareLparReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getAlertHardwareReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getAlertSoftwareLparReport(Account pAccount, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getAlertUnlicensedIbmSwReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getAlertUnlicensedIsvSwReport(Account pAccount,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

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
