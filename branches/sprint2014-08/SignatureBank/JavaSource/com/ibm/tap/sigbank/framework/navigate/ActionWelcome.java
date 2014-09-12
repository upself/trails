package com.ibm.tap.sigbank.framework.navigate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;
import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionWelcome extends BaseAction {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// TODO Instead of needing this in every action we should be able to
		// wire this
		UserContainer user = loadUser(request);

		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		if (user.isAdminAccess()) {
			user.setNewFilters(SoftwareFilterDelegate
					.getNewSoftwareFilterCount());
		}

		// Set the user container in the request
		setUserContainer(request, user);

		// If the user is an admin, then we need to send them to a different
		// page
		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		// Return to a view only page
		return mapping.findForward(Constants.VIEW);
	}

}