/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.qualifiedDiscount;

import java.util.ArrayList;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.qualifiedDiscount.QualifiedDiscount;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class QualifiedDiscountReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static ArrayList getQualifiedDiscounts() throws HibernateException,
			NamingException {

		ArrayList qualifiedDiscounts = null;

		Session session = getHibernateSession();

		qualifiedDiscounts = (ArrayList) session.getNamedQuery(
				"getQualifiedDiscounts").list();

		session.close();

		return qualifiedDiscounts;
	}

	/**
	 * @param qualifiedDiscountLong
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static QualifiedDiscount getQualifiedDiscountByLong(
			Long qualifiedDiscountLong) throws HibernateException,
			NamingException {
		Session session = getHibernateSession();

		QualifiedDiscount qualifiedDiscount = (QualifiedDiscount) session
				.getNamedQuery("getQualifiedDiscountByLong").setLong(
						"qualifiedDiscountId",
						qualifiedDiscountLong.longValue()).uniqueResult();

		session.close();

		return qualifiedDiscount;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static QualifiedDiscount getQualifiedDiscountByName(
			String qualifiedDiscountName) throws HibernateException,
			NamingException {

		QualifiedDiscount qualifiedDiscount = null;

		Session session = getHibernateSession();

		qualifiedDiscount = (QualifiedDiscount) session.getNamedQuery(
				"getQualifiedDiscountByName").setString(
				"qualifiedDiscountName", qualifiedDiscountName).uniqueResult();

		session.close();

		return qualifiedDiscount;
	}
}