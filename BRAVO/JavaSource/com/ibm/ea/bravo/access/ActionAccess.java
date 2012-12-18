package com.ibm.ea.bravo.access;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.user.UserContainer;

public class ActionAccess extends ActionBase {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(ActionAccess.class);

    public ActionForward init(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	
    	UserContainer user = loadUser(request);
    	
    	request.setAttribute(Constants.USER, user);
    	
        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward register(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	
        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward error(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("access error");
    	
        return mapping.findForward(Constants.SUCCESS);
    }

}
