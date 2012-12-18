/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.cndb;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.exceptions.ApplicationException;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PodReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPods() throws HibernateException, NamingException {
		List pods = null;

		Session session = getHibernateSession();

		pods = session.getNamedQuery("getPods").list();

		session.close();

		return pods;
	}

	public static List getPodRegistrationStatus() throws ApplicationException,
			HibernateException, NamingException {

		List pods = null;
		Session session = getHibernateSession();

		pods = session.getNamedQuery("getRegistrationStatus").list();

		session.close();

		if (pods.isEmpty()) {
			return null;
		}

		return pods;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Pod getPod(Long podId) throws HibernateException,
			NamingException {

		Pod pod = null;
		Session session = getHibernateSession();
		pod = (Pod) session.getNamedQuery("getPod").setLong("podId",
				podId.longValue()).uniqueResult();
		session.close();
		return pod;
	}

}