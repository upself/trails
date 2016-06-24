package com.ibm.tap.sigbank.framework.common;

import java.io.FileInputStream;
import java.util.Properties;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;

public class HibernateUtils {
	private final static HibernateUtils hibernateUtils = new HibernateUtils();
	private static SessionFactory sessionFactory;
	private static AnnotationConfiguration hibernateConfiguration;

	private static final Logger logger = Logger.getLogger(HibernateUtils.class);

	private HibernateUtils() {
		try {
			initializeHibernate();
		} catch (Exception e) {
			logger.error(e.getMessage());
		}
	}

	private void initializeHibernate() throws Exception {
		loadConfiguration();

		if (hibernateConfiguration == null)
			throw new Exception("Load Configuration failed for " + Constants.HIBERNATE_PROPERTIES);

		sessionFactory = hibernateConfiguration.buildSessionFactory();
	}

	private void loadConfiguration() {

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

		} catch (Exception e) {
			logger.error(e);
		}
	}

	public synchronized static Session getSession() throws Exception, HibernateException {
		return sessionFactory.openSession();
	}
}
