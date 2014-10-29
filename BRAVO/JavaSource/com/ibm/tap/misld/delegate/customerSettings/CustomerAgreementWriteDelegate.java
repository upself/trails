/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class CustomerAgreementWriteDelegate extends Delegate {

	/**
	 * @param customer
	 * @param session
	 * @throws HibernateException
	 */
	public static void deleteCustomerAgreements(Customer customer,
			Session session) throws HibernateException {

		session.getNamedQuery("deleteCustomerAgreementsByCustomer").setEntity(
				"customer", customer).executeUpdate();

	}

}