/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftProductWriteDelegate extends Delegate {

	/**
	 * @param microsoftProduct
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveMicrosoftProduct(MicrosoftProduct microsoftProduct)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.save(microsoftProduct);

		tx.commit();
		session.close();

	}
}