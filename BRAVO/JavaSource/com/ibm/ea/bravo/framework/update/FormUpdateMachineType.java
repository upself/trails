package com.ibm.ea.bravo.framework.update;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.framework.common.Constants;

public class FormUpdateMachineType extends FormUpdate {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(FormUpdateMachineType.class);

	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {

		logger.debug("FormUpdateMachineType.validate");

		ActionErrors errors = super.validate(mapping, request);
		
		logger.debug("FormUpdateMachineType.validate errors= " + errors);

		logger.debug("FormUpdateMachineType.validate type=" + this.type);

		// account search specifics
		if (this.type.equalsIgnoreCase(Constants.UPDATE)){
		}else{
			logger.debug("FormUpdateMachineType.validate type=" + this.type);
			errors.add(Constants.UPDATE, new ActionMessage(Constants.UNKNOWN_ERROR));
		}

		logger.debug("FormUpdateMachineType.validate errors=" + errors);

		return errors;
	}
}
