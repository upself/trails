package com.ibm.asset.trails.service;

import java.io.PrintWriter;
import java.io.OutputStream;

import org.hibernate.HibernateException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.asset.trails.domain.Account;

public interface ReportService {
	void getAlertExpiredMaintReport(Account pAccount, String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws Exception;

	void getAlertExpiredScanReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws Exception;

	void getAlertHardwareLparReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertHardwareReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertSoftwareLparReport(Account pAccount,String remoteUser, String lsName,  HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception;

	void getAlertUnlicensedIbmSwReport(Account pAccount, String remoteUser, String lsName, 
			 HSSFWorkbook phwb, OutputStream pOutputStream) throws HibernateException, Exception;
	
	void getAccountDataExceptionReport(Account pAccount, String remoteUser, String lsName,  String pAlertCode,
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getAlertUnlicensedIsvSwReport(Account pAccount, String remoteUser, String lsName, 
			 HSSFWorkbook phwb, OutputStream pOutputStream) throws HibernateException, Exception;

	void getFreeLicensePoolReport(Account pAccount, String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getFullReconciliationReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception;

	void getHardwareBaselineReport(Account pAccount, String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getInstalledSoftwareBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception;

	void getLicenseBaselineReport(Account pAccount,String remoteUser, String lsName,  PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception;

	void getNonWorkstationAccountsReport(String remoteUser, String lsName, PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getReconciliationSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception;
	
	void getCauseCodeSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getSoftwareComplianceSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception;

	void getSoftwareLparBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception;

	void getSoftwareVarianceReport(Account pAccount, String remoteUser, String lsName,   PrintWriter pPrintWriter)
			throws HibernateException, Exception;

	void getWorkstationAccountsReport(String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws HibernateException, Exception;
	
	void getNonInstanceBasedSWReport(PrintWriter pPrintWriter);
	void getPriorityISVSWReport(PrintWriter pPrintWriter);
	void getAlertHardwareCfgDataReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb, OutputStream pOutputStream)throws HibernateException, Exception;

	void getAlertUnlicensed(Account pAccount, String remoteUser, String lsName,
			HSSFWorkbook phwb, OutputStream pOutputStream, String type,
			String code, String reportName, String sheetName ) throws HibernateException, Exception;
}
