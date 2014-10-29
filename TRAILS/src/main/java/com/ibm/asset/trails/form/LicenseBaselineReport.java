package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class LicenseBaselineReport extends ReportBase {

	public LicenseBaselineReport(ReportService pReportService,
			OutputStream pOutputStream,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked) {
		super(pReportService, pOutputStream,
				pbCustomerOwnedCustomerManagedSearchChecked,
				pbCustomerOwnedIBMManagedSearchChecked,
				pbIBMOwnedIBMManagedSearchChecked,
				pbIBMO3rdMSearchChecked,
				pbCustO3rdMSearchChecked,
			    pbIBMOibmMSWCOSearchChecked,
				pbCustOibmMSWCOSearchChecked,
				pbTitlesNotSpecifiedInContractScopeSearchChecked,
				pbSelectAllChecked);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount, String remoteUser, String lsName)
			throws HibernateException, Exception {
		super.getReportService().getLicenseBaselineReport(pAccount, remoteUser, lsName, 
				new PrintWriter(super.getOutputStream(), true),
				super.isCustomerOwnedCustomerManagedSearchChecked(),
				super.isCustomerOwnedIBMManagedSearchChecked(),
				super.isIbmOwnedIBMManagedSearchChecked(),
				super.isIbmO3rdMSearchChecked(),
				super.isCustO3rdMSearchChecked(),
			    super.isIbmOibmMSWCOSearchChecked(),
				super.isCustOibmMSWCOSearchChecked(),
				super.isTitlesNotSpecifiedInContractScopeSearchChecked(),
				super.isSelectAllChecked());
	}
}
