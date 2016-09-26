package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.ProductInfo;
import com.ibm.ea.sigbank.SoftwareCategory;

public class ProductInfoTestHelper {

	public static ProductInfo create() {

		return create(null, SoftwareCategoryTestHelper.create());
	}

	public static ProductInfo create(Long id, SoftwareCategory softwareCategory) {

		ProductInfo productInfo = new ProductInfo();
		if (id != null) {
			productInfo.setProductId(id);
		}
		productInfo.setRecordTime(new Date());
		productInfo.setRemoteUser("PAVEL");
		productInfo.setComments("test object");
		productInfo.setChangeJustification("changeJustification");
		productInfo.setLicensable(true);
		productInfo.setPriority(1);
		productInfo.setSoftwareCategory(softwareCategory);

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

	public static ProductInfo getAny() {

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

	public static void delete(ProductInfo productInfo) {

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

	public static void delete(Long productInfoId) {
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
	
	public static void deleteById(Long productInfoId) {
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
