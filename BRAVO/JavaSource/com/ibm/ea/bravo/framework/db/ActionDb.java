package com.ibm.ea.bravo.framework.db;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;

public class ActionDb extends ActionBase {
	
	public ActionForward create(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

    	DbDelegate.dbAction("create");
		
		return mapping.findForward(Constants.SUCCESS);
    }

	public ActionForward activate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		DbDelegate.dbAction("activate");
		
		return mapping.findForward(Constants.SUCCESS);
	}
}
