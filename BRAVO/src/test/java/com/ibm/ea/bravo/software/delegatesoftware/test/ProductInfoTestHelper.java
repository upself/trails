package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.ProductInfo;
import com.ibm.ea.sigbank.SoftwareCategory;

public class ProductInfoTestHelper {

	public static ProductInfo getAnyRecord(){
		
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
		
		//createRecord = I mean that, return a record :) Figure out keys, IDs, expect exceptions, rerun again
		//Hibernate: select max(ID) from PRODUCT_INFO ~ Hibernate maybe taking care of this one
		//figure out locking, this select max(ID) might be run three times at the same time from different sources
		ProductInfo productInfo = new ProductInfo();
		productInfo.setRecordTime(new Date());
		productInfo.setRemoteUser("PAVEL");
		productInfo.setComments("test object");
		productInfo.setChangeJustification("changeJustification");
		productInfo.setLicensable(true);
		productInfo.setPriority(1);
		productInfo.setSoftwareCategory(getSoftwareCategory());
		//move getSoftwareCategory() -> SoftwareCategoryHelper.getAnyRecord

		//Transaction is probably not needed for one save operation
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
		    tx = session.beginTransaction();
		     
		    session.save(productInfo);
		    
		    tx.commit();
		 }
		 catch (Exception e) {
			 System.out.println("whooops");
		     if (tx!=null) tx.rollback();
		     e.printStackTrace();
		 }
		 finally {
			 session.close();
		 }
		return productInfo;
	}

	//create the testHelper out of it, commit!
	private static SoftwareCategory getSoftwareCategory() {
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

	public static void deleteRecord(ProductInfo productInfo) {
		
//		Session session;
//		try {
//			session = HibernateDelegate.getSession();
//			String hqlDelete = "delete ProductInfo where id = :productInfoId";
//			Transaction tx = session.beginTransaction();
//			session.createQuery(hqlDelete)
//					.setLong("productInfoId", new Long(productInfoId))
//					.executeUpdate();
//
//			tx.commit();
//			session.close();
//			System.out.println("deleted productInfoId: " + productInfoId);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
		    tx = session.beginTransaction();

		    session.refresh(productInfo);
		    System.out.println("productInfo.getProductId(): " + productInfo.getProductId());
		    session.delete(productInfo);
		     
		    tx.commit();
		}
		catch (Exception e) {
		    if (tx!=null) tx.rollback();
		    e.printStackTrace();
		}
		finally {
			session.close();
		}
		
	}

	
	
}
