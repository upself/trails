package com.ibm.ea.bravo.help;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionHelp extends ActionBase {

	private static final Logger logger = Logger.getLogger(ActionHelp.class);

    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHelp.home");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward faq(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHelp.faq");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward commonSteps(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHelp.commonSteps");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward help(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHelp.help");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
    public ActionForward demo(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionHelp.demo");
    	
        return mapping.findForward(Constants.SUCCESS);
    }
    
}
