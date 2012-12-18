/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProductMap;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftProductMapReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static HashMap getMicrosoftProductMapHash()
			throws HibernateException, NamingException {

		HashMap microsoftProductMapHash = new HashMap();

		Session session = getHibernateSession();

		List microsoftProductMapList = session.getNamedQuery(
				"getMicrosoftProductMap").list();

		session.close();

		Iterator i = microsoftProductMapList.iterator();
		while (i.hasNext()) {
			MicrosoftProductMap microsoftProductMap = (MicrosoftProductMap) i
					.next();

			microsoftProductMapHash.put(microsoftProductMap
					.getMicrosoftProductMapId(), microsoftProductMap
					.getMicrosoftProduct());
		}

		return microsoftProductMapHash;
	}

	/**
	 * @param softwareId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MicrosoftProductMap getMicrosoftProductMap(Long softwareId)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		MicrosoftProductMap microsoftProductMap = (MicrosoftProductMap) session
				.get(MicrosoftProductMap.class, softwareId);

		session.close();

		return microsoftProductMap;
	}

	/**
	 * @param microsoftProductId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getMicrosoftProductMapByProduct(Long microsoftProductId)
			throws HibernateException, NamingException {

		List productList = null;

		Session session = getHibernateSession();

		productList = session.getNamedQuery("getMicrosoftProductMapByProduct")
				.setLong("microsoftProductId", microsoftProductId.longValue())
				.list();

		session.close();

		return productList;
	}
}