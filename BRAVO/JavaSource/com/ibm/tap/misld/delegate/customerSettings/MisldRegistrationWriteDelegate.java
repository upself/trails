/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import java.util.Date;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldRegistration;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MisldRegistrationWriteDelegate extends Delegate {

	/**
	 * @param misldRegistration
	 * @param customer
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveMisldRegistration(
			MisldRegistration misldRegistration, Customer customer,
			String remoteUser) throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		if (customer.getMisldRegistration() != null) {

			misldRegistration.setMisldRegistrationId(customer
					.getMisldRegistration().getMisldRegistrationId());

			MisldAccountSettingsWriteDelegate.clearForms(customer);

			if (customer.getMisldRegistration().isInScope() != misldRegistration
					.isInScope()) {
				if (customer.getMisldRegistration().isInScope()) {
					MisldAccountSettingsWriteDelegate
							.deleteMisldAccountSettings(customer, session);
				}
			}
		}

		if (misldRegistration.isInScope()) {
			misldRegistration.setNotInScopeJustification(null);
			misldRegistration.setJustificationOther(null);
		} else if (misldRegistration.getNotInScopeJustification().equals(
				"OTHER")) {
			misldRegistration.setJustificationOther(misldRegistration
					.getJustificationOther().toUpperCase());
		}

		misldRegistration.setCustomer(customer);
		misldRegistration.setRemoteUser(remoteUser);
		misldRegistration.setRecordTime(new Date());
		misldRegistration.setStatus(Constants.COMPLETE);

		session.saveOrUpdate(misldRegistration);

		tx.commit();
		session.close();

	}

	/**
	 * @param customer
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void destroyCustomer(Customer customer)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		MisldAccountSettingsWriteDelegate.clearForms(customer);

		if (customer.getMisldAccountSettings() != null) {
			session.delete(customer.getMisldAccountSettings());
		}

		if (customer.getMisldRegistration() != null) {
			session.delete(customer.getMisldRegistration());
		}

		tx.commit();
		session.close();

	}

	/**
	 * @param unlockCustomers
	 * @param lockCustomers
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void lockAccountRegistration(Vector unlockCustomers,
			Vector lockCustomers) throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		if (!unlockCustomers.isEmpty()) {
			session.getNamedQuery("unlockRegistration").setParameterList(
					"customers", unlockCustomers).executeUpdate();
		}

		if (!lockCustomers.isEmpty()) {
			session.getNamedQuery("lockRegistration").setParameterList(
					"customers", lockCustomers).executeUpdate();
		}

		tx.commit();

		session.close();

	}

}