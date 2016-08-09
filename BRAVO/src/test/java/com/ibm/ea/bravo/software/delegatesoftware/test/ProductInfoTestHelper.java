package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.ProductInfo;

public class ProductInfoTestHelper {

	public static ProductInfo getAnyRecord() {

		ProductInfo productInfo = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM ProductInfo");
			query.setMaxResults(1);
			productInfo = (ProductInfo) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return productInfo;
	}

	public static ProductInfo createRecord() {

		// createRecord = I mean that, return a record :) Figure out keys, IDs,
		// expect exceptions, rerun again
		// Hibernate: select max(ID) from PRODUCT_INFO ~ Hibernate maybe taking
		// care of this one
		// figure out locking, this select max(ID) might be run three times at
		// the same time from different sources
		
		ProductInfo productInfo = new ProductInfo();
		productInfo.setRecordTime(new Date());
		productInfo.setRemoteUser("PAVEL");
		productInfo.setComments("test object");
		productInfo.setChangeJustification("changeJustification");
		productInfo.setLicensable(true);
		productInfo.setPriority(1);
		productInfo.setSoftwareCategory(SoftwareCategoryTestHelper.getAnyRecord());

		// Transaction(the rollback, mainly) is probably not needed for one save
		// operation
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(productInfo);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		return productInfo;
	}

	public static void deleteRecord(ProductInfo productInfo) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(productInfo);
			session.delete(productInfo);

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
