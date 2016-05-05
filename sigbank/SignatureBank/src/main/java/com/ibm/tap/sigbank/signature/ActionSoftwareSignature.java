package com.ibm.tap.sigbank.signature;

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
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.software.ProductDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionSoftwareSignature extends BaseAction {

	public ActionForward moveSignature(ActionMapping mapping, ActionForm form,
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
			return mapping.findForward(Constants.ERROR);
		}

		// Set the request attributes
		request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
				.getSoftwareSignaturesByProduct(product));

		request.setAttribute("softwares", ProductDelegate.getProductBriefs());

		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.VIEW);
		}

		// Save a token
		saveToken(request);

		return mapping.findForward(Constants.EDIT);
	}

	public ActionForward viewSignature(ActionMapping mapping, ActionForm form,
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
			return mapping.findForward(Constants.ERROR);
		}

		// Set the request attributes
		request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
				.getSoftwareSignaturesByProduct(product));

//		if (!user.isAdminAccess()) {
//		return mapping.findForward(Constants.VIEW);
//	}
		if (!user.isAdminAccess()) {
			return mapping.findForward(Constants.VIEW);
		}

		// Save a token
		saveToken(request);
		return mapping.findForward(Constants.EDIT);
	}

	public ActionForward addSoftwareSignature(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user container
		UserContainer user = loadUser(request);

		// They can only perform if they are an admin
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.ERROR);
		}

		// Save a token
		saveToken(request);

		// Send the user to the form
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSoftwareSignatureSave(ActionMapping mapping,
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
			return mapping.findForward(Constants.SUCCESS);
		}

		// If no software, get out
		if (user.getProduct() == null) {
			return mapping.findForward(Constants.ERROR);
		}

		// Cast the form out of the request
		SoftwareSignatureForm softwareSignatureForm = (SoftwareSignatureForm) form;

		// Try to save the software
		ActionErrors errors = SoftwareSignatureDelegate.addSoftwareSignature(
				softwareSignatureForm, user.getProduct(), request
						.getRemoteUser());

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

	public ActionForward updateSoftwareSignature(ActionMapping mapping,
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
		SoftwareSignatureForm softwareSignatureForm = (SoftwareSignatureForm) request
				.getAttribute("softwareSignatureForm");

		// If the id isn't an integer and the form is null, throw an exception
		// TODO probably need a different type of exception
		if (!Util.isInt(id)) {
			if (softwareSignatureForm == null) {
				throw new InvalidAccessException();
			}
		} else {
			softwareSignatureForm = SoftwareSignatureDelegate.setUpdateForm(id);
		}

		// set the softwareform bean
		request.setAttribute("softwareSignatureForm", softwareSignatureForm);

		// Set up the history list
		request.setAttribute("softwareSignatureHistory",
				SoftwareSignatureDelegate
						.getSoftwareSignatureHistory(softwareSignatureForm
								.getSoftwareSignatureId()));

		// Send to the form
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward updateSoftwareSignatureSave(ActionMapping mapping,
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
		SoftwareSignatureForm softwareSignatureForm = (SoftwareSignatureForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareSignatureDelegate
				.updateSoftwareSignature(softwareSignatureForm, request
						.getRemoteUser());

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

	public ActionForward moveSoftwareSignatureSave(ActionMapping mapping,
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

		// Pull the softwareForm from the request
		SoftwareSignatureForm ssf = (SoftwareSignatureForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareSignatureDelegate.moveSoftwareSignatures(
				ssf, request.getRemoteUser());

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

		SoftwareSignatureForm ssf = (SoftwareSignatureForm) form;

		request.setAttribute(Constants.REPORT, SoftwareSignatureDelegate
				.searchByFileName(ssf.getFileName()));

		// Reset our token
		resetToken(request);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward addSearchSoftwareSignatureSave(ActionMapping mapping,
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
		SoftwareSignatureForm ssf = (SoftwareSignatureForm) form;

		// Try to save the object
		ActionErrors errors = SoftwareSignatureDelegate
		.addSearchSoftwareSignatures(ssf, user.getProduct(), request
						.getRemoteUser());

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
}