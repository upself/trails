/*
 * Created on Jun 14, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.common;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

public interface IForm {
	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request);
	public void init() throws Exception;

}
