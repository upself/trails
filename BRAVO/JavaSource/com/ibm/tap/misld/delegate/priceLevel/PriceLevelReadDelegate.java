/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.priceLevel;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.priceLevel.PriceLevel;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PriceLevelReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceLevel getPriceLevelByName(String priceLevelName)
			throws HibernateException, NamingException {

		PriceLevel priceLevel = null;

		Session session = getHibernateSession();

		priceLevel = (PriceLevel) session.getNamedQuery("getPriceLevelByName")
				.setString("priceLevelName", priceLevelName).uniqueResult();

		session.close();

		return priceLevel;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPriceLevels() throws HibernateException,
			NamingException {

		List priceLevels = null;

		Session session = getHibernateSession();

		priceLevels = session.getNamedQuery("getPriceLevels").list();

		session.close();

		return priceLevels;
	}

	/**
	 * @param priceLevelId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static PriceLevel getPriceLevel(Long priceLevelId)
			throws HibernateException, NamingException {
		Session session = getHibernateSession();
		PriceLevel priceLevel = (PriceLevel) session.getNamedQuery(
				"getPriceLevelByLong").setLong("priceLevelId",
				priceLevelId.longValue()).uniqueResult();
		session.close();

		return priceLevel;
	}
}