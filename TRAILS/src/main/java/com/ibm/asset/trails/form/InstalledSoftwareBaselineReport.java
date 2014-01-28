package com.ibm.asset.trails.form;

import java.io.OutputStream;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;

import org.hibernate.HibernateException;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;

public class InstalledSoftwareBaselineReport extends ReportBase {

	public InstalledSoftwareBaselineReport(ReportService pReportService,
			OutputStream pOutputStream,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked) {
		super(pReportService, pOutputStream,
				pbCustomerOwnedCustomerManagedSearchChecked,
				pbCustomerOwnedIBMManagedSearchChecked,
				pbIBMOwnedIBMManagedSearchChecked,
				pbTitlesNotSpecifiedInContractScopeSearchChecked);
	}

	@Override
	public void execute(HttpServletRequest pHttpServletRequest, Account pAccount, String remoteUser, String lsName)
			throws HibernateException, Exception {
		super.getReportService().getInstalledSoftwareBaselineReport(pAccount, remoteUser, lsName, 
				new PrintWriter(super.getOutputStream(), true),
				super.isCustomerOwnedCustomerManagedSearchChecked(),
				super.isCustomerOwnedIBMManagedSearchChecked(),
				super.isIbmOwnedIBMManagedSearchChecked(),
				super.isTitlesNotSpecifiedInContractScopeSearchChecked());
	}
}
