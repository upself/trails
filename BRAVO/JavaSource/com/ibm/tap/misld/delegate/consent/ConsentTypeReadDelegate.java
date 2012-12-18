/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.consent;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.consent.ConsentType;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ConsentTypeReadDelegate extends Delegate {

	/**
	 * @param consentTypeName
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static ConsentType getConsentTypeByName(String consentTypeName)
			throws HibernateException, NamingException {

		ConsentType consentType = null;

		Session session = getHibernateSession();

		consentType = (ConsentType) session.getNamedQuery(
				"getConsentTypeByName").setString("consentTypeName",
				consentTypeName).uniqueResult();

		session.close();

		return consentType;

	}

}