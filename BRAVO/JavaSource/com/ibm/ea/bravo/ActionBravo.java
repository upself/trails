package com.ibm.ea.bravo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionBravo extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionBravo.class);

    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionBravo.home");

        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward invalid(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionBravo.invalid");
    	
    	return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward search(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionBravo.search");
    	
    	// cast the form
    	FormSearch searchForm = (FormSearch) form;
    	
    	// validate the form
    	ActionErrors errors = searchForm.validate(mapping, request);
    	if (! errors.isEmpty()) {
    		logger.debug("ActionSearch.search Errors: " + errors);
    		saveErrors(request, errors);
	    	return mapping.findForward(Constants.ERROR);
    	}
    	
       	logger.debug("ActionSearch.search context = " + searchForm.getContext());
           	
    	// setup form to pass and forward to the right delegate
    	request.setAttribute(Constants.SEARCH, searchForm);

    	// forward to the right delegate
    	if (searchForm.getContext().equalsIgnoreCase(Constants.HOME)) {
    		return mapping.findForward(Constants.ACCOUNT);
    	}   	

    	if (searchForm.getType().equalsIgnoreCase(Constants.NAME_SEARCH) ||
				searchForm.getType().equalsIgnoreCase(Constants.TYPE_SEARCH) ||
				searchForm.getType().equalsIgnoreCase(Constants.DEFINITION_SEARCH) ||
				searchForm.getType().equalsIgnoreCase(Constants.RECENTADD_SEARCH)) {
    		
        		return mapping.findForward(Constants.MACHINETYPE);    	
    	}
    	
    	return mapping.findForward(Constants.ERROR);
    }
}
