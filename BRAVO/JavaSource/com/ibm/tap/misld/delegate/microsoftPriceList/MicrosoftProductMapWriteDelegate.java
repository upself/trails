/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.microsoftPriceList;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.sigbank.Product;
import com.ibm.tap.misld.delegate.software.SoftwareReadDelegate;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.LoadException;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProduct;
import com.ibm.tap.misld.om.microsoftPriceList.MicrosoftProductMap;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MicrosoftProductMapWriteDelegate extends Delegate {

	/**
	 * @param stringFields
	 * @param remoteUser
	 * @throws LoadException
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void loadMapping(String[] stringFields, String remoteUser)
			throws LoadException, HibernateException, NamingException {

		String softwareName = ((String) stringFields[0]).toUpperCase();
		String productDescription = ((String) stringFields[1]).toUpperCase();

		if (Util.isBlankString(softwareName)) {
			throw new LoadException("Sigbank name is blank");
		}
		if (Util.isBlankString(productDescription)) {
			throw new LoadException("Microsoft name is blank");
		}

		//Get the software object by name
		Product software = SoftwareReadDelegate
				.getSoftwareByName(softwareName);

		if (software == null) {
			throw new LoadException("Invalid sigbank software name");
		}

		//Get the microsoft product by name
		MicrosoftProduct microsoftProduct = MicrosoftProductReadDelegate
				.getMicrosoftProductByName(productDescription);

		if (microsoftProduct == null) {
			throw new LoadException("Invalid microsoft product name");
		}

		//Check and make sure a mapping for this software does not exist
		MicrosoftProductMap microsoftProductMap = MicrosoftProductMapReadDelegate
				.getMicrosoftProductMap(software.getSoftwareId());

		//If does not exist, then we create new one, we update the mapping if
		// not
		if (microsoftProductMap == null) {
			microsoftProductMap = new MicrosoftProductMap();
		}

		microsoftProductMap.setMicrosoftProduct(microsoftProduct);
		microsoftProductMap.setSoftware(software);

		saveMicrosoftProductMap(microsoftProductMap);

	}

	/**
	 * @param microsoftProductMap
	 * @throws NamingException
	 * @throws HibernateException
	 */
	private static void saveMicrosoftProductMap(
			MicrosoftProductMap microsoftProductMap) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(microsoftProductMap);

		tx.commit();
		session.close();
	}

	/**
	 * @param microsoftProductMapId
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void deleteMicrosoftProductMap(Long microsoftProductMapId)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.getNamedQuery("deleteMicrosoftProductMap").setLong(
				"microsoftProductMapId", microsoftProductMapId.longValue())
				.executeUpdate();

		tx.commit();
		session.close();

	}

	/**
	 * @param microsoftProductId
	 * @param softwareId
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void addMicrosoftProductMap(Long microsoftProductId,
			Long softwareId) throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		MicrosoftProduct microsoftProduct = MicrosoftProductReadDelegate
				.getFullMicrosoftProduct(microsoftProductId);
		Product software = SoftwareReadDelegate.getSoftwareByLong(softwareId);

		MicrosoftProductMap microsoftProductMap = new MicrosoftProductMap();
		microsoftProductMap.setMicrosoftProduct(microsoftProduct);
		microsoftProductMap.setSoftware(software);

		session.save(microsoftProductMap);

		tx.commit();
		session.close();

	}

}