package com.ibm.tap.sigbank.framework.navigate;

import java.util.List;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.hibernate.HibernateException;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.manufacturer.ManufacturerDelegate;
import com.ibm.tap.sigbank.software.ProductDelegate;
import com.ibm.tap.sigbank.software.SoftwareForm;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@version 1.0
 * @@author
 */
public class ActionSearch extends BaseAction {

	public ActionForward softwareSearchSetup(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user
		UserContainer user = loadUser(request);

		// User must be a sigbank user
		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		setDropDowns(request);

		user.setLevelOneOpenLink(NavigationController.softwareLink);

		// Return to a view only page
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward searchSoftware(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// Load the user
		UserContainer user = loadUser(request);

		// User must be a sigbank user
		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		// Pull the form
		SearchForm ssf = (SearchForm) form;

		String softwareName = ssf.getSoftwareName();

		request.setAttribute(Constants.REPORT, ProductDelegate
				.searchProductByName(softwareName.toUpperCase()));

		setDropDowns(request);

		user.setLevelOneOpenLink(NavigationController.softwareLink);

		// If the user is an admin, then we need to send them to a different
		// page
		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		// Return to a view only page
		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward searchRefineSoftware(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user
		UserContainer user = loadUser(request);

		// User must be a sigbank user
		if (!user.isSigBankUser()) {
			throw new InvalidAccessException();
		}

		// Pull the form
		SearchForm ssf = (SearchForm) form;

		ActionErrors errors = ProductDelegate.validateSoftwareSearch(ssf);

		// If there are errors send them back to the form and display errors
		if (!errors.isEmpty()) {
			saveErrors(request, (ActionMessages) errors);

			return mapping.getInputForward();
		}

		List product = ProductDelegate.getProductSearchResults(ssf);

		request.setAttribute(Constants.REPORT, product);

		setDropDowns(request);

		user.setLevelOneOpenLink(NavigationController.softwareLink);

		// If the user is an admin, then we need to send them to a different
		// page
		if (user.isAdminAccess()) {
			return mapping.findForward(Constants.EDIT);
		}

		// Return to a view only page
		return mapping.findForward(Constants.VIEW);
	}

	public ActionForward manufacturerSwSearch(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user
		UserContainer user = loadUser(request);

		// User must be a sigbank user
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Pull the form
		SearchForm ssf = (SearchForm) form;

		String softwareName = ssf.getSoftwareName();

		request.setAttribute(Constants.REPORT, ProductDelegate
				.searchProductByName(softwareName.toUpperCase()));

		SoftwareForm sf = new SoftwareForm();
		sf.setManufacturer(user.getManufacturer().getManufacturerId()
				.toString());
		sf.setSoftwareName(softwareName);
		request.setAttribute("softwareForm", sf);

		user.setLevelOneOpenLink(NavigationController.manufacturerLink);

		// Return to a view only page
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward softwareCategorySwSearch(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		// Load the user
		UserContainer user = loadUser(request);

		// User must be a sigbank user
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Pull the form
		SearchForm ssf = (SearchForm) form;

		String softwareName = ssf.getSoftwareName();

		request.setAttribute(Constants.REPORT, ProductDelegate
				.searchProductByName(softwareName.toUpperCase()));

		SoftwareForm sf = new SoftwareForm();
		sf.setSoftwareCategory(user.getSoftwareCategory()
				.getSoftwareCategoryId().toString());
		sf.setSoftwareName(softwareName);
		request.setAttribute("softwareForm", sf);

		user.setLevelOneOpenLink(NavigationController.softwareCategoryLink);

		// Return to a view only page
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