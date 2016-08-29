package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.KbDefinition;

public class KbDefinitionTestHelper {

	public static KbDefinition create() {

		KbDefinition kbDefinition = new KbDefinition();
		kbDefinition.setCreationTime(new Date());

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(kbDefinition);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return kbDefinition;
	}

	public static void delete(KbDefinition kbDefinition) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(kbDefinition);
			session.delete(kbDefinition);

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
