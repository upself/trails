package com.ibm.ea.bravo.hardware;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.FormSearch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class FormHardwareSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static final Logger logger = Logger.getLogger(FormHardwareSearch.class);
	
	private String id;

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		
		ActionErrors errors = new ActionErrors();
		
		errors = super.validate(mapping, request);

		// hardware search specifics
		if (! this.type.equalsIgnoreCase(Constants.HOSTNAME_SEARCH) &&
			! this.type.equalsIgnoreCase(Constants.SERIAL_SEARCH)) {
			logger.debug("FormSearchHardware.validate type = " + this.type);
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
		}
		
		if (EaUtils.isBlank(this.id)) {
			logger.debug("FormSearchHardware.validate id = " + this.id);
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
		}

		return errors;
	}
	
	/**
	 * @return Returns the id.
	 */
	public String getId() {
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(String id) {
		this.id = id;
	}
}
