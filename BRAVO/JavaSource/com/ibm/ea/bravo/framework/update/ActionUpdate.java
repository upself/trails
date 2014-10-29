package com.ibm.ea.bravo.framework.update;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionUpdate extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionUpdate.class);

	
    public ActionForward update(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	
    	logger.debug("ActionSearch.search");
    	
    	// cast the form
    	FormUpdate updateForm = (FormUpdate) form;
    	
    	// validate the form
    	ActionErrors errors = updateForm.validate(mapping, request);
    	if (! errors.isEmpty()) {
    		logger.debug("ActionSearch.search Errors: " + errors);
    		saveErrors(request, errors);
	    	return mapping.findForward(Constants.ERROR);
    	}
    	
    	logger.debug("ActionUpdate.update Source = " + updateForm.getSource());
       	logger.debug("ActionUpdate.update type = " + updateForm.getType());
           	
    	// setup form to pass and forward to the right delegate
    	request.setAttribute(Constants.UPDATE, updateForm);

    	// forward to the right delegate
    	if (updateForm.getType().equalsIgnoreCase(Constants.UPDATE) && 
    			updateForm.getSource().equalsIgnoreCase(Constants.MACHINETYPE))
    		return mapping.findForward(Constants.ACCOUNT);
        
    	
    	return mapping.findForward(Constants.ERROR);
    }
}
