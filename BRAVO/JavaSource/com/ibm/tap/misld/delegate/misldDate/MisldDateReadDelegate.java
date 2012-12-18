/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.misldDate;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.misldDate.MisldDate;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MisldDateReadDelegate extends Delegate {


	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MisldDate getCurrentQtr() throws HibernateException, NamingException {

		MisldDate currentQtr = null;

		Session session = getHibernateSession();

		currentQtr = (MisldDate)session.getNamedQuery("getCurrentQtr").uniqueResult();

		session.close();

		return currentQtr;
	}
	
	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPoDates() throws HibernateException, NamingException {

		List poDates = null;

		Session session = getHibernateSession();

		poDates = session.getNamedQuery("getPoDates").list();

		session.close();

		return poDates;
	}
	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getUsageDates() throws HibernateException, NamingException {

		List usageDates = null;

		Session session = getHibernateSession();

		usageDates = session.getNamedQuery("getUsageDates").list();

		session.close();

		return usageDates;
	}

}