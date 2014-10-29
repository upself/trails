package com.ibm.ea.bravo.discrepancy;

import java.util.List;

import org.hibernate.Session;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;

public abstract class DelegateDiscrepancy extends HibernateDelegate {

	public static long NONE = 1;

	public static long MISSING = 2;

	public static long FALSE_HIT = 3;

	public static long VALID = 4;

	public static long INVALID = 5;
	
	public static long TADZ = 6;

	@SuppressWarnings("unchecked")
    public static List<DiscrepancyType> getDiscrepancies() throws Exception {
		List<DiscrepancyType> list = null;

		Session session = getSession();

		list = session.getNamedQuery("discrepancies").list();

		System.out.println("list: " + list);
		
		closeSession(session);

		return list;
	}

	public static DiscrepancyType getDiscrepancyType(String discrepancyTypeId)
			throws Exception {
		return getDiscrepancyType(Long.parseLong(discrepancyTypeId));
	}

	public static DiscrepancyType getDiscrepancyType(long discrepancyTypeId)
			throws Exception {
		DiscrepancyType discrepancyType = null;

		Session session = getSession();

		discrepancyType = (DiscrepancyType) session.getNamedQuery(
				"discrepancyById").setLong(Constants.ID, discrepancyTypeId)
				.uniqueResult();

		closeSession(session);

		return discrepancyType;
	}

}