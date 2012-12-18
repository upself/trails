/*
 * Created on Jun 23, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.report;

import javax.servlet.http.HttpServletRequest;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface IReport {
	
	public void execute(String[] arguments, HttpServletRequest request) throws ExceptionAccountAccess, Exception;

}
