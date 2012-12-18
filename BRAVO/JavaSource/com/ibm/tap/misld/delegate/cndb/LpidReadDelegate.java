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

import com.ibm.ea.cndb.Lpid;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class LpidReadDelegate extends Delegate {

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getCustomerLpids(Customer customer)
			throws HibernateException, NamingException {
		List lpids = null;

		Session session = getHibernateSession();

		lpids = session.getNamedQuery("getCustomerLpids").setEntity("customer",
				customer).list();

		session.close();

		return lpids;
	}

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static ArrayList getLpidMajorHash(Customer customer)
			throws HibernateException, NamingException {

		List customerNumbers = LpidReadDelegate.getCustomerLpids(customer);
		ArrayList lpids = new ArrayList();

		Iterator j = customerNumbers.iterator();

		while (j.hasNext()) {
			Lpid lpid = (Lpid) j.next();

			lpids.add(new LabelValueBean(lpid.getLpidName() + " - "
					+ lpid.getMajor().getMajorName(), "" + lpid.getLpidId()));

		}

		return lpids;
	}

	/**
	 * @param defaultLpidLong
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Lpid getLpidByLong(Long defaultLpidLong)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		Lpid lpid = (Lpid) session.get(Lpid.class, defaultLpidLong);

		session.close();

		return lpid;
	}
}