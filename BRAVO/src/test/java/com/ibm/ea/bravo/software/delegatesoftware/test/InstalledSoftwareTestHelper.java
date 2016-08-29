package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.InstalledSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;

import com.ibm.ea.sigbank.ProductInfo;

public class InstalledSoftwareTestHelper {

	public static InstalledSoftware createActiveRecord(ProductInfo productInfo, SoftwareLpar softwareLpar, DiscrepancyType discrepancyType) {

		InstalledSoftware installedSoftware = new InstalledSoftware();
		installedSoftware.setStatus("ACTIVE");
		installedSoftware.setRecordTime(new Date());
		installedSoftware.setRemoteUser("STAGING");
		installedSoftware.setAuthenticated(0);
		installedSoftware.setProcessorCount(1);
		installedSoftware.setDiscrepancyType(discrepancyType);
		installedSoftware.setSoftwareLpar(softwareLpar);
		installedSoftware.setSoftware(SoftwareTestHelper.create());
		
		// ^^watch out for detached entities - refresh/use one session to build
		// this
		// installedSoftware.setP;//roductInfo ??

		// Transaction(the rollback, mainly) is probably not needed for one save
		// operation
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(installedSoftware);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return installedSoftware;
	}

	public static InstalledSoftware getAnyRecord() {

		InstalledSoftware installedSoftware = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("from com.ibm.ea.bravo.software.InstalledSoftware s" + 
				" join fetch s.softwareLpar" +
				" join fetch s.softwareLpar.customer" +
				" join fetch s.software" +
				" join fetch s.software.manufacturer" +
				" join fetch s.discrepancyType");
			
			query.setMaxResults(1);
			installedSoftware = (InstalledSoftware) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return installedSoftware;
	}
	
	public static void deleteRecord(InstalledSoftware installedSoftware) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(installedSoftware);
			session.delete(installedSoftware);

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
