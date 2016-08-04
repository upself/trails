package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.util.Date;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public class DiscrepancyTypeTestHelper {
	@SuppressWarnings("unchecked")
	public static DiscrepancyType getAnyRecord() {
		
		List<DiscrepancyType> discrepancyTypesList = null;
		
		try {
			Session session = HibernateDelegate.getSession();
			discrepancyTypesList = session.createQuery("FROM DiscrepancyType").list();

			HibernateDelegate.closeSession(session);
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		//if there would be no record, ie. empty db. In this situation get a list and select first occurence?
//		DiscrepancyType discrepancyType = new DiscrepancyType();
//		discrepancyType.setId(4L);
//		discrepancyType.setName("VALID");
//		discrepancyType.setRemoteUser("STAGING");
//		discrepancyType.setRecordTime(new Date());
//		discrepancyType.setStatus("ACTIVE");
		
		return discrepancyTypesList.get(3);
	}

	public static void deleteRecord(Long discrepancyTypeId) {
		// TODO Auto-generated method stub
		
	}
}
