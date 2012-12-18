package com.ibm.ea.bravo.hardwaresoftware;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.FormSearch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class FormCompositeSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static final Logger logger = Logger.getLogger(FormCompositeSearch.class);
	
	private String accountId;
	private String status;

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		
		ActionErrors errors = new ActionErrors();
		
		errors = super.validate(mapping, request);

//		// hardware search specifics
//		if (! type.equalsIgnoreCase(Constants.HOSTNAME_SEARCH) &&
//			! type.equalsIgnoreCase(Constants.SERIAL_SEARCH)) {
//			logger.debug("FormCompositeSearch.validate type = " + type);
//			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
//		}
		
		if (EaUtils.isBlank(this.accountId)) {
			logger.debug("FormCompositeSearch.validate id = " + this.accountId);
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
		}

		return errors;
	}
	
	/**
	 * @return Returns the accountId.
	 */
	public String getAccountId() {
		return this.accountId;
	}
	/**
	 * @param accountId The accountId to set.
	 */
	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return this.status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}
