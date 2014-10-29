package com.ibm.ea.bravo.account;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.FormSearch;

public class FormAccountSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(FormAccountSearch.class);
	
	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {

		logger.debug("FormSearchAccount.validate");
		
		ActionErrors errors = super.validate(mapping, request);
		
//		logger.debug("FormSearchAccount type = " + type);
//		// account search specifics
//		if (! type.equalsIgnoreCase(Constants.SEARCH_ACCOUNT_NAME) &&
//			! type.equalsIgnoreCase(Constants.SEARCH_ACCOUNT_NUMBER)) {
//			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
//		}
		
		return errors;
	}
}
