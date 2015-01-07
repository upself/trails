/*
 * Created on Feb 3, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

import java.io.FileInputStream;
import java.util.Properties;

import javax.servlet.ServletException;
import org.hibernate.cfg.AnnotationConfiguration;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;
import org.hibernate.cfg.Configuration;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class HibernateSessionPlugin implements PlugIn {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(HibernateSessionPlugin.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.apache.struts.action.PlugIn#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.apache.struts.action.PlugIn#init(org.apache.struts.action.ActionServlet,
	 *      org.apache.struts.config.ModuleConfig)
	 */
	public void init(ActionServlet arg0, ModuleConfig arg1)
			throws ServletException {

		if (logger.isDebugEnabled()) {
			logger.debug("init(ActionServlet, ModuleConfig) - start");
		}

		try {
			AnnotationConfiguration configuration = loadConfiguration();
			if (configuration == null)
				throw new Exception("Load Configuration failed for "
						+ Constants.HIBERNATE_PROPERTIES);

			configuration.buildSessionFactory();
		} catch (Exception e) {
			logger.error("init(ActionServlet, ModuleConfig)", e);

			e.printStackTrace();
		}

		if (logger.isDebugEnabled()) {
			logger.debug("init(ActionServlet, ModuleConfig) - end");
		}
	}

	public AnnotationConfiguration loadConfiguration() {
		if (logger.isDebugEnabled()) {
			logger.debug("loadConfiguration() - start");
		}

		AnnotationConfiguration configuration = null;

		try {
			logger.debug("Constants.HIBERNATE_PROPERTIES = "
					+ Constants.HIBERNATE_PROPERTIES);
			Properties properties = new Properties();
			properties
					.load(new FileInputStream(Constants.HIBERNATE_PROPERTIES));
			logger.debug("properties = " + properties);

			configuration = new AnnotationConfiguration();
			configuration.setProperties(properties).configure();
			logger.debug("configuration = " + configuration);

		} catch (Exception e) {
			logger.error("loadConfiguration()", e);

			e.printStackTrace();
		}

		if (logger.isDebugEnabled()) {
			logger.debug("loadConfiguration() - end");
		}

		return configuration;
	}
}