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
import com.ibm.tap.misld.om.customerSettings.CustomerAgreementType;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class CustomerAgreementTypeReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getCustomerAgreementTypes() throws HibernateException,
			NamingException {

		List customerAgreementTypes = null;

		Session session = getHibernateSession();

		customerAgreementTypes = session.getNamedQuery(
				"getCustomerAgreementTypes").list();

		session.close();

		return customerAgreementTypes;
	}

	/**
	 * @param long1
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static CustomerAgreementType getCustomerAgreementTypeByLong(
			Long customerAgreementTypeLong) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		CustomerAgreementType customerAgreementType = (CustomerAgreementType) session
				.get(CustomerAgreementType.class, customerAgreementTypeLong);

		session.close();

		return customerAgreementType;
	}

}