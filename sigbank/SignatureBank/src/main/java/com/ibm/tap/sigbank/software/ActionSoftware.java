package com.ibm.tap.sigbank.software;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.hibernate.HibernateException;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.framework.navigate.NavigationController;
import com.ibm.tap.sigbank.framework.navigate.SearchForm;
import com.ibm.tap.sigbank.manufacturer.ManufacturerDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionSoftware extends BaseAction {
	static Logger logger = Logger.getLogger(ActionSoftware.class);

	public ActionForward software(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		user.setLevelOneOpenLink(NavigationController.softwareLink);

		// The can only perform if they are an admin
		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		// Forward them to the form jsp
		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward softwareHistoryPopUp(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String softwareId = request.getParameter("id");

		request.setAttribute(Constants.REPORT, SoftwareDelegate
				.getSoftwareHistory(softwareId));

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftware(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Save a token
		saveToken(request);

		// Set up the drop downs
		setDropDowns(request);

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftwareSave(ActionMapping mapping,
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
		SoftwareForm softwareForm = (SoftwareForm) form;

		// Try to save the software
		ActionErrors errors = SoftwareDelegate.addSoftware(softwareForm,
				request.getRemoteUser());

		// If we have errors, redirect them to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Reset our token
		resetToken(request);

		// TODO lets see if we can get rid of this
		if (user.getFrom() != null) {
			if (user.getFrom().equals(Constants.SOFTWARE_FILTER_BEAN)) {
				return mapping.findForward(Constants.SOFTWARE_FILTER_BEAN);
			}
		}

		// Forward them to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftware(ActionMapping mapping, ActionForm form,
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

		// Pull the software id from the request
		String id = request.getParameter(Constants.ID);

		// We pull the form from the request in case we are coming back
		// due to errors in the actual update
		SoftwareForm softwareForm = (SoftwareForm) request
				.getAttribute("softwareForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (softwareForm == null) {
				throw new InvalidAccessException();
			}
		}
		// update the software form from the id
		else {
			softwareForm = SoftwareDelegate.setUpdateForm(id);
		}

		// Set the drop downs
		setDropDowns(request);

		// set the softwareform bean
		request.setAttribute("softwareForm", softwareForm);

		// Set up the history list
		request.setAttribute("softwareHistory", SoftwareDelegate
				.getSoftwareHistory(softwareForm.getSoftwareId()));

		// Send to the form
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareSave(ActionMapping mapping,
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
		SoftwareForm softwareForm = (SoftwareForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareDelegate.updateSoftware(softwareForm,
				request.getRemoteUser());

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.findForward(Constants.ERROR);
		}

		// Reset our token
		resetToken(request);

		// TODO lets see if we can get rid of this
		if (user.getFrom() != null) {
			if (user.getFrom().equals(Constants.SOFTWARE_FILTER_BEAN)) {
				return mapping.findForward(Constants.SOFTWARE_FILTER_BEAN);
			}
		}

		// Send them back to the software report
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareManufacturerSave(ActionMapping mapping,
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

		// Pull the softwareForm from the request
		SoftwareForm softwareForm = (SoftwareForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareDelegate.updateSoftwareManufacturer(
				softwareForm, request.getRemoteUser());

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

	public ActionForward addSoftwareManufacturerSave(ActionMapping mapping,
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

		// Pull the softwareForm from the request
		SoftwareForm softwareForm = (SoftwareForm) form;

		ActionErrors errors = new ActionErrors();
		errors = softwareForm.validate(mapping, request);
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);
			SearchForm ssf = new SearchForm();
			ssf.setSoftwareName(softwareForm.getSoftwareName());
			request.setAttribute("softwareSearchForm", ssf);
			return mapping.findForward(Constants.ERROR);
		}

		// Try to save the object
		errors = SoftwareDelegate.updateSoftwareManufacturer(softwareForm,
				request.getRemoteUser());

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

	public ActionForward updateSoftwareSoftwareCategorySave(
			ActionMapping mapping, ActionForm form, HttpServletRequest request,
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

		// Pull the softwareForm from the request
		SoftwareForm softwareForm = (SoftwareForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareDelegate.updateSoftwareSoftwareCategory(
				softwareForm, request.getRemoteUser());

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

	public ActionForward addSoftwareSoftwareCategorySave(ActionMapping mapping,
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

		// Pull the softwareForm from the request
		SoftwareForm softwareForm = (SoftwareForm) form;

		ActionErrors errors = new ActionErrors();
		errors = softwareForm.validate(mapping, request);
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);
			SearchForm ssf = new SearchForm();
			ssf.setSoftwareName(softwareForm.getSoftwareName());
			request.setAttribute("softwareSearchForm", ssf);
			return mapping.findForward(Constants.ERROR);
		}

		// Try to save the object
		errors = SoftwareDelegate.updateSoftwareSoftwareCategory(softwareForm,
				request.getRemoteUser());

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

	public ActionForward changeSoftwarePriority(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		String id = request.getParameter("id");
		if (Util.isBlankString(id)) {
			id = request.getParameter("softwareId");
		}

		SoftwareForm sf = SoftwareDelegate.setUpdateForm(id);

		request.setAttribute("softwareForm", sf);
		request.setAttribute(Constants.SOFTWARES, SoftwareDelegate
				.getSoftwares(user.getSoftwareCategory()));

		user.setLevelOneOpenLink(NavigationController.softwareCategoryLink);

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward changeSoftwarePrioritySave(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// The can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		SoftwareForm sf = (SoftwareForm) form;

		SoftwareDelegate.changeSoftwarePriority(sf, request.getRemoteUser());

		// Forward them to the form jsp
		return mapping.findForward(Constants.SUCCESS);
	}

	private void setDropDowns(HttpServletRequest request)
			throws HibernateException, NamingException {

		request.setAttribute(Constants.MANUFACTURERS, ManufacturerDelegate
				.getManufacturers());

		request.setAttribute(Constants.SOFTWARE_CATEGORYS,
				SoftwareCategoryDelegate.getSoftwareCategorys());
	}
}