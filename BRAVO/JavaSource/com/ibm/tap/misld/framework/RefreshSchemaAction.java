/*
 * Created on Feb 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework;

import java.io.FileInputStream;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.hibernate.cfg.Configuration;
import org.hibernate.tool.hbm2ddl.SchemaExport;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class RefreshSchemaAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		Configuration cfg = null;

		try {
			cfg = loadConfiguration();

			if (cfg == null)
				throw new Exception("Load Configuration failed for "
						+ Constants.HIBERNATE_PROPERTIES);

			cfg.buildSessionFactory();

		} catch (Exception e) {
			e.printStackTrace();
		}

		SchemaExport schema = new SchemaExport(cfg);

		schema.setOutputFile("e:/temp/tap-project-schema.sql");
		schema.setDelimiter(";");

		String destroy = request.getParameter("destroy");

		if (destroy == null) {
			schema.create(false, false);
		} else {
			schema.create(false, true);
		}

		return mapping.findForward(Constants.HOME);

	}

	public Configuration loadConfiguration() {

		Configuration configuration = null;

		try {
			Properties properties = new Properties();
			properties
					.load(new FileInputStream(Constants.HIBERNATE_PROPERTIES));

			configuration = new Configuration();
			configuration.setProperties(properties).configure();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return configuration;
	}

}