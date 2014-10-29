package com.ibm.tap.misld.gui.action;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;

import com.ibm.tap.misld.delegate.consent.ConsentLetterReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentLetterWriteDelegate;
import com.ibm.tap.misld.delegate.priceLevel.PriceLevelReadDelegate;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.om.consent.ConsentLetter;
import com.ibm.tap.misld.om.priceLevel.PriceLevel;

/**
 * @version 1.0
 * @author
 */
public class ConsentLetterAction extends BaseAction

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

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		request.setAttribute(Constants.CONSENT_LIST, ConsentLetterReadDelegate
				.getConsentLettersByCustomer(user.getCustomer()));

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward question(ActionMapping mapping, ActionForm form,
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

		Long consentLetterId;
		String consentLetterIdStr = request.getParameter("consentLetter");

		if (consentLetterIdStr == null) {
			return mapping.findForward(Constants.ERROR);
		}

		try {
			consentLetterId = new Long(consentLetterIdStr);
		} catch (Exception e) {
			return mapping.findForward(Constants.ERROR);
		}

		ConsentLetter consentLetter = ConsentLetterReadDelegate
				.getConsentLetterByLong(consentLetterId.longValue());

		if (consentLetter == null) {
			return mapping.findForward(Constants.ERROR);
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		request.setAttribute("consentLetter", consentLetter);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward saveConsentLetter(ActionMapping mapping,
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
					Constants.LOCKED)
					|| user.getCustomer().getMisldAccountSettings().getStatus()
							.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		ConsentLetter consentLetterForm = (ConsentLetter) form;

		ConsentLetter consentLetter = ConsentLetterReadDelegate
				.getConsentLetterByLong(consentLetterForm.getConsentLetterId()
						.longValue());

		PriceLevel priceLevel = PriceLevelReadDelegate
				.getPriceLevelByName(consentLetterForm.getPriceLevelValue());

		consentLetter.setPriceLevel(priceLevel);

		if (consentLetter == null) {
			return mapping.findForward(Constants.ERROR);
		}

		ActionErrors errors = new ActionErrors();
		errors = form.validate(mapping, request);

		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			request.setAttribute("consentLetter", consentLetter);

			return new ActionForward(mapping.getInput());
		}

		ConsentLetterWriteDelegate.saveConsentLetterQuestion(consentLetter,
				consentLetterForm, user.getCustomer(), request.getRemoteUser());

		return mapping.findForward(Constants.SUCCESS);
	}
}