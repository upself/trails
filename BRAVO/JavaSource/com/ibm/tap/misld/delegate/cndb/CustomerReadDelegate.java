/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.cndb;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.cndb.Pod;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.notification.Notification;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class CustomerReadDelegate extends Delegate {

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getCustomersByPod(Pod pod) throws HibernateException,
			NamingException {

		List customers = null;

		if (pod == null) {
			return null;
		}

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getCustomersByPod").setEntity("pod",
				pod).list();

		session.close();

		return customers;
	}

	/**
	 * @param customerId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Customer getCustomerByLong(long customerId)
			throws HibernateException, NamingException {
		// TODO Auto-generated method stub

		Session session = getHibernateSession();

		Customer customer = (Customer) session.getNamedQuery(
				"getCustomerByLong").setLong("customerId", customerId)
				.uniqueResult();

		session.close();

		return customer;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getInScopeCustomersByPod(Pod pod)
			throws HibernateException, NamingException {

		List customers = null;

		if (pod == null) {
			return null;
		}

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getInScopeCustomersByPod")
				.setEntity("pod", pod).list();

		session.close();

		return customers;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getApprovedPriceReports()
			throws HibernateException, NamingException {

		List customers = null;

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getApprovedPriceReports").list();

		session.close();

		return customers;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getApprovedPriceReportsByPod(Pod pod)
			throws HibernateException, NamingException {

		List customers = null;

		if (pod == null) {
			return null;
		}

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getApprovedPriceReportsByPod")
				.setEntity("pod", pod).list();

		session.close();

		return customers;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getReportCustomerView(Pod pod)
			throws HibernateException, NamingException {

		List customers = null;
		Notification notification = null;

		if (pod == null) {
			return null;
		}
	
		Session session = getHibernateSession();

		customers = session.getNamedQuery("getInScopeCustomersByPod")
				.setEntity("pod", pod).list();

		Iterator i = customers.iterator();
		while (i.hasNext()) {
			Customer customer = (Customer) i.next();
			notification = (Notification) session.getNamedQuery(
					"getNotification").setEntity("customer", customer)
					.setString("notificationType", "PRICE REPORT")
					.uniqueResult();

			customer.setPriceReportNotification(notification);
		}

		session.close();

		return customers;
	}

	/**
	 * @param accountNumber
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Customer getCustomerByAccountNumber(long accountNumber)
			throws HibernateException, NamingException {
		Session session = getHibernateSession();

		Customer customer = (Customer) session.getNamedQuery(
				"getCustomerByAccountNumber").setLong("accountNumber",
				accountNumber).uniqueResult();

		session.close();

		return customer;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Vector getInScopeCustomers() throws HibernateException,
			NamingException {

		List customers = null;

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getInScopeCustomers").list();

		session.close();

		return new Vector(customers);
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Vector getLockedCustomers() throws HibernateException,
			NamingException {

		List customers = null;

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getLockedCustomers").list();

		session.close();

		return new Vector(customers);
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getInScopeCustomersByPodView(Pod pod)
			throws HibernateException, NamingException {

		List customers = null;
		Notification notification = null;

		if (pod == null) {
			return null;
		}

		Session session = getHibernateSession();

		customers = session.getNamedQuery("getInScopeCustomersByPod")
				.setEntity("pod", pod).list();

		Iterator i = customers.iterator();
		while (i.hasNext()) {
			Customer customer = (Customer) i.next();

			notification = (Notification) session.getNamedQuery(
					"getNotification").setEntity("customer", customer)
					.setString("notificationType", "SCAN").uniqueResult();

			customer.setScanNotification(notification);
		}

		session.close();

		return customers;
	}
}