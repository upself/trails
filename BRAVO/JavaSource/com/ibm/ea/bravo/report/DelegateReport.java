/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.report;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.framework.report.ReportBase;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.Hardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.hardwaresoftware.DelegateComposite;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End

/**
 * @author denglers
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class DelegateReport extends HibernateDelegate {
	private static final Logger logger = Logger.getLogger(DelegateReport.class);

	public static ReportBase getReport(String reportName) {
		ReportBase report = null;

		if (reportName.equalsIgnoreCase(Constants.ACCOUNT_ASSETS))
			report = new AccountAssets();

		if (reportName.equalsIgnoreCase(Constants.HARDWARE_LPAR_ONLY))
			report = new HardwareLparOnly();

		if (reportName.equalsIgnoreCase(Constants.SOFTWARE_LPAR_ONLY))
			report = new SoftwareLparOnly();

		if (reportName.equalsIgnoreCase(Constants.ACCOUNT_DISCREPANCIES))
			report = new AccountDiscrepancies();

		if (reportName.equalsIgnoreCase(Constants.GLOBAL_DISCREPANCIES))
			report = new GlobalDiscrepancies();

		if (reportName.equalsIgnoreCase(Constants.GLOBAL_SUMMARY))
			report = new GlobalSummary();

		if (reportName.equalsIgnoreCase(Constants.ACCOUNT_SOFTWARE))
			report = new AccountSoftware();

		if (reportName.equalsIgnoreCase(Constants.TRAILS_MANUAL_SW_LOADER))
			report = new TrailsManualSoftwareLoader();

		if (reportName.equalsIgnoreCase(Constants.SOFTWARE_DISCREPANCY_BLANK))
			report = new SoftwareDiscrepancyLoaderTemplate();

		if (reportName.equalsIgnoreCase(Constants.SCRT_REPORT))
			report = new SCRTReportDownload();

		if (reportName.equalsIgnoreCase(Constants.MAINFRAME_SCAN))
			report = new MainframeScan();

		if (reportName.equalsIgnoreCase(Constants.AUTHORIZED_ASSETS_BLANK))
			report = new AuthorizedAssetsLoaderTemplate();

		if (reportName.equalsIgnoreCase(Constants.SW_MULTI_REPORT)) {
			report = new SwMultiReport();
		}
		return report;
	}

	public static ReportBase getReport(String reportName,
			OutputStream outputStream) {
		ReportBase report = null;

		report = getReport(reportName);

		if (report != null)
			report.setOutputStream(outputStream);

		return report;
	}

	public static List<Object[]> getReport(AccountAssets report,
			HttpServletRequest request) throws HibernateException, Exception {
		logger.debug("DelegateReport.getReport(AccountAssets)");
		List<Object[]> list = new ArrayList<Object[]>();

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		// For hardware records we want to only retrieve those that are not
		// removed status
		// For software we only want to retrieve active records

		// Get our composites and our active software lpars
		// We know that composites will only be active stuff
		ArrayList<Object> data = new ArrayList<Object>(
				DelegateComposite.getSoftwareLparAllByCustomer(account));

		if (data != null) {
			Iterator<Object> i = data.iterator();
			while (i.hasNext()) {
				SoftwareLpar sl = (SoftwareLpar) i.next();
				Integer processorCount = null;
				String biosSerial = null;

				if ((sl.getSoftwareLparEff() == null)
						|| (sl.getSoftwareLparEff().getStatus()
								.equalsIgnoreCase(Constants.INACTIVE))) {
					processorCount = sl.getProcessorCount();
				} else {
					processorCount = sl.getSoftwareLparEff()
							.getProcessorCount();
				}

				biosSerial = sl.getBiosSerial();

				String hwFlag = "N";
				String type = null;
				String serial = null;
				String hwStatus = null;
				String machineTypeName = null;
				String customerNumber = null;

				if (sl.getHardwareLpar() != null) {
					hwFlag = "Y";
					if (sl.getHardwareLpar().getHardware() != null) {
						serial = sl.getHardwareLpar().getHardware().getSerial();
						hwStatus = sl.getHardwareLpar().getHardware()
								.getHardwareStatus();
						customerNumber = sl.getHardwareLpar().getHardware()
								.getCustomerNumber();
						if (sl.getHardwareLpar().getHardware().getMachineType() != null) {
							type = sl.getHardwareLpar().getHardware()
									.getMachineType().getType();
							machineTypeName = sl.getHardwareLpar()
									.getHardware().getMachineType().getName();
						}
					}

				}

				list.add(new Object[] {
						account.getCustomer().getAccountNumber(),
						account.getCustomer().getCustomerName(),
						account.getCustomer().getCustomerType()
								.getCustomerTypeName(),
						account.getCustomer().getPod().getPodName(),
						sl.getName(), type, serial, biosSerial, hwFlag, "Y",
						hwStatus, machineTypeName, customerNumber,
						sl.getScantimeDate(), processorCount });
			}
		}

		data = new ArrayList<Object>(
				DelegateHardware.getHardwareLparsWithoutSoftware(account));

		if (data != null) {
			Iterator<Object> i = data.iterator();
			while (i.hasNext()) {
				HardwareLpar hl = (HardwareLpar) i.next();

				Integer processorCount = null;
				String biosSerial = null;

				String hwFlag = "Y";
				String type = null;
				String serial = null;
				String hwStatus = null;
				String machineTypeName = null;
				String customerNumber = null;

				if (hl.getHardware() != null) {
					serial = hl.getHardware().getSerial();
					hwStatus = hl.getHardware().getHardwareStatus();
					customerNumber = hl.getHardware().getCustomerNumber();
					if (hl.getHardware().getMachineType() != null) {
						type = hl.getHardware().getMachineType().getType();
						machineTypeName = hl.getHardware().getMachineType()
								.getName();
					}
				}

				list.add(new Object[] {
						account.getCustomer().getAccountNumber(),
						account.getCustomer().getCustomerName(),
						account.getCustomer().getCustomerType()
								.getCustomerTypeName(),
						account.getCustomer().getPod().getPodName(),
						hl.getName(), type, serial, biosSerial, hwFlag, "N",
						hwStatus, machineTypeName, customerNumber, null,
						processorCount });
			}
		}

		data = new ArrayList<Object>(
				DelegateHardware.getHardwaresNoActiveLparsByCustomer(account));

		if (data != null) {
			Iterator<Object> i = data.iterator();
			while (i.hasNext()) {
				Hardware h = (Hardware) i.next();

				Integer processorCount = null;
				String biosSerial = null;

				String hwFlag = "Y";
				String type = null;
				String serial = null;
				String hwStatus = null;
				String machineTypeName = null;
				String customerNumber = null;

				serial = h.getSerial();
				hwStatus = h.getHardwareStatus();
				customerNumber = h.getCustomerNumber();
				if (h.getMachineType() != null) {
					type = h.getMachineType().getType();
					machineTypeName = h.getMachineType().getName();
				}

				list.add(new Object[] {
						account.getCustomer().getAccountNumber(),
						account.getCustomer().getCustomerName(),
						account.getCustomer().getCustomerType()
								.getCustomerTypeName(),
						account.getCustomer().getPod().getPodName(), "No LPAR",
						type, serial, biosSerial, hwFlag, "N", hwStatus,
						machineTypeName, customerNumber, null, processorCount });
			}
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<Object[]> getReport(HardwareLparOnly report,
			HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("DelegateReport.getReport(HardwareLparOnly)");
		List<Object[]> list = new ArrayList<Object[]>();

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		try {

			Session session = getSession();

			list = session.getNamedQuery("reportHardwareOnlyByCustomer")
					.setEntity("customer", account.getCustomer())
					.setString("status", Constants.ACTIVE).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<Object[]> getReport(SoftwareLparOnly report,
			HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("DelegateReport.getReport(SoftwareLparOnly)");
		List<Object[]> list = new ArrayList<Object[]>();
		// ScrollableResults list = null;

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		try {

			Session session = getSession();

			list = session.getNamedQuery("reportSoftwareOnlyByCustomer")
					.setEntity("customer", account.getCustomer())
					.setString("status", Constants.ACTIVE).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	public static ScrollableResults getReport(AccountDiscrepancies report,
			HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("DelegateReport.getReport(AccountDiscrepancies)");
		// List list = new ArrayList();
		ScrollableResults list = null;

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("reportDiscrepanciesByCustomer")
					.setLong("customer",
							account.getCustomer().getCustomerId().longValue())
					.setString("status", Constants.ACTIVE).scroll();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<DiscrepancySummary> getDiscrepancySummaryReport()
			throws HibernateException, Exception {

		logger.debug("DelegateReport.getReport(getDiscrepancySummaryReport)");
		List<DiscrepancySummary> list = new ArrayList<DiscrepancySummary>();

		try {

			Session session = getSession();

			list = session.getNamedQuery("discrepancySummaryReport").list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<Object[]> getReport(GlobalSummary report) {
		logger.debug("DelegateReport.getReport(GlobalSummary)");
		List<Object[]> list = new ArrayList<Object[]>();

		try {

			Session session = getSession();

			list = session.getNamedQuery("reportGlobalSummary").list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<Object[]> getReport(AccountSoftware report,
			HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("DelegateReport.getReport(AccountSoftware)");
		List<Object[]> list = new ArrayList<Object[]>();

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		// validate the software exists
		//Change Bravo to use Software View instead of Product Object Start
		//Product software = DelegateSoftware.getSigBank(report.getSoftwareId());
		Software software = DelegateSoftware.getSigBank(report.getSoftwareId());
		//Change Bravo to use Software View instead of Product Object End
		if (software == null)
			return list;

		try {

			Session session = getSession();

			list = session.getNamedQuery("reportLparsByAccountBySoftware")
					.setEntity("customer", account.getCustomer())
					.setEntity("software", software)
					.setString("status", Constants.ACTIVE).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<Object[]> getReport(TrailsManualSoftwareLoader report,
			HttpServletRequest request) throws ExceptionAccountAccess {
		logger.debug("DelegateReport.getReport(TrailsManualSoftwareLoader)");
		List<Object[]> list = new ArrayList<Object[]>();

		// validate the account exists
		Account account = DelegateAccount.getAccount(report.getAccountId(),
				request);
		if (account == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("reportTrailsManualSoftwareLoader")
					.setLong("customer_id",
							account.getCustomer().getCustomerId().longValue())
					.list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;
	}

	/**
	 * @param template
	 * @param request
	 */
	@SuppressWarnings("unchecked")
	public static List<String> getReport(
			SoftwareDiscrepancyLoaderTemplate template,
			HttpServletRequest request) {
		logger.debug("DelegateReport.getReport(SoftwareDiscrepancyLoaderTemplate)");
		List<String> list = new ArrayList<String>();

		try {

			Session session = getSession();

			list = session.getNamedQuery("activeSoftware").list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;

	}

	/**
	 * @param template
	 * @param request
	 */
	@SuppressWarnings("unchecked")
	public static List<String> getReport(
			AuthorizedAssetsLoaderTemplate template, HttpServletRequest request) {
		logger.debug("DelegateReport.getReport(AuthorizedAssetsLoaderTemplate)");
		List<String> list = new ArrayList<String>();

		try {

			Session session = getSession();

			list = session.getNamedQuery("activeSoftware").list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e);
		}

		return list;

	}

	@SuppressWarnings("unchecked")
	public static List<DepartmentScanReport> getDepartmentScanReport(
			String deptId) throws HibernateException, Exception {

		List<DepartmentScanReport> results = null;

		Session session = getSession();

		results = session.getNamedQuery("departmentScanReport")
				.setLong("pod", new Long(deptId).longValue()).list();

		closeSession(session);

		return results;
	}

	@SuppressWarnings("unchecked")
	public static List<DepartmentScanReport> getGeoScanReport()
			throws HibernateException, Exception {

		List<DepartmentScanReport> results = null;

		Session session = getSession();

		results = session.getNamedQuery("geoScanReport").list();

		closeSession(session);

		return results;
	}

	@SuppressWarnings("unchecked")
	public static List<DepartmentScanReport> getGeoRollupReport(String geoId)
			throws HibernateException, Exception {

		List<DepartmentScanReport> results = null;

		Session session = getSession();

		results = session.getNamedQuery("geoRollupReport")
				.setLong("geo", new Long(geoId).longValue()).list();

		closeSession(session);

		return results;
	}

	@SuppressWarnings("unchecked")
	public static List<DepartmentScanReport> getRegionRollupReport(
			String regionId) throws HibernateException, Exception {

		List<DepartmentScanReport> results = null;

		Session session = getSession();

		results = session.getNamedQuery("regionRollupReport")
				.setLong("region", new Long(regionId).longValue()).list();

		closeSession(session);

		return results;
	}

	@SuppressWarnings("unchecked")
	public static List<DepartmentScanReport> getCountryCodeRollupReport(
			String countryId) throws HibernateException, Exception {

		List<DepartmentScanReport> results = null;

		Session session = getSession();

		results = session.getNamedQuery("countryCodeRollupReport")
				.setLong("country", new Long(countryId).longValue()).list();

		closeSession(session);

		return results;
	}
}