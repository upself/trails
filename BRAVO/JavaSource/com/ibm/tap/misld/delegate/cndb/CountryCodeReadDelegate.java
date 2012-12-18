/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.cndb;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import org.apache.struts.util.LabelValueBean;
import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.cndb.CountryCode;
import com.ibm.tap.misld.framework.Delegate;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class CountryCodeReadDelegate extends Delegate {

	/**
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static ArrayList getCountryCodes()
			throws HibernateException, NamingException {

	
		List countryCodeList = CountryCodeReadDelegate.getCountryCodeList();
		ArrayList countryCodes = new ArrayList();

		Iterator j = countryCodeList.iterator();

		while (j.hasNext()) {
			CountryCode countryCode = (CountryCode) j.next();

			countryCodes.add(new LabelValueBean(countryCode.getName() + "- "+ countryCode.getCode()
					, "" + countryCode.getId()));

		}

		return countryCodes;
	}
	
	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getCountryCodeList()
			throws HibernateException, NamingException {

		List countryCodes = null;

		Session session = getHibernateSession();

		countryCodes = session.getNamedQuery("getCountryCodes").list();

		session.close();

		return countryCodes;
	}

}