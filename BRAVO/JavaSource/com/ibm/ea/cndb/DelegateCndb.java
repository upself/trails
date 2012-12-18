/*
 * Created on Jan 19, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.cndb;

import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class DelegateCndb extends HibernateDelegate {
	@SuppressWarnings("unchecked")
    public static List<Pod> getDepartments() throws HibernateException, Exception {

		List<Pod> results = null;

		Session session = getSession();

		results = session.getNamedQuery("departments").list();

		closeSession(session);

		return results;
	}

}