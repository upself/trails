package com.ibm.tap.sigbank.filter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Pagination;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.software.ProductDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionSoftwareFilter extends BaseAction {

	public ActionForward moveFilter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The user must at least be a sigbank user
		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		// Grab the id from the request
		String id = request.getParameter(Constants.ID);
		Product product;

		// If the passed request contains an id, pull the software from the db
		if (id != null) {
			product = ProductDelegate.getProduct(id);
			setProduct(request, product);
		}
		// Pull it from the user container
		else {
			product = getProduct(request);
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		// Set the request attributes
		request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
				.getSoftwareFiltersByProduct(product));

		request.setAttribute("softwares", ProductDelegate.getProducts());

		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.VIEW);
		}

		// Save a token
		saveToken(request);

		return mapping.findForward(Constants.EDIT);
	}

	public ActionForward viewFilter(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The user must at least be a sigbank user
		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		// Grab the id from the request
		String id = request.getParameter(Constants.ID);
		Product product;

		// If the passed request contains an id, pull the software from the db
		if (id != null) {
			product = ProductDelegate.getProduct(id);
			setProduct(request, product);
		}
		// Pull it from the user container
		else {
			product = getProduct(request);
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		// Set the request attributes
		request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
				.getSoftwareFiltersByProduct(product));

		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.VIEW);
		}
		saveToken(request);

		return mapping.findForward(Constants.EDIT);
	}

	public ActionForward moveSoftwareFilterSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Check the token for double submission
		if (!isTokenValid(request)) {
			System.out.println("yo");
			// TODO I need to send this to a page
			return mapping.findForward(Constants.SUCCESS);
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		// Pull the softwareForm from the request
		SoftwareFilterForm sff = (SoftwareFilterForm) form;

		// Try to save the object
		ActionErrors errors = new ActionErrors();

		if (sff.getAction().equals("move")) {
			errors = SoftwareFilterDelegate.moveSoftwareFilters(sff, request
					.getRemoteUser());
		} else if (sff.getAction().equals("map")) {
			errors = SoftwareFilterDelegate.mapSoftwareFilters(sff, request
					.getRemoteUser());
		} else {
			throw new InvalidAccessException();
		}

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Reset our token
		resetToken(request);

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareFilter(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Save a token
		saveToken(request);

		// Pull the software signature id from the request
		String id = request.getParameter(Constants.ID);

		// We pull the form from the request in case we are coming back
		// due to errors in the actual update
		SoftwareFilterForm softwareFilterForm = (SoftwareFilterForm) request
				.getAttribute("softwareFilterForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (softwareFilterForm == null) {
				throw new InvalidAccessException();
			}
		} else {
			softwareFilterForm = SoftwareFilterDelegate.setUpdateForm(id);
		}

		// set the softwareform bean
		request.setAttribute("softwareFilterForm", softwareFilterForm);

		// Set up the history list
		request.setAttribute("softwareFilterHistory", SoftwareFilterDelegate
				.getSoftwareFilterHistory(softwareFilterForm
						.getSoftwareFilterId()));

		// Send to the form
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareFilterSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Check the token for double submission
		if (!isTokenValid(request)) {
			// TODO I need to send this to a page
			return mapping.findForward(Constants.SUCCESS);
		}

		// If cancelled, forward to the software report
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		// Pull the softwareForm from the request
		SoftwareFilterForm softwareFilterForm = (SoftwareFilterForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareFilterDelegate.updateSoftwareFilter(
				softwareFilterForm, request.getRemoteUser());

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Reset our token
		resetToken(request);

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward searchSetup(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.ERROR);
		}

		// Save a token
		saveToken(request);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		SoftwareFilterForm sff = (SoftwareFilterForm) form;

		request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
				.searchByFileNameAndStatus(sff.getSoftwareName(), sff
						.getStatus()));

		// Reset our token
		resetToken(request);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSearchSoftwareFilterSave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		// Pull the softwareForm from the request
		SoftwareFilterForm ssf = (SoftwareFilterForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareFilterDelegate.addSearchSoftwareFilters(
				ssf, user.getProduct(), request.getRemoteUser());

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Reset our token
		resetToken(request);

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward newFilters(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setNewFilters(SoftwareFilterDelegate.getNewSoftwareFilterCount());

		setUserContainer(request, user);

		Pagination pagination = new Pagination(request, new Integer(user
				.getNewFilters().intValue()), 25);

		request.setAttribute(Constants.PAGINATION, pagination);

		request.setAttribute(Constants.REPORT, SoftwareFilterDelegate
				.getNewSoftwareFilters(pagination));

		request.setAttribute("softwares", ProductDelegate.getProducts());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward newFilterSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Pull the softwareForm from the request
		SoftwareFilterForm sff = (SoftwareFilterForm) form;

		// Try to save the object
		ActionErrors errors = new ActionErrors();

		if (sff.getAction().equals("add")) {
			errors = SoftwareFilterDelegate.moveSoftwareFilters(sff, request
					.getRemoteUser());
		} else if (sff.getAction().equals("remove")) {
			errors = SoftwareFilterDelegate.removeNewSoftwareFilters(sff,
					request.getRemoteUser());
		} else {
			throw new InvalidAccessException();
		}

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}
}