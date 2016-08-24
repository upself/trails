package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Manufacturer;

public class ManufacturerTestHelper {

	public static Manufacturer createRecord() {
		// createRecord = I mean that, return a record :) Figure out keys, IDs,
		// expect exceptions, rerun again
		// Hibernate: select max(ID) from PRODUCT_INFO ~ Hibernate maybe taking
		// care of this one
		// figure out locking, this select max(ID) might be run three times at
		// the same time from different sources

		Manufacturer manufacturer = new Manufacturer();
		manufacturer.setManufacturerName("manufacturerName");

		// Transaction(the rollback, mainly) is probably not needed for one save
		// operation
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

}
