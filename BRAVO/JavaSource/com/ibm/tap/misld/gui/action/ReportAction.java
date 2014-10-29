package com.ibm.tap.misld.gui.action;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.util.LabelValueBean;

import com.ibm.batch.IBatch;
import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.batch.MisldBatchFactory;
import com.ibm.tap.misld.delegate.baseline.MsInstalledSoftwareBaselineReadDelegate;
import com.ibm.tap.misld.delegate.batch.BatchReadDelegate;
import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.cndb.PodReadDelegate;
import com.ibm.tap.misld.delegate.misldDate.MisldDateReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.ForwardParameters;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.misldDate.MisldDate;
import com.ibm.tap.misld.om.priceReportCycle.PriceReportArchive;
import com.ibm.tap.misld.om.priceReportCycle.PriceReportCycle;
import com.ibm.tap.misld.report.PriceReport;
import com.ibm.tap.misld.report.PriceReportDelegate;

/**
 * @version 1.0
 * @author
 */
public class ReportAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/ReportPod.do");
		
		Pod podForm = (Pod) form;

		if (podForm.getPodId() != null) {
			Pod pod = PodReadDelegate.getPod(podForm.getPodId());
			user.setPod(pod);
			setUserContainer(request, user);
		}

		request.setAttribute(Constants.CUSTOMER_LIST, CustomerReadDelegate
				.getReportCustomerView(user.getPod()));
		request.setAttribute(Constants.POD_LIST, PodReadDelegate.getPods());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward dpe(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		if (user.getPod() == null) {
			return mapping.findForward(Constants.NEW);
		}

		user.setLevelOneOpenLink("/MsWizard/ReportPod.do");

		List customers = CustomerReadDelegate.getReportCustomerView(user
				.getPod());

		DynaActionForm f = (DynaActionForm) form;
		f.set("customer", (Customer[]) customers.toArray(new Customer[0]));
		request.setAttribute(Constants.CUSTOMER_LIST, customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward priceReportApprovalStatus(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages errors = new ActionMessages();
		
		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}
		user.setLevelOneOpenLink("/MsWizard/ReportPod.do");

		List customers = CustomerReadDelegate.getApprovedPriceReports();
		request.setAttribute(Constants.CUSTOMER_LIST, customers);

		errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("Email sent"));
		saveErrors(request, errors);
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward splaAccountReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		ActionMessages errors = new ActionMessages();
		
		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}
		user.setLevelOneOpenLink("/MsWizard/ReportPod.do");

		List priceReports = PriceReportDelegate.getSPLAAccountReport(user.getRemoteUser());
		
		request.setAttribute(Constants.PRICE_REPORTS_LIST, priceReports);

		errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("Email sent"));
		saveErrors(request, errors);
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward graph(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		try {
			UserContainer user = loadUser(request);
			user.setLevelOneOpenLink("/MsWizard/ReportPod.do");
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward splaPoReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getSplaPoReportBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward esplaPoReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getEsplaPoReportBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward q0xfHardwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getPodHardwareBaselineBatch("Q0XF",
				request.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward q0xfSoftwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getPodInstalledSoftwareBaselineBatch(
				"Q0XF", request.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward podHardwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);
		String pod = request.getParameter(Constants.POD);

		if (!user.isLoaded() || Util.isBlankString(pod)) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}
		
		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getPodHardwareBaselineBatch(pod,
				request.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward podSoftwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);
		String pod = request.getParameter(Constants.POD);

		if (!user.isLoaded() || Util.isBlankString(pod)) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getPodInstalledSoftwareBaselineBatch(
				pod, request.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward duplicateHostname(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory
				.getDuplicateHostnameReportBatch(request.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward duplicatePrefix(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getDuplicatePrefixReportBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward priceReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		Long customerId;
		String customerIdStr = request.getParameter("customer");

		if (customerIdStr == null) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			customerId = new Long(customerIdStr);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		Customer customer = CustomerReadDelegate.getCustomerByLong(customerId
				.longValue());
		String mas_status = customer.getMisldAccountSettings().getStatus();
		String mas_pr_status = customer.getMisldAccountSettings().getPriceReportStatus();

		if (customer == null) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/Report.do");
		user.setLevelTwoOpenLink("/MsWizard/ReportPod.do?pod="
				+ customer.getPod().getPodId());

		PriceReport priceReport = (PriceReport) form;

		PriceReportCycle priceReportCycle = PriceReportDelegate
				.getActivePriceReportCycle(customer);

		request.setAttribute("priceReportCycleList", PriceReportDelegate
				.getPriceReportCycles(customer));

		if (priceReportCycle == null) {
			priceReportCycle = new PriceReportCycle();
			priceReportCycle.setCustomerId(customerId);
			if ((user.getContact() != null && user.getContact().getContactId()
					.intValue() == customer.getContactDPE().getContactId()
					.intValue())
					|| user.isAdminAccess()) {

				PriceReport priceReportStuff = PriceReportDelegate
						.getPriceReport(customer);
				BeanUtils.copyProperties(priceReport, priceReportStuff);
				request.setAttribute("priceReportCycle", priceReportCycle);
				request.setAttribute("priceReport", priceReport);
				return mapping.findForward(Constants.NEW);
			} else {
				priceReport = PriceReportDelegate.getPriceReport(customer);
				priceReportCycle.setCustomerId(customerId);
				request.setAttribute("priceReportCycle", priceReportCycle);
				request.setAttribute("priceReport", priceReport);
				return mapping.findForward(Constants.ONDEMAND);
			}
		}

		else if (((priceReportCycle.getCycleStatus().equals(Constants.APPROVED))
				 || (priceReportCycle.getCycleStatus().equals(Constants.PO_ENTERED))
				 || (mas_status.equals(Constants.LOCKED)))     // KJN - 9/22/09
				&& user.isAsset()) {
			priceReportCycle.setCustomerId(customerId);
			request.setAttribute("priceReportCycle", priceReportCycle);
			request.setAttribute("priceReport", priceReport);
			// KJN 9/23/09
			PriceReport priceReportStuff = new PriceReport();
			if (mas_status.equals(Constants.LOCKED) && !mas_pr_status.equals(Constants.APPROVED)) {
				priceReportStuff = PriceReportDelegate
					.getLockedPriceReportArchive(priceReportCycle, customer);
				
			} else {
				priceReportStuff = PriceReportDelegate
					.getPriceReportArchive(priceReportCycle, customer);
			}
			BeanUtils.copyProperties(priceReport, priceReportStuff);
			
			if (mas_status.equals(Constants.LOCKED) && !mas_pr_status.equals(Constants.APPROVED)) {
				return mapping.findForward(Constants.NEW);
			} else {
				//request.setAttribute("poDates", MisldDateReadDelegate.getPoDates());
				//request.setAttribute("usageDates", MisldDateReadDelegate.getUsageDates());
				List poDateList = MisldDateReadDelegate.getPoDates();
				ArrayList poDates = new ArrayList();

				Iterator j = poDateList.iterator();

				while (j.hasNext()) {
					MisldDate misldDate = (MisldDate) j.next();

					poDates.add(new LabelValueBean(misldDate.getDateValue(), 
													"" + misldDate.getMisldDateId()));

				}
				priceReport.setPoDates(poDates);
				
				List usageDateList = MisldDateReadDelegate.getUsageDates();
				ArrayList usageDates = new ArrayList();

				Iterator k = usageDateList.iterator();

				while (k.hasNext()) {
					MisldDate misldDate = (MisldDate) k.next();

					usageDates.add(new LabelValueBean(misldDate.getDateValue(), 
													"" + misldDate.getMisldDateId()));

				}
				priceReport.setUsageDates(usageDates);
				return mapping.findForward(Constants.APPROVED);
			}
		}

		priceReportCycle.setCustomerId(customerId);
		priceReport = PriceReportDelegate.getPriceReportArchive(
				priceReportCycle, customer);
		request.setAttribute("priceReportCycle", priceReportCycle);
		request.setAttribute("priceReport", priceReport);
		return mapping.findForward(Constants.ARCHIVE);

	}

	public ActionForward emailPriceReport(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		Long customerId;
		String customerIdStr = request.getParameter("customer");

		if (customerIdStr == null) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			customerId = new Long(customerIdStr);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		Customer customer = CustomerReadDelegate.getCustomerByLong(customerId
				.longValue());

		if (customer == null) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/Report.do");
		user.setLevelTwoOpenLink("/MsWizard/ReportPod.do?pod="
				+ customer.getPod().getPodId());

		IBatch batch = MisldBatchFactory.getPriceReportBatch(customer, request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return new ForwardParameters().add("pod",
				"" + customer.getPod().getPodId()).forward(
				mapping.findForward(Constants.SUCCESS));
	}
	
	public ActionForward emailPriceReportApprovalStatus(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/Report.do");

		IBatch batch = MisldBatchFactory.getPriceReportApprovalStatusBatch(request
				.getRemoteUser());
		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward emailSPLAAccountReport(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user;

		try {
			user = loadUser(request);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/Report.do");

		IBatch batch = MisldBatchFactory.getSPLAAccountReportBatch(request
				.getRemoteUser());
		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward softwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		IBatch batch = MisldBatchFactory
				.getMsInstalledSoftwareBaselineReportBatch(request
						.getRemoteUser(), user.getCustomer());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward hardwareBaseline(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		Customer customer = user.getCustomer();

		IBatch batch = MisldBatchFactory.getMsHardwareBaselineReportBatch(
				request.getRemoteUser(), customer);

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward createSplaMoetReport(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		PriceReportArchive priceReportArchive = (PriceReportArchive) form;

		IBatch batch = MisldBatchFactory.getSplaMoetReportBatch(request
				.getRemoteUser(), priceReportArchive.getSku());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward acceptSplaMoetReport(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		PriceReportArchive priceReportArchive = (PriceReportArchive) form;

		PriceReportDelegate.acceptSplaMoet(priceReportArchive.getSku());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward notify(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		DynaActionForm f = (DynaActionForm) form;
		Customer[] c = (Customer[]) f.get("customer");
				
		PriceReportDelegate.sendNotifications(c, request.getRemoteUser(), null, null, null, Constants.PRICE_REPORT);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward status(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		request.setAttribute("status", BatchReadDelegate.getBatchQueues());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward noOs(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		request.setAttribute("server.list",
				MsInstalledSoftwareBaselineReadDelegate
						.getNoOperatingSystemBaseline());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward missingScan(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getMissingScanReportBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward unlockedReport(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/AdminReport.do");

		IBatch batch = MisldBatchFactory.getUnlockedReportBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward archive(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		PriceReportCycle priceReportCycle = (PriceReportCycle) form;

		Customer customer = CustomerReadDelegate
				.getCustomerByLong(priceReportCycle.getCustomerId().longValue());

		if (customer == null) {
			return mapping.findForward(Constants.ERROR);
		}

		if (priceReportCycle.getPriceReportCycleId().intValue() == 0) {
			return new ForwardParameters().add("customer",
					"" + customer.getCustomerId()).forward(
					mapping.findForward("current"));
		}

		user.setLevelOneOpenLink("/MsWizard/Report.do");
		user.setLevelTwoOpenLink("/MsWizard/ReportPod.do?pod="
				+ customer.getPod().getPodId());

		priceReportCycle = PriceReportDelegate
				.getPriceReportCycle(priceReportCycle.getPriceReportCycleId());
		priceReportCycle.setCustomerId(customer.getCustomerId());
		request.setAttribute("priceReportCycleList", PriceReportDelegate
				.getPriceReportCycles(customer));

		PriceReport priceReport = PriceReportDelegate.getPriceReportArchive(
				priceReportCycle, customer);
		request.setAttribute("priceReportCycle", priceReportCycle);
		request.setAttribute("priceReport", priceReport);

		return mapping.findForward(Constants.SUCCESS);

	}
}