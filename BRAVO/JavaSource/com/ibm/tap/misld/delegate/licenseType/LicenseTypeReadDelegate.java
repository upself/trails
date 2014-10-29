/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.licenseType;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.microsoftPriceList.LicenseType;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class LicenseTypeReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static LicenseType getLicenseTypeByName(String licenseTypeName)
			throws HibernateException, NamingException {

		LicenseType licenseType = null;

		Session session = getHibernateSession();

		licenseType = (LicenseType) session.getNamedQuery(
				"getLicenseTypeByName").setString("licenseTypeName",
				licenseTypeName).uniqueResult();

		session.close();

		return licenseType;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getLicenseTypes() throws HibernateException,
			NamingException {

		List licenseTypes = null;

		Session session = getHibernateSession();

		licenseTypes = session.getNamedQuery("getLicenseTypes").list();

		session.close();

		return licenseTypes;
	}

	/**
	 * @param licenseTypeId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static LicenseType getLicenseType(Long licenseTypeId)
			throws HibernateException, NamingException {
		Session session = getHibernateSession();
		LicenseType licenseType = (LicenseType) session.getNamedQuery(
				"getLicenseTypeById").setLong("licenseTypeId",
				licenseTypeId.longValue()).uniqueResult();
		session.close();

		return licenseType;
	}
}