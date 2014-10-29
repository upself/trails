package com.ibm.ea.bravo.contact;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.FormSearch;
import com.ibm.ea.bravo.framework.common.Constants;

public class FormBluePagesSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(FormBluePagesSearch.class);

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {

		logger.debug("FormBluePagesSearch.validate");

		ActionErrors errors = super.validate(mapping, request);
		
		logger.debug("FormBluePagesSearch.validate errors= " + errors);

		logger.debug("FormBluePagesSearch.validate type=" + this.type);

		// FormBluePagesSearch Search specifics
		if (this.type.equalsIgnoreCase(Constants.SEARCH) && (this.context.equalsIgnoreCase(Constants.INTERNET) || 
			this.context.equalsIgnoreCase(Constants.NAME) || this.context.equalsIgnoreCase(Constants.SERIAL))){
		}else{
			logger.debug("FormBluePagesSearch.validate type=" + this.type);
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
		}

		logger.debug("FormBluePagesSearch.validate errors=" + errors);

		return errors;
	}
}
