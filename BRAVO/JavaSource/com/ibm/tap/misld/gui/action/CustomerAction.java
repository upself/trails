package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentLetterReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.CustomerAgreementReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.ApplicationException;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.framework.exceptions.InvalidParameterException;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @version 1.0
 * @author
 */
public class CustomerAction extends BaseAction

{
	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		String customerIdStr = request.getParameter("customer");

		if (customerIdStr == null) {
			throw new InvalidParameterException();
		}

		long customerId;
		try {
			customerId = new Long(customerIdStr).longValue();
		} catch (Exception e) {
			throw new InvalidParameterException();
		}

		Customer customer = CustomerReadDelegate.getCustomerByLong(customerId);

		if (customer == null) {
			throw new ApplicationException();
		}

		setCustomer(request, customer);

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod=" + customer.getPod().getPodId());

		request.setAttribute(Constants.CUSTOMER_AGREEMENT_LIST,
				CustomerAgreementReadDelegate
						.getCustomerAgreementsByCustomer(user.getCustomer()));

		request.setAttribute(Constants.CONSENT_LIST, ConsentLetterReadDelegate
				.getConsentLettersByCustomer(user.getCustomer()));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward profile(ActionMapping mapping, ActionForm form,
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
		user.setLevelTwoOpenLink("/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		request.setAttribute(Constants.CUSTOMER_AGREEMENT_LIST,
				CustomerAgreementReadDelegate
						.getCustomerAgreementsByCustomer(user.getCustomer()));

		request.setAttribute(Constants.CONSENT_LIST, ConsentLetterReadDelegate
				.getConsentLettersByCustomer(user.getCustomer()));

		return mapping.findForward(Constants.SUCCESS);
	}
}