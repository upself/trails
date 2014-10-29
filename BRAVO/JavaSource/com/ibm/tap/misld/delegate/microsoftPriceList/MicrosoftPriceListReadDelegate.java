/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.licenseAgreementType.LicenseAgreementType;
import com.ibm.tap.misld.om.microsoftPriceList.LicenseType;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftPriceList;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;
import com.ibm.tap.misld.om.priceLevel.PriceLevel;
import com.ibm.tap.misld.om.qualifiedDiscount.QualifiedDiscount;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftPriceListReadDelegate extends Delegate {

	/**
	 * @param microsoftProduct
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getMicrosoftPriceListByProduct(
			MicrosoftProduct microsoftProduct) throws HibernateException,
			NamingException {

		List priceList = null;

		Session session = getHibernateSession();

		priceList = session.getNamedQuery("getMicrosoftPriceListByProduct")
				.setEntity("microsoftProduct", microsoftProduct).list();

		session.close();

		return priceList;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPriceList() throws HibernateException,
			NamingException {
		List priceList = null;

		Session session = getHibernateSession();

		priceList = session.getNamedQuery("getMicrosoftPriceListAll").list();

		session.close();

		return priceList;
	}

	/**
	 * @param priceListId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MicrosoftPriceList getMicrosoftPriceListById(Long priceListId)
			throws HibernateException, NamingException {

		MicrosoftPriceList microsoftPriceList = null;

		Session session = getHibernateSession();

		microsoftPriceList = (MicrosoftPriceList) session.getNamedQuery(
				"getMicrosoftPriceListById").setLong("microsoftPriceListId",
				priceListId.longValue()).uniqueResult();

		session.close();

		return microsoftPriceList;
	}

	/**
	 * @param microsoftProduct
	 * @param sku
	 * @param licenseAgreementType
	 * @param qualifiedDiscount
	 * @param licenseType
	 * @param authentication
	 * @param priceLevel
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MicrosoftPriceList getMicrosoftPriceListByFields(
			MicrosoftProduct microsoftProduct, String sku,
			LicenseAgreementType licenseAgreementType,
			QualifiedDiscount qualifiedDiscount, LicenseType licenseType,
			String authentication, PriceLevel priceLevel)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		MicrosoftPriceList microsoftPriceList = (MicrosoftPriceList) session
				.getNamedQuery("getMicrosoftPriceListByFields").setEntity(
						"microsoftProduct", microsoftProduct).setString("sku",
						sku).setEntity("licenseAgreementType",
						licenseAgreementType).setEntity("qualifiedDiscount",
						qualifiedDiscount).setEntity("priceLevel", priceLevel)
				.setEntity("licenseType", licenseType).setString(
						"authenticated", authentication).uniqueResult();

		session.close();

		return microsoftPriceList;
	}

}