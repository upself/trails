package com.ibm.tap.sigbank.bankaccount;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.framework.navigate.NavigationController;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @version 1.0
 * @author
 */
public class ActionBankAccount extends BaseAction {

	public ActionForward bankAccount(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);

		return mapping.findForward(Constants.GLOBAL_HOME);
	}

	public ActionForward connected(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		request.setAttribute(Constants.REPORT, BankAccountDelegate
				.getBankAccounts(Constants.CONNECTED));

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.connectedLink);

		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward addConnected(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.connectedLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addConnectedSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If canceled send back to the bank account page
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		BankAccountForm baf = (BankAccountForm) form;

		ActionErrors errors;
		errors = BankAccountDelegate.addConnected(baf, request.getRemoteUser());

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.connectedLink);

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateConnected(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If canceled send back to the bank account page
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		String id = request.getParameter("id");

		// We pull the form from the request in case we are coming back
		// due to errors in the actual update
		BankAccountForm baf = (BankAccountForm) request
				.getAttribute("bankAccountForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (baf == null) {
				throw new InvalidAccessException();
			}
		} else {
			baf = BankAccountDelegate.setUpdateForm(id);
		}

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.connectedLink);

		request.setAttribute("bankAccountForm", baf);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateConnectedSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If canceled send back to the bank account page
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		// Pull the softwareForm from the request
		BankAccountForm baf = (BankAccountForm) form;

		// Try to save the object
		ActionErrors errors = BankAccountDelegate.updateConnectedBankAccount(
				baf, request.getRemoteUser());

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.connectedLink);

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward disconnected(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		request.setAttribute(Constants.REPORT, BankAccountDelegate
				.getBankAccounts(Constants.DISCONNECTED));

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.disconnectedLink);

		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward addDisconnected(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.disconnectedLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addDisconnectedSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If canceled send back to the bank account page
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		BankAccountForm baf = (BankAccountForm) form;

		ActionErrors errors;
		errors = BankAccountDelegate.addDisconnected(baf, request
				.getRemoteUser());

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.disconnectedLink);

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateDisconnected(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String id = request.getParameter("id");

		// We pull the form from the request in case we are coming back
		// due to errors in the actual update
		BankAccountForm baf = (BankAccountForm) request
				.getAttribute("bankAccountForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (baf == null) {
				throw new InvalidAccessException();
			}
		} else {
			baf = BankAccountDelegate.setUpdateForm(id);
		}

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.disconnectedLink);

		request.setAttribute("bankAccountForm", baf);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateDisconnectedSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If canceled send back to the bank account page
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		// Pull the softwareForm from the request
		BankAccountForm baf = (BankAccountForm) form;

		// Try to save the object
		ActionErrors errors = BankAccountDelegate
				.updateDisconnectedBankAccount(baf, request.getRemoteUser());

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);
		user.setLevelTwoOpenLink(NavigationController.disconnectedLink);

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward statusDetail(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String id = request.getParameter("id");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			throw new InvalidAccessException();
		}

		BankAccount ba = BankAccountDelegate.getBankAccount(id);

		request.setAttribute("bankAccount", ba);

		user.setLevelOneOpenLink(NavigationController.bankAccountLink);

		return mapping.findForward(Constants.SUCCESS);
	}
}