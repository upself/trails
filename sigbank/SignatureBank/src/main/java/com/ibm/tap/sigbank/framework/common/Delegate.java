/*
 * Created on Feb 7, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

import java.util.List;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

/**
 * @@author newtont
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Delegate {
	private static final Logger logger = Logger.getLogger(Delegate.class);

	public static List readHqlList(String query) {
		List returnList = new Vector();

		try {

			// do something here
			Session session = getHibernateSession();

			Query hqlQuery = session.createQuery(query);
			returnList = hqlQuery.list();

			session.close();

		} catch (Exception e) {

			e.printStackTrace();

		}

		return returnList;

	}

	public static Object readHqlObject(String query) {
		Object returnObject = new Vector();

		try {

			// do something here
			Session session = getHibernateSession();

			Query hqlQuery = session.createQuery(query);
			returnObject = hqlQuery.uniqueResult();

			session.close();

		} catch (Exception e) {

			e.printStackTrace();
		}

		return returnObject;

	}

	/**
	 * @@return
	 * @@throws NamingException
	 * @@throws HibernateException
	 */
	protected static Session getHibernateSession() throws NamingException, HibernateException {
		Session session = null;
		logger.debug("Delegate.getHibernateSession(.....) started");
		try {
			Context ctx = new InitialContext();
			Object obj = ctx.lookup("HibernateSessionFactory");
			SessionFactory sessionFactory = (SessionFactory) obj;
			session = sessionFactory.openSession();
			logger.debug("Delegate.getHibernateSession(.....) ended");
		} catch (Exception e) {
			logger.error("Delegate.getHibernateSession(.....) error here with message: "+e.getMessage());
			try {
				logger.debug("HibernateUtils.getSession(.....) started");
				session = HibernateUtils.instance().getSession();
				logger.debug("HibernateUtils.getSession(.....) ended");
			} catch (Exception e1) {
				logger.error("HibernateUtils.getSession(.....) error here with message: "+e1.getMessage());
			}
		}
		return session;
	}

}