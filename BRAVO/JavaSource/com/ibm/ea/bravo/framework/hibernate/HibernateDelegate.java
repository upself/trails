/*
 * Created on Mar 18, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.framework.hibernate;

import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.DelegateBase;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class HibernateDelegate extends DelegateBase {
	
	protected static SessionFactory sessionFactory;
	protected static Configuration hibernateConfiguration;
	private static Session cachedSession;

	private static final Logger logger = Logger.getLogger(HibernateDelegate.class);
	
	public static void initializeHibernate() throws Exception {
		loadConfiguration();
		
		if (hibernateConfiguration == null)
			throw new Exception("Load Configuration failed for " + Constants.HIBERNATE_PROPERTIES);
		
		sessionFactory = hibernateConfiguration.buildSessionFactory();
	}
	
	public static void loadConfiguration() {
		
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(Constants.HIBERNATE_PROPERTIES));
			
			hibernateConfiguration = new Configuration();
			hibernateConfiguration.setProperties(properties).configure();
			
		} catch (Exception e) {
			logger.error(e);
		}
	}

	public static Session getSession() throws Exception, HibernateException {

		// if there is a cachedSession, use it before generating
		// a new one from the Sessionfactory
		if (cachedSession != null)
			return cachedSession;
			
		// otherwise, we need to generate a new session
		// if the SessionFactory wasn't initialized by the plugin,
		// initialize it and get a session
		if (sessionFactory == null)
			HibernateDelegate.initializeHibernate();
		
		return sessionFactory.openSession();
	}
	
	public static void closeSession(Session session) throws HibernateException {
		if (cachedSession == null)
			session.close();
	}

	public static void cacheSession(Session session) {
		cachedSession = session;
	}
	
	public static Configuration getHibernateConfiguration() {
		return hibernateConfiguration;
	}
}
