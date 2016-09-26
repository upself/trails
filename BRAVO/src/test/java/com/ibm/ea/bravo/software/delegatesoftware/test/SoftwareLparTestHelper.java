package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.SoftwareLpar;

public class SoftwareLparTestHelper {

	public static SoftwareLpar getAnyRecord() {
		
		SoftwareLpar softwareLparFrom = null;

		Session session = null;
		try {
			session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.bravo.software.SoftwareLpar");
			query.setMaxResults(1);
			softwareLparFrom = (SoftwareLpar) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		return softwareLparFrom;
	}
	
	
	public static SoftwareLpar createAsActive() {

//		SoftwareLpar softwareLpar = getAnyRecord();
//		softwareLpar.setStatus("ACTIVE");
//		softwareLpar.setName("softwareLparName");

		 SoftwareLpar softwareLpar = new SoftwareLpar();
		 softwareLpar.setComputerId("computerId");
		 softwareLpar.setStatus("ACTIVE");
		 softwareLpar.setRecordTime(new Date());
		 softwareLpar.setScantime(new Date());
		 softwareLpar.setAcquisitionTime(new Date());
		 softwareLpar.setRemoteUser("STAGING");
		 softwareLpar.setProcessorCount(1);
		 softwareLpar.setName("softwareLparName");
		 softwareLpar.setCustomer(CustomerTestHelper.getAnyRecord());

		Transaction tx = null;
		 Session session = null;

		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(softwareLpar);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return softwareLpar;

	}

	public static void delete(SoftwareLpar softwareLpar) {

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
