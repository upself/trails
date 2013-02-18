package com.ibm.tap.sigbank.software;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.manufacturer.ManufacturerDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;

/**
 * Form bean for a Struts application. Users may access 2 fields on this form:
 * <ul>
 * <li>softwareCategoryId - [your comment here]
 * <li>manufacturerId - [your comment here]
 * </ul>
 * 
 * @@version 1.0
 * @@author
 */
public class SoftwareView extends ActionForm

{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String softwareCategoryId = null;

	private String manufacturerId = null;

	private String search = null;

	private String action = null;

	/**
	 * @@return Returns the action.
	 */
	public String getAction() {
		return action;
	}

	/**
	 * @@param action
	 *            The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}

	/**
	 * @@return Returns the search.
	 */
	public String getSearch() {
		return search;
	}

	/**
	 * @@param search
	 *            The search to set.
	 */
	public void setSearch(String search) {
		this.search = search;
	}

	/**
	 * Get softwareCategoryId
	 * 
	 * @@return String
	 */
	public String getSoftwareCategoryId() {
		return softwareCategoryId;
	}

	/**
	 * Set softwareCategoryId
	 * 
	 * @@param <code>String</code>
	 */
	public void setSoftwareCategoryId(String s) {
		this.softwareCategoryId = s;
	}

	/**
	 * Get manufacturerId
	 * 
	 * @@return String
	 */
	public String getManufacturerId() {
		return manufacturerId;
	}

	/**
	 * Set manufacturerId
	 * 
	 * @@param <code>String</code>
	 */
	public void setManufacturerId(String m) {
		this.manufacturerId = m;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {

		try {
			request.setAttribute(Constants.MANUFACTURERS, ManufacturerDelegate
					.getManufacturers());
			request.setAttribute(Constants.SOFTWARE_CATEGORYS,
					SoftwareCategoryDelegate.getSoftwareCategorys());
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {

		ActionErrors errors = new ActionErrors();

		return errors;

	}
}