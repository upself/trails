/*
 * Created on Apr 4, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.db;

import org.apache.log4j.Logger;
import org.hibernate.cfg.Configuration;
import org.hibernate.tool.hbm2ddl.SchemaExport;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class DbDelegate {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(DbDelegate.class);

	public static void dbAction(String dbAction) {
		boolean activate = false;
		
		if (dbAction.toLowerCase().equals("activate"))
			activate = true;
		
    	Configuration hibernateConfiguration = HibernateDelegate.getHibernateConfiguration();
    	
    	
    	if (hibernateConfiguration == null)
    		return;

    	try {
			SchemaExport schema = new SchemaExport(hibernateConfiguration);
			schema.setOutputFile(Constants.DB_SCHEMA);
			schema.setDelimiter(";");
			schema.create(false, activate);
    	} catch (Exception e) {
    		logger.error(e);
    	}
	}
}
