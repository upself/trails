package com.ibm.asset.trails.form;

import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts2.util.ServletContextAware;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.ReportService;
import com.ibm.tap.trails.framework.UserSession;

public class ReportDownload extends HttpServlet implements ServletContextAware {
	private static final long serialVersionUID = 1L;

	private static final Log log = LogFactory.getLog(ReportDownload.class);
	
	private final String REPORT_NAME_CAUSE_CODE_SUMMARY = "casueCodeSummary";

	private final String REPORT_NAME_ALERT_EXPIRED_MAINT = "alertExpiredMaint";

	private final String REPORT_NAME_ALERT_EXPIRED_SCAN = "alertExpiredScan";

	private final String REPORT_NAME_ALERT_HARDWARE = "alertHardware";

	private final String REPORT_NAME_ALERT_HARDWARE_LPAR = "alertHardwareLpar";

	private final String REPORT_NAME_ALERT_SOFTWARE_LPAR = "alertSoftwareLpar";
	
	private final String REPORT_NAME_ACCOUNT_DATA_EXCEPTION = "accountDataException";

	private final String REPORT_NAME_ALERT_UNLICENSED_IBM_SW =
			"alertUnlicensedIbmSw";

	private final String REPORT_NAME_ALERT_UNLICENSED_ISV_SW =
			"alertUnlicensedIsvSw";

	private final String REPORT_NAME_FREE_LICENSE_POOL = "freeLicensePool";

	private final String REPORT_NAME_FULL_RECONCILIATION = "fullReconciliation";

	private final String REPORT_NAME_HARDWARE_BASELINE = "hardwareBaseline";

	private final String REPORT_NAME_INSTALLED_SOFTWARE_BASELINE =
			"installedSoftwareBaseline";

	private final String REPORT_NAME_LICENSE_BASELINE = "licenseBaseline";

	private final String REPORT_NAME_NON_WORKSTATION_ACCOUNTS =
			"nonWorkstationAccounts";

	private final String REPORT_NAME_RECONCILIATION_SUMMARY =
			"reconciliationSummary";

	private final String REPORT_NAME_SOFTWARE_COMPLIANCE_SUMMARY =
			"softwareComplianceSummary";

	private final String REPORT_NAME_SOFTWARE_LPAR_BASELINE =
			"softwareLparBaseline";

	private final String REPORT_NAME_SOFTWARE_VARIANCE =
			"softwareVariance";

	private final String REPORT_NAME_WORKSTATION_ACCOUNTS = "workstationAccounts";

	@Override
	public void doGet(HttpServletRequest pHttpServletRequest,
			HttpServletResponse pHttpServletResponse) throws ServletException,
			IOException {
		String lsName = this.getParameter(pHttpServletRequest, "name");
		String lsCode = this.getParameter(pHttpServletRequest, "code");
		UserSession lUserSession = ((UserSession) pHttpServletRequest.getSession()
				.getAttribute("userSession"));

		if (lUserSession != null
				|| lsName.equalsIgnoreCase(REPORT_NAME_NON_WORKSTATION_ACCOUNTS)
				|| lsName.equalsIgnoreCase(REPORT_NAME_WORKSTATION_ACCOUNTS)) {
			Account lAccount = null;
			String remoteUser = null;
			ReportBase lReportBase = null;
			ServletContext lServletContext = getServletContext();
			WebApplicationContext lWebApplicationContext = WebApplicationContextUtils
					.getRequiredWebApplicationContext(lServletContext);
			ReportService lReportService = (ReportService) lWebApplicationContext
					.getBean("reportService");

			if (lUserSession != null) {
				lAccount = ((UserSession) pHttpServletRequest.getSession()
						.getAttribute("userSession")).getAccount();
				remoteUser = ((UserSession) pHttpServletRequest.getSession()
						.getAttribute("userSession")).getRemoteUser();
			}
			
			try {
				pHttpServletResponse.setContentType("application/vnd.ms-excel");
				HSSFWorkbook hwb=new HSSFWorkbook();
				if(lsCode != null){
				pHttpServletResponse.setHeader("Content-Disposition", new StringBuffer(
						"filename=").append(lsName).append(lsCode).append(
						lAccount != null ? lAccount.getAccount().toString() : "").append(
						".xls").toString());
				} else {
					pHttpServletResponse.setHeader("Content-Disposition", new StringBuffer(
							"filename=").append(lsName).append(
							lAccount != null ? lAccount.getAccount().toString() : "").append(
							".xls").toString());
				}
				lReportBase = getReport(lsName, lsCode, lReportService,
						pHttpServletResponse.getOutputStream(), pHttpServletRequest, hwb);

				if (lReportBase != null) {
					lReportBase.execute(pHttpServletRequest, lAccount, remoteUser, lsName);
				}
			} catch (Exception e) {
				e.printStackTrace(System.out);
			}
		} else {
			pHttpServletResponse.sendRedirect("/TRAILS");
		}
	}

