package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.ibm.tap.misld.delegate.cndb.CustomerReadDelegate;
import com.ibm.tap.misld.delegate.cndb.LpidReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentLetterReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.CustomerAgreementReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.CustomerAgreementTypeReadDelegate;
import com.ibm.tap.misld.delegate.customerSettings.MisldAccountSettingsWriteDelegate;
import com.ibm.tap.misld.delegate.qualifiedDiscount.QualifiedDiscountReadDelegate;
import com.ibm.tap.misld.framework.CommandBaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;

/**
 * @version 1.0
 * @author
 */
public class CustomerSettingsAction extends CommandBaseAction

{
	public ActionForward unspecified(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		if (isCancelled(request)) {
			return mapping.findForward(Constants.CANCEL);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		if (user.getCustomer().getMisldAccountSettings() != null) {

			user.getCustomer().getMisldAccountSettings()
					.setQualifiedDiscountLong(
							user.getCustomer().getMisldAccountSettings()
									.getQualifiedDiscount()
									.getQualifiedDiscountId());
			request.setAttribute("misldAccountSettings", user.getCustomer()
					.getMisldAccountSettings());
			try {
					user.getCustomer().getMisldAccountSettings()
							.setDefaultLpidLong(user.getCustomer().getMisldAccountSettings().getDefaultLpid().getLpidId());
			} catch (Exception e) {
				//continue
				System.out.println("catch block");
			}
		}

		request.setAttribute("lpids", LpidReadDelegate.getLpidMajorHash(user
				.getCustomer()));
		request.setAttribute("qualifiedDiscount.list",
				QualifiedDiscountReadDelegate.getQualifiedDiscounts());
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward next(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
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

		setAccountSettingsForm(request, null);

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute("qualifiedDiscount.list",
					QualifiedDiscountReadDelegate.getQualifiedDiscounts());

			request.setAttribute("lpids", LpidReadDelegate
					.getLpidMajorHash(user.getCustomer()));

			return new ActionForward(mapping.getInput());
		}

		MisldAccountSettings misldAccountSettings = (MisldAccountSettings) form;

		if (misldAccountSettings.getMicrosoftSoftwareOwner().equals("IBM")) {

			MisldAccountSettingsWriteDelegate.saveMisldAccountSettings(
					misldAccountSettings, user.getCustomer(), request
							.getRemoteUser());

			Customer customer = CustomerReadDelegate.getCustomerByLong(user
					.getCustomer().getCustomerId().longValue());

			if (customer == null) {
				return mapping.findForward(Constants.ERROR);
			}

			setCustomer(request, customer);

			return mapping.findForward(Constants.SUCCESS);
		}

		setAccountSettingsForm(request, misldAccountSettings);

		request.setAttribute(Constants.AGREEMENT_TYPE_LIST,
				CustomerAgreementTypeReadDelegate.getCustomerAgreementTypes());

		return mapping.findForward(Constants.NEXT);
	}

	public ActionForward draft(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
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

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute("qualifiedDiscount.list",
					QualifiedDiscountReadDelegate.getQualifiedDiscounts());

			request.setAttribute("lpids", LpidReadDelegate
					.getLpidMajorHash(user.getCustomer()));

			return new ActionForward(mapping.getInput());
		}

		MisldAccountSettings misldAccountSettings = (MisldAccountSettings) form;

		MisldAccountSettingsWriteDelegate.saveDraftMisldAccountSettings(
				misldAccountSettings, user.getCustomer(), request
						.getRemoteUser());

		Customer customer = CustomerReadDelegate.getCustomerByLong(user
				.getCustomer().getCustomerId().longValue());

		if (customer == null) {
			return mapping.findForward(Constants.ERROR);
		}

		setCustomer(request, customer);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveFinal(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
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

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		MisldAccountSettings misldAccountSettings = (MisldAccountSettings) form;

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (misldAccountSettings.getCustomerAgreementLongs().length == 0) {
			ActionMessages messages = new ActionMessages();
			messages.add("errors.required", new ActionMessage(
					"errors.required", "Customer agreement"));
			errors.add(messages);
		}

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute(Constants.AGREEMENT_TYPE_LIST,
					CustomerAgreementTypeReadDelegate
							.getCustomerAgreementTypes());

			return new ActionForward(mapping.getInput());
		}

		MisldAccountSettingsWriteDelegate.saveFinalMisldAccountSettings(
				misldAccountSettings, user.getAccountSettingsForm(), user
						.getCustomer(), request.getRemoteUser());

		Customer customer = CustomerReadDelegate.getCustomerByLong(user
				.getCustomer().getCustomerId().longValue());

		if (customer == null) {
			return mapping.findForward(Constants.ERROR);
		}

		setAccountSettingsForm(request, null);
		setCustomer(request, customer);

		request.setAttribute(Constants.CUSTOMER_AGREEMENT_LIST,
				CustomerAgreementReadDelegate
						.getCustomerAgreementsByCustomer(customer));

		request.setAttribute(Constants.CONSENT_LIST, ConsentLetterReadDelegate
				.getConsentLettersByCustomer(customer));

		return mapping.findForward(Constants.SUCCESS);
	}
}