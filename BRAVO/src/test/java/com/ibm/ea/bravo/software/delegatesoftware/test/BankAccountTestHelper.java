package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.BankAccount;

public class BankAccountTestHelper {
	
	public static BankAccount getAnyRecord() {

		BankAccount bankAccount = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.sigbank.BankAccount");
			query.setMaxResults(1);
			bankAccount = (BankAccount) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bankAccount;
	}

	public static void deleteRecord(BankAccount bankAccount) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(bankAccount);
			session.delete(bankAccount);

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