	private String getParameter(HttpServletRequest pHttpServletRequest,
			String psName) {
		String lsParameter = pHttpServletRequest.getParameter(psName);

		if (lsParameter == null || lsParameter.trim().length() == 0) {
			Object loParameter = pHttpServletRequest.getAttribute(psName);

			if (loParameter != null) {
				lsParameter = (String) loParameter;
			}
		}

		return lsParameter;
	}

	private ReportBase getReport(String psName, String psCode, ReportService pReportService,
			ServletOutputStream pServletOutputStream,
			HttpServletRequest pHttpServletRequest, HSSFWorkbook phwb) throws Exception {
		if (psName.equalsIgnoreCase(REPORT_NAME_FULL_RECONCILIATION)
				|| psName.equalsIgnoreCase(REPORT_NAME_INSTALLED_SOFTWARE_BASELINE)
				|| psName.equalsIgnoreCase(REPORT_NAME_LICENSE_BASELINE)
				|| psName.equalsIgnoreCase(REPORT_NAME_SOFTWARE_COMPLIANCE_SUMMARY)) {
			String lsCustomerOwnedCustomerManagedSearchChecked = this.getParameter(
					pHttpServletRequest, "customerOwnedCustomerManagedSearchChecked");
			String lsCustomerOwnedIBMManagedSearchChecked = this.getParameter(
					pHttpServletRequest, "customerOwnedIBMManagedSearchChecked");
			String lsIBMOwnedCustomerIBMSearchChecked = this.getParameter(
					pHttpServletRequest, "ibmOwnedIBMManagedSearchChecked");
			String lsIBMO3rdMSearchChecked = this.getParameter(
					pHttpServletRequest, "ibmO3rdMSearchChecked");
			String lsCustO3rdMSearchChecked = this.getParameter(
					pHttpServletRequest, "custO3rdMSearchChecked");
			String lsIBMOibmMSWCOSearchChecked = this.getParameter(
					pHttpServletRequest, "ibmOibmMSWCOSearchChecked");
			String lsCustOibmMSWCOSearchChecked = this.getParameter(
					pHttpServletRequest, "custOibmMSWCOSearchChecked");
			String lsTitlesNotSpecifiedInContractScopeSearchChecked = this
					.getParameter(pHttpServletRequest,
							"titlesNotSpecifiedInContractScopeSearchChecked");
			String lsSelectAllChecked = this.getParameter(
					pHttpServletRequest, "selectAllChecked");
			boolean lbCustomerOwnedCustomerManagedSearchChecked = lsCustomerOwnedCustomerManagedSearchChecked != null
					&& lsCustomerOwnedCustomerManagedSearchChecked.length() > 0;
			boolean lbCustomerOwnedIBMManagedSearchChecked = lsCustomerOwnedIBMManagedSearchChecked != null
					&& lsCustomerOwnedIBMManagedSearchChecked.length() > 0;
			boolean lbIBMOwnedCustomerIBMSearchChecked = lsIBMOwnedCustomerIBMSearchChecked != null
					&& lsIBMOwnedCustomerIBMSearchChecked.length() > 0;
			boolean lbIBMO3rdMSearchChecked = lsIBMO3rdMSearchChecked != null
					&& lsIBMO3rdMSearchChecked.length() > 0;
			boolean lbCustO3rdMSearchChecked = lsCustO3rdMSearchChecked != null
					&& lsCustO3rdMSearchChecked.length() > 0;
			boolean lbIBMOibmMSWCOSearchChecked = lsIBMOibmMSWCOSearchChecked != null
					&& lsIBMOibmMSWCOSearchChecked.length() > 0;
			boolean lbCustOibmMSWCOSearchChecked = lsCustOibmMSWCOSearchChecked != null
				    && lsCustOibmMSWCOSearchChecked.length() > 0;
			boolean lbTitlesNotSpecifiedInContractScopeSearchChecked = lsTitlesNotSpecifiedInContractScopeSearchChecked != null
					&& lsTitlesNotSpecifiedInContractScopeSearchChecked.length() > 0;
			boolean lbSelectAllChecked = lsSelectAllChecked != null
					&& lsSelectAllChecked.length() > 0;

			if (psName.equalsIgnoreCase(REPORT_NAME_FULL_RECONCILIATION)) {
				return new FullReconciliationReport(pReportService,
						pServletOutputStream, lbCustomerOwnedCustomerManagedSearchChecked,
						lbCustomerOwnedIBMManagedSearchChecked,
						lbIBMOwnedCustomerIBMSearchChecked,
						lbIBMO3rdMSearchChecked,
						lbCustO3rdMSearchChecked,
						lbIBMOibmMSWCOSearchChecked,
						lbCustOibmMSWCOSearchChecked,
						lbTitlesNotSpecifiedInContractScopeSearchChecked,
						lbSelectAllChecked);
			} else if (psName
					.equalsIgnoreCase(REPORT_NAME_INSTALLED_SOFTWARE_BASELINE)) {
				return new InstalledSoftwareBaselineReport(pReportService,
						pServletOutputStream, lbCustomerOwnedCustomerManagedSearchChecked,
						lbCustomerOwnedIBMManagedSearchChecked,
						lbIBMOwnedCustomerIBMSearchChecked,
						lbIBMO3rdMSearchChecked,
						lbCustO3rdMSearchChecked,
						lbIBMOibmMSWCOSearchChecked,
						lbCustOibmMSWCOSearchChecked,
						lbTitlesNotSpecifiedInContractScopeSearchChecked,
						lbSelectAllChecked);
			} else if (psName.equalsIgnoreCase(REPORT_NAME_LICENSE_BASELINE)) {
				return new LicenseBaselineReport(pReportService, pServletOutputStream,
						lbCustomerOwnedCustomerManagedSearchChecked,
						lbCustomerOwnedIBMManagedSearchChecked,
						lbIBMOwnedCustomerIBMSearchChecked,
						lbIBMO3rdMSearchChecked,
						lbCustO3rdMSearchChecked,
						lbIBMOibmMSWCOSearchChecked,
						lbCustOibmMSWCOSearchChecked,
						lbTitlesNotSpecifiedInContractScopeSearchChecked,
						lbSelectAllChecked);
			} else if (psName
					.equalsIgnoreCase(REPORT_NAME_SOFTWARE_COMPLIANCE_SUMMARY)) {
				return new SoftwareComplianceSummaryReport(pReportService,
						pServletOutputStream, lbCustomerOwnedCustomerManagedSearchChecked,
						lbCustomerOwnedIBMManagedSearchChecked,
						lbIBMOwnedCustomerIBMSearchChecked,
						lbIBMO3rdMSearchChecked,
						lbCustO3rdMSearchChecked,
						lbIBMOibmMSWCOSearchChecked,
						lbCustOibmMSWCOSearchChecked,
						lbTitlesNotSpecifiedInContractScopeSearchChecked,
						lbSelectAllChecked);
			} else {
				log.error(new StringBuffer("An invalid report name, '").append(psName)
						.append("', was given."));
				throw new Exception(new StringBuffer("An invalid report name, '")
						.append(psName).append("', was given.").toString());
			}
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_EXPIRED_MAINT)) {
			return new AlertExpiredMaintReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_EXPIRED_SCAN)) {
			return new AlertExpiredScanReport(pReportService,
					pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_HARDWARE)) {
			return new AlertHardwareReport(pReportService, pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_HARDWARE_LPAR)) {
			return new AlertHardwareLparReport(pReportService,
					pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_SOFTWARE_LPAR)) {
			return new AlertSoftwareLparReport(pReportService,
					pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ACCOUNT_DATA_EXCEPTION)) {
			return new AccountDataExceptionsReport(pReportService, psCode,
					pServletOutputStream);
		}  else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_UNLICENSED_IBM_SW)) {
			return new AlertUnlicensedIbmSwReport(pReportService,
					pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_ALERT_UNLICENSED_ISV_SW)) {
			return new AlertUnlicensedIsvSwReport(pReportService,
					pServletOutputStream, phwb);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_FREE_LICENSE_POOL)) {
			return new FreeLicensePoolReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_HARDWARE_BASELINE)) {
			return new HardwareBaselineReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_NON_WORKSTATION_ACCOUNTS)) {
			return new NonWorkstationAccountsReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_RECONCILIATION_SUMMARY)) {
			return new ReconciliationSummaryReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_SOFTWARE_LPAR_BASELINE)) {
			return new SoftwareLparBaselineReport(pReportService,
					pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_SOFTWARE_VARIANCE)) {
			return new SoftwareVarianceReport(pReportService, pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_WORKSTATION_ACCOUNTS)) {
			return new WorkstationAccountsReport(pReportService, pServletOutputStream);
		} else if (psName.equalsIgnoreCase(REPORT_NAME_CAUSE_CODE_SUMMARY)) {
			return new CauseCodeSummaryReport(pReportService, pServletOutputStream);
		} else {
			log.error(new StringBuffer("An invalid report name, '").append(
					psName).append("', was given."));
			throw new Exception(new StringBuffer("An invalid report name, '")
					.append(psName).append("', was given.").toString());
		}
	}

	public void setServletContext(ServletContext servletContext) {
		return;
	}
}
