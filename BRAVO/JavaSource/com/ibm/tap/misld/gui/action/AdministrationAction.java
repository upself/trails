package com.ibm.tap.misld.gui.action;

import java.util.List;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;

import com.ibm.batch.IBatch;
import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.batch.MisldBatchFactory;
import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.cndb.PodReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.MisldAccountSettingsWriteDelegate;
import com.ibm.tap.misld.delegate.customerSettings.MisldRegistrationWriteDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.report.PriceReport;
import com.ibm.tap.misld.report.PriceReportDelegate;

/**
 * @version 1.0
 * @author
 */
public class AdministrationAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		Pod podForm = (Pod) form;

		if (podForm.getPodId() != null) {
			Pod pod = PodReadDelegate.getPod(podForm.getPodId());
			user.setPod(pod);
			setUserContainer(request, user);
		} else {
			request.setAttribute("pod", user.getPod());
		}

		List customers = CustomerReadDelegate.getInScopeCustomersByPod(user
				.getPod());
		request.setAttribute(Constants.POD_LIST, PodReadDelegate.getPods());

		request.setAttribute("customer", customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward report(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward adminFunction(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		request.setAttribute("usageDates", PriceReportDelegate
				.getDistinctUsageDates());

		request.setAttribute("moetUsageDates", PriceReportDelegate
				.getAcceptMoetDates());

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward unlock(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		DynaActionForm f = (DynaActionForm) form;
		Customer[] s = (Customer[]) f.get("customer");

		Vector unlockCustomers = new Vector();

		for (int i = 0; i < s.length; i++) {
			if (s[i].getMisldAccountSettings().getStatus().equals(
					Constants.COMPLETE)) {
				unlockCustomers.add(s[i]);
			}
		}

		MisldAccountSettingsWriteDelegate.unlockAccounts(unlockCustomers);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward lock(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		DynaActionForm f = (DynaActionForm) form;
		Customer[] s = (Customer[]) f.get("customer");

		Vector lockCustomers = new Vector();

		for (int i = 0; i < s.length; i++) {
			if (s[i].getMisldAccountSettings().getStatus().equals(
					Constants.LOCKED)) {
				lockCustomers.add(s[i].getCustomerId());
			}
		}

		MisldAccountSettingsWriteDelegate.lockAccounts(lockCustomers);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}
	
	public ActionForward notify(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		DynaActionForm f = (DynaActionForm) form;
		Customer[] s = (Customer[]) f.get("customer");

		for (int i = 0; i < s.length; i++) {
			if (s[i].getMisldAccountSettings().getStatus().equals("send")) {

				IBatch batch = MisldBatchFactory.getMassNotificationBatch(
						request.getRemoteUser(), s[i]);

				if (batch != null) {
					addBatch(batch);
				}
			}

		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward unlockView(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (user.getPod() == null) {
			return mapping.findForward(Constants.NEW);
		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		List customers = CustomerReadDelegate.getInScopeCustomersByPod(user
				.getPod());

		DynaActionForm f = (DynaActionForm) form;
		f.set("customer", (Customer[]) customers.toArray(new Customer[0]));
		request.setAttribute("customer", customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward scan(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (user.getPod() == null) {
			return mapping.findForward(Constants.NEW);
		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		List customers = CustomerReadDelegate.getInScopeCustomersByPodView(user
				.getPod());

		DynaActionForm f = (DynaActionForm) form;
		f.set("customer", (Customer[]) customers.toArray(new Customer[0]));

		request.setAttribute("customer", customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward approvePriceReport(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		PriceReport priceReport = (PriceReport) form;

		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		String lockButton=request.getParameter("Lock");
		String approveButton=request.getParameter("Approve");
		String rejectButton=request.getParameter("Reject");
		
		if (lockButton != null) {
			PriceReportDelegate.lockAccount(priceReport, request.getRemoteUser(), user);
		}		
		if (approveButton != null) {
			PriceReportDelegate.approvePriceReport(priceReport, request.getRemoteUser());
		}
		if (rejectButton != null) {
			PriceReportDelegate.updatePriceReportStatus(priceReport, Constants.REJECTED, request.getRemoteUser());
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward savePoInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAsset()) {
			return mapping.findForward(Constants.ACCESS);
		}

		PriceReport priceReport = (PriceReport) form;

		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		PriceReportDelegate.updatePriceReportArchivePO(priceReport, request
				.getRemoteUser());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward lockAll(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		IBatch batch = MisldBatchFactory.getMassPriceReportArchiveBatch(request
				.getRemoteUser());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward unlockAll(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		Vector customers = CustomerReadDelegate.getLockedCustomers();

		MisldAccountSettingsWriteDelegate.unlockAccounts(customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward registrationLock(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		if (user.getPod() == null) {
			return mapping.findForward(Constants.NEW);
		}

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		List customers = CustomerReadDelegate.getInScopeCustomersByPod(user
				.getPod());

		DynaActionForm f = (DynaActionForm) form;
		f.set("customer", (Customer[]) customers.toArray(new Customer[0]));
		request.setAttribute("customer", customers);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward lockRegistration(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.ACCESS);
		}

		DynaActionForm f = (DynaActionForm) form;
		Customer[] s = (Customer[]) f.get("customer");

		Vector lockCustomers = new Vector();
		Vector unlockCustomers = new Vector();

		for (int i = 0; i < s.length; i++) {
			if (s[i].getMisldRegistration().getStatus()
					.equals(Constants.LOCKED)) {
				lockCustomers.add(s[i]);
			} else {
				unlockCustomers.add(s[i]);
			}
		}

		MisldRegistrationWriteDelegate.lockAccountRegistration(unlockCustomers,
				lockCustomers);

		user.setLevelOneOpenLink("/MsWizard/AdminPod.do");

		return mapping.findForward(Constants.SUCCESS);
	}
}