package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.sigbank.SoftwareCategory;

public class CustomerTestHelper {

	public static Customer getAnyRecord() {

		Customer customer = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.cndb.Customer");
			query.setMaxResults(1);
			customer = (Customer) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return customer;
	}

	public static void deleteRecord(Customer customer) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(customer);
			session.delete(customer);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}

}
