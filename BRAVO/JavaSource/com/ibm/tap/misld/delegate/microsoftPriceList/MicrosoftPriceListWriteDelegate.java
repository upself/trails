/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import java.util.Date;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.delegate.licenseAgreementType.LicenseAgreementTypeReadDelegate;
import com.ibm.tap.misld.delegate.licenseType.LicenseTypeReadDelegate;
import com.ibm.tap.misld.delegate.priceLevel.PriceLevelReadDelegate;
import com.ibm.tap.misld.delegate.qualifiedDiscount.QualifiedDiscountReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.LoadException;
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
public class MicrosoftPriceListWriteDelegate extends Delegate {

	/**
	 * @throws NamingException
	 * @throws HibernateException
	 *  
	 */
	public static void clearPriceList() throws HibernateException,
			NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.delete(session.getNamedQuery("getMicrosoftPriceList")
				.getQueryString());

		tx.commit();
		session.close();

	}

	/**
	 * @param stringFields
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void loadPriceList(String[] stringFields, String remoteUser)
			throws LoadException, HibernateException, NamingException {

		Float unitPrice;
		int unit;

		String licenseAgreementTypeStr = ((String) stringFields[0])
				.toUpperCase();
		String sku = ((String) stringFields[1]).toUpperCase();
		String productDescription = ((String) stringFields[2]).toUpperCase();
		String licenseTypeStr = ((String) stringFields[3]).toUpperCase();
		String priceLevelStr = ((String) stringFields[4]).toUpperCase();
		String qualifiedDiscountStr = ((String) stringFields[5]).toUpperCase();
		String unitPriceStr = ((String) stringFields[6]);
		String unitStr = ((String) stringFields[7]);
		String authentication = ((String) stringFields[8]).toUpperCase();

		if (Util.isBlankString(licenseAgreementTypeStr)) {
			throw new LoadException("License agreement type is blank");
		}
		if (Util.isBlankString(sku)) {
			throw new LoadException("SKU is blank");
		}
		if (Util.isBlankString(productDescription)) {
			throw new LoadException("Product description is blank");
		}
		if (Util.isBlankString(productDescription)) {
			throw new LoadException("Product description is blank");
		}
		if (Util.isBlankString(licenseTypeStr)) {
			throw new LoadException("License type is blank");
		}
		if (Util.isBlankString(priceLevelStr)
				&& Util.isBlankString(qualifiedDiscountStr)) {
			throw new LoadException(
					"Price Level and/or qualifiedDiscount is blank");
		}
		if (!Util.isBlankString(priceLevelStr)) {
			if (!Util.isBlankString(qualifiedDiscountStr)) {
				throw new LoadException(
						"Price Level and/or qualifiedDiscount both contain values");
			}
		}
		if (Util.isBlankString(priceLevelStr)) {
			priceLevelStr = "";
		}
		if (Util.isBlankString(qualifiedDiscountStr)) {
			qualifiedDiscountStr = "NONE";
		}
		if (Util.isBlankString(unitPriceStr)) {
			throw new LoadException("Unit price is blank");
		}
		if (Util.isBlankString(unitStr)) {
			throw new LoadException("Unit is blank");
		}

		if (Util.isDecimal(unitPriceStr)) {
			unitPrice = new Float(unitPriceStr);
		} else {
			throw new LoadException("Unit price is not in correct format");
		}

		if (Util.isInt(unitStr)) {
			unit = Integer.parseInt(unitStr);
		} else {
			throw new LoadException("Unit is not in correct format");
		}

		LicenseAgreementType licenseAgreementType = LicenseAgreementTypeReadDelegate
				.getLicenseAgreementTypeByName(licenseAgreementTypeStr);
		if (licenseAgreementType == null) {
			throw new LoadException("License Agreement Type is invalid");
		}

		LicenseType licenseType = LicenseTypeReadDelegate
				.getLicenseTypeByName(licenseTypeStr);
		if (licenseType == null) {
			throw new LoadException("License Type is invalid");
		}

		PriceLevel priceLevel = null;
		priceLevel = PriceLevelReadDelegate.getPriceLevelByName(priceLevelStr);

		if (priceLevel == null) {
			throw new LoadException("Price level is invalid");
		}

		QualifiedDiscount qualifiedDiscount = null;

		qualifiedDiscount = QualifiedDiscountReadDelegate
				.getQualifiedDiscountByName(qualifiedDiscountStr);

		if (qualifiedDiscount == null) {
			throw new LoadException("Qualified discount is invalid");
		}

		if (!Util.isBlankString(authentication)) {
			if (!authentication.equals("Y")) {
				if (!authentication.equals("N")) {
					throw new LoadException(
							"Authentication is in incorrect format");
				}
			}
		} else {
			authentication = null;
		}

		//Check if this product exists
		MicrosoftProduct microsoftProduct = MicrosoftProductReadDelegate
				.getMicrosoftProductByName(productDescription);

		if (microsoftProduct == null) {

			microsoftProduct = new MicrosoftProduct();
			microsoftProduct.setProductDescription(productDescription);
			microsoftProduct.setRemoteUser(remoteUser);
			microsoftProduct.setRecordTime(new Date());
			microsoftProduct.setStatus(Constants.ACTIVE);

			MicrosoftProductWriteDelegate
					.saveMicrosoftProduct(microsoftProduct);

			microsoftProduct = MicrosoftProductReadDelegate
					.getMicrosoftProductByName(productDescription);
		}

		//Check if it exists in the pricelist

		MicrosoftPriceList microsoftPriceList = null;

		microsoftPriceList = MicrosoftPriceListReadDelegate
				.getMicrosoftPriceListByFields(microsoftProduct, sku,
						licenseAgreementType, qualifiedDiscount, licenseType,
						authentication, priceLevel);
		if (microsoftPriceList == null) {
			microsoftPriceList = new MicrosoftPriceList();
		}

		microsoftPriceList.setQualifiedDiscount(qualifiedDiscount);
		microsoftPriceList.setPriceLevel(priceLevel);
		microsoftPriceList.setAuthenticated(authentication);
		microsoftPriceList.setLicenseAgreementType(licenseAgreementType);
		microsoftPriceList.setLicenseType(licenseType);
		microsoftPriceList.setMicrosoftProduct(microsoftProduct);
		microsoftPriceList.setRecordTime(new Date());
		microsoftPriceList.setRemoteUser(remoteUser);
		microsoftPriceList.setSku(sku);
		microsoftPriceList.setStatus(Constants.ACTIVE);
		microsoftPriceList.setUnit(unit);
		microsoftPriceList.setUnitPrice(unitPrice);

		saveMicrosoftPriceList(microsoftPriceList);

	}

	/**
	 * @param microsoftPriceList
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveMicrosoftPriceList(
			MicrosoftPriceList microsoftPriceList) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(microsoftPriceList);

		tx.commit();
		session.close();
	}

	/**
	 * @param microsoftPriceList
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static MicrosoftPriceList setUpMicrosoftPriceListForm(
			MicrosoftPriceList microsoftPriceList, String remoteUser)
			throws HibernateException, NamingException {

		LicenseAgreementType licenseAgreementType = LicenseAgreementTypeReadDelegate
				.getLicenseAgreementType(microsoftPriceList
						.getLicenseAgreementTypeId());

		LicenseType licenseType = LicenseTypeReadDelegate
				.getLicenseType(microsoftPriceList.getLicenseTypeId());

		MicrosoftProduct microsoftProduct = MicrosoftProductReadDelegate
				.getFullMicrosoftProduct(microsoftPriceList
						.getMicrosoftProductId());

		PriceLevel priceLevel = PriceLevelReadDelegate
				.getPriceLevel(microsoftPriceList.getPriceLevelId());

		QualifiedDiscount qualifiedDiscount = QualifiedDiscountReadDelegate
				.getQualifiedDiscountByLong(microsoftPriceList
						.getQualifiedDiscountId());

		MicrosoftPriceList microsoftPriceListCheck = MicrosoftPriceListReadDelegate
				.getMicrosoftPriceListByFields(microsoftProduct,
						microsoftPriceList.getSku().toUpperCase(),
						licenseAgreementType, qualifiedDiscount, licenseType,
						microsoftPriceList.getAuthenticated(), priceLevel);

		if (microsoftPriceListCheck != null) {
			if (microsoftPriceListCheck.getUnit() == microsoftPriceList
					.getUnit()) {
				if (microsoftPriceListCheck.getUnitPrice() == microsoftPriceList
						.getUnitPrice()) {
					return null;
				}
			} else {
				microsoftPriceList
						.setMicrosoftPriceListId(microsoftPriceListCheck
								.getMicrosoftPriceListId());
			}
		}

		microsoftPriceList.setLicenseAgreementType(licenseAgreementType);
		microsoftPriceList.setLicenseType(licenseType);
		microsoftPriceList.setMicrosoftProduct(microsoftProduct);
		microsoftPriceList.setPriceLevel(priceLevel);
		microsoftPriceList.setQualifiedDiscount(qualifiedDiscount);
		microsoftPriceList.setSku(microsoftPriceList.getSku().toUpperCase());

		microsoftPriceList.setRecordTime(new Date());
		microsoftPriceList.setStatus(Constants.ACTIVE);
		microsoftPriceList.setRemoteUser(remoteUser);

		return microsoftPriceList;

	}

	/**
	 * @param microsoftPriceList
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void deleteMicrosoftPriceList(
			MicrosoftPriceList microsoftPriceList) throws HibernateException,
			NamingException {

		microsoftPriceList = MicrosoftPriceListReadDelegate
				.getMicrosoftPriceListById(microsoftPriceList
						.getMicrosoftPriceListId());

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.delete(microsoftPriceList);

		tx.commit();
		session.close();

	}
}