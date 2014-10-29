package com.ibm.ea.bravo.software;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.FormSearch;

public class FormSoftwareSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String accountId;
	private String lparId;
	private String lparName;

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		
		ActionErrors errors = new ActionErrors();
		
		errors = super.validate(mapping, request);

//		if (EaUtils.isBlank(lparId)) {
//			logger.debug("FormSoftwareSearch.validate id = " + lparId);
//			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
//		}

		return errors;
	}
	
	/**
	 * @return Returns the accountId.
	 */
	public String getAccountId() {
		return accountId;
	}
	/**
	 * @param accountId The accountId to set.
	 */
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	/**
	 * @return Returns the lparId.
	 */
	public String getLparId() {
		return lparId;
	}
	/**
	 * @param lparId The lparId to set.
	 */
	public void setLparId(String lparId) {
		this.lparId = lparId;
	}
	/**
	 * @return Returns the lparName.
	 */
	public String getLparName() {
		return lparName;
	}
	/**
	 * @param lparName The lparName to set.
	 */
	public void setLparName(String lparName) {
		this.lparName = lparName;
	}
}
