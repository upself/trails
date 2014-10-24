package com.ibm.tap.sigbank.softwarecategory;

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
import com.ibm.tap.sigbank.framework.navigate.SearchForm;
import com.ibm.tap.sigbank.software.ProductDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionSoftwareCategory extends BaseAction {

	public ActionForward softwareCategory(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		request.setAttribute(Constants.REPORT, SoftwareCategoryDelegate
				.getSoftwareCategorys());

		user.setLevelOneOpenLink(NavigationController.softwareCategoryLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward software(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);

		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String id = request.getParameter("id");

		SearchForm sf = (SearchForm) form;
		if (sf == null) {
			sf = new SearchForm();
		}
		sf.setSoftwareCategoryId(id);
		sf.setManufacturerId("");
		sf.setSoftwareName("");

		user.setLevelOneOpenLink(NavigationController.softwareCategoryLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward softwareCategoryHistoryPopUp(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String id = request.getParameter("id");

		request.setAttribute(Constants.REPORT, SoftwareCategoryDelegate
				.getSoftwareCategoryHistory(id));

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftwareCategory(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Save a token
		saveToken(request);

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftwareCategorySave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If cancelled, forward to the software report
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		// Check the token for double submission
		if (!isTokenValid(request)) {
			throw new InvalidAccessException();
		}

		// Cast the form out of the request
		SoftwareCategoryForm scf = (SoftwareCategoryForm) form;

		// Try to save the software
		ActionErrors errors = SoftwareCategoryDelegate.addSoftwareCategory(scf,
				request.getRemoteUser());

		// If we have errors, redirect them to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.getInputForward();
		}

		// Reset our token
		resetToken(request);

		// Forward them to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareCategory(ActionMapping mapping,
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

		// Pull the software id from the request
		String id = request.getParameter(Constants.ID);

		// We pull the form from the request in case we are coming back
		// due to errors in the actual update
		SoftwareCategoryForm softwareCategoryForm = (SoftwareCategoryForm) request
				.getAttribute("softwareCategoryForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (softwareCategoryForm == null) {
				throw new InvalidAccessException();
			}
		}
		// update the software form from the id
		else {
			softwareCategoryForm = SoftwareCategoryDelegate.setUpdateForm(id);
		}

		// set the softwareform bean
		request.setAttribute("softwareCategoryForm", softwareCategoryForm);

		// Set up the history list
		request.setAttribute("softwareCategoryHistory",
				SoftwareCategoryDelegate
						.getSoftwareCategoryHistory(softwareCategoryForm
								.getSoftwareCategoryId()));

		// Send to the form
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareCategorySave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They must be an admin to execute
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If cancelled send them back to the software report
		if (isCancelled(request)) {
			return mapping.findForward(Constants.SUCCESS);
		}

		// Check the token for double submission
		if (!isTokenValid(request)) {
			// TODO I need to send this to a page
			return mapping.findForward(Constants.SUCCESS);
		}

		// Pull the softwareForm from the request
		SoftwareCategoryForm softwareCategoryForm = (SoftwareCategoryForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareCategoryDelegate.updateSoftwareCategory(
				softwareCategoryForm, request.getRemoteUser());

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

	public ActionForward moveSoftware(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Save a token
		saveToken(request);

		String id = request.getParameter(Constants.ID);
		SoftwareCategory softwareCategory;

		if (id != null) {
			softwareCategory = SoftwareCategoryDelegate.getSoftwareCategory(id);
			setSoftwareCategory(request, softwareCategory);
		} else {
			softwareCategory = getSoftwareCategory(request);
		}

		request.setAttribute(Constants.PRODUCTS, ProductDelegate
				.getProducts(softwareCategory));

		request.setAttribute(Constants.SOFTWARE_CATEGORYS,
				SoftwareCategoryDelegate.getSoftwareCategories());

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftware(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Save a token
		saveToken(request);

		String id = request.getParameter(Constants.ID);
		SoftwareCategory softwareCategory;

		if (id != null) {
			softwareCategory = SoftwareCategoryDelegate.getSoftwareCategory(id);
			setSoftwareCategory(request, softwareCategory);
		} else {
			softwareCategory = getSoftwareCategory(request);
		}

		return mapping.findForward(Constants.SUCCESS);
	}
}