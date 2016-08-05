package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.SoftwareCategory;

public class SoftwareCategoryTestHelper {

	public static SoftwareCategory getAnyRecord() {
		SoftwareCategory softwareCategory = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM SoftwareCategory");
			query.setMaxResults(1);
			softwareCategory = (SoftwareCategory) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return softwareCategory;
	}

	public static void deleteRecord(SoftwareCategory softwareCategory) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(softwareCategory);
			session.delete(softwareCategory);

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
