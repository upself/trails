/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.licenseAgreementType;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.licenseAgreementType.LicenseAgreementType;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class LicenseAgreementTypeReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static LicenseAgreementType getLicenseAgreementTypeByName(
			String licenseAgreementTypeName) throws HibernateException,
			NamingException {

		LicenseAgreementType licenseAgreementType = null;

		Session session = getHibernateSession();

		licenseAgreementType = (LicenseAgreementType) session.getNamedQuery(
				"getLicenseAgreementTypeByName").setString(
				"licenseAgreementTypeName", licenseAgreementTypeName)
				.uniqueResult();

		session.close();

		return licenseAgreementType;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getLicenseAgreementTypes() throws HibernateException,
			NamingException {

		List licenseAgreementTypes = null;

		Session session = getHibernateSession();

		licenseAgreementTypes = session.getNamedQuery(
				"getLicenseAgreementTypes").list();

		return licenseAgreementTypes;
	}

	/**
	 * @param licenseAgreementTypeId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static LicenseAgreementType getLicenseAgreementType(
			Long licenseAgreementTypeId) throws HibernateException,
			NamingException {
		Session session = getHibernateSession();
		LicenseAgreementType licenseAgreementType = (LicenseAgreementType) session
				.getNamedQuery("getLicenseAgreementTypeByLong").setLong(
						"licenseAgreementTypeId",
						licenseAgreementTypeId.longValue()).uniqueResult();
		session.close();

		return licenseAgreementType;
	}
}