package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Query;
import org.hibernate.Session;

import com.ibm.ea.bravo.discrepancy.DiscrepancyType;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public class DiscrepancyTypeTestHelper {

	public static DiscrepancyType getAnyRecord() {

		DiscrepancyType discrepancyType = null;

		try {
			Session session = HibernateDelegate.getSession();

			Query query = session.createQuery("FROM DiscrepancyType");
			query.setMaxResults(1);
			discrepancyType = (DiscrepancyType) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return discrepancyType;

	}
}
