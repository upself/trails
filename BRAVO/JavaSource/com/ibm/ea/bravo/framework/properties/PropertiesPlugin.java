/*
 * Created on Mar 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.properties;

import javax.servlet.ServletException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

public class PropertiesPlugin implements PlugIn {

	private static final Logger logger = Logger.getLogger(PropertiesPlugin.class);

	public void init(ActionServlet arg0, ModuleConfig arg1) throws ServletException {

		try {
			DelegateProperties.initializeProperties();
			logger.info("start Properties plugin");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
	}

	// destroy is called when the Plugin is destroyed
	public void destroy() {
		logger.info("stop Properties plugin");
	}

}