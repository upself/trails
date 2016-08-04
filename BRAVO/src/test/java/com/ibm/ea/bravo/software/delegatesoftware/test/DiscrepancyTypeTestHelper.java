package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public class DiscrepancyTypeTestHelper {
	@SuppressWarnings("unchecked")
	public static DiscrepancyType getAnyRecord() {
		
		//read first entry
		List<DiscrepancyType> discrepancyTypesList = null;
		
		try {
			Session session = HibernateDelegate.getSession();
			discrepancyTypesList = session.createQuery("FROM DiscrepancyType").list();
			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return discrepancyTypesList.get(0);

		//add a new entry(if there would be no record, ie. empty db/in-memory db)
//		DiscrepancyType discrepancyType = new DiscrepancyType();
//		discrepancyType.setId(8L);
//		discrepancyType.setName("TEST");
//		discrepancyType.setRemoteUser("STAGING");
//		discrepancyType.setRecordTime(new Date());
//		discrepancyType.setStatus("ACTIVE");

	}

//	public static void deleteRecord(DiscrepancyType discrepancyType) {
//		Transaction tx = null;
//		 Session session = null;
//		 try {
//			 session = HibernateDelegate.getSession();
//		     tx = session.beginTransaction();
//		     
//		     session.delete(discrepancyType);
//		     
//		     tx.commit();
//		 }
//		 catch (Exception e) {
//		     if (tx!=null) tx.rollback();
//		     e.printStackTrace();
//		 }
//		 finally {
//			 session.close();
//		 }
//		
//	}
}
