package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.SoftwareLpar;

public class SoftwareLparTestHelper {

	public static SoftwareLpar createAsActive() {

		SoftwareLpar softwareLparFromDB = null;

		Session session = null;
		try {
			session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.bravo.software.SoftwareLpar");
			query.setMaxResults(1);
			softwareLparFromDB = (SoftwareLpar) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		SoftwareLpar softwareLparNew = softwareLparFromDB;

		softwareLparNew.setStatus("ACTIVE");
		softwareLparNew.setName("softwareLparName");

		// SoftwareLpar softwareLpar = new SoftwareLpar();
		// softwareLpar.setComputerId("computerId");
		// softwareLpar.setStatus("ACTIVE");
		// softwareLpar.setRecordTime(new Date());
		// softwareLpar.setScantime(new Date());
		// softwareLpar.setAcquisitionTime(new Date());
		// softwareLpar.setRemoteUser("STAGING");
		// softwareLpar.setProcessorCount(1);
		// softwareLpar.setName("softwareLparName");
		// softwareLpar.setCustomer(CustomerTestHelper.getAnyRecord());

		// Transaction(the rollback, mainly) is probably not needed for one save
		// operation
		Transaction tx = null;
		// Session session = null;

		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(softwareLparNew);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return softwareLparNew;

	}

	public static void deleteRecord(SoftwareLpar softwareLpar) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(softwareLpar);
			session.delete(softwareLpar);

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
