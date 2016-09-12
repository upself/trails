package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;
import java.util.UUID;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.SoftwareCategory;

public class SoftwareCategoryTestHelper {

	public static SoftwareCategory create() {

		SoftwareCategory softwareCategory = new SoftwareCategory();
		softwareCategory.setStatus("status");
		softwareCategory.setRecordTime(new Date());
		softwareCategory.setRemoteUser("remoteUser");
		softwareCategory.setComments("comments");
		softwareCategory.setChangeJustification("changeJustification");
		
		String randomSoftwareCategoryName = UUID.randomUUID().toString().substring(0, 20);
		//SoftwareCategoryName is nullable, but has to be unique!
		
		softwareCategory.setSoftwareCategoryName("softwareCategoryName-" + randomSoftwareCategoryName);
		
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(softwareCategory);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return softwareCategory;
	}
	
	public static SoftwareCategory getAny() {

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

	public static void delete(SoftwareCategory softwareCategory) {

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
