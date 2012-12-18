/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.cndb;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.cndb.Contact;
import com.ibm.tap.misld.framework.Delegate;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ContactReadDelegate extends Delegate {

	/**
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Contact getContact(String remoteUser)
			throws HibernateException, NamingException {

		Contact contact = null;

		Session session = getHibernateSession();

		contact = (Contact) session.getNamedQuery("getContacts").setString(
				"remoteUser", remoteUser).setString("role", "DPE")
				.uniqueResult();

		session.close();

		return contact;
	}

}