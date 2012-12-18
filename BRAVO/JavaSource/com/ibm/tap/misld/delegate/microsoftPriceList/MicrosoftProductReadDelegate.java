/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftProductReadDelegate extends Delegate {

	/**
	 * @param sku
	 * @param productDescription
	 * @param licenseAgreementType
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static MicrosoftProduct getMicrosoftProductByName(
			String productDescription) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		MicrosoftProduct microsoftProduct = (MicrosoftProduct) session
				.getNamedQuery("getMicrosoftProductByName").setString(
						"productDescription", productDescription)
				.uniqueResult();

		session.close();

		return microsoftProduct;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getMicrosoftProducts() throws HibernateException,
			NamingException {

		List microsoftProducts = null;

		Session session = getHibernateSession();

		microsoftProducts = session.getNamedQuery("getMicrosoftProducts")
				.list();

		return microsoftProducts;
	}

	/**
	 * @param microsoftProductId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MicrosoftProduct getFullMicrosoftProduct(
			Long microsoftProductId) throws HibernateException, NamingException {
		Session session = getHibernateSession();

		MicrosoftProduct microsoftProduct = (MicrosoftProduct) session
				.getNamedQuery("getMicrosoftProductByLong").setLong(
						"microsoftProductId", microsoftProductId.longValue())
				.uniqueResult();

		session.close();

		return microsoftProduct;
	}
}