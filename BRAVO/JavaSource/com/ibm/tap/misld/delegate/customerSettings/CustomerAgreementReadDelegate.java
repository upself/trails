/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import java.util.List;

import javax.naming.NamingException;

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
public class CustomerAgreementReadDelegate extends Delegate {

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getCustomerAgreementsByCustomer(Customer customer)
			throws HibernateException, NamingException {

		List customerAgreements = null;

		Session session = getHibernateSession();

		customerAgreements = session.getNamedQuery(
				"getCustomerAgreementsByCustomer").setEntity("customer",
				customer).list();

		session.close();

		return customerAgreements;
	}

}