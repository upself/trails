package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.Product;

public class ProductTestHelper {

	public static Product getAnyRecord() {

		Product product = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM com.ibm.ea.sigbank.Product");
			query.setMaxResults(1);
			product = (Product) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return product;
	}

	public static Product create() {
		return create(null, ManufacturerTestHelper.create());
	}

	public static Product create(Long id, Manufacturer manufacturer) {

		Product product = new Product();
		if (id != null) {
			product.setId(id);
		}
		product.setManufacturer(manufacturer);

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(product);

			tx.commit();

		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
			return null;
		} finally {
			session.close();
		}
		return product;
	}

	public static void deleteRecord(Product product) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(product);
			session.delete(product);
			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}

	}

	public static void deleteRecordById(Long productInfoId) {
		Session session;
		try {
			session = HibernateDelegate.getSession();

			String hqlDelete = "delete ProductInfo where id = :productInfoId";
			Transaction tx = session.beginTransaction();
			session.createQuery(hqlDelete).setLong("productInfoId", new Long(productInfoId)).executeUpdate();

			tx.commit();
			session.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
