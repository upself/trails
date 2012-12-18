/*
 * Created on Aug 14, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.report;

import java.util.Date;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.notification.Notification;

/**
 * @author alexmois
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class NotificationDelegate extends Delegate {

	/**
	 * @param customer
	 * @param price_report
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Notification getNotification(Customer customer,
			String notificationType) throws HibernateException, NamingException {

		Session session = getHibernateSession();

		Notification notification = (Notification) session.getNamedQuery(
				"getNotification").setEntity("customer", customer).setString(
				"notificationType", notificationType).uniqueResult();

		session.close();

		return notification;

	}

	/**
	 * @param customer
	 * @param price_report
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static Notification getNotificationByCustomerTypeStatus(
			Customer customer, String notificationType, String status)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		Notification notification = (Notification) session.getNamedQuery(
				"getNotificationByCustomerTypeStatus").setEntity("customer",
				customer).setString("notificationType", notificationType)
				.setString("status", status).uniqueResult();

		session.close();

		return notification;

	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @param string
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void createNotification(Customer customer, String remoteUser,
			String notificationType) throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		Notification notification = NotificationDelegate.getNotification(
				customer, notificationType);

		if (notification == null) {
			notification = new Notification();
			notification.setCustomer(customer);
			notification.setNotificationType(notificationType);
		}

		notification.setRemoteUser(remoteUser);
		notification.setStatus(Constants.ACTIVE);
		notification.setRecordTime(new Date());

		session.saveOrUpdate(notification);
		tx.commit();
		session.close();

	}

}
