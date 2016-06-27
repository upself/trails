package com.ibm.tap.sigbank.framework.common;

import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;

public class HibernateUtils {
	private static HibernateUtils hibernateUtils;
	private SessionFactory sessionFactory;
	private AnnotationConfiguration hibernateConfiguration;

	private static final Logger logger = Logger.getLogger(HibernateUtils.class);

	private HibernateUtils() {
		try {
			logger.debug("HibernateUtils.HibernateUtils(.....) started");
			initializeHibernate();
			logger.debug("HibernateUtils.HibernateUtils(.....) ended");
		} catch (Exception e) {
			logger.error("HibernateUtils.HibernateUtils(.....) error here with message: "+e.getMessage());
		}
	}

	private void initializeHibernate() throws Exception {
		logger.debug("HibernateUtils.initializeHibernate(.....) started");
		loadConfiguration();

		if (hibernateConfiguration == null)
			throw new Exception("Load Configuration failed for " + Constants.HIBERNATE_PROPERTIES);

		sessionFactory = hibernateConfiguration.buildSessionFactory();
		logger.debug("HibernateUtils.initializeHibernate(.....) ended");
	}

	private void loadConfiguration() {

		logger.debug("HibernateUtils.loadConfiguration(.....) started");
		try {
			Properties properties = new Properties();
			String classPathRoot = HibernateUtils.class.getResource("").getPath();
			if (classPathRoot.indexOf("dst1185") != -1) {
				logger.info("loading the dst1185 hibernate properites");
				properties.load(new FileInputStream(Constants.CONF_DIR + "hibernateDST1185.properties"));
			} else {
				properties.load(new FileInputStream(Constants.HIBERNATE_PROPERTIES));
			}

			hibernateConfiguration = new AnnotationConfiguration();
			hibernateConfiguration.setProperties(properties).configure();
			logger.debug("HibernateUtils.loadConfiguration(.....) ended");
		} catch (Exception e) {
			logger.error("HibernateUtils.loadConfiguration(.....) error here with message: "+e.getMessage());
		}
	}
	
	public static synchronized HibernateUtils instance(){
		if(hibernateUtils == null){
			hibernateUtils = new HibernateUtils();
		}
		
		return hibernateUtils;
	}

	public Session getSession() throws Exception, HibernateException {
		return sessionFactory.openSession();
	}
}
