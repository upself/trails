package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.Product;

public class ManufacturerTestHelper {

	public static Manufacturer create() {

		Manufacturer manufacturer = new Manufacturer();
		manufacturer.setManufacturerName("manufacturerName");

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(manufacturer);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return manufacturer;
	}
	
	public static void delete(Manufacturer manufacturer) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();
				
			session.refresh(manufacturer);
			session.delete(manufacturer);
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
