package com.ibm.ea.bravo;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.utils.EaUtils;

public class FormSearch extends FormBase {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(FormSearch.class);

	protected String search;
	protected String context;
	protected String type;
	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		logger.debug("FormSearch.validate");
		
		ActionErrors errors = new ActionErrors();
		
		// cleanup search string, context and type
		if (this.search != null)
			this.search = this.search.trim();
		
		if (this.context != null)
			this.context = this.context.trim();

		if (this.type != null)
			this.type = this.type.trim();
		logger.debug("FormSearch.validate search, context and type: " + this.search + ", " + this.context + ", " + this.type);
		
		// search string is required
		if (EaUtils.isBlank(this.search)) {
			errors.add(Constants.SEARCH, new ActionMessage(Constants.REQUIRED));
			return errors;
		}
		
		// search can't equal %, %%, etc
		if (this.search.matches(Constants.INVALID_SEARCH_REGEX)) {
			errors.add(Constants.SEARCH, new ActionMessage(Constants.INVALID));
			return errors;
		}
		
		// type should be set by the submission, but its required
		if (EaUtils.isBlank(this.type)) {
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
			return errors;			
		}
		
		// type should be set by the submission, but its required
		if (EaUtils.isBlank(this.context)) {
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
			return errors;			
		}
		
		return errors;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
	}

	/**
	 * @return Returns the context.
	 */
	public String getContext() {
		return this.context;
	}
	/**
	 * @param context The context to set.
	 */
	public void setContext(String context) {
		this.context = context;
	}
	/**
	 * @return Returns the search.
	 */
	public String getSearch() {
		return this.search;
	}
	/**
	 * @param search The search to set.
	 */
	public void setSearch(String search) {
		this.search = search;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return this.type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
}
