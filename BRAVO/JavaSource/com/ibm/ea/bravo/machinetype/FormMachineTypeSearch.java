package com.ibm.ea.bravo.machinetype;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.FormSearch;
import com.ibm.ea.bravo.framework.common.Constants;

public class FormMachineTypeSearch extends FormSearch {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(FormMachineTypeSearch.class);

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {

		logger.debug("FormSearchMachineType.validate");

		ActionErrors errors = super.validate(mapping, request);
		
		logger.debug("FormSearchMachineType.validate errors= " + errors);

		logger.debug("FormSearchMachineType.validate type=" + type);

		// MachineType Search specifics
		if (type.equalsIgnoreCase(Constants.NAME_SEARCH) || 
			type.equalsIgnoreCase(Constants.TYPE_SEARCH) || 
			type.equalsIgnoreCase(Constants.DEFINITION_SEARCH)){
		}else{
			logger.debug("FormSearchMachineType.validate type=" + type);
			errors.add(Constants.SEARCH, new ActionMessage(Constants.UNKNOWN_ERROR));
		}

		logger.debug("FormSearchMachineType.validate errors=" + errors);

		return errors;
	}
}
