/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.notification;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;

/**
 * @author kneikirk
 * 
 */
public class NotificationReadDelegate extends Delegate {

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getNotificationsByType(String type) throws HibernateException,
			NamingException {

		List notifications = null;

		Session session = getHibernateSession();

		notifications = session.getNamedQuery("getNotification").
							setEntity("notificationType",type).list();

		session.close();

		return notifications;
	}
	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getNotificationsByTypeStatus(String type, String status) throws HibernateException,
			NamingException {

		List notifications = null;

		Session session = getHibernateSession();

		notifications = session.getNamedQuery("getNotificationsByTypeStatus").
							setString("notificationType",type).
							setString("status",status).
							list();

		session.close();

		return notifications;
	}
}