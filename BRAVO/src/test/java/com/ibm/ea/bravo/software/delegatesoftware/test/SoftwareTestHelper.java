package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Software;

public class SoftwareTestHelper {
	
	public static Software getAnyRecord() {

		Software software = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.sigbank.Software");
			query.setMaxResults(1);
			software = (Software) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return software;
	}

	public static void deleteRecord(Software software) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(software);
			session.delete(software);

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
