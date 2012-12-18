/*
 * Created on Mar 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.hibernate;

import javax.servlet.ServletException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

public class HibernatePlugin implements PlugIn {

	private static final Logger logger = Logger.getLogger(HibernatePlugin.class);

	public void init(ActionServlet arg0, ModuleConfig arg1) throws ServletException {

		try {
			HibernateDelegate.initializeHibernate();
			logger.info("HIBERNATE STARTED");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void destroy() {}
}