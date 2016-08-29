package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.ProductInfo;
import com.ibm.ea.sigbank.SoftwareItem;

public class SoftwareItemTestHelper {

	public static SoftwareItem create() {

		return create(null);
	}
	
	public static SoftwareItem create(Long id) {

		SoftwareItem softwareItem = new SoftwareItem();
		if (id != null) {
			softwareItem.setId(id);
		}

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(softwareItem);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return softwareItem;
	}
	
	public static void delete(SoftwareItem softwareItem) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(softwareItem);
			session.delete(softwareItem);

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
