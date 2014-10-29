package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.MisldRegistrationWriteDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.ApplicationException;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldRegistration;

/**
 * @version 1.0
 * @author
 */
public class CustomerRegistrationAction extends BaseAction

{
	public ActionForward registration(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

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

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward destroy(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

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

		MisldRegistrationWriteDelegate.destroyCustomer(user.getCustomer());

		Customer customer = CustomerReadDelegate.getCustomerByLong(user
				.getCustomer().getCustomerId().longValue());

		setCustomer(request, customer);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveCustomerRegistration(ActionMapping mapping,
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

		if (isCancelled(request)) {
			return mapping.findForward(Constants.CANCEL);
		}

		if (user.getCustomer().getMisldRegistration() != null) {
			if (user.getCustomer().getMisldRegistration().getStatus().equals(
					Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}
		
		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}

		MisldRegistration misldRegistration = (MisldRegistration) form;

		MisldRegistrationWriteDelegate.saveMisldRegistration(misldRegistration,
				user.getCustomer(), request.getRemoteUser());

		Customer customer = CustomerReadDelegate.getCustomerByLong(user
				.getCustomer().getCustomerId().longValue());

		if (customer == null) {
			throw new ApplicationException();
		}

		setCustomer(request, customer);

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		if (misldRegistration.isInScope()) {
			return mapping.findForward(Constants.SETTINGS);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateRegistration(ActionMapping mapping,
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

		request.setAttribute("misldRegistration", user.getCustomer()
				.getMisldRegistration());

		return mapping.findForward(Constants.SUCCESS);
	}
}