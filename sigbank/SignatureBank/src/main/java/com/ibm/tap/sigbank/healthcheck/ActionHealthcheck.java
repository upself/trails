package com.ibm.tap.sigbank.healthcheck;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;

/**
 * @version 1.0
 * @author
 */
public class ActionHealthcheck extends BaseAction

{
	public ActionForward read(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		return mapping.findForward(Constants.SUCCESS);

	}

}