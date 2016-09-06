package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.SoftwareScript;

public class SoftwareScriptTestHelper {
	
	public static SoftwareScript getAnyRecord() {

		SoftwareScript softwareScript = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.sigbank.SoftwareScript");
			query.setMaxResults(1);
			softwareScript = (SoftwareScript) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return softwareScript;
	}

	public static void deleteRecord(SoftwareScript softwareScript) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(softwareScript);
			session.delete(softwareScript);

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
